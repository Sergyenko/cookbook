class TrashController < ApplicationController
  def index
    @dishes = Dish.find(:all,:conditions => "is_deleted = 1").sort_by(&:category_id)
    @categories = Category.find(:all, :conditions => "is_deleted = 1")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dishes }
    end
  end

  def restore_dish
    @dish = Dish.find(params[:id])
    @dish.update_attributes(:is_deleted => false)
    redirect_to :action => :index
  end

  def restore_category
    @categories = Category.find(params[:id])
    @categories.update_attributes(:is_deleted => false)
    redirect_to :action => :index
  end

  def empty

    @dishes = Dish.find(:all,:conditions => "is_deleted = 1").sort_by(&:category_id)

    @dishes.each do |dish|
      dish.destroy
    end
    redirect_to :action => :index
  end

end
