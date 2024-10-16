class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_course, only: %i[show edit update destroy approve unapprove analytics] 

  # GET /courses or /courses.json
  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)    
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :tags))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :tags))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :tags))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :tags))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :tags))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def approve
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved and visible!"
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course upapproved and hidden!"
  end


  # GET /courses/1 or /courses/1.json
  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_review = @course.enrollments.reviewed
  end

  # GET /courses/new
  def new
    @course = current_user.courses.new
    authorize @course
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def analytics
    authorize @course
  end

  # POST /courses or /courses.json
  def create
    @course = current_user.courses.new(course_params)
    authorize @course
    @course.description = 'Curriculum Description'
    @course.marketing_description = 'Marketing Description'

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_course_wizard_index_path(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: 'Course has enrollments. Can not be destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :marketing_description, :price, :level, :language, :published, :avatar, tag_ids: [])
    end
end
