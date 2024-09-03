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

  def validate_response(response, expected_code, error_message = nil)
    log_response(response, expected_code)

    aggregate_failures do
      expect(response.code).to eq(expected_code)
      expect(response.parsed_response['error']).to eq(error_message) if error_message
    end
  end

  def contract_verify(response)
    validation_errors = JSON::Validator.fully_validate(schema_path, response, strict: true)

    if validation_errors.empty?
      puts "Contrato validado com sucesso!"
    end

    expect(validation_errors).to be_empty, "Erro ao validar o contrato: #{validation_errors.join(', ')}"
  end
end
