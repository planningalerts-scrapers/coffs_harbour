require "icon_scraper"

# Testing to figure out source of 502 bad gateway on morph (but not when run locally)
agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.set_proxy("36.91.129.164", 3128)

page = agent.get("https://planningexchange.coffsharbour.nsw.gov.au/PortalProd/Pages/XC.Track/SearchApplication.aspx?d=thisweek&k=LodgementDate&o=xml")
puts page.body
exit

IconScraper.scrape_and_save(:coffs_harbour)
