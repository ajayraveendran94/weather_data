class ForecastsController < ApplicationController
    def index
    end
    
    def show
        @address = params[:address]
    
        if @address.present? 
            @forecast = WeatherService.get_forecast(@address)
            Rails.logger.info "New #{@forecast}"
    
            if @forecast[:error]
                flash.now[:alert] = @forecast[:error]
                render :index
            end
        else
            flash.now[:alert] = "Please enter an address"
            render :index
        end
    end
end