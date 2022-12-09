class ErrorsController < ApplicationController
  def not_found
    @desc = "Error 404 - The page you are looking for was moved, removed or might have never existed."
    @title = "Error 404"
    @heading = "Error 404"

    @message = "The page you are looking for was moved, removed or might have never existed."

    render status: 404
  end

  def internal_server_error
    @desc = "Error 500 - Oops, something went wrong. Try to refresh this page or feel free to contact us if the problem persists."
    @title = "Error 500"
    @heading = "Error 500"

    @message = "Oops, something went wrong.<br>Try to refresh this page or feel free to contact us if the problem persists".html_safe
    
    render status: 500
  end
end