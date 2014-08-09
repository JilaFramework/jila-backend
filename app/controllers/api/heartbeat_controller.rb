class Api::HeartbeatController < ApplicationController
  newrelic_ignore

  def heartbeat
    render json: {status: 'OK'}
  end
end