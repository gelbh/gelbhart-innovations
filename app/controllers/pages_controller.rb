class PagesController < ApplicationController
  include JarallaxConfiguration

  def index
    assign_page_metadata(title: "Home")
  end

  def services
    assign_page_metadata(title: "Services")
    assign_jarallax(image: "services_cover")
  end

  def pharmaceutical
    assign_page_metadata(title: "Pharmaceutical Services")
    assign_jarallax(image: "services_cover")
    @services = Service.pharmaceutical
  end

  def real_estate
    assign_page_metadata(title: "Real Estate Services")
    assign_jarallax(image: "services_cover")
    @real_estate_services = Service.real_estate
  end

  def team
    assign_page_metadata(title: "Team")
    assign_jarallax(image: "team_cover")
    @members = TeamMember.all
  end

  def contacts
    assign_page_metadata(title: "Contact Us")
    assign_jarallax(image: "contacts_cover", height: 300, speed: 0.1)
  end
end
