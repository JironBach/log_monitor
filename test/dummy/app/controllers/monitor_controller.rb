class MonitorController < ApplicationController

  def raise500
  end

  def post
    logger.debug "debug by JironBach : webpost"
    render text: params[:body]
  end

end
