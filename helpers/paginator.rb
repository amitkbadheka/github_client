require 'httparty'

class Helpers


  module  Paginator
    NEXT_PATTERN = /(?<=<)([\S]*)(?=>; rel="next")/i

    def paginate(url, headers, request_type=:http)
      # this method sends an API request to Github
      # based on the request_type. Eg: if request_type=:http
      # it sends http request, otherwise it will send GraphQL request
      # to fetch the repo details

      data = []
      case request_type
      when :http
        next_page_present = true

        while next_page_present && !url.empty?
          response = HTTParty.get(url, headers: headers)
          data += JSON.parse(response.body)
          link_header = response.headers['link'].to_s
          next_page_present = link_header.include?('rel="next"')
          if next_page_present
            url = link_header.match(NEXT_PATTERN).to_s
          end
        end
      when :gql
      end

      data
    end
  end
end