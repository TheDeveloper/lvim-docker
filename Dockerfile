FROM debian:bullseye-slim as builder

WORKDIR /root

RUN apt update

# node 16 repo
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN apt install -y curl git python3 python3-pip unzip python3-venv nodejs npm

# nvim
RUN \
curl -o ./nvim-linux64.deb -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb && \
apt install ./nvim-linux64.deb

RUN mkdir lua-language-server && \
curl -L https://github.com/sumneko/lua-language-server/releases/download/3.5.6/lua-language-server-3.5.6-linux-x64.tar.gz -o ./lua-language-server/lua-language-server-3.5.6-linux-x64.tar.gz && \
cd lua-language-server && \
tar -xzf lua-language-server-3.5.6-linux-x64.tar.gz && \
rm lua-language-server-3.5.6-linux-x64.tar.gz

COPY ./lua-language-server /usr/local/bin/lua-language-server

# rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && . "$HOME/.cargo/env"

# nodejs
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
# . ~/.bashrc && \
# nvm i 16 && \
# nvm alias default 16
# RUN apt install -y xz-utils
# RUN curl -L -o ./node.tar.xz https://nodejs.org/dist/v16.17.1/node-v16.17.1-linux-x64.tar.xz && \
# xz -d -v node.tar.xz && \
# ls -alh node*

RUN npm i -g bash-language-server

# lunarvim
# deps: git python3 python3-pip
# source .bashrc for node, cargo
RUN . ~/.bashrc && curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | bash -s -- -y
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# currently doesn't seem to be a way to wait for treesitter to finish
# installing its plugins, so we have to resort to a sleep before quit here
RUN . ~/.bashrc && lvim --headless -c 'TSInstall bash javascript json python typescript tsx css rust java yaml' -c "sleep 10 | quit"

# deps: nodejs npm python3-venv
RUN . ~/.bashrc && lvim --headless -c 'LspInstall bashls jedi_language_server eslint yamlls jsonls dockerls' -c "sleep 10 | quit"

# RUN which nvim

# FROM debian:bullseye-slim

# COPY --from=builder /usr/local /usr/local
# COPY --from=builder /usr/bin /usr/bin
# COPY --from=builder /root /root
# COPY --from=builder /usr/share /usr/share

WORKDIR /root/workspace

ENTRYPOINT bash -lc 'cd /root/workspace && lvim'