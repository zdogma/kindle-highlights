require 'kindle_highlights'

class JpKindleHighlights < KindleHighlights::Client
  KindleHighlights::KINDLE_LOGIN_PAGE = 'http://kindle.amazon.co.jp/login'

  def highlights_for(asin)
    sleep 0.3

    page = @mechanize_agent.get("https://kindle.amazon.co.jp/your_highlights_and_notes/#{asin}")

    highlights = page.xpath('//div[@class="highlightRow yourHighlight"]').map do |e|
      {
        text: e.xpath('span[@class="highlight"]')&.inner_text || '',
        location_href: e.css('a')&.attribute('href')&.value   || ''
      }
    end

    {
      title:  page.search('span.title').text.gsub(/\(Japanese Edition\)|\n.*\z/, ''),
      author: page.search('span.author').text.gsub(/\A by /, '').strip,
      highlights:  highlights
    }
  end
end
