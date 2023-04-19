#!/bin/bash
# Copy Github CI
mkdir -p .github/workflows
cp .devcontainer/ci/latex_build.yml .github/workflows
# Copy Gitlab CI
cp .devcontainer/ci/.gitlab-ci.yml ./