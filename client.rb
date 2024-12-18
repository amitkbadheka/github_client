require 'httparty'
require_relative './helpers/paginotor.rb'
include  Helpers::Paginator


module Github
  class Client
    # this class is responsible for making requests to the Github API
    # It accepts a personal access token and stores it as an instance variable.
    # It has a method called `get` that accepts a URL and returns the response
    # from the Github API

    def initialize(token, repo_url)
      # implement this method
      @token = token
      @repo_url = repo_url
    end

    def get(url)
      # this method generates the required headers that use the bearer token 
      # and paginates the GET request to the Github API using the provided URL.
      # It returns the response from the Github API
      # It appends the path in the url argument to the repo_url instance variable
      # to form the full URL
      paginate("#{@repo_url}#{url}", headers, :http)
    end

    private


    def headers
      # this method returns the headers required to make requests to the Github API using a personal access token
      {
        'Authorization' => "Bearer #{@token}",
        'User-Agent' => 'Github Client'
      }
    end
  end
end
