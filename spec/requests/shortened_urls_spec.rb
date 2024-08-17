require 'rails_helper'

RSpec.describe "ShortenedUrls", type: :request do
  describe "GET /index" do
    it "assigns a new ShortenedUrl to @url" do
      get shortened_urls_path
      expect(assigns(:url)).to be_a_new(ShortenedUrl)
    end

    it "renders the index template" do
      get shortened_urls_path
      expect(response).to render_template('index')
    end
  end

  describe "GET /:short_url" do
    it "redirects to the sanitized URL" do
      url = create(:shortened_url)
      get "/#{url.short_url}"
      expect(response).to redirect_to(url.sanitize_url)
    end
  end

  describe "GET /shortened/:short_url" do
    it "assigns the ShortenedUrl to @url" do
      url = create(:shortened_url)
      get "/shortened/#{url.short_url}"
      expect(assigns(:url)).to eq(url)
    end

    it "assigns the sanitized URL to @target_url" do
      url = create(:shortened_url)
      get "/shortened/#{url.short_url}"
      expect(assigns(:target_url)).to eq(url.sanitize_url)
    end

    it "assigns the shortened URL code to @short_url" do
      url = create(:shortened_url)
      get "/shortened/#{url.short_url}"
      expect(assigns(:short_url)).to eq("#{request.host_with_port}/#{url.short_url}")
    end
  end

  describe "POST /shortened_urls/create" do
    context "with valid params" do
      it "creates a new ShortenedUrl" do
        expect {
          post "/shortened_urls/create", params: {  target_url: 'https://example.com'  }
        }.to change(ShortenedUrl, :count).by(1)
      end

      it "redirects to the shortened URL" do
        post "/shortened_urls/create", params: {  target_url: 'https://example.com' }
        expect(response).to redirect_to(shortened_path(assigns(:url).short_url))
      end
    end

    context "with invalid params" do
      it "does not create a new ShortenedUrl" do
        expect {
          post "/shortened_urls/create", params: {  target_url: '' }
        }.not_to change(ShortenedUrl, :count)
      end

      it "renders the index template with errors" do
        post "/shortened_urls/create", params: {  target_url: '' }
        expect(response).to render_template('index')
        expect(assigns(:url).errors).not_to be_empty
      end
    end

    context "with a duplicate URL" do
      it "does not create a new ShortenedUrl" do
        url = create(:shortened_url)
        expect {
          post "/shortened_urls/create", params: {  target_url: url.target_url  }
        }.not_to change(ShortenedUrl, :count)
      end

      it "redirects to the existing shortened URL" do
        url = create(:shortened_url)
        post "/shortened_urls/create", params: {  target_url: url.target_url  }
        expect(response).to redirect_to(shortened_path(url.short_url))
      end
    end
  end

  describe "GET /shortened_urls/fetch_original_url" do
    it "redirects to the sanitized URL" do
      url = create(:shortened_url)
      get "/shortened_urls/fetch_original_url", params: { short_url: url.short_url }
      expect(response).to redirect_to(url.sanitize_url)
    end
  end
end
