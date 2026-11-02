# VS Code LaTeX Devcontainer

Devcontainer using LaTeX with VS Code featuring

- Common LaTeX plugins
- Github and Gitlab CI
- one-click arXiv export
- one-click PDF URL check
- prebuilt image on the GitHub Container Registry (`ghcr.io/adriandavidauer/latex-devcontainer`)

_Note_: No local LaTeX installation is needed, however, [VS Code](https://code.visualstudio.com/) and [Docker](https://docs.docker.com/get-docker/) need to be installed to use this.

## Usage

![](misc/devcontainer.gif)

### Prebuilt image (recommended)

No submodule and no local build needed, VS Code just pulls the image.
Already using the submodule? See [Migrating from the submodule to the prebuilt image](#migrating-from-the-submodule-to-the-prebuilt-image).

- Install VS Code Devcontainer extension `ms-vscode-remote.remote-containers`
- Create `.devcontainer/devcontainer.json` in your project:
  ```json
  {
      "name": "LatexDevcontainer",
      "image": "ghcr.io/adriandavidauer/latex-devcontainer:latest"
  }
  ```
  Extensions, settings and setup commands are part of the image, you can still add or override anything in this file.
- Press `F1` (or `CTRL + SHIFT + P`) and select `Dev Containers: Reopen in Container`
- (optional) rename main Texfile to `root.tex` or adjust CI configs if you want to use the CIs
- Commit the files copied during the Devcontainer setup (`.vscode/settings.json`, `.gitlab-ci.yml`, `.github/workflows/latex_build.yml`)

Available tags: `latest` (main branch), `<major>.<minor>` and `<version>` for releases, `sha-<commit>` for every build.
The image is rebuilt weekly to include updates of the TeX Live base image.

### In CI

The copied CI configs already build your document inside the image:

- GitHub Actions: `container: image: ghcr.io/adriandavidauer/latex-devcontainer:latest`
- GitLab CI: `image: ghcr.io/adriandavidauer/latex-devcontainer:latest`

### As submodule (builds the image locally)

Step by Step:

- Install VS Code Devcontainer extension `ms-vscode-remote.remote-containers`
- Clone repo or add submodule with path `.devcontainer` into your project
  ```shell
  git clone git@github.com:adriandavidauer/latex-devcontainer.git .devcontainer
  git submodule add git@github.com:adriandavidauer/latex-devcontainer.git .devcontainer
  ```
- Press `F1` (or `CTRL + SHIFT + P`) and select `Dev Containers: Rebuild and Reopen Container`
- (optional) rename main Texfile to `root.tex` or adjust CI configs if you want to use the CIs
- Commit the files copied during the Devcontainer setup (`settings.json`, `.gitlab-ci.yml`, `latex_build.yml`)
- If you do not see the following latex command menu, try reloading the window
<p align="center">
    <img src="./misc/latex_command_menu.png" height="250"/>
</p>

## Migrating from the submodule to the prebuilt image

Projects set up with the submodule build the image locally. To switch to the prebuilt image (no submodule, image is only downloaded), run the following in your project root. Commit or stash your changes first.

1. **Remove the submodule**
   ```shell
   git submodule deinit -f .devcontainer
   git rm -f .devcontainer
   rm -rf .git/modules/.devcontainer    # PowerShell: Remove-Item -Recurse -Force .git\modules\.devcontainer
   ```
   If `.devcontainer` was your only submodule, `.gitmodules` is now empty. Remove it as well:
   ```shell
   git rm -f .gitmodules
   ```
2. **Add the new config** `.devcontainer/devcontainer.json`
   ```json
   {
       "name": "LatexDevcontainer",
       "image": "ghcr.io/adriandavidauer/latex-devcontainer:latest"
   }
   ```
3. **Update the files copied from the submodule.** They are only copied once and are not overwritten, so update them by hand:
   - `.vscode/settings.json` (required, otherwise the *prepare arxiv* recipe fails): in `latex-workshop.latex.tools` replace the `prepare_arxiv` tool
     ```json
     "command": "sh",
     "args": [
         "%DIR%/.devcontainer/misc/prepare_arxiv.sh"
     ],
     ```
     with
     ```json
     "command": "prepare_arxiv",
     "args": [],
     ```
   - `.github/workflows/latex_build.yml` and `.gitlab-ci.yml` (optional): the old versions keep working. To compile in CI with the same image as locally, replace them with the current [ci/latex_build.yml](ci/latex_build.yml) and [ci/.gitlab-ci.yml](ci/.gitlab-ci.yml) (keep your `root_file`/`FILE_NAME` if you changed it).

   Alternatively delete these files before reopening the container, then the new versions are copied in. This discards your own changes to them.
4. **Commit**
   ```shell
   git add -A
   git commit -m "Use prebuilt LaTeX devcontainer image instead of submodule"
   ```
5. **(optional) Remove the old container and locally built images.** Close the VS Code window of the container first. The images are named `vsc-<project>-<hash>` and `vsc-<project>-<hash>-uid`, where `<project>` is the project folder name in lower case:
   ```shell
   docker rm -f $(docker ps -aq --filter "label=devcontainer.local_folder=$PWD")
   docker images "vsc-<project>-*"
   docker rmi $(docker images -q "vsc-<project>-*")
   ```
6. **Reopen the container**: press `F1` and select `Dev Containers: Rebuild and Reopen in Container`. The image is now downloaded instead of built.

### Collaborators with an existing clone

A plain `git pull` fails with `untracked working tree files would be overwritten by merge: .devcontainer/devcontainer.json`, because the old submodule folder stays on disk. Remove it **before** pulling:

```shell
git submodule deinit -f .devcontainer
rm -rf .devcontainer .git/modules/.devcontainer    # PowerShell: Remove-Item -Recurse -Force .devcontainer, .git\modules\.devcontainer
git pull
```

Then continue with steps 5 and 6. Fresh clones need no extra steps.

## Troubleshooting

- When using [Rancher Desktop](https://rancherdesktop.io/) on Windows, you might need to disable mounting the Wayland Socket (see [this](https://github.com/rancher-sandbox/rancher-desktop/issues/4436#issuecomment-1712518033))

## Credits

- Uses the [danteev/texlive](https://github.com/dante-ev/docker-texlive) Docker image as base: [MIT License](https://github.com/dante-ev/docker-texlive/blob/main/LICENSE)
- Uses [arxiv-latex-cleaner](https://github.com/google-research/arxiv-latex-cleaner): [Apache 2.0 License](https://github.com/google-research/arxiv-latex-cleaner/blob/main/LICENSE)
- Uses [pdf-link-checker](https://github.com/a-nau/pdf-link-checker): [MIT License](https://github.com/a-nau/pdf-link-checker/blob/main/LICENSE)
- Uses [cvpr-latex-template](https://github.com/apoorvkh/cvpr-latex-template) as example for the `.gif`

Unless stated otherwise, this project is licensed under the [MIT license](LICENSE).