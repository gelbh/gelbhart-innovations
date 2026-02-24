# frozen_string_literal: true

class TeamMember
  attr_reader :key, :linkedin_url, :github_url

  MEMBERS = [
    { key: :bareket, linkedin_url: "https://www.linkedin.com/in/bareket-gelbhart-83904a16/" },
    { key: :yaron, linkedin_url: "https://www.linkedin.com/in/yaron-gelbhart/" },
    { key: :tomer, linkedin_url: "https://www.linkedin.com/in/tomer-gelbhart/", github_url: "https://github.com/gelbh" },
    { key: :effie, linkedin_url: "" }
  ].freeze

  def initialize(key:, linkedin_url:, github_url: nil)
    @key = key
    @linkedin_url = linkedin_url
    @github_url = github_url
  end

  def name = I18n.t("team_members.#{key}.name")
  def bio = I18n.t("team_members.#{key}.bio")
  def first_name = key.to_s.split("_").first.capitalize
  def image_filename = "team/#{key}.png"
  def linkedin? = linkedin_url.present?
  def github? = github_url.present?

  def self.all
    MEMBERS.map { |attrs| new(**attrs) }
  end
end
