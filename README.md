# Local AI Automation Stack (n8n + Ollama)

This project sets up a completely self-hosted, local AI workflow automation environment combining **n8n** (the powerful node-based automation platform) and **Ollama** (the local LLM runtime). 

It is pre-configured to download and use **`llama3.1:8b`** as the main large language model and **`nomic-embed-text`** as the text embedding model for building local RAG (Retrieval-Augmented Generation) applications.

---

## 🏗️ Architecture

- **n8n**: Accessible via `http://localhost:5678`
- **Ollama API**: Accessible via `http://localhost:11434` (Internal service address for n8n: `http://ollama:11434`)
- **Network**: Both services run inside an isolated Docker bridge network called `ai-network`.
- **Persistence**: 
  - `./ollama_data` tracks your downloaded AI models.
  - `./n8n_data` tracks your workflows, credentials, and configuration execution history.

---

## 🛠️ Prerequisites

Before you start, make sure you have the following installed on your machine:
1. **Docker Desktop** (with Docker Compose enabled).
2. **Windows Operating System** (to run the setup batch script natively).

---

## 🚀 Quick Start Setup

1. **Save the Script**: Ensure you have the automation batch script (e.g., `setup-stack.bat`) inside your working folder.
2. **Run the Script**: Double-click `setup-stack.bat` or run it from your command prompt:
   ```cmd
   setup-stack.bat
