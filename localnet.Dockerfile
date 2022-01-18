FROM ubuntu:18.04

# ---------- install utils ----------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y curl git wget

# ---------- install rust ----------

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
# check cargo works
RUN cargo version
# rustup
RUN rustup default stable
RUN rustup target add wasm32-unknown-unknown

# ---------- install nearup ----------
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip

RUN pip3 install nearup

# ---------- install npm, yarn, nodejs ----------

ARG NODE_VERSION=14.18.0
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN node --version
RUN npm --version

# ---------- install yarn ----------

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update
RUN apt install -y yarn
RUN yarn --version

# ---------- install go ----------

RUN curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz --output go.tar.gz
RUN tar -C /usr/local -xzf go.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin
RUN go version

# ---------- install near and aurora cli ----------

RUN npm install -g near-cli

RUN npm install -g aurora-is-near/aurora-cli

# ---------- run/init near and aurora ----------

COPY . .

RUN make -B testnet
RUN chmod +x localnet-init.sh
USER root
RUN ./localnet-init.sh

CMD ["/root/.nearup/near/localnet/neard", "--home", "root/.near/localnet/node0", "run"]