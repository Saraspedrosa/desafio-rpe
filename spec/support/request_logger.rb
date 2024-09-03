# spec/support/request_logger.rb

module RequestLogger
  def log_request(request_body, url = nil)
    puts "Request URL: #{url}" if url
    puts "Request Body: #{JSON.pretty_generate(request_body)}"
  end

  def log_response(response, expect_code)
    begin
      puts "status code Esperado: #{expect_code}"
      puts "status code Recebido da API: #{response.code}"

      formatted_json = JSON.pretty_generate(JSON.parse(response.body))
      puts "Response:\n#{formatted_json}"
    rescue => exception
      puts "Falha ao retornar a requisição parseada #{response.body}"
      puts exception
    end
  end
end
