class ShortenedUrlsController < ApplicationController
  before_action :find_url, only: [ :show, :shortened ]
  # skip_before_filter :verify_authenticity_token

  def index
    @url = ShortenedUrl.new
  end

  def show
    redirect_to @url.sanitize_url, allow_other_host: true
  end

  def create
    @url = ShortenedUrl.new
    @url.target_url = params[:target_url]
    @url.santize
    if @url.new_url?
      if @url.save
        redirect_to shortened_path(@url.short_url)
      else
        flash[:error] = "Check errors below"
        render "index"
      end
    else
      # TODO: Change this to allow multiple short urls with the same target url
      flash[:notice] = "URL already shortened"
      redirect_to shortened_path(@url.find_duplicate.short_url)
    end
  end

  def shortened
    @url = ShortenedUrl.find_by_short_url(params[:short_url])
    host = request.host_with_port
    @target_url = @url.sanitize_url
    @short_url = host + "/" + @url.short_url
  end

  def fetch_original_url
    fetch_url = ShortenedUrl.find_by_short_url(params[:short_url])
    redirect_to fetch_url.sanitize_url, allow_other_host: true
  end

  private
  def find_url
    @url = ShortenedUrl.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:target_url)
  end
end
