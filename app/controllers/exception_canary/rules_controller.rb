require_dependency 'exception_canary/application_controller'

module ExceptionCanary
  class RulesController < ApplicationController
    def index
      @rules = Rule.scoped.page(params[:page])
    end

    def show
      @rule = Rule.find(params[:id])
      @stored_exceptions = @rule.stored_exceptions.page(params[:page])
    end
  end
end
