ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative 'number_cruncher.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Number Cruncher" do

  it "should return the factors of 6" do
    6.factors.must_equal [1,2,3,6]
  end

  it "should say that 2 is prime" do
    assert 2.prime?
  end

  it "should say that 10 is not prime" do
    refute 10.prime?
  end

  it "should return json from root_url" do
    get '/6'
    last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "should return json from random" do
    get '/random/10'
    last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "should return the correct info about 6 as json" do
    get '/6'
    six_info = { number: 6, factors: 6.factors, odd: 6.odd?, even: 6.even?, prime: 6.prime? }
    six_info.to_json.must_equal last_response.body
  end

  it "should return a random number less than 10 and a float and the seed as json" do
    get '/random/10'
    body = JSON.parse(last_response.body)
    body["int"].to_i < 10 && body["float"] && body["seed"]
  end

end
