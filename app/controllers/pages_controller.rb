class PagesController < ApplicationController
  def index
    @title = "Home"
  end

  def services
    @title = "Services"
    @jarallax = "services_cover"
  end

  def pharmaceutical
    @title = "Pharmaceutical Services"
    @jarallax = "services_cover"
    @services = Service.pharmaceutical
  end

  def real_estate
    @title = "Real Estate Services"
    @jarallax = "services_cover"
    @real_estate_services = Service.real_estate
  end

  def team
    @title = "Team"
    @jarallax = "team_cover"
    @members = TeamMember.all
  end

  def contacts
    @title =  'Contact Us'
    @jarallax = 'contacts_cover'
    @jarallaxHeight = 300
    @jarallaxSpeed = 0.1
  end
end
