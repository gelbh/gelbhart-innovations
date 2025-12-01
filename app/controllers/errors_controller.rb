class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html do
        assign_page_metadata(
          title: "Error 404",
          description: "Error 404 - The page you are looking for was moved, removed or might have never existed."
        )
        @heading = "Error 404"
        @message = "The page you are looking for was moved, removed or might have never existed."
        render status: 404
      end
      format.xml do
        render xml: '<?xml version="1.0" encoding="UTF-8"?><error><code>404</code><message>Not Found</message></error>', status: 404
      end
      format.json do
        render json: { error: { code: 404, message: "Not Found" } }, status: 404
      end
      format.any do
        head :not_found
      end
    end
  end

  def internal_server_error
    assign_page_metadata(
      title: "Error 500",
      description: "Error 500 - Oops, something went wrong. Try to refresh this page or feel free to contact us if the problem persists."
    )
    @heading = "Error 500"

    @message = "Oops, something went wrong.<br>Try to refresh this page or feel free to contact us if the problem persists".html_safe

    render status: 500
  end
end