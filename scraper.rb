require 'scraperwiki'
require 'mechanize'

FileUtils.touch('data.sqlite')

today = Time.now.strftime('%Y-%m-%d')

url = 'https://www.melton.vic.gov.au/Services/Building-Planning-Transport/Statutory-planning/Advertised-planning-applications/Planning-apps-current'
agent = Mechanize.new
page  = agent.get(url)

table = page.search('div.landing-page-nav.landing-3-col')
rows = table.search('div.col-xs-12.col-m-4')

for row in rows do
  record = {}
  record['address'] = row.search('h2').text.strip
  record['date_scraped'] = today
  record['council_reference'] = row.search('p').text.strip.split('Number: ')[1]
  info_url = row.search('a').to_s.split('"')[1]
  record['info_url'] = info_url
  page = agent.get(info_url)
  record['description'] = page.search('p')[1].text.strip
  ScraperWiki.save_sqlite(['council_reference'], record)
end
