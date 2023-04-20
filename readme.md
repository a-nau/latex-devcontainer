# VS Code LaTeX Devcontainer

Devcontainer using LaTeX with VS Code featuring

- Common LaTeX plugins
- Github and Gitlab CI
- one-click arXiv export
- one-click PDF URL check

_Note_: You need VS Code and Docker installed to use this.

## Usage

![](misc/devcontainer.gif)
_Note_: I already had the extension installed, and a reload is needed at the end to get access to the one-click tools from the Latex Build Option menu.

Step by Step:

- Install extension VS Code Devcontainer extension `ms-vscode-remote.remote-containers`
- Clone repo or add submodule with path `.devcontainer` into your project
  ```shell
  git clone https://github.com/a-nau/latex-devcontainer.git .devcontainer
  git submodule add https://github.com/a-nau/latex-devcontainer.git .devcontainer
  ```
- Press `F1` (or `CTRL + SHIFT + P`) and select `Dev Containers: Rebuild and Reopen Container`
- (optional) rename main Texfile to `root.tex` or adjust CI configs if you want to use the CIs
- Commit the files copied during the Devcontainer setup (`settings.json`, `.gitlab-ci.yml`, `latex_build.yml`)

## Credits

- Uses [arxiv-latex-cleaner](https://github.com/google-research/arxiv-latex-cleaner): [Apache 2.0 License](https://github.com/google-research/arxiv-latex-cleaner/blob/main/LICENSE)
- Uses [pdf-link-checker](https://github.com/a-nau/pdf-link-checker): [MIT License](https://github.com/a-nau/pdf-link-checker/blob/main/LICENSE)
