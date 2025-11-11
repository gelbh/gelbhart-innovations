class ErrorsController < ApplicationController
  def not_found
    assign_page_metadata(
      title: "Error 404",
      description: "Error 404 - The page you are looking for was moved, removed or might have never existed."
    )
    @heading = "Error 404"

    @message = "The page you are looking for was moved, removed or might have never existed."

    render status: 404
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