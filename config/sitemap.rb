# frozen_string_literal: true

require "sitemap_generator"

base_host = ENV.fetch("SITEMAP_HOST", nil) ||
            Rails.application.config.action_mailer.default_url_options[:host] ||
            "gelbhart.com"

normalized_host = base_host.gsub(%r{^https?://}, "")
default_host = "https://#{normalized_host}"

SitemapGenerator::Sitemap.default_host = default_host
SitemapGenerator::Sitemap.public_path = "public/"
SitemapGenerator::Sitemap.sitemaps_path = ""
SitemapGenerator::Sitemap.compress = false

SITEMAP_LOCALES = %i[en es fr de it pt zh ja ko ar].freeze

def view_lastmod(view_path)
  full_path = Rails.root.join("app/views", view_path)
  full_path.exist? ? File.mtime(full_path) : Time.current
rescue StandardError
  Time.current
end

def recent_view_lastmod(*view_paths)
  view_paths.map { |path| view_lastmod(path) }.max || Time.current
end

def alternate_links_for(path_method, _locale_param = nil)
  SITEMAP_LOCALES.map do |locale|
    locale_path = locale == :en ? nil : locale
    path = public_send(path_method, locale: locale_path)
    { href: "#{SitemapGenerator::Sitemap.default_host}#{path}", lang: locale.to_s }
  end
end

SitemapGenerator::Sitemap.create do
  extend Rails.application.routes.url_helpers

  SITEMAP_LOCALES.each do |locale|
    locale_param = locale == :en ? nil : locale

    add root_path(locale: locale_param),
        lastmod: recent_view_lastmod("pages/index.html.erb", "layouts/application.html.erb"),
        alternates: alternate_links_for(:root_path)

    add services_path(locale: locale_param), lastmod: view_lastmod("pages/services.html.erb"), alternates: alternate_links_for(:services_path)
    add pharmaceutical_path(locale: locale_param), lastmod: view_lastmod("pages/pharmaceutical.html.erb"), alternates: alternate_links_for(:pharmaceutical_path)
    add real_estate_path(locale: locale_param), lastmod: view_lastmod("pages/real_estate.html.erb"), alternates: alternate_links_for(:real_estate_path)
    add team_path(locale: locale_param), lastmod: view_lastmod("pages/team.html.erb"), alternates: alternate_links_for(:team_path)
    add contact_path(locale: locale_param), lastmod: view_lastmod("pages/contact.html.erb"), alternates: alternate_links_for(:contact_path)
    add tos_path(locale: locale_param), lastmod: view_lastmod("documents/tos.html.erb"), alternates: alternate_links_for(:tos_path)
  end
end
