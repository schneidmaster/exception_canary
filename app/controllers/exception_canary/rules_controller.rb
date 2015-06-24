require_dependency 'exception_canary/application_controller'

module ExceptionCanary
  class RulesController < ApplicationController
    helper_method :sort_column, :sort_direction

    def index
      @rules = Rule.scoped.calculated(:exceptions_count, :most_recent_exception).order(sort_param).page(params[:page])
    end

    def show
      @rule = Rule.find(params[:id])
      @stored_exceptions = @rule.stored_exceptions.page(params[:page])
    end

    def new
      @rule = Rule.new
    end

    def create
      params[:rule][:value].gsub!("\r\n", "\n") if params[:rule][:value]
      @rule = Rule.new(params[:rule].merge(is_auto_generated: false))
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
      params[:rule][:value].gsub!("\r\n", "\n") if params[:rule][:value]
      if @rule.update_attributes(params[:rule].merge(is_auto_generated: false))
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

    def sort_param
      "#{sort_column} #{sort_direction}"
    end

    def sort_column
      Rule.column_names.concat(%w(exceptions_count most_recent_exception)).include?(params[:sort]) ? params[:sort] : 'most_recent_exception'
    end

    def sort_direction
      default = sort_column == 'most_recent_exception' ? 'desc' : 'asc'
      %w(asc desc).include?(params[:direction]) ? params[:direction] : default
    end

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
          old_rule = se.rule
          se.rule = @rule
          se.save!
          old_rule.destroy if old_rule && old_rule.auto_generated? && old_rule.stored_exceptions.empty?
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
