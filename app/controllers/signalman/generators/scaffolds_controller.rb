require "open3"

module Signalman
  class Generators::ScaffoldsController < ApplicationController
    def show
    end

    def create
      @fields = params[:fields].map { |field| [field[:name], field[:type]].join(":") }
      Bundler.with_original_env do
        @stdout, @stderr, @status = Open3.capture3("rails", "generate", "scaffold", params[:model_name], *@fields)
      end
    end
  end
end
