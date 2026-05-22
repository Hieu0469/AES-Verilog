import json
import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

NIST_KEY = bytes.fromhex(
    "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
)
NIST_PLAINTEXT = bytes.fromhex("00112233445566778899aabbccddeeff")
NIST_CIPHERTEXT = bytes.fromhex("8ea2b7ca516745bfeafc49904b496089")


def _rand_bytes(rng: random.Random, n: int) -> bytes:
    return bytes(rng.getrandbits(8) for _ in range(n))


def _get_pycryptodome_cipher():
    try:
        from Crypto.Cipher import AES

        return AES
    except Exception:
        return None


async def _run_one(dut, key: bytes, plaintext: bytes) -> bytes:
    dut.rst.value = 1
    for _ in range(2):
        await RisingEdge(dut.clk)
    dut.rst.value = 0

    dut.key.value = int.from_bytes(key, "big")
    dut.plaintext.value = int.from_bytes(plaintext, "big")

    while int(dut.warmup.value) < 8:
        await RisingEdge(dut.clk)

    for _ in range(15):
        await RisingEdge(dut.clk)

    ciphertext = int(dut.ciphertext.value).to_bytes(16, "big")
    return ciphertext


@cocotb.test()
async def aes256_vectors(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await RisingEdge(dut.clk)

    results = {
        "cases_total": 0,
        "cases_passed": 0,
        "cases_failed": 0,
    }
    failures = []

    def record(ok: bool, idx: int, expected: bytes, got: bytes) -> None:
        results["cases_total"] += 1
        if ok:
            results["cases_passed"] += 1
        else:
            results["cases_failed"] += 1
            failures.append(
                {
                    "index": idx,
                    "expected": expected.hex(),
                    "got": got.hex(),
                }
            )

    got = await _run_one(dut, NIST_KEY, NIST_PLAINTEXT)
    record(got == NIST_CIPHERTEXT, 0, NIST_CIPHERTEXT, got)

    random_tests = int(os.getenv("AES_RANDOM_TESTS", "0"))
    seed = int(os.getenv("AES_SEED", "1"))

    if random_tests > 0:
        aes = _get_pycryptodome_cipher()
        if aes is None:
            dut._log.warning("pycryptodome not installed, skipping random tests")
        else:
            rng = random.Random(seed)
            for i in range(random_tests):
                key = _rand_bytes(rng, 32)
                plaintext = _rand_bytes(rng, 16)
                expected = aes.new(key, aes.MODE_ECB).encrypt(plaintext)
                got = await _run_one(dut, key, plaintext)
                record(got == expected, i + 1, expected, got)

    out_path = Path(os.getenv("AES_RESULTS_JSON", "results/sim_cases.json"))
    if not out_path.is_absolute():
        out_path = Path(__file__).resolve().parents[1] / out_path
    out_path.parent.mkdir(parents=True, exist_ok=True)

    payload = dict(results)
    payload["failures"] = failures
    out_path.write_text(json.dumps(payload, indent=2))

    dut._log.info(
        "Cases total=%d passed=%d failed=%d",
        results["cases_total"],
        results["cases_passed"],
        results["cases_failed"],
    )
    assert results["cases_failed"] == 0
