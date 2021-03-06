class DishesController < ApplicationController
  
  def index
    
    @dishes = Dish.find(:all,:conditions => "is_deleted = 0").sort_by{|p| p['id']}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dishes }
    end
  end

  def show
    @dish = Dish.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dish }
    end
  end
  
  def new
    @dish = Dish.new
    @categories = Array.new()
    Category.find(:all, :conditions => "is_deleted = 0").each do |category|
      @categories[@categories.size] = [category.title, category.id]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dish }
    end
  end

  def edit
    @dish = Dish.find(params[:id])
    @categories = Array.new()
    Category.find(:all, :conditions => "is_deleted = 0").each do |category|
      @categories[@categories.size] = [category.title, category.id]
    end
  end

  def create
    @dish = Dish.new(params[:dish])

    respond_to do |format|
      if @dish.save
        flash[:notice] = 'Dish was successfully created.'
        format.html { redirect_to(@dish) }
        format.xml  { render :xml => @dish, :status => :created, :location => @dish }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dish.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @dish = Dish.find(params[:id])

    respond_to do |format|
      if @dish.update_attributes(params[:dish])
        flash[:notice] = 'Dish was successfully updated.'
        format.html { redirect_to(@dish) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dish.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
      respond_to do |format|
      format.html { redirect_to :back }
      format.js   {
        @dish = Dish.find(params[:id])
        @dish.update_attributes(:is_deleted => '1')
        @dishes = Dish.find(:all,:conditions => "is_deleted = 0").sort_by{|p| p['id']}
        render :partial => 'list_of_dishes'
       }
      format.xml  { head :ok }
    end
  end

  def sort
    respond_to do |format|
      format.html
      format.js {
        @dishes = Dish.find(:all,:conditions => "is_deleted = 0").sort_by{|p| p[params[:key]]}
        render :partial => 'list_of_dishes'
      }
    end
  end
end
