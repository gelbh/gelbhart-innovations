class DocumentsController < ApplicationController
  def tos
    @title = "Terms & Conditions and Privacy Policy"
    @desc = "Use of this website is subject to all of the terms and conditions of this legal notice and to all applicable laws."
  end
end