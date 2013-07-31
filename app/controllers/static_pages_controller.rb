class StaticPagesController < ApplicationController
  def home
  	@course = current_user.courses.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
