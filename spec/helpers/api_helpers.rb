require 'json-schema'
require_relative '../support/request_logger'

module ApiHelpers


  def log_and_request(method, id, params = {})
    log_request("#{method.upcase} - '#{base_uri}'")

    case method
    when :create
      APIClient.send("#{method}_user", params)
    when :patch, :put
      APIClient.send("#{method}_user", id, params)
    when :delete
      APIClient.send("#{method}_user", id)
    else
      raise ArgumentError, "Método inválido: #{method}"
    end
  end

  def validate_response(response, expected_code)
    log_response(response, expected_code)

    expect(response.code).to eq(expected_code)
  end

  def contract_verify(response)
    validation_errors = JSON::Validator.fully_validate(schema_path, response, strict: true)

    if validation_errors.empty?

      RequestLogger::LOG.info("Contrato validado com sucesso!")
    end

    expect(validation_errors).to be_empty, "Erro ao validar o contrato: #{validation_errors.join(', ')}"
  end
end
