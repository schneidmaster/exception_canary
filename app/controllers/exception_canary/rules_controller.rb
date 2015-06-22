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

    def new
      @rule = Rule.new
    end

    def create
      @rule = Rule.new(params[:rule])
      if @rule.save
        reclassified_msg = flash_num_reclassified(reclassify_exceptions)
        redirect_to @rule, flash: { notice: "Created rule and reclassified #{reclassified_msg}." }
      else
        render :new
      end
    end

    def edit
      @rule = Rule.find(params[:id])
    end

    def update
      @rule = Rule.find(params[:id])
      if @rule.update_attributes(params[:rule])
        reclassified_msg = flash_num_reclassified(reclassify_exceptions)
        redirect_to @rule, flash: { notice: "Updated rule and reclassified #{reclassified_msg}." }
      else
        render :edit
      end
    end

    def destroy
      rule = Rule.find(params[:id])
      rule.destroy
      redirect_to rules_path, flash: { notice: 'Deleted rule.' }
    end

    private

    def reclassify_exceptions
      exceptions_reclassified = 0
      StoredException.all.each do |se|
        if se.rule == @rule
          unless @rule.matches? se
            se.rule = nil
            se.save!
            exceptions_reclassified += 1
          end
        elsif @rule.matches? se
          se.rule = @rule
          se.save!
          exceptions_reclassified += 1
        end
      end
      exceptions_reclassified
    end

    def flash_num_reclassified(num_reclassified)
      ActionController::Base.helpers.pluralize(num_reclassified, 'exception')
    end
  end
end
