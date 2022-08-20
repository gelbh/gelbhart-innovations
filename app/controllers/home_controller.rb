class HomeController < ApplicationController
  def index
    @page_desc = "Gelbhart Innovations"
    @page_title = "Home"
  end

  def services
    @page_desc = "Gelbhart Innovations"
    @page_title = "Services"
  end

  def team
    @page_desc = "Gelbhart Innovations"
    @page_title = "Team"

    @desc1 = "Bareket Gelbhart joined Eldan Molecular Imaging in January 2022 as the International Business Manager. Previously she worked in Dipharma, serving as Head of Marketing for 6 years and as Chief Business Development Officer for additional 3 years.<br><br>Prior to Dipharma, Bareket worked in Teva Pharmaceuticals for 17 years, in different positions.".html_safe

    @desc2 = "Yaron attended the Technion, Israel Institute of Technology, from where he holds his Bachelor of Science degree in Engineering with Project Management as a principal subject. Yaron possesses over 20 years of experience in large projects management with emphasis on the Indian subcontinent.<br><br>His interests also spread across real estate and hospitality. He is fluent in English and Hebrew and has conversational level in Italian. In his free time Yaron does yoga and enjoys a glass of good Italian wine.".html_safe
    
    @desc3 = "".html_safe

    @members = [
      ["Bareket Gelbhart", "https://www.linkedin.com/in/bareket-gelbhart-83904a16/", @desc1],
      ["Yaron Gelbhart", "https://www.linkedin.com/in/yaron-gelbhart/", @desc2],
      ["Tomer Gelbhart", "https://www.linkedin.com/in/tomer-gelbhart-1452a11a0/", @desc3]]
  end

  def corporate
    @page_desc = "Gelbhart Innovations"
    @page_title = "Corporate"
  end

  def contact
    @page_desc = "Gelbhart Innovations"
    @page_title = "Contact"
  end
end
