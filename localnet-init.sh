#!/bin/bash
set -eu

echo "starting aurora initialisation"

NEAR_KEY_PATH_FLAG="--keyPath /root/.near/localnet/node0/validator_key.json"
AURORA_KEY_PATH_FLAG="--keyPath /root/.near-credentials/local/aurora.node0.json"

export NEAR_ENV=local
nearup run localnet --num-nodes 1
near create-account aurora.node0 --master-account node0 --initial-balance 100000 $NEAR_KEY_PATH_FLAG
near deploy --account-id=aurora.node0  --wasm-file=/testnet-release.wasm $AURORA_KEY_PATH_FLAG

export AURORA_ENGINE=aurora.node0
export NEAR_MASTER_ACCOUNT=aurora.node0
aurora -d -v initialize --chain 1313161556 --owner aurora.node0

# check that the node is working
aurora get-balance 0x134c83de83d37c0c59860fa4a9433d026ca29ac8
aurora get-nonce 0x134c83de83d37c0c59860fa4a9433d026ca29ac8

echo "aurora initialisation done"
nearup stop
echo "near is stopped"