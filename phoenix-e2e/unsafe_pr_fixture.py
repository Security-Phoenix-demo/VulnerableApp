"""Intentional PR review fixture. Do not import, run, approve, or merge.

This file exists only to exercise Phoenix scanners in a disposable PR.
"""

import subprocess


# E2E: move finding anchors to verify linked discussions after a new commit.
def unsafe_shell_preview(user_input: str) -> str:
    result = subprocess.run(
        "echo " + user_input, shell=True, capture_output=True, text=True
    )
    return result.stdout
