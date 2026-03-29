class PagesController < ApplicationController
  include JarallaxConfiguration

  def index
    assign_page_metadata(
      title: t("nav.home"),
      description: t("seo.pages.home.description")
    )
  end

  def services
    assign_page_metadata(
      title: t("nav.services"),
      description: t("seo.pages.services.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
  end

  def pharmaceutical
    assign_page_metadata(
      title: t("pages.services.pharmaceutical.page_title"),
      description: t("pages.services.pharmaceutical.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:pharmaceutical], height: AppConstants::SERVICE_HERO_JARALLAX_HEIGHT, speed: 0.35)
    @jarallax_extra_class = "jarallax--service-hero"
    @jarallax_hide_overlay = true
    @services = Service.pharmaceutical
    @pharmaceutical_member = TeamMember.find_by_key(:bareket)
  end

  def real_estate
    assign_page_metadata(
      title: t("pages.services.real_estate.page_title"),
      description: t("pages.services.real_estate.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:real_estate], height: AppConstants::SERVICE_HERO_JARALLAX_HEIGHT, speed: 0.35)
    @jarallax_extra_class = "jarallax--service-hero"
    @jarallax_hide_overlay = true
    @real_estate_services = Service.real_estate
    @real_estate_member = TeamMember.find_by_key(:yaron)
  end

  def full_stack
    assign_page_metadata(
      title: t("pages.services.full_stack.page_title"),
      description: t("pages.services.full_stack.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:full_stack], height: AppConstants::SERVICE_HERO_JARALLAX_HEIGHT, speed: 0.35)
    @jarallax_extra_class = "jarallax--service-hero"
    @jarallax_hide_overlay = true
    @full_stack_member = TeamMember.find_by_key(:tomer)
  end

  def sustainability
    assign_page_metadata(
      title: t("pages.services.sustainability.page_title"),
      description: t("pages.services.sustainability.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:sustainability], height: AppConstants::SERVICE_HERO_JARALLAX_HEIGHT, speed: 0.35)
    @jarallax_extra_class = "jarallax--sustainability-hero"
    @jarallax_hide_overlay = true
    @sustainability_member = TeamMember.find_by_key(:effie)
  end

  def team
    assign_page_metadata(
      title: t("nav.team"),
      description: t("pages.team.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:team])
    @members = TeamMember.all
  end

  def contact
    assign_page_metadata(
      title: t("nav.contact"),
      description: t("seo.pages.contact.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:contact], height: 300, speed: 0.1)

    # Generate LocalBusiness structured data
    contact = AppConstants::CONTACT_INFO
    address_schema = {
      "@type" => "PostalAddress",
      "streetAddress" => contact[:address][:street],
      "addressLocality" => contact[:address][:city],
      "postalCode" => contact[:address][:postal_code],
      "addressCountry" => contact[:address][:country]
    }

    @structured_data = {
      "@context" => "https://schema.org",
      "@type" => "LocalBusiness",
      "name" => "Gelbhart Innovations",
      "address" => address_schema,
      "telephone" => contact[:phone][:display],
      "email" => contact[:email],
      "url" => root_url
    }
  end
end
