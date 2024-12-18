require 'rspec'
require 'webmock/rspec'
require_relative '../../helpers/paginator.rb'

RSpec.describe Helpers::Paginator do
  include Helpers::Paginator

  let(:headers) { { 'Authorization' => 'Bearer GITHUB_TOKEN' } }
  let(:base_url) { 'http://example.com/data' }
  let(:page1_data) { [{ 'id' => 1, 'name' => 'Item 1' }] }
  let(:page2_data) { [{ 'id' => 2, 'name' => 'Item 2' }] }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it 'paginates through multiple pages' do
    page1_link = '<http://example.com/data?page=2>; rel="next"'

    stub_request(:get, base_url)
      .with(headers: headers)
      .to_return(body: page1_data.to_json, headers: { 'link' => page1_link })

    stub_request(:get, 'http://example.com/data?page=2')
      .with(headers: headers)
      .to_return(body: page2_data.to_json, headers: {})

    result = paginate(base_url, headers)
    expect(result).to eq(page1_data + page2_data)
  end

  it 'handles no pagination links' do
    stub_request(:get, base_url)
      .with(headers: headers)
      .to_return(body: page1_data.to_json, headers: {})

    result = paginate(base_url, headers)
    expect(result).to eq(page1_data)
  end

  it 'returns empty array for empty initial URL' do
    result = paginate('', headers)
    expect(result).to eq([])
  end

  it 'returns empty array for no data in response' do
    stub_request(:get, base_url)
      .with(headers: headers)
      .to_return(body: [].to_json, headers: {})

    result = paginate(base_url, headers)
    expect(result).to eq([])
  end

end