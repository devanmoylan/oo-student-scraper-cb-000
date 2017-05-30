require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    @student_index_array = []
    doc.css(".student-card").each_with_index do |student, index|
      @student_index_array[index] = {
        :name => student.css("a .card-text-container .student-name").text,
        :location => student.css("a .card-text-container .student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    @student_index_array
  end

  #Write a class method that accesses a page via an url given as an argument.
  #The return value of the class method should be a hash that contains the key / value pair of each student.
  #Some students don't have some of the information / rescue nils.
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_hash = {}
    student_first_name = doc.css(".vitals-text-container h1").text.split(" ")[0].downcase
    student_last_name = doc.css(".vitals-text-container h1").text.split(" ")[1].downcase
    doc.css(".vitals-container .social-icon-container a").each do |social_media|
      if social_media.attribute("href").value.include?("twitter")
        student_hash[:twitter] = social_media.attribute("href").value
      elsif social_media.attribute("href").value.include?("linkedin")
        student_hash[:linkedin] = social_media.attribute("href").value
      elsif social_media.attribute("href").value.include?("github")
        student_hash[:github] = social_media.attribute("href").value
      elsif social_media.attribute("href").value.include?("#{student_last_name.downcase}") && social_media.attribute("href").value.include?("#{student_first_name.downcase}")
        student_hash[:blog] = social_media.attribute("href").value
      end
    end
    student_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    student_hash[:bio] = doc.css(".details-container .details-block .content-holder .description-holder p").text
    student_hash
  end

end
