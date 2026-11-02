FROM danteev/texlive

ARG USERNAME=devuser
ENV LATEX_DEVCONTAINER_DIR=/opt/latex-devcontainer

# Create user if it doesn't exist, set up sudoers
RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -s /bin/bash ${USERNAME}; \
    fi && \
    apt-get update && apt-get install -y sudo zip && \
    rm -rf /var/lib/apt/lists/* && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Install tools system-wide so they work for every user (devcontainer and CI)
RUN pip install --no-cache-dir arxiv-latex-cleaner==0.1.* pdflinkchecker-cli==0.2.* --break-system-packages

# Ship settings, CI templates and helper scripts inside the image,
# so projects using the prebuilt image don't need this repo as submodule
COPY settings.json ${LATEX_DEVCONTAINER_DIR}/
COPY ci/ ${LATEX_DEVCONTAINER_DIR}/ci/
COPY misc/initialize.sh misc/prepare_arxiv.sh misc/cleaner_config.yaml ${LATEX_DEVCONTAINER_DIR}/misc/
RUN sed -i 's/\r$//' ${LATEX_DEVCONTAINER_DIR}/misc/*.sh && \
    chmod +x ${LATEX_DEVCONTAINER_DIR}/misc/*.sh && \
    ln -s ${LATEX_DEVCONTAINER_DIR}/misc/prepare_arxiv.sh /usr/local/bin/prepare_arxiv

# Devcontainer configuration used when the image is referenced directly
# ("image": "ghcr.io/adriandavidauer/latex-devcontainer:latest").
# The container's default user stays root so CI runners can write to their workspace;
# VS Code connects as ${USERNAME}, whose UID is mapped to the host user.
LABEL devcontainer.metadata='[{ \
    "remoteUser": "'${USERNAME}'", \
    "updateRemoteUserUID": true, \
    "initializeCommand": "chmod 644 ~/.ssh/config 2>/dev/null || true", \
    "postCreateCommand": "sudo chown -R $(id -u):$(id -g) ${containerWorkspaceFolder} && bash /opt/latex-devcontainer/misc/initialize.sh", \
    "postStartCommand": "sudo chown -R $(id -u):$(id -g) ${containerWorkspaceFolder} && sudo chown -R root:root /etc/ssh/ssh_config.d/ && sudo chmod 755 /etc/ssh /etc/ssh/ssh_config.d && sudo chmod 644 /etc/ssh/ssh_config.d/* 2>/dev/null || true", \
    "customizations": { "vscode": { "extensions": [ \
        "james-yu.latex-workshop", \
        "nickfode.latex-formatter", \
        "mathematic.vscode-latex", \
        "ms-azuretools.vscode-docker", \
        "meezilla.json", \
        "valentjn.vscode-ltex", \
        "streetsidesoftware.code-spell-checker" \
    ] } } \
}]'
LABEL org.opencontainers.image.source="https://github.com/adriandavidauer/latex-devcontainer"
LABEL org.opencontainers.image.description="VS Code LaTeX devcontainer based on danteev/texlive"
LABEL org.opencontainers.image.licenses="MIT"
