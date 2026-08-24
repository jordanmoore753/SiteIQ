class CapturesController < ApplicationController
  # Runs CaptureJob against a URL and returns the metrics without persisting
  # them.
  #
  # @param capture [Hash] request param, requires :url
  # @return [void] renders an unsaved Capture as JSON
  def measure
    site = Site.find_or_create_by(url: measure_params[:url])
    metrics = CaptureJob.perform_now(site.url)
    capture = site.captures.new(metrics)

    render json: capture, status: :ok
  end

  # Persists a Capture from metrics the client already measured.
  #
  # @param capture [Hash] request param, requires :site_id, :ttfb, :lcp,
  #   :count_404, :count_500, :total_size_mb
  # @return [void] renders the saved Capture as JSON, or its errors
  def create
    capture = Capture.new(capture_params)

    if capture.save
      render json: capture, status: :created
    else
      render json: capture.errors, status: :unprocessable_entity
    end
  end

  private

  # @return [ActionController::Parameters] permitted params for #measure
  def measure_params
    params.require(:capture).permit(:url)
  end

  # @return [ActionController::Parameters] permitted params for #create
  def capture_params
    params.require(:capture).permit(:site_id, :ttfb, :lcp, :count_404, :count_500, :total_size_mb)
  end
end
