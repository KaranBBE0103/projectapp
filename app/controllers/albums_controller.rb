class AlbumsController < ApplicationController
  before_action :authenticate_user! , except: [:index, :show]

  def index
    @q = Album.ransack(params[:q])
    @albums = Album.all.where(publisher: true)
  
    if params[:tag].present?
      @albums = @albums.tagged_with(params[:tag]).where(publisher: true)
    else
      @albums = @q.result(distinct: true).where(publisher: true)
    end
  end
  def show
    @album = Album.find(params[:id])
  end
  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to @album
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])

    if @album.update(album_params)
      redirect_to @album
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    redirect_to root_path, status: :see_other
  end

  def remove_video
    @album = Album.find(params[:id])
    video_attachment = @album.videos.find(params[:video_id])
    video_attachment.purge 
    redirect_to @album, alert: "Video attachment deleted."
  end

  def my_albums
    # @albums = Album.all
    @q = Album.ransack(params[:q])
    @albums = @q.result(distinct: true).where(publisher: false)
    params[:tag] ? @albums = Album.tagged_with(params[:tag]) : @albums = Album.all.where(publisher: false)
  end
end

private
def album_params
  params.require(:album).permit(:title, :body, :publisher, :coverimg,:tag_list, :tag,:tag_ids,{ tag_ids: [] }, videos: [])
end