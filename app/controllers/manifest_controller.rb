class ManifestController < ApplicationController
  def site_webmanifest
    render json: manifest_data, content_type: "application/manifest+json"
  end

  private

  def manifest_data
    {
      name: "Gelbhart",
      short_name: "Gelbhart",
      icons: manifest_icons,
      theme_color: "#ffffff",
      background_color: "#ffffff",
      display: "standalone"
    }
  end

  def manifest_icons
    %w[192x192 512x512].map do |size|
      {
        src: helpers.asset_path("web-app-manifest-#{size}.png"),
        sizes: size,
        type: "image/png",
        purpose: "maskable"
      }
    end
  end
end
