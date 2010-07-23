class AssetsController < ApplicationController
  def show
    assets = Assets.find(params[:id])
    # do security check here
    send_file assets.data.path, :type => assets.data_content_type
  end
end
