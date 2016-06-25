$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'kindle'
require 'dotenv'
require 'evernote'
require 'active_support'
require 'active_support/core_ext'

KINDLE_NOTEBOOK = 'KindleHighlights'.freeze
LOG_PATH = "./log/kindle_evernote_#{Time.current.strftime('%Y%m%d')}"

logger = Logger.new(LOG_PATH)
logger.info "START by #{ENV['USER']}"
Dotenv.load

kindle = JpKindleHighlights.new(
  ENV['AMAZON_MAIL_ADDRESS'],
  ENV['AMAZON_PASSWORD']
)

asins = kindle.books.keys
asins.each do |asin|
  book = kindle.highlights_for(asin)
  next if book[:highlights].blank?

  note = Evernote::Note.new(
    title: "[★#{book[:highlights].count}] #{book[:title]} / #{book[:author]} (#{asin})",
    content: book[:highlights].map { |highlight|
      "<b>『#{highlight[:text]}』</b><br /><font color='gray'>(#{CGI.escape(highlight[:location_href])})</font><br /><br />"
    }.join("\n"),
    notebook_name: KINDLE_NOTEBOOK,
    search_keyword: asin
  )
  if note.update
    logger.info "CREATED #{asin} #{book[:title]}"
  else
    logger.warn "FAILED #{asin} #{book[:title]}"
  end
end

logger.info 'FINISH'
