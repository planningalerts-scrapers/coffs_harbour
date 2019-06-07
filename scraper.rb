require "icon_scraper"

case ENV['MORPH_PERIOD']
  when 'lastmonth'
  	period = "lastmonth"
  when 'thismonth'
  	period = "thismonth"
  else
    period = "thisweek"
end
puts "Getting data in `" + period + "`, changable via MORPH_PERIOD environment"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

IconScraper.rest_xml(
  "https://planningexchange.coffsharbour.nsw.gov.au/PortalProd/Pages/XC.Track/SearchApplication.aspx",
  "d=#{period}&k=LodgementDate&o=xml",
  false,
  agent
)
