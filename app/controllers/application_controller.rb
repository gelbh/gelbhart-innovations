# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include PageMetadata

  before_action :set_locale
  after_action :store_locale_preference

  private

  def set_locale
    I18n.locale = locale_from_params || locale_from_cookie || locale_from_browser || I18n.default_locale
  end

  def locale_from_params
    extract_valid_locale(params[:locale])
  end

  def locale_from_cookie
    extract_valid_locale(cookies[:locale])
  end

  def locale_from_browser
    accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
    return if accept_language.blank?

    accept_language
      .split(",")
      .map { |lang| lang.split(";").first.strip.split("-").first.downcase }
      .uniq
      .find { |locale| valid_locale?(locale) }
      &.to_sym
  end

  def extract_valid_locale(locale)
    locale.to_sym if locale.present? && valid_locale?(locale)
  end

  def valid_locale?(locale)
    I18n.available_locales.map(&:to_s).include?(locale.to_s)
  end

  def store_locale_preference
    return unless params[:locale].present? && valid_locale?(params[:locale])

    cookies[:locale] = { value: I18n.locale.to_s, expires: 1.year.from_now, same_site: :lax }
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
