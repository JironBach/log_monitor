class MonitorController < ApplicationController

  def raise500
  end

  def post
    logger.debug "debug by JironBach:#{params.inspect}"
    render text: params[:body]
  end

end
