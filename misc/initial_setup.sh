#!/bin/bash

# Copy VS Code Settings
mkdir -p .vscode
cp -n .devcontainer/settings.json .vscode
# Copy Github CI
mkdir -p .github/workflows
cp -n .devcontainer/ci/latex_build.yml .github/workflows
# Copy Gitlab CI
cp -n .devcontainer/ci/.gitlab-ci.yml ./
