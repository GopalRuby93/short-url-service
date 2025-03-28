class ShortUrlGeneratorService
  attr_reader :short_url_params

  ELEMENTS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze
  BASE = ELEMENTS.length

  def initialize(short_url_params)
    @short_url_params = short_url_params
  end

  def call
    ShortUrl.new(short_url_params.merge(short_url: generate_short_url))
  end

  private

  def generate_short_url
    last_id = ShortUrl.maximum(:id)
    next_id = last_id.nil? ? 1 : last_id + 1
    base10_to_base62(next_id)
  end  

  def base10_to_base62(n)
    return "0000000" if n.zero?

    short_url = ""
    while n.positive?
      short_url.prepend(ELEMENTS[n % BASE])
      n /= BASE
    end

    short_url.rjust(7, '0')
  end
end
