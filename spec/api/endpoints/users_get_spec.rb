require 'json-schema'

require_relative '../../../lib/api_client'
require_relative '../../support/request_logger'
require_relative '../../helpers/api_helpers'

RSpec.describe 'API de consulta de usuários', type: :request do
  include RequestLogger

  let(:base_uri) { APIClient.base_uri }
  let(:id) { 2 }
  let(:invalid_id) { 9999 }

  it 'Listar todos os usuários' do
    log_request(nil, "GET - #{base_uri}/users")

    response = APIClient.list_users
    log_response(response, 200)

    expect(response.parsed_response['data']).to be_an(Array)
  end

  it 'Consultar um usuário específico' do
    log_request(nil, "GET - #{base_uri}/users/#{id}")

    response = APIClient.get_user(id)
    log_response(response, 200)
  end

  it 'Retorna erro quando o usuário não é encontrado' do
    log_request(nil, "GET - #{base_uri}/users/#{invalid_id}")

    response = APIClient.get_user(invalid_id)
    log_response(response, 404)
  end
end