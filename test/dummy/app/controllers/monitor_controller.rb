class MonitorController < ApplicationController
  protect_from_forgery except: [:post]

  def raise500
  end

  def post
    logger.debug "debug by JironBach : webpost"
    render nothing: true
  end

end
