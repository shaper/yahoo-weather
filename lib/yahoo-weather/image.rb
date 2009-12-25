class YahooWeather::Image
  # the height of the image in pixels.
  attr_reader :height

  # the url intended to be used as a link wrapping the image, for
  # instance, to send the user to the main Yahoo Weather home page.
  attr_reader :link

  # the title of hte image.
  attr_reader :title

  # the full url to the image.
  attr_reader :url

  # the width of the image in pixels.
  attr_reader :width

  def initialize (payload)
    @title = payload.xpath('title').first.content
    @link = payload.xpath('link').first.content
    @url = payload.xpath('url').first.content
    @height = payload.xpath('height').first.content.to_i
    @width = payload.xpath('width').first.content.to_i
  end
end
