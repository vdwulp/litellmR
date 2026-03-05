library(httr2)
library(jsonlite)

#' Configure connection settings for a LiteLLM server
#'
#' This function sets up the connection to a LiteLLM server by storing
#' the API key and the base URL of the server in the current R session.
#' Other functions in this package (such as `litellm_chat()` and
#' `litellm_models()`) use these settings automatically when sending
#' requests to the server.
#'
#' The settings are stored using `options()` and remain available
#' for the duration of the current R session.
#'
#' @param api_key Character string. The API key used to authenticate
#'   with the LiteLLM server. This key is usually provided by the
#'   administrator of the server or the API provider.
#'
#' @param base_url Character string. The base URL of the LiteLLM API,
#'   including the `/v1` path. For example:
#'
#'   `"https://my-litellm-server/v1"`
#'
#'   or for a local installation:
#'
#'   `"http://localhost:4000/v1"`
#'
#' @details
#' This function typically needs to be called **once per R session**
#' before using other functions in this package.
#'
#' The API key is stored internally in:
#'
#' `options("litellm_api_key")`
#'
#' and the server URL in:
#'
#' `options("litellm_base_url")`
#'
#' @return
#' This function returns no value. It stores the configuration
#' in the R session options.
#'
#' @examples
#' \dontrun{
#'
#' litellm_setup(
#'   api_key = "MY_API_KEY",
#'   base_url = "https://my-server/v1"
#' )
#'
#' }
#'
#' @export
litellm_setup <- function(api_key, base_url) {
  options(
    litellm_api_key = api_key,
    litellm_base_url = base_url
  )
}

#' Send a prompt to a LiteLLM chat model
#'
#' This function sends a prompt to a language model via a LiteLLM server
#' and returns the generated response as text.
#'
#' LiteLLM provides an OpenAI-compatible API that allows different
#' language models to be accessed through a single interface.
#'
#' Before using this function, a connection must be configured with
#' `litellm_setup()`.
#'
#' @param prompt Character string. The question or instruction to send
#'   to the language model. For example:
#'   `"Explain what regression analysis is."`
#'
#' @param model Character string. The name of the model to use.
#'   The available models depend on the LiteLLM server configuration.
#'   Examples include `"gpt-4o-mini"` or `"gpt-4o"`.
#'
#' @param temperature Numeric value controlling the randomness of the
#'   generated output.
#'   \itemize{
#'   \item Low values (e.g., 0.1–0.3) produce more deterministic answers
#'   \item Medium values (~0.5–0.7) provide balanced responses
#'   \item Higher values (~0.8–1) produce more creative outputs
#'   }
#'
#' @param max_tokens Integer. The maximum number of tokens the model
#'   is allowed to generate in its response. Larger values allow longer
#'   answers but may increase processing time or API usage.
#'
#' @param system_prompt Optional character string. A system instruction
#'   that defines the role or behavior of the model before the user
#'   prompt is processed. For example:
#'
#'   `"You are a statistics teacher who explains concepts clearly."`
#'
#' @param new_context Logical. If TRUE, starts a new conversation by
#'   clearing all previous messages and the stored system prompt. The new
#'   conversation will only include the current prompt and, if provided, a
#'   new system prompt. If FALSE (default), the previous conversation context
#'   is preserved.
#'
#' @return Character string containing the model's response.
#'
#' @seealso litellm_setup(), litellm_models()
#'
#' @examples
#' \dontrun{
#'
#' # Configure connection
#' litellm_setup(
#'   api_key = "MY_API_KEY",
#'   base_url = "https://my-server/v1"
#' )
#'
#' # Simple prompt
#' litellm_chat("What is machine learning?")
#'
#' # Prompt with a system role
#' litellm_chat(
#'   "Explain regression analysis.",
#'   system_prompt = "You are a statistics teacher."
#' )
#'
#' # More creative output
#' litellm_chat(
#'   "Write a short haiku about data science",
#'   temperature = 0.9
#' )
#'
#' }
#'
#' @export
litellm_chat <- function(prompt,
                         model = "gpt-4o-mini",
                         temperature = 0.7,
                         max_tokens = 500,
                         system_prompt = NULL,
                         new_context = FALSE) {

  # Ensure setup
  api_key <- getOption("litellm_api_key")
  base_url <- getOption("litellm_base_url")

  if (is.null(api_key) || is.null(base_url)) {
    stop("Run litellm_setup() first.")
  }

  # Ensure environment exists
  if (!exists(".litellm_env", envir = .GlobalEnv)) {
    assign(".litellm_env", new.env(), envir = .GlobalEnv)
  }
  env <- get(".litellm_env", envir = .GlobalEnv)

  # Initialize storage if needed
  if (!exists("messages", envir = env)) env$messages <- list()
  if (!exists("system_prompt", envir = env)) env$system_prompt <- NULL

  # Handle new context
  if (new_context) {
    env$messages <- list()
    env$system_prompt <- NULL
  }

  # Update system prompt if provided
  if (!is.null(system_prompt)) {
    env$system_prompt <- list(role = "system", content = system_prompt)
  }

  # Build message list
  messages <- list()
  if (!is.null(env$system_prompt)) messages <- list(env$system_prompt)
  if (length(env$messages) > 0) messages <- append(messages, env$messages)
  messages <- append(messages, list(list(role = "user", content = prompt)))

  req <- request(paste0(base_url, "/chat/completions")) |>
    req_headers(
      "x-litellm-api-key" = api_key,
      "Content-Type" = "application/json"
    ) |>
    req_body_json(list(
      model = model,
      messages = messages,
      temperature = temperature,
      max_tokens = max_tokens
    ))

  resp <- req_perform(req)
  json <- resp_body_json(resp)

  answer <- json$choices[[1]]$message$content

  # Append assistant response to stored context
  env$messages <- append(env$messages, list(list(role = "user", content = prompt),
                                            list(role = "assistant", content = answer)))

  return(answer)
}

#' Retrieve available models from the LiteLLM server
#'
#' This function requests a list of available language models from the
#' LiteLLM server. It can be used to check which models are accessible
#' before calling functions such as `litellm_chat()`.
#'
#' @details
#' The function sends a request to the `/models` endpoint of the
#' LiteLLM API and returns the response as an R list.
#'
#' A connection must first be configured using `litellm_setup()`.
#'
#' @return
#' A list containing information about the models available on the
#' LiteLLM server. The exact structure depends on the server
#' configuration but typically includes model names and metadata.
#'
#' @examples
#' \dontrun{
#'
#' litellm_setup(
#'   api_key = "MY_API_KEY",
#'   base_url = "https://my-server/v1"
#' )
#'
#' models <- litellm_models()
#'
#' print(models)
#'
#' }
#'
#' @export
litellm_models <- function() {

  api_key <- getOption("litellm_api_key")
  base_url <- getOption("litellm_base_url")

  req <- request(paste0(base_url, "/models")) |>
    req_headers(
      "x-litellm-api-key" = api_key
    )
  resp <- req_perform(req)

  resp_body_json(resp)
}

