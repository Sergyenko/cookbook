class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all, :conditions => "is_deleted = 0")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    params[:sort].blank? ? sortby = 'title' : sortby = params[:sort]

    @category = Category.find(params[:id], :conditions => "is_deleted = 0")
    @dishes = @category.dishes.sort_by{|p| p['created_at']}
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id], :conditions => "is_deleted = 0")
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id], :conditions => "is_deleted = 0")

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.js {
        @category = Category.find(params[:id])
        Dish.all.each do |dish|
          if dish.category_id == params[:id].to_i
           dish.update_attributes(:category_id => '1')
          end
        end
        @category.update_attributes(:is_deleted => '1')
        @categories = Category.find(:all, :conditions => "is_deleted = 0")
        render :partial => 'list_of_categories'
      }
    end
  end

  def sort
    respond_to do |format|
      format.html
      format.js {
        @categories = Category.find(:all,:conditions => "is_deleted = 0").sort_by{|p| p[params[:key]]}
        render :partial => 'list_of_categories'
      }
    end
  end

  def sort_dishes_on_categry
     respond_to do |format|
      format.js {

        @category = Category.find(params[:id], :conditions => "is_deleted = 0")
        @dishes = @category.dishes.sort_by{|p| p[params[:key]]}
        render :partial => 'list_of_dishes'
        
      }
    end
  end
  def destroy_dishes_on_category
    respond_to do |format|
      format.js   {
        @category = Category.find(params[:id], :conditions => "is_deleted = 0")
        @dish = @category.dishes.find(params[:dish_id])
        @dish.update_attributes(:is_deleted => true)
        @dishes = @category.dishes.sort_by{|p| p['created_at']}
        render :partial => 'list_of_dishes'
       }
    end
  end
end
