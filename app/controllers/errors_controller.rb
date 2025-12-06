class ErrorsController < ApplicationController
  def not_found
    # Silently handle bot/scanner requests without logging
    if bot_request?
      Rails.logger.silence do
        render_not_found_response
      end
    else
      # Full logging for legitimate 404 requests
      render_not_found_response
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

  def render_not_found_response
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

  def bot_request?
    path = request.path.downcase

    # Check for .php file extensions
    return true if path.end_with?(".php")

    # Check for WordPress paths
    wordpress_patterns = %w[
      /wp-admin/
      /wp-content/
      /wp-includes/
      /wp-login.php
      /wp-config.php
      /wp-load.php
      /xmlrpc.php
    ]
    return true if wordpress_patterns.any? { |pattern| path.include?(pattern) }

    # Check for common scanner targets
    scanner_targets = %w[
      /admin.php
      /filemanager.php
      /config.php
      /phpmyadmin
      /phpinfo.php
      /shell.php
      /c99.php
      /r57.php
      /backup.php
      /database.php
    ]
    return true if scanner_targets.any? { |target| path.include?(target) }

    # Check for suspicious numeric-only paths (e.g., /2.php, /333.php)
    # Matches paths like /123.php, /4567.php, etc.
    return true if path.match?(%r{^/\d+\.php$})

    false
  end

  def build_error_xml(code, message)
    '<?xml version="1.0" encoding="UTF-8"?>' \
    "<error><code>#{code}</code><message>#{message}</message></error>"
  end
end
