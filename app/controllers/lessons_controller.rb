class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy delete_video]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    authorize @lesson
    current_user.view_lesson(@lesson)
    @lessons = @course.lessons.rank(:row_order)
    @comment = Comment.new
    @comments = @lesson.comments.order(created_at: :desc)
  end

  # GET /lessons/new
  def new
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.new
    authorize @lesson
  end

  # GET /lessons/1/edit
  def edit
    authorize @lesson
  end

  # POST /lessons or /lessons.json
  def create
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.new(lesson_params.except(:video))
    authorize @lesson
    respond_to do |format|
      if @lesson.save
        # Create and store a blob for the video
        if lesson_params[:video].present?
          # Save the video as a blob and enqueue the job with the signed blob ID
          video_blob = ActiveStorage::Blob.create_and_upload!(
            io: lesson_params[:video].tempfile,
            filename: lesson_params[:video].original_filename,
            content_type: lesson_params[:video].content_type
          )

          VideoUploadJob.perform_later(@lesson.id, video_blob.signed_id)
        end
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: "Lesson was successfully created. Video upload is in progress if a new video was provided." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    authorize @lesson
    byebug
    respond_to do |format|
      if @lesson.update(lesson_params.except(:video))
        byebug
         # Create and store a blob for the video
         if lesson_params[:video].present?
          # Save the video as a blob and enqueue the job with the signed blob ID
          video_blob = ActiveStorage::Blob.create_and_upload!(
            io: lesson_params[:video].tempfile,
            filename: lesson_params[:video].original_filename,
            content_type: lesson_params[:video].content_type
          )

          VideoUploadJob.perform_later(@lesson.id, video_blob.signed_id)
        end
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: "Lesson was successfully updated. Video upload is in progress if a new video was provided." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    authorize @lesson
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_video
    authorize @lesson, :edit?
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course, @lesson), notice: 'Video successfully deleted!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @course = Course.friendly.find(params[:course_id])
      @lesson = Lesson.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :video, :video_thumbnail, :course_id)
    end
end
