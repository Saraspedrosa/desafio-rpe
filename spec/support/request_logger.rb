require 'json'
require 'logger'


module RequestLogger
  LOG = Logger.new(STDOUT)
  file = Logger.new('evidence.log')

  LOG.level = Logger::DEBUG
  file.level = Logger::DEBUG

  def log_request(request_body = nil, url = nil)
    LOG.info("Request URL: #{url}") if url
    LOG.info("Request Body: #{JSON.pretty_generate(request_body)}")
  end

  def log_response(response, expect_code)
    begin
      LOG.info("status code Esperado: #{expect_code}")
      LOG.info("status code Recebido da API: #{response.code}")

      formatted_json = response.body ? JSON.pretty_generate(JSON.parse(response.body)) : "Não possui response"
      LOG.info("Response:\n#{formatted_json}")
    rescue => exception
      LOG.info("Falha ao retornar a requisição parseada #{response.body}")
      LOG.info(exception)
    end
  end
end
