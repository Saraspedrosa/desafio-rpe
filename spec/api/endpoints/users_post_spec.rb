require 'spec_helper'
require 'json-schema'
require_relative '../../../lib/api_client'
require_relative '../../support/request_logger'
require_relative '../../helpers/api_helpers'


RSpec.describe 'API de criação de usuários', type: :request do
  include RequestLogger
  include ApiHelpers

  let(:schema_path) { 'schemas/user_schemas.json' }
  let(:base_uri) { APIClient.base_uri + '/users' }
  let(:valid_user_params) { { name: 'João dos Testes', job: 'Engenheiro de Qualidade' } }

  let(:invalid_params_list) do
    [
      { name: '', job: 'Desenvolvedor' },
      { name: 'Maria dos Testes', job: nil },
      { name: 123, job: 'Desenvolvedor' },
      { name: 'Maria dos Testes', job: {} },
      {}
    ]
  end

  it 'Criando um novo usuário' do
    log_request(valid_user_params)
    response = log_and_request(:create, nil, valid_user_params)
    validate_response(response, 201)

    aggregate_failures do
      expect(response.parsed_response['name']).to eq(valid_user_params[:name])
      expect(response.parsed_response['job']).to eq(valid_user_params[:job])
      expect(response.parsed_response['id']).not_to be_nil
    end

    contract_verify(response.parsed_response)
  end

  # Não há validações da API para inputs inválidos.
  it 'Não cria um usuário a partir de inputs inválidos' do
    log_request(valid_user_params)

    invalid_params_list.each do |params|
      response = log_and_request(:create, nil, params)
      validate_response(response, 400)
    end
  end
end
