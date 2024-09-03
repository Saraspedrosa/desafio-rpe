require 'spec_helper'
require_relative '../../../lib/api_client'
require_relative '../../support/request_logger'
require_relative '../../helpers/api_helpers'

RSpec.describe 'API de atualização de dados de usuário', type: :request do
  include RequestLogger
  include ApiHelpers

  let(:schema_path) { 'schemas/user_patch_schemas.json' }
  let(:base_uri) { APIClient.base_uri + '/users' }
  let(:id) { 2 }
  let(:invalid_id) { 9999 }
  let(:invalid_user_id) { 'abc' }
  let(:valid_user_params) { { name: 'João dos bugs', job: 'Engenheiro de Qualidade Senior' } }
  let(:invalid_params_list) do
    [
      { name: '', job: 'Desenvolvedor' },
      { name: 'Maria dos Testes', job: nil },
      { name: 123, job: 'Desenvolvedor' },
      { name: 'Maria dos Testes', job: {} },
      {}
    ]
  end

  it 'Atualiza um usuário com dados válidos' do
    log_request(valid_user_params)

    response = log_and_request(:put, id, valid_user_params)
    validate_response(response, 200)

    aggregate_failures do
      expect(response.parsed_response['job']).to eq(valid_user_params[:job])
    end
    contract_verify(response.parsed_response)
  end

  it 'Não atualiza um usuário com ID inválido' do
    response = log_and_request(:put, invalid_user_id, valid_user_params)
    validate_response(response, 400)
  end

  it 'Não atualiza um usuário com ID inexistente' do
    response = log_and_request(:put, invalid_id, valid_user_params)
    validate_response(response, 404)
  end

  # Não há validações da API para inputs inválidos.
  it 'Não atualiza um usuário com dados inválidos' do
    invalid_params_list.each do |params|
      response = log_and_request(:put, id, params)
      validate_response(response, 400)
    end
  end

  it 'Não atualiza um usuário com campos faltantes' do
    response = log_and_request(:put, id, { name: 'John Doe' })
    validate_response(response, 400)

    response = log_and_request(:put, id, { job: 'Software Developer' })
    validate_response(response, 400)
  end
end