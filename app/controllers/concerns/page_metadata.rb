module PageMetadata
  extend ActiveSupport::Concern

  private

  def assign_page_metadata(title:, description: nil, breadcrumb: nil)
    @title = title
    @desc = description
    @breadcrumb = breadcrumb
  end
end



