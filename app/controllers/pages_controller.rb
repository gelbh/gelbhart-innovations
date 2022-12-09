class PagesController < ApplicationController
  def index
    @title = "Home"
  end

  def services
    @title = "Services"
    @jarallax = "services_cover"
  end

  def team
    @title = "Team"
    @jarallax = "team_cover"

    @desc1 = "Bareket attended the Technion, Israel Institute of Technology, from where she holds her Bachelor degree in Chemistry with Organic Chemistry as the principal subject.<br><br>She is fluent in Hebrew and English and can converse in Italian. Bareket posses advanced knowledge of Microsoft Word, Excel and PowerPoint.<br><br>She resides in Ticino, Switzerland with her family, from where she travels across the globe regularly for work.<br><br>Bareket is a passionate cook and a die hard football fan.".html_safe

    @desc2 = "Yaron attended the Technion, Israel Institute of Technology, from where he holds his Bachelor of Science degree in Engineering with Project Management as a principal subject. Yaron possesses over 20 years of experience in large projects management with emphasis on the Indian subcontinent.<br><br>His interests also spread across real estate and hospitality. He is fluent in English and Hebrew and has conversational level in Italian. In his free time Yaron does yoga and enjoys a glass of good Italian wine.".html_safe
    
    @desc3 = "".html_safe

    @members = [
      ["Bareket Gelbhart", @desc1],
      ["Yaron Gelbhart", @desc2],
      ["Tomer Gelbhart", @desc3]]
  end

  def contacts
    @title =  "Contact Us"
    @jarallax = "contacts_cover"
  end
end
