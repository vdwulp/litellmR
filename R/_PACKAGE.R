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
#'   \item{\code{\link{litellm_chat}}}{Send a user prompt to a LiteLLM model and receive a response.}
#'   \item{\code{\link{litellm_models}}}{List the models available on the LiteLLM server.}
#' }
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
#' # 3. Send a prompt
#' litellm_chat("Explain regression analysis in simple terms.")
#' }
#'
#' @keywords internal
"_PACKAGE"
