$stdout.reopen("suppliers.csv", "w")
$stdout.sync = true
$stderr.reopen($stdout)

require 'rubygems'
require 'bundler/setup'
require 'curb'
require 'nokogiri'
require 'open-uri'

=begin
(1..144).to_a.each{|n|
  Nokogiri::HTML(open('http://www.allbeton.ru/company/?PAGEN_1='+n.to_s).read).css('.object').each{|object|
    object = Nokogiri::HTML(object.to_s)
    object.css('.info a').each{|a| print a.text + '|' }
    object.css('.contacts').each{|contacts|
      puts Nokogiri::HTML(contacts.to_s).css('li')[0].text.sub('|', '').gsub(/\s+/, '')
    }
  }
}
=end

# suppliers

(1..17).to_a.each{|n|
  html = open('http://www.pro-telecom.ru/companies?filter_vocab1=All&filter_vocab6=All&filter_vocab4=1998&filter_vocab5=1&filter_vocab2=&filter_vocab3=&filter_vocab20=&sub=%D0%98%D1%81%D0%BA%D0%B0%D1%82%D1%8C&&page='+n.to_s)
  rows = Nokogiri::HTML(html.read)
  rows.css('table.view-companies tbody tr').each{|row|
    row = Nokogiri::HTML(row.to_s)
    td = row.css('td')
    print td[1].text.gsub(/\s+/, '')+'|'
    print td[2].text.gsub(/\s+/, '')+'|'
    print td[3].text.gsub(/\s+/, '')+'|'
    c_url = 'http://www.pro-telecom.ru'+td[1].children[1]['href']
    html = open(c_url).read
    begin
      print html.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)[0]
    rescue
      print 'no email'
    end
    print "\n"
  }
}
