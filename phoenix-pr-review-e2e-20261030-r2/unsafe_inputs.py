"""Intentionally vulnerable PR-review fixture; never import or execute."""

import subprocess

import yaml


def run_report(user_input: str) -> str:
    result = subprocess.run(
        "echo " + user_input, shell=True, capture_output=True, text=True
    )
    return result.stdout


def evaluate_expression(user_input: str):
    return eval(user_input)


def parse_document(user_input: str):
    return yaml.load(user_input, Loader=yaml.Loader)
