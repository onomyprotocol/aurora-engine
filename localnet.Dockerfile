FROM ubuntu:20.04 as build

RUN apt update
RUN apt install -y curl make git wget build-essential
ENV DEBIAN_FRONTEND=noninteractive

# ---------- install rust ----------

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo version
# rustup
RUN rustup default stable
RUN rustup target add wasm32-unknown-unknown

# ---------- install yarn ----------

RUN curl https://deb.nodesource.com/setup_14.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN yarn --version

# build testnet/localnet
COPY . .
RUN make clean
RUN make -B testnet

FROM ubuntu:20.04

RUN apt update
RUN apt install -y curl git wget

# ---------- install nearup ----------
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip

RUN pip3 install nearup

# ---------- install npm and nodejs ----------

ARG NODE_VERSION=14.18.0
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# ---------- install near and aurora cli ----------

RUN npm install -g near-cli
RUN npm install -g aurora-is-near/aurora-cli

# ---------- run/init near and aurora ----------

COPY ./localnet-init.sh ./localnet-init.sh
COPY --from=build ./testnet-release.wasm ./testnet-release.wasm

RUN chmod +x localnet-init.sh
USER root
RUN ./localnet-init.sh

CMD ["/root/.nearup/near/localnet/neard", "--home", "root/.near/localnet/node0", "run"]