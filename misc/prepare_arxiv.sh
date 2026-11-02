#!/bin/bash
# Cleaner config lives next to this script (in the image or the .devcontainer submodule)
configFile=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/cleaner_config.yaml
# Save folder names
workspaceFolder=$(pwd)
workspaceFolderBasename=$(basename $(pwd))
echo preparing arxiv for ${workspaceFolder}...
cd ..
# Run arXiv cleaner
arxiv_latex_cleaner ${workspaceFolderBasename} --config ${configFile}
mv ${workspaceFolderBasename}_arXiv ${workspaceFolderBasename}/arxiv
cd ${workspaceFolderBasename}
echo 'arxiv/' >>.gitignore
echo 'arxiv.zip' >>.gitignore
zip -r arxiv.zip arxiv
echo finished arxiv...
