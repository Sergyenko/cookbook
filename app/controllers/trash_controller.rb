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
    respond_to do |format|
      format.js{
        @dish = Dish.find(params[:id])
        @dish.update_attributes(:is_deleted => false)
        @dishes = Dish.find(:all,:conditions => "is_deleted = 1").sort_by(&:category_id)
        render :partial => 'list_of_dishes'
      }
    end
  end

  def restore_category
    respond_to do |format|
      format.js {
        @category = Category.find(params[:id])
        @category.update_attributes(:is_deleted => false)
        @categories = Category.find(:all, :conditions => "is_deleted = 1")
        render :partial => 'list_of_categories'
      }
    end
  end

  def empty
    @dishes = Dish.find(:all,:conditions => "is_deleted = 1")
    @categories = Category.find(:all,:conditions => "is_deleted = 1")

    @dishes.each do |dish|
      dish.destroy
    end

    @categories.each do |category|
      category.destroy
    end
    redirect_to :action => :index
  end

end
