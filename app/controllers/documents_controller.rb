class DocumentsController < ApplicationController
  include JarallaxConfiguration

  def tos
    assign_page_metadata(
      title: "Terms & Conditions and Privacy Policy",
      description: "Use of this website is subject to all of the terms and conditions of this legal notice and to all applicable laws."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
  end
end
