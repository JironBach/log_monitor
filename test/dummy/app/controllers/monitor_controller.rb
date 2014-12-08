class MonitorController < ApplicationController
  protect_from_forgery except: [:post]

  def raise500
  end

  def post
    render nothing: true
  end

end
