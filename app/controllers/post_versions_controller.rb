class PostVersionsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @post_versions = PostVersion.search(params[:search]).order("updated_at desc").paginate(params[:page], :search_count => params[:search])
    respond_with(@post_versions)
  end
  
  def search
  end
end
