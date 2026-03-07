#' litellmR: Lightweight R wrapper for LiteLLM
#'
#' The `litellmR` package provides a simple interface to interact with
#' LiteLLM language models from R. It allows sending prompts, receiving
#' generated responses, and querying available models, all via a
#' LiteLLM server using an OpenAI-compatible API.
#'
#' @section Main functions:
#' \describe{
#'   \item{\code{\link{litellm_setup}}}{Configure the API key and server URL. Must be run before other functions.}
#'   \item{\code{\link{litellm_prompt}}}{Send one or more prompts to a LiteLLM model (without chat context).}
#'   \item{\code{\link{litellm_chat}}}{Send a chat message to a LiteLLM model (multi-turn).}
#'   \item{\code{\link{litellm_models}}}{List the models available on the LiteLLM server.}
#' }
#'
#' @name litellmR
#' @author SA van der Wulp
#'
#' @examples
#' \dontrun{
#' library(litellmR)
#'
#' # 1. Set up the connection
#' litellm_setup(
#'   api_key = "YOUR_API_KEY",
#'   base_url = "https://my-litellm-server/v1"
#' )
#'
#' # 2. Check available models
#' litellm_models()
#'
#' # 3. Send a single prompt (without chat context)
#' litellm_prompt("Explain regression analysis in simple terms.")
#'
#' # 4. Multi-turn chat (context preserved)
#' litellm_chat("Explain regression analysis in simple terms.")
#' litellm_chat("That is way too complex for me.")
#' }
#'
#' @keywords internal
"_PACKAGE"
