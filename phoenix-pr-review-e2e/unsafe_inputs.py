"""Synthetic PR review targets. Never import or execute this module."""

import pickle
import subprocess


def evaluate_expression(user_input: str):
    return eval(user_input)


def run_report(user_input: str) -> str:
    result = subprocess.run(
        "echo " + user_input, shell=True, capture_output=True, text=True
    )
    return result.stdout


def deserialize_payload(user_input: bytes):
    return pickle.loads(user_input)
