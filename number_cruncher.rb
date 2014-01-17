# Example from: http://www.sitepoint.com/build-sinatra-api-using-tdd-heroku-continuous-integration-travis/

class Integer
	def factors
		square_root = self**0.5
		(1..square_root)
			.map { |n| [n, self/n] if self/n*n == self }
			.compact
			.flatten
			.sort
	end

	def prime?
		self.factors.size == 2
	end

	def factorial
		(1..self).reduce(:*)
	end

end

require 'sinatra'
require 'json'
require 'timeout'

configure :development, :test do
	disable :force_ssl
end

configure :production, :staging do
	enable :force_ssl
end

get '/:number' do
	content_type :json
	number = params[:number].to_i
	{
		number: number,
		factors: number.factors,
		odd: number.odd?,
		even: number.even?,
		prime: number.prime?
	}.to_json
end

get '/:number/factorial' do
	begin
		timeout(3) {
			content_type :json
			number = params[:number].to_i
			{
				number: number,
				factorial: number.factorial
			}.to_json
		}
	rescue Timeout::Error
		{ error: { message: "Whew... That took too long!" } }.to_json
	end
end

get '/random/:number' do
	content_type :json
	number = params[:number].to_i
	seed = Random.new_seed
	r = Random.new(seed)
	{
		float: r.rand,
		int: r.rand(number),
		seed: seed
	}.to_json
end
