module PageMetadata
  extend ActiveSupport::Concern

  private

  def assign_page_metadata(title:, description: nil, breadcrumb: nil, og_image: nil, canonical_url: nil, robots: nil, structured_data: nil)
    @title = title
    @desc = description
    @breadcrumb = breadcrumb
    @og_image = og_image
    @canonical_url = canonical_url
    @robots = robots
    @structured_data = structured_data
  end
end
