require "open3"

module Signalman
  class Generators::ModelsController < ApplicationController
    def show
    end

    def create
      @fields = params[:fields].map { |field| [field[:name], field[:type]].join(":") }
      Bundler.with_original_env do
        @stdout, @stderr, @status = Open3.capture3("rails", "generate", "model", params[:model_name], *@fields)
      end
    end
  end
end
