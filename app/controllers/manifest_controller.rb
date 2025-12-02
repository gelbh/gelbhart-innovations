class ManifestController < ApplicationController
  def site_webmanifest
    render json: {
      name: "Gelbhart",
      short_name: "Gelbhart",
      icons: [
        {
          src: view_context.asset_path('web-app-manifest-192x192.png'),
          sizes: "192x192",
          type: "image/png",
          purpose: "maskable"
        },
        {
          src: view_context.asset_path('web-app-manifest-512x512.png'),
          sizes: "512x512",
          type: "image/png",
          purpose: "maskable"
        }
      ],
      theme_color: "#ffffff",
      background_color: "#ffffff",
      display: "standalone"
    }, content_type: 'application/manifest+json'
  end
end

