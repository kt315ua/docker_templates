# Run Vulkan/ROCm LLaMa

docker compose build   

docker compose up
docker compose stop 
docker compose rm

# Simple LLM start (using Open-WebUI)
Just run script: `./start.sh`

# RAG Launching

For RAG you need run `./start-rag.sh` and then configure **Anything LLM**:
- LLM: 
  - Settings > AI Providers > LLM
    - Ollama Model: llama3.1:8b
    - Ollama Base URL: http://ollama-rag-llm-model:11434
- Embedding
  - Settings > AI Providers > Embedder
    - Embedding Provider: nomic-embed-text:latest
    - Ollama Base URL: http://ollama-rag-embed-model:11434
- Qdrant database
  - Settings > AI Providers > Vector Database
    - Vector Database Provider: QDrant
    - QDrant API Endpoint: http://ollama-rag-qdrant:6333
