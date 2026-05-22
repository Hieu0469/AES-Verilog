# AES-256 DV Automation (Python)

This setup automates Vivado synth/impl, Vivado xsim regression using cocotb, and report parsing/plotting.

## Prerequisites

- Vivado 2023.1 in PATH (use `vivado.bat` on Windows if needed)
- Vivado simulator tools in PATH (xvlog/xelab/xsim)
- Python 3.9+

Install Python dependencies:

```
pip install cocotb pycryptodome pandas matplotlib
```

## 1) Run cocotb regression (Vivado xsim)

Known NIST AES-256 vector always runs. Optional random tests use `pycryptodome`.

```
python scripts/run_sim_cocotb.py --tests 25 --seed 7 --coverage
```

Outputs:

- `results/sim_cases.json`

## 2) Run Vivado synth + impl in batch mode

```
python scripts/run_vivado.py
```

Outputs:

- `results/timing_summary.rpt`
- `results/utilization.rpt`
- `results/power.rpt`

## 3) Parse reports to CSV

```
python scripts/parse_reports.py
```

Outputs:

- `results/summary.csv`

## 4) Plot a summary figure

```
python scripts/plot_reports.py
```

Outputs:

- `results/summary.png`

## Notes

- `--sim xsim` is the default (alias: `--sim vivado`).
- If Vivado is not in PATH, pass a full path using `--vivado` or set `XILINX_VIVADO` or `VIVADO_HOME`.
- If cocotb runner import fails, upgrade cocotb: `python -m pip install --upgrade cocotb`.
- Coverage collection depends on simulator support and license level.
