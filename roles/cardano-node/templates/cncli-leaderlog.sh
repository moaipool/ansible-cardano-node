#!/usr/bin/env bash

epoch="${1:-next}"
timezone="${2:-UTC}"

function getStatus() {
    local result
    result=$(/usr/local/bin/cncli status \
        --db ${CNODE_HOME}/scripts/cncli.db \
        --byron-genesis ${CNODE_HOME}/mainnet-byron-genesis.json \
        --shelley-genesis ${CNODE_HOME}/mainnet-shelley-genesis.json \
        | jq -r .status
    )
    echo "$result"
}

function getLeader() {
    /usr/local/bin/cncli leaderlog \
        --db ${CNODE_HOME}/scripts/cncli.db \
        --pool-id  $(cat ${CNODE_HOME}/stakepoolid.txt) \
        --pool-vrf-skey ${CNODE_HOME}/vrf.skey \
        --byron-genesis ${CNODE_HOME}/mainnet-byron-genesis.json \
        --shelley-genesis ${CNODE_HOME}/mainnet-shelley-genesis.json \
        --ledger-set "$epoch" \
        --tz "$timezone"
}

statusRet=$(getStatus)

if [[ "$statusRet" == "ok" ]]; then
    mv ${CNODE_HOME}/scripts/leaderlog.json ${CNODE_HOME}/scripts/leaderlog."\$(date +%F-%H%M%S)".json
    getLeader > ${CNODE_HOME}/scripts/leaderlog.json
    find . -name "leaderlog.*.json" -mtime +15 -exec rm -f '{}' \;
else
    echo "CNCLI database not synced!!!"
fi

exit 0