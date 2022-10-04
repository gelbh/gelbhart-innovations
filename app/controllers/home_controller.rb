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

    @desc1 = "Bareket attended the Technion, Israel Institute of Technology, from where she holds her Bachelor degree in Chemistry with Organic Chemistry as the principal subject.<br><br>She is fluent in Hebrew and English and can converse in Italian. Bareket posses advanced knowledge of Microsoft Word, Excel and PowerPoint.<br><br>She resides in Ticino, Switzerland with her family, from where she travels across the globe regularly for work.<br><br>Bareket is a passionate cook and a die hard football fan.".html_safe

    @desc2 = "Yaron attended the Technion, Israel Institute of Technology, from where he holds his Bachelor of Science degree in Engineering with Project Management as a principal subject. Yaron possesses over 20 years of experience in large projects management with emphasis on the Indian subcontinent.<br><br>His interests also spread across real estate and hospitality. He is fluent in English and Hebrew and has conversational level in Italian. In his free time Yaron does yoga and enjoys a glass of good Italian wine.".html_safe
    
    @desc3 = "".html_safe

    @members = [
      ["Bareket Gelbhart", "https://www.linkedin.com/in/bareket-gelbhart-83904a16/", @desc1],
      ["Yaron Gelbhart", "https://www.linkedin.com/in/yaron-gelbhart/", @desc2],
      ["Tomer Gelbhart", "https://www.linkedin.com/in/tomer-gelbhart-1452a11a0/", @desc3]]
  end

  def contact
    @page_desc = "Gelbhart Innovations"
    @page_title = "Contact"
  end
end
