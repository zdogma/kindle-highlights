$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'kindle'
require 'dotenv'
require 'twitter'

Dotenv.load

SELF_SCREEN_NAME = ENV['TWITTER_SELF_SCREEN_NAME']

kindle = JpKindleHighlights.new(
  ENV['MAIL_ADDRESS'],
  ENV['PASSWORD']
)
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

target_book = nil
while true do
  asin        = kindle.books.keys.sample
  target_book = kindle.highlights_for(asin)

  break unless target_book.dig(:highlights).empty?
end

title      = target_book.dig(:book_title)
highlights = target_book.dig(:highlights).map { |h| h.fetch(:text) }.compact

messages = [
  '------',
  title,
  highlights
]

messages.flatten.each do |message|
  sleep 1
  twitter.create_direct_message(SELF_SCREEN_NAME, message)
end
