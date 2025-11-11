module JarallaxConfiguration
  extend ActiveSupport::Concern

  private

  def assign_jarallax(image:, height: nil, speed: nil)
    @jarallax = image
    @jarallaxHeight = height
    @jarallaxSpeed = speed
  end
end



