FROM debian:trixie-slim

ARG USERNAME=mjs
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive

# Minimal system-level tooling that is useful in essentially every
# development environment.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        openssh-client \
        sudo \
    && rm -rf /var/lib/apt/lists/*

# Create the development user with passwordless sudo.
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd \
        --uid "${USER_UID}" \
        --gid "${USER_GID}" \
        --create-home \
        --shell /bin/bash \
        "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" \
        > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}"

# Install mise itself system-wide, but don't install any language runtimes.
RUN curl -fsSL https://mise.run \
    | MISE_INSTALL_PATH=/usr/local/bin/mise sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Make mise-managed tools available to interactive and non-interactive shells.
ENV PATH="/home/${USERNAME}/.local/share/mise/shims:${PATH}"

RUN echo 'eval "$(mise activate bash)"' >> ~/.bashrc

CMD ["bash"]
