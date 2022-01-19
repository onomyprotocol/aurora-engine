* Build
```
docker build -t onomy/aurora-engine-local:local --progress=plain --network=host -f localnet.Dockerfile .
```

* Run
```
docker run -p 3030:3030 --name aurora-engine-local -d onomy/aurora-engine-local:local
```

* Login to the container
```
docker exec -it aurora-engine-local sh
```

* Examine engine:
```
export AURORA_ENGINE=aurora.node0
aurora get-version
aurora get-owner
aurora get-chain-id
aurora encode-address aurora.node0
aurora get-balance 0x177DF8c673ef3007eCa4b2BaBcFe2A6CaF529dd8
```

* Deploy and inspect the contract
```
export NEAR_ENV=local
export AURORA_ENGINE=aurora.node0
export NEAR_MASTER_ACCOUNT=aurora.node0

aurora deploy 0x600060005560648060106000396000f360e060020a6000350480638ada066e146028578063d09de08a1460365780632baeceb714604d57005b5060005460005260206000f3005b5060016000540160005560005460005260206000f3005b5060016000540360005560005460005260206000f300

# take the address fron the respnse

aurora -d -v get-nonce 0x134c83de83d37c0c59860fa4a9433d026ca29ac8
aurora get-code 0x134c83de83d37c0c59860fa4a9433d026ca29ac8
aurora get-storage-at 0x134c83de83d37c0c59860fa4a9433d026ca29ac8 0

```

* Add/get account balance.

```

export NEAR_ENV=local
export AURORA_ENGINE=aurora.node0
export NEAR_MASTER_ACCOUNT=aurora.node0

near call aurora.node0 fund_account '{"address": "0x134c83de83d37c0c59860fa4a9433d026ca29ac8", "amount": "100000000000000000000000"}' \
    --accountId aurora.node0 --keyPath /root/.near-credentials/local/aurora.node0.json

aurora get-balance 0x134c83de83d37c0c59860fa4a9433d026ca29ac8
aurora get-nonce 0x134c83de83d37c0c59860fa4a9433d026ca29ac8
```
