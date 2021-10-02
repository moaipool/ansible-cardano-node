#!/usr/bin/env bash

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

function sendSlots() {
    /usr/local/bin/cncli sendslots \
        --db ${CNODE_HOME}/scripts/cncli.db \
        --byron-genesis ${CNODE_HOME}/mainnet-byron-genesis.json \
        --shelley-genesis ${CNODE_HOME}/mainnet-shelley-genesis.json \
        --config ${CNODE_HOME}/scripts/pooltool.json
}

statusRet=$(getStatus)

if [[ "$statusRet" == "ok" ]]; then
    mv ${CNODE_HOME}/scripts/sendslots.log ${CNODE_HOME}/scripts/sendslots."\$(date +%F-%H%M%S)".log
    sendSlots > ${CNODE_HOME}/scripts/sendslots.log
    find . -name "sendslots.*.log" -mtime +15 -exec rm -f '{}' \;
else
    echo "CNCLI database not synced!!!"
fi

exit 0