FROM texlive/texlive:latest-full

# Update and install Python3
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv

RUN apt-get install -y git zip

# Create a virtual environment and activate it
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip
RUN pip3 install --upgrade pip

# Install tools
RUN pip3 install arxiv-latex-cleaner pdflinkchecker-cli