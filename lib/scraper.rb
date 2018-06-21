require 'open-uri'
require 'pry'

class Scraper
  @@all = []

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |student|
      @@all<< {
        :name => student.css("h4").text,
        :location => student.css("p").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    @@all
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}
    student[:twitter] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /twitter.com/ } unless :twitter == nil
    student[:linkedin] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /linkedin.com/ } unless doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /linkedin.com/ } == nil
    student[:github] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /github.com/ } unless doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /github.com/ } == nil
    student[:blog] = doc.css(".social-icon-container a").last.attribute("href").value unless student.has_value?(doc.css(".social-icon-container a").last.attribute("href").value)
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    student
  end

end
