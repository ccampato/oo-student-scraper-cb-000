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
    student[:twitter] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /twitter.com/ } unless doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /twitter.com/ } == nil
    student[:linkedin] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /linkedin.com/ } unless doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /linkedin.com/ } == nil
    student[:github] = doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /github.com/ } unless doc.css('a').map { |e| e.attributes.values.first.value }.detect {|e| e =~ /github.com/ } == nil
    student[:blog] = doc.css(".social-icon-container a")[3].attribute("href").value unless doc.css(".social-icon-container a")[3] == nil
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    student
  end

end

'''
students = @@all.map { |hash| hash.values_at(:name, :profile_url) }
students.each do |student|
  profile = Nokogiri::HTML(open("./fixtures/student-site/"+student[1].to_s))
  student[:twitter] = profile.css(".social-icon-container a")[0].attribute("href").value unless profile.css(".social-icon-container a")[0] == nil
  student[:linkedin] = profile.css(".social-icon-container a")[1].attribute("href").value unless profile.css(".social-icon-container a")[1] == nil
  student[:github] = profile.css(".social-icon-container a")[2].attribute("href").value unless profile.css(".social-icon-container a")[2] == nil
  student[:blog] = profile.css(".social-icon-container a")[3].attribute("href").value unless profile.css(".social-icon-container a")[3] == nil
  student[:profile_quote] = profile.css(".profile-quote").text
  student[:bio] = profile.css(".description-holder p").text
end
student

array = []
doc.css(".social-icon-container a").each do |anchor|
  array << anchor.attribute().value
end
'''
