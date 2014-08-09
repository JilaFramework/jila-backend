class Api::HeartbeatController < ApplicationController
  def heartbeat
    render json: {status: 'OK'}
  end
end