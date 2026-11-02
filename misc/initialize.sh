#!/bin/bash

# Location of settings and CI templates: inside the image or the .devcontainer submodule
srcDir=${LATEX_DEVCONTAINER_DIR:-.devcontainer}

# Copy VS Code Settings
mkdir -p .vscode
cp -n ${srcDir}/settings.json .vscode
# Copy Github CI
mkdir -p .github/workflows
cp -n ${srcDir}/ci/latex_build.yml .github/workflows
# Copy Gitlab CI
cp -n ${srcDir}/ci/.gitlab-ci.yml ./
