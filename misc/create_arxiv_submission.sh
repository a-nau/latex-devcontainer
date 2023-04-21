#!/bin/bash
# Save folder names
workspaceFolder=$(pwd)
workspaceFolderBasename=$(basename $(pwd))
echo preparing arxiv for ${workspaceFolder}...
cd ..
# Run arXiv cleaner
arxiv_latex_cleaner ${workspaceFolderBasename} --config ${workspaceFolder}/.devcontainer/misc/cleaner_config.yaml
mv ${workspaceFolderBasename}_arXiv ${workspaceFolderBasename}/arxiv
cd ${workspaceFolderBasename}
echo 'arxiv/' >>.gitignore
echo 'arxiv.zip' >>.gitignore
zip -r arxiv.zip arxiv
echo finished arxiv...
