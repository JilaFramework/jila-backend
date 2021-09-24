# frozen_string_literal: true

module Api
  class HeartbeatController < ApplicationController
    newrelic_ignore

    def heartbeat
      render json: { status: 'OK' }
    end
  end
end
