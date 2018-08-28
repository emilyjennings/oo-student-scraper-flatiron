require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :student
  @@all = []

  def self.scrape_index_page(index_url)
    html = open(index_url)

    page = Nokogiri::HTML(html)

    students = []

    page.css("div.student-card").each do |student|

      students << {
         :name => student.css("h4.student-name").text,
         :location => student.css("p.student-location").text,
         :profile_url => student.children[1].attributes["href"].value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))

    student_page = {}

    social_links = page.css(".social-icon-container").css('a').collect {|e| e.attributes["href"].value}

    social_links.detect do |e|

      student_page[:twitter] = e if e.include?("twitter")
      student_page[:linkedin] = e if e.include?("linkedin")
      student_page[:github] = e if e.include?("github")

    end

    student_page[:blog] = social_links[3] if social_links[3] != nil
    student_page[:profile_quote] = page.css(".profile-quote")[0].text
    student_page[:bio] = page.css(".description-holder").css('p')[0].text
    student_page
  end


end
