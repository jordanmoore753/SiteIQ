class CapturesController < ApplicationController
  def create
    site = Site.find_or_create_by(url: capture_params[:url])
    capture = site.captures.new

    if capture.save
      ttfb = CaptureJob.perform_now(site.url)
      render json: capture.as_json.merge(ttfb: ttfb), status: :created
    else
      render json: capture.errors, status: :unprocessable_entity
    end
  end

  private

  def capture_params
    params.require(:capture).permit(:url)
  end
end
