FROM fedora:34 as build

RUN dnf install -y git make gcc gcc-c++ which iproute iputils procps-ng vim-minimal tmux net-tools htop tar jq npm openssl-devel perl
RUN npm install -g yarn

# install all 3 toolchains
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y && \
    /root/.cargo/bin/rustup update beta && \
    /root/.cargo/bin/rustup update nightly

ENV PATH=/root/.cargo/bin:$PATH
# check cargo works
RUN cargo version
# rustup
RUN rustup default stable
RUN rustup target add wasm32-unknown-unknown

# build testnet/localnet
COPY . .
RUN make clean
RUN make -B testnet

FROM fedora:34

RUN dnf install -y git gcc gcc-c++ which iproute iputils procps-ng vim-minimal tmux net-tools htop tar jq npm openssl-devel python3-pip
# only required for deployment script
RUN npm install -g ts-node && npm install -g typescript && npm install -g yarn

# nearup
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN pip3 install nearup

# near and aurora cli
RUN npm install -g near-cli
RUN npm install -g aurora-is-near/aurora-cli

# run/init near and aurora
COPY ./localnet-init.sh ./localnet-init.sh
COPY --from=build ./testnet-release.wasm ./testnet-release.wasm

RUN chmod +x localnet-init.sh
RUN ./localnet-init.sh

CMD ["/root/.nearup/near/localnet/neard", "--home", "root/.near/localnet/node0", "run"]