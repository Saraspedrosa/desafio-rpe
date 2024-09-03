require 'httparty'
require 'json'


class APIClient
  include HTTParty

  base_uri 'https://reqres.in/api'

  def self.ssl_options
    { verify: false }
  end

  def self.list_users
    get('/users',
        verify: ssl_options[:verify])
  end

  def self.get_user(id)
    get("/users/#{id}",
        verify: ssl_options[:verify])
  end

  def self.create_user(params)
    post('/users',
         body: params.to_json,
         headers: { 'Content-Type': 'application/json' },
         verify: ssl_options[:verify])
  end

  def self.put_user(id, params)
    put("/users/#{id}",
        body: params.to_json,
        headers: { 'Content-Type': 'application/json' },
        verify: ssl_options[:verify])
  end

  def self.patch_user(id, params)
    put("/users/#{id}",
        body: params.to_json,
        headers: { 'Content-Type': 'application/json' },
        verify: ssl_options[:verify])
  end

  def self.delete_user(id)
    delete("/users/#{id}",
           verify: ssl_options[:verify])
  end
end
