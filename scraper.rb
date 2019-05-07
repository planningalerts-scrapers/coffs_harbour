require 'scraperwiki'
require 'rss/2.0'
require 'mechanize'

case ENV['MORPH_PERIOD']
  when 'lastmonth'
  	period = "lastmonth"
  when 'thismonth'
  	period = "thismonth"
  else
    period = "thisweek"
end
puts "Getting data in `" + period + "`, changable via MORPH_PERIOD environment"

base_url = "https://planningexchange.coffsharbour.nsw.gov.au/PortalProd"
url = "#{base_url}/Pages/XC.Track/SearchApplication.aspx?d=" + period + "&k=LodgementDate&o=rss"
comment_url = "mailto:coffs.council@chcc.nsw.gov.au"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

page = agent.get(url)
t = page.content.to_s

feed = RSS::Parser.parse(t, false)

feed.channel.items.each do |item|
  t = item.description.split('. ')
  if t.count >= 2
    record = {
      'council_reference' => item.title.split(' ')[0],
      'description'       => t[1].strip,
      # Have to make this a string to get the date library to parse it
      'date_received'     => Date.parse(item.pubDate.to_s).to_s,
      'address'           => t[0].squeeze(" ").strip,
      'info_url'          => base_url + item.link,
      # Comment URL is actually an email address but I think it's best
      # they go to the detail page
      'comment_url'       => comment_url,
      'date_scraped'      => Date.today.to_s
    }

    puts "Saving record " + record['council_reference'] + ", " + record['address']
#       puts record
    ScraperWiki.save_sqlite(['council_reference'], record)
  end
end
