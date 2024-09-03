#require 'spec_helper'
require 'json-schema'
require_relative '../../../lib/api_client'
require_relative '../../support/request_logger'
require_relative '../../helpers/api_helpers'

RSpec.describe 'API de atualização parcial de dados de usuário', type: :request do
  include RequestLogger
  include ApiHelpers

  let(:schema_path) { 'schemas/user_update_schemas.json' }
  let(:base_uri) { APIClient.base_uri + '/users' }
  let(:id) { 2 }
  let(:invalid_id) { 9999 }
  let(:valid_user_params) { { name: 'João dos bugs', job: 'Engenheiro de Qualidade' } }
  let(:patch_user_params) { { job: 'Engenheiro de Qualidade Pleno' } }
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
    response = log_and_request(:patch, id, valid_user_params)
    validate_response(response, 200)

    expect(response.parsed_response['job']).to eq(valid_user_params[:job])

    contract_verify(response.parsed_response)
  end

  # Não há validações da API para inputs inválidos.
  it 'Não atualiza um usuário com dados inválidos' do
    invalid_params_list.each do |params|
      response = log_and_request(:patch, id, params)
      validate_response(response, 400)
    end
  end

  it 'Não atualiza um usuário com ID inexistente' do
    response = log_and_request(:patch, invalid_id, valid_user_params)
    validate_response(response, 404)
  end
end
