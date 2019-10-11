#!/bin/bash -ev
# Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved

# Run this script at project root by "./dev/linter.sh" before you commit

echo "Running isort ..."
isort -y --multi-line 3 --trailing-comma -sp . --skip datasets --skip docs --skip-glob '*/__init__.py' --atomic

echo "Running black ..."
black -l 100 .

echo "Running flake8 ..."
if [ -x "$(command -v flake8-3)" ]; then
  flake8-3 .
else
  python3 -m flake8 .
fi

# echo "Running mypy ..."
# Pytorch does not have enough type annotations
# mypy detectron2/solver detectron2/structures detectron2/config

echo "Running clang-format ..."
find . -regex ".*\.\(cpp\|c\|cc\|cu\|cxx\|h\|hh\|hpp\|hxx\|tcc\|mm\|m\)" -print0 | xargs -0 clang-format -i

command -v arc > /dev/null && arc lint