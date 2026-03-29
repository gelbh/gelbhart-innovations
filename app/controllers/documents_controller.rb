class DocumentsController < ApplicationController
  include JarallaxConfiguration

  def tos
    assign_page_metadata(
      title: t("seo.pages.tos.title"),
      description: t("seo.pages.tos.description")
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
  end
end
