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
    binding.pry
    #student[:twitter] = doc.css(".social-icon-container a")[0].attribute("href").value unless doc.css(".social-icon-container a")[0] == nil
    student[:twitter] = doc.at_css(".social-icon-container a[href]:contains(twitter)").attribute("href").value unless doc.at_css(".social-icon-container a[href]:contains(twitter)") == nil
    #student[:linkedin] = doc.css(".social-icon-container a")[1].attribute("href").value unless doc.css(".social-icon-container a")[1] == nil
    student[:linkedin] = doc.at_css(".social-icon-container a[href.include?('linkedin')]").attribute("href").value #unless doc.at_css(".social-icon-container a[href]:contains(linkedin)") == nil
    #student[:github] = doc.css(".social-icon-container a")[2].attribute("href").value unless doc.css(".social-icon-container a")[2] == nil
    student[:github] = doc.at_css(".social-icon-container a[href]:contains(github)").attribute("href").value unless doc.at_css(".social-icon-container a[href]:contains(github)") == nil
    student[:blog] = doc.css(".social-icon-container a")[3].attribute("href").value unless doc.css(".social-icon-container a")[3] == nil
    #student[:blog] =doc.at_css(".social-icon-container a[href]:contains()").attribute("href").value unless doc.at_css(".social-icon-container a[href]:contains(twitter)") == nil
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    student
    binding.pry
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
'''
