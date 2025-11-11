# frozen_string_literal: true

# Plain Old Ruby Object for team members
# Not backed by database - used for static team data
class TeamMember
  attr_reader :name, :bio, :linkedin_url, :github_url

  def initialize(name:, bio:, linkedin_url:, github_url: nil)
    @name = name
    @bio = bio
    @linkedin_url = linkedin_url
    @github_url = github_url
  end

  def first_name
    name.split.first
  end

  def image_filename
    "team/#{first_name.downcase}.png"
  end

  def github?
    github_url.present?
  end

  # Class method to return all team members
  def self.all
    [
      new(
        name: "Bareket Gelbhart",
        bio: "Bareket attended the Technion, Israel Institute of Technology, from where she holds her Bachelor degree in Chemistry with Organic Chemistry as the principal subject.<br><br>She is fluent in Hebrew and English and can converse in Italian. Bareket posses advanced knowledge of Microsoft Word, Excel and PowerPoint.<br><br>She resides in Ticino, Switzerland with her family, from where she travels across the globe regularly for work.<br><br>Bareket is a passionate cook and a die hard football fan.",
        linkedin_url: "https://www.linkedin.com/in/bareket-gelbhart-83904a16/"
      ),
      new(
        name: "Yaron Gelbhart",
        bio: "Yaron attended the Technion, Israel Institute of Technology, from where he holds his Bachelor of Science degree in Engineering with Project Management as a principal subject. Yaron possesses over 20 years of experience in large projects management with emphasis on the Indian subcontinent.<br><br>His interests also spread across real estate and hospitality. He is fluent in English and Hebrew and has conversational level in Italian. In his free time Yaron does yoga and enjoys a glass of good Italian wine.",
        linkedin_url: "https://www.linkedin.com/in/yaron-gelbhart/"
      ),
      new(
        name: "Tomer Gelbhart",
        bio: "Passionate MSc Computer Science student with a BSc in Computer Science. Experienced in front-end development and API integration to develop tools that address real-world challenges.<br><br>Looking for an internship beginning May 2026 to strengthen my back-end development skills and progress toward becoming a full-stack developer.",
        linkedin_url: "https://www.linkedin.com/in/tomer-gelbhart/",
        github_url: "https://github.com/gelbh"
      )
    ]
  end
end

