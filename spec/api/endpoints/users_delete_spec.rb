require 'spec_helper'
require_relative '../../../lib/api_client'
require_relative '../../support/request_logger'
require_relative '../../helpers/api_helpers'

RSpec.describe 'API de deleção de usuário', type: :request do
  include RequestLogger
  include ApiHelpers

  let(:base_uri) { APIClient.base_uri + '/users' }
  let(:id) { 2 }
  let(:nonexistent_user_id) { 9999 }
  let(:invalid_user_id) { 'abc' }

  it 'Exclui um usuário válido' do
    response = log_and_request(:delete, id)
    validate_response(response, 204)
  end

  it 'Não exclui um usuário que não existe' do
    response = log_and_request(:delete, id)
    validate_response(response, 404)
  end

  it 'Não exclui um usuário sem fornecer um ID' do
    response = log_and_request(:delete, nil)
    validate_response(response, 400)
  end
end
