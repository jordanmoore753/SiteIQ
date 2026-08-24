class CapturesController < ApplicationController
  def create
    site = Site.find_or_create_by(url: capture_params[:url])
    metrics = CaptureJob.perform_now(site.url)
    capture = site.captures.new(metrics)

    if capture.save
      render json: capture, status: :created
    else
      render json: capture.errors, status: :unprocessable_entity
    end
  end

  private

  def capture_params
    params.require(:capture).permit(:url)
  end
end
