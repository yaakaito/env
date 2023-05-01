ARG VARIANT=bullseye
FROM --platform=linux/amd64 mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV DENO_INSTALL=/deno
RUN mkdir -p /deno \
    && curl -fsSL https://deno.land/x/install/install.sh | sh \
    && chown -R vscode /deno

USER vscode
# RUN curl -fsSL https://fnm.vercel.app/install | bash
RUN echo 'export DENO_INSTALL="/deno"' >> ~/.bashrc
RUN echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.bashrc
RUN echo 'export DENO_INSTALL="/deno"' >> ~/.zshrc
RUN echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.zshrc
