"""Intentional PR review fixture. Do not import, run, approve, or merge.

This file exists only to exercise Phoenix scanners in a disposable PR.
"""

import subprocess


def unsafe_shell_preview(user_input: str) -> str:
    result = subprocess.run(
        "echo " + user_input, shell=True, capture_output=True, text=True
    )
    return result.stdout


def unsafe_expression_preview(user_input: str):
    return eval(user_input)
