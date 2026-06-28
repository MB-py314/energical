@echo off
echo ===================================================
echo   Setting up Local AI Stack (n8n + Ollama)
echo ===================================================

:: 1. Create a dedicated project directory and navigate into it
echo Creating directory "local-ai-stack"...
mkdir local-ai-stack
cd local-ai-stack

:: 2. Create the docker-compose.yml file directly from the script
echo Generating docker-compose.yml configuration...
(
echo version: '3.8'
echo.
echo networks:
echo   ai-network:
echo     driver: bridge
echo.
echo services:
echo   ollama:
echo     image: ollama/ollama:latest
echo     container_name: ollama
echo     restart: unless-stopped
echo     ports:
echo       - "11434:11434"
echo     volumes:
echo       - ./ollama_data:/root/.ollama
echo     networks:
echo       - ai-network
echo.
echo   n8n:
echo     image: docker.n8n.io/n8nio/n8n:latest
echo     container_name: n8n
echo     restart: unless-stopped
echo     ports:
echo       - "5678:5678"
echo     volumes:
echo       - ./n8n_data:/home/node/.n8n
echo     environment:
echo       - N8N_HOST=localhost
echo       - N8N_PORT=5678
echo       - N8N_PROTOCOL=http
echo       - NODE_ENV=production
echo       - WEBHOOK_URL=http://localhost:5678/
echo     depends_on:
echo       - ollama
echo     networks:
echo       - ai-network
) > docker-compose.yml

:: 3. Stop and clean up any old, standalone containers to free up the ports
echo.
echo Cleaning up any old conflicting containers...
docker stop n8n ollama >nul 2>&1
docker rm n8n ollama >nul 2>&1

:: 4. Start the new Docker Compose stack
echo.
echo Launching the Docker Compose stack...
docker compose up -d

echo.
echo ===================================================
echo   SUCCESS! Your stack is initializing.
echo ===================================================
echo  - n8n interface: http://localhost:5678
echo  - Ollama internal address for n8n: http://ollama:11434
echo ===================================================
echo.

:: 5. Prompt to download the LLM and Embedding models automatically
set /p download_model="Do you want to download llama3.1:8b and nomic-embed-text models inside Ollama right now? (y/n): "
if /i "%download_model%"=="y" (
    echo.
    echo Downloading llama3.1:8b... This might take a few minutes.
    docker exec -it ollama ollama pull llama3.1:8b
    
    echo.
    echo Downloading nomic-embed-text...
    docker exec -it ollama ollama pull nomic-embed-text
    
    echo.
    echo All models downloaded successfully!
) else (
    echo.
    echo Skipped model download. You can download them manually later using:
    echo docker exec -it ollama ollama pull llama3.1:8b
    echo docker exec -it ollama ollama pull nomic-embed-text
)

pause