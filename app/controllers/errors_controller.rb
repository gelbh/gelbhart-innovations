class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html do
        assign_page_metadata(
          title: "Error 404",
          description: "The page you are looking for was moved, removed or might have never existed."
        )
        @heading = "Error 404"
        @message = "The page you are looking for was moved, removed or might have never existed."
        render status: :not_found
      end
      format.xml do
        render xml: build_error_xml(404, "Not Found"), status: :not_found
      end
      format.json do
        render json: { error: { code: 404, message: "Not Found" } }, status: :not_found
      end
      format.any { head :not_found }
    end
  end

  def internal_server_error
    assign_page_metadata(
      title: "Error 500",
      description: "Oops, something went wrong. Try to refresh this page or feel free to contact us if the problem persists."
    )
    @heading = "Error 500"
    @message = "Oops, something went wrong.<br>Try to refresh this page or feel free to contact us if the problem persists."
    render status: :internal_server_error
  end

  private

  def build_error_xml(code, message)
    '<?xml version="1.0" encoding="UTF-8"?>' \
    "<error><code>#{code}</code><message>#{message}</message></error>"
  end
end
