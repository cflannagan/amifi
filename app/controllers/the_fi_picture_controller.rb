class TheFiPictureController < ActionController::Base
  def index
    @fi = TheFiPicture.new
  end
end
