import os
import random

import cocotb
from cocotb.triggers import Timer


def _rand_bytes(rng: random.Random, n: int) -> bytes:
    return bytes(rng.getrandbits(8) for _ in range(n))


def _hex(b: bytes) -> str:
    return b.hex()


@cocotb.test()
async def round_encrypt_decrypt(dut):
    rng = random.Random(int(os.getenv("AES_SEED", "1")))

    for is_final in (0, 1):
        for i in range(3):
            state = _rand_bytes(rng, 16)
            round_key = _rand_bytes(rng, 16)

            dut.is_final.value = is_final
            dut.mode.value = 0
            dut.state_in.value = int.from_bytes(state, "big")
            dut.round_key.value = int.from_bytes(round_key, "big")
            await Timer(1, unit="ns")
            enc = int(dut.state_out.value).to_bytes(16, "big")

            dut.mode.value = 1
            dut.state_in.value = int.from_bytes(enc, "big")
            await Timer(1, unit="ns")
            dec = int(dut.state_out.value).to_bytes(16, "big")

            dut._log.info(
                "case=%d final=%d state=%s key=%s enc=%s dec=%s",
                i,
                is_final,
                _hex(state),
                _hex(round_key),
                _hex(enc),
                _hex(dec),
            )
            assert dec == state
