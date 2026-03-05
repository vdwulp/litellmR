# 📚 Package litellmR

R package providing a simple interface to interact with LiteLLM AI language models.

## ✈️ Installation

Run these R commands:

  ```r
  # Install remotes package if necessary
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }
  
  # Install litellmR package from GitHub
  remotes::install_github("vdwulp/litellmR")
  ```

## 🚶 Basic usage

Code example:

  ```r
  library(litellmR)

  # 1. Set up the connection
  litellm_setup(
    api_key = "YOUR_API_KEY",
    base_url = "https://my-litellm-server/v1"
  )

  # 2. Check available models
  litellm_models()

  # 3. Send a prompt
  litellm_prompt("Explain regression analysis in simple terms.")
   ```

For extended documentation, use:

  ```r
  ?litellmR
  ```

## 🏃 Advanced usage

For a multi-turn chat where context is preserved across messages:

  ```R
  # 4. Chat with LiteLLM
  litellm_chat("Explain regression analysis in simple terms.")
  litellm_chat("That is way too complex for me.")
  ```

Note:
- Use litellm_prompt() for one-off queries or batch processing where context is not needed.
- Use litellm_chat() when you need follow-up messages to be aware of previous conversation.

## 🗒️ License
To be added later...

Copyright (c) 2026 SA van der Wulp
