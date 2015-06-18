json.array!(@payoffs) do |payoff|
  json.extract! payoff, :id
  json.url payoff_url(payoff, format: :json)
end
