require 'faraday'
require 'nokogiri'

require 'models'

class MuniApi # SF Muni
  MUNI_ENDPOINT = 'http://webservices.nextbus.com/service/publicXMLFeed?command=messages&a=sf-muni'.freeze

  def self.get_data
    response = Faraday.get(MUNI_ENDPOINT)
    body = Nokogiri::XML.parse(body)

    messages = xml.xpath('//messages/text').to_a
                  .map { |e| e.to_s
                              .gsub(/<.?text>/, '')
                              .gsub(/\s+/, ' ') }
                  .uniq
                  .select {|s| s =~ /levator/ }
                  .reject {|s| s =~ /levator OK/ }

    elevator_names = []
    messages.each do |msg|
      e = msg.sub(/No Elevator at/, '')
             .sub(/ Station/)
      if e && e != ''
        elevator_names << "Muni: #{e}"
      else
        Models::Unparseable.first_or_create(:data => msg)
      end
    end

    elevator_names
  end
end