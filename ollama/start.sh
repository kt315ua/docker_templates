#!/bin/bash

export $(grep -v '^#' .env | xargs)


echo "Launching OLLAMA AI..."
echo "OLLAMA MODEL: ${OLLAMA_LLM_MODEL}"
echo "OLLAMA DATA PATH: ${OLLAMA_DATA}"
echo "Open-WEBUI DATA PATH: ${WEBUI_DATA}"

if [[ -z ${OLLAMA_DATA} ]]; then
    echo "OLLAMA data path ${OLLAMA_DATA} not found. Creating..."
    mkdir -p ${OLLAMA_DATA}
fi

if [[ -z ${WEBUI_DATA} ]]; then
    echo "Open-WEBUI data path ${WEBUI_DATA} not found. Creating..."
    mkdir -p ${WEBUI_DATA}
fi

echo "Starting service on http://${HOST_IP}:${HOST_PORT}..."

docker rm ollama-llm-model
docker rm open-webui

docker compose up
