require "icon_scraper"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

IconScraper.rest_xml(
  "https://planningexchange.coffsharbour.nsw.gov.au/PortalProd/Pages/XC.Track/SearchApplication.aspx",
  {d: "thisweek", k: "LodgementDate", o: "xml"},
  agent
) do |record|
  IconScraper.save(record)
end
