class StoresController < ApplicationController

  def self.all_cached
    Rails.cache.fetch('Store.all') { all }
  end

  def index
    @stores = Store.all_cached.online
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
