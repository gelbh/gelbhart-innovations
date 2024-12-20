class PagesController < ApplicationController
  def index
    @title = "Home"
  end

  def services
    @title = "Services"
    @jarallax = "services_cover"

    @services = [
      ["Due Diligence", "diligence", "Are you considering to purchase a new pharmaceutical asset, be it a product or a company?", "With more than 27 years of experience in the pharmaceutical industry, we provide assistance and advice in relation to any due diligence of a pharmaceutical product and a pharmaceutical company, including assessment, evaluation, structuring, negotiation and completion of a potential investment."],
      ["Business Development (Partnerships)", "business", "Are you developing a new product and looking for the best partner or looking to license out your product?", "With our industry experience and knowledge, we can find the right partner to your API, FDF and/or Orphan Generic Drug worldwide."],
      ["Portfolio", "portfolio", "Looking for a new molecule but don’t know where to start?", "With our chemistry background and industry knowledge, we can help you find the right molecules to develop, whether they are small niche molecules or future blockbusters, bread & butter or pearls. We will define the strategy for development after considering intellectual property, pricing and competition."],
      ["Strategy", "strategy", "Not sure which road your company should follow?", "We will research and identify the market needs and market potential to develop business opportunities for the company's portfolio. We will then locate new customers and new markets in which the company’s potential is not yet fully realized. We will evaluate the current sales team and recommend the right structure, identify sales personnel and train them. After reviewing agencies network we will recommend, where and if to work through agents or directly. We will define ideal pipeline process, KPIs and organization, and evaluate competitors' status."],
      ["Generic Orphan Drugs", "drugs", "Are you developing a Generic Orphan Drug?", "In many cases, it means investing in the development of a small niche product, but that doesn’t mean the market potential is also small. Every market has its own rules for Orphan Drugs and in many cases the brand product is not approved or not marketed in a specific location. We will Identify the relevant markets & find the right local partners, doctors (KOLs), patients and patient associations to allow you to offer your product in a fast and effective way, realizing profits in early stages of the development."],
      ["Launch of New Products", "products", "Marketing authorization is just around the corner but the product is not yet ready for launch?", "We will evaluate the situation and direct your suppliers (API and/or FDF) on how to develop their capacity, open bottlenecks, solve quality problems in the manufacturing procedures quickly and effectively to enable a smooth and timely launch."]]
  end

  def team
    @title = "Team"
    @jarallax = "team_cover"

    @members = [
      ["Bareket Gelbhart", "Bareket attended the Technion, Israel Institute of Technology, from where she holds her Bachelor degree in Chemistry with Organic Chemistry as the principal subject.<br><br>She is fluent in Hebrew and English and can converse in Italian. Bareket posses advanced knowledge of Microsoft Word, Excel and PowerPoint.<br><br>She resides in Ticino, Switzerland with her family, from where she travels across the globe regularly for work.<br><br>Bareket is a passionate cook and a die hard football fan.".html_safe, "https://www.linkedin.com/in/bareket-gelbhart-83904a16/"],
      ["Yaron Gelbhart", "Yaron attended the Technion, Israel Institute of Technology, from where he holds his Bachelor of Science degree in Engineering with Project Management as a principal subject. Yaron possesses over 20 years of experience in large projects management with emphasis on the Indian subcontinent.<br><br>His interests also spread across real estate and hospitality. He is fluent in English and Hebrew and has conversational level in Italian. In his free time Yaron does yoga and enjoys a glass of good Italian wine.".html_safe, "https://www.linkedin.com/in/yaron-gelbhart/"],
      ["Tomer Gelbhart", "Recent graduate with 5+ years of experience in software development, web development, and large language models. Planning to pursue a masters in Artificial Intelligence in the near future. Currently working on expanding my expertise in Computing and Mathematics.".html_safe, "https://www.linkedin.com/in/tomer-gelbhart/"]]
  end

  def contacts
    @title =  'Contact Us'
    @jarallax = 'contacts_cover'
    @jarallaxHeight = 300
    @jarallaxSpeed = 0.1
  end

  def consent
    @title = 'Hevy Tracker Add-on'
    @desc = 'Track your Hevy workouts in Google Sheets'
  end
end
