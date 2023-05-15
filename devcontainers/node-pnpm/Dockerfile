ARG VARIANT=bullseye
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash - \
    && apt-get install -y nodejs
RUN corepack enable

USER vscode
RUN corepack prepare pnpm@8.2.0 --activate
RUN pnpm install-completion zsh
