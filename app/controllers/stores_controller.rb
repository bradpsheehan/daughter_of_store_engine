class StoresController < ApplicationController

  def index
    @stores = Store.all_cached.select {|s| s.online?}
  end

  def new
    @new_store = Store.new
  end

  def create
    @new_store = Store.new(params[:store])

    if @new_store.save
      render :confirmation
    else
      render :new
    end
  end
end
