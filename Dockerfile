FROM debian:bullseye-slim

WORKDIR /root

RUN apt update
RUN apt install -y curl git python3 python3-pip unzip

# nvim
RUN \
	curl -o ./nvim-linux64.deb -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb && \
	apt install ./nvim-linux64.deb

# rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && . "$HOME/.cargo/env"

# nodejs
# deps: unzip
RUN curl -fsSL https://fnm.vercel.app/install | bash
RUN . ~/.bashrc && fnm install 16

# lunarvim
# deps: git python3 python3-pip
# source .bashrc for fnm node, cargo
RUN . ~/.bashrc && curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | bash -s -- -y
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# currently doesn't seem to be a way to wait for treesitter to finish
# installing its plugins, so we have to resort to a sleep before quit here
RUN . ~/.bashrc && lvim --headless -c 'TSInstall bash javascript json python typescript tsx css rust java yaml' -c "sleep 10 | quit"

WORKDIR /root/workspace

ENTRYPOINT [ "/root/.local/bin/lvim" ]