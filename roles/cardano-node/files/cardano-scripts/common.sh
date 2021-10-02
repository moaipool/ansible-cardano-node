#!/usr/bin/env bash
# Bunch of common functions which are used repeatedly by Ansible and the Cardano user.

#Subroutines to calculate current slotHeight(tip)
get_currentTip() {
local currentTip=$(${CARDANO_CLI} shelley query tip ${MAGIC_PARAM} ${MAGIC} | grep -oP 'unSlotNo = \K\d+')
echo ${currentTip}
}

#Subroutines to calculate current TTL
get_currentTTL() {
echo $(( $(get_currentTip) + 10000 ))
}

#Subroutines to calculate time until next epoch from genesis.json
get_timeUntilNextEpoch() {
local startTimeGenesis=$(cat ${GENESIS_JSON} | jq -r .systemStart)
local startTimeSec=$(date --date=${startTimeGenesis} +%s)     #in seconds (UTC)
local currentTimeSec=$(date -u +%s)                           #in seconds (UTC)
local epochLength=$(cat ${GENESIS_JSON} | jq -r .epochLength)
local currentEPOCH=$(( (${currentTimeSec}-${startTimeSec}) / ${epochLength} ))  #returns a integer number, we like that
local timeUntilNextEpoch=$(( ${epochLength} - (${currentTimeSec}-${startTimeSec}) + (${currentEPOCH}*${epochLength}) ))
echo ${timeUntilNextEpoch}
}

#Subroutines to calculate current epoch from genesis.json
get_currentEpoch() {
local startTimeGenesis=$(cat ${GENESIS_JSON} | jq -r .systemStart)
local startTimeSec=$(date --date=${startTimeGenesis} +%s)     #in seconds (UTC)
local currentTimeSec=$(date -u +%s)                           #in seconds (UTC)
local epochLength=$(cat ${GENESIS_JSON} | jq -r .epochLength)
local currentEPOCH=$(( (${currentTimeSec}-${startTimeSec}) / ${epochLength} ))  #returns a integer number, we like that
echo ${currentEPOCH}
}
