# 📚 Package litellmR

R package providing a simple interface to interact with LiteLLM AI language models.

## ✈️ Installation

Run these R commands:

  ```r
  # Install remotes package if necessary
  install.packages("remotes")
  
  # Install litellmR package from GitHub
  remotes::install_github("vdwulp/litellmR")
  ```

## 🚶 Basic usage

Code example:

  ```r
  library(litellmR)

  # Set up the connection
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

### Multiple prompts at once

Prompts can be provided as a vector:

  ```R
  prompts <- c(
    "Summarize key points about teaching feedback.",
    "Give tips for improving student engagement."
  )
  litellm_prompt(prompts)
  ```

Or integrated in a tidyverse pipeline:

  ```R
  df <- tibble(
    Number = 1:2,
    Request = c( "Summarize key points about teaching feedback.",
                 "Give tips for improving student engagement." )
  )
    
  df |>
    mutate(Response = litellm_prompt(Request))
  ```

- Each element in the vector or data frame column is treated as a separate prompt.

### Multi-turn chat

For a multi-turn chat where context is preserved across messages:

  ```R
  litellm_chat("Explain regression analysis in simple terms.")
  litellm_chat("That is way too complex for me.")
  ```

- litellm_prompt() is stateless, best for single or batched prompts where context is not needed.
- litellm_chat() preserves conversation context, suited for multi-turn interactions.

### Model and temperature

You can specify the AI model and/or temperature:

  ```R
  litellm_prompt("Explain regression analysis in simple terms.",
                 model = "gpt-4.1",
                 temperature = 1.0 )
  ```

- `model` selects which LiteLLM AI model to use (default `gpt-4o-mini`, `gpt-4.1` in example).
- `temperature` controls creativity/randomness (0 = deterministic, 1 = creative, default 0.7).

## 🗒️ License
MIT License, full text available in [LICENSE](https://github.com/vdwulp/litellmR/blob/master/LICENSE.md) file.

Copyright (c) 2026 SA van der Wulp
