class ShortenedUrlsController < ApplicationController
  before_action :find_url, only: [ :show, :shortened, :stats ]

  def index
    @url = ShortenedUrl.new
  end

  def show
    if Rails.env.development? || Rails.env.test?
      city_data = "Kuala Lumpur"
      country_data = "Malaysia"
      timezone = "Malaysia/Kuala_Lumpur"
    else
      city_data = request.location.city
      country_data = request.location.country
      user_ip = request.location.ip
      timezone = Geocoder.search(user_ip).first.data["timezone"]
    end
    @user_data = UserStat.new
    @user_data.origin_city = city_data
    @user_data.origin_country = country_data
    @user_data.timezone = timezone
    if @url
      @user_data.shortened_url_id = @url.id
      @user_data.save
      redirect_to @url.sanitize_url, allow_other_host: true
    else
      flash[:error] = "URL not found"
      redirect_to root_path
    end
  end

  def create
    @url = ShortenedUrl.new
    @url.target_url = params[:target_url]
    @url.santize
    if @url.save
      redirect_to shortened_path(@url.short_url)
    else
      flash[:error] = "Something went wrong when shortening your URL! Please try again."
      render "index"
    end
  end

  def shortened
    host = request.host_with_port
    @target_url = @url.sanitize_url
    @short_url = host + "/" + @url.short_url
    @short_code = @url.short_url
    @title = @url.title
  end

  def fetch_original_url
    fetch_url = ShortenedUrl.find_by_short_url(params[:short_url])
    redirect_to fetch_url.sanitize_url, allow_other_host: true
  end

  def overall_stats
    @user_stats = ShortenedUrl.page(params[:page]).per(10)
    @clicks_by_country = UserStat.group(:origin_country).count
    @clicks_by_timezone = UserStat.group(:timezone).count
    @clicks_over_time = UserStat.group_by_day(:created_at).count
    render "all_stats"
  end
  def stats
    @user_stats = UserStat.where(shortened_url_id: @url.id)
    @url_title = @url.title
    @clicks_by_country = @user_stats.group(:origin_country).count
    @clicks_by_timezone = @user_stats.group(:timezone).count
    @clicks_over_time = @user_stats.group_by_day(:created_at).count
  end

  private
  def find_url
    @url = ShortenedUrl.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:target_url)
  end
end
