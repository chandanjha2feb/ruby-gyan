# app/jobs/video_upload_job.rb
class VideoUploadJob < ApplicationJob
  queue_as :default

  def perform(lesson_id, signed_blob_id)
    lesson = Lesson.find_by(id: lesson_id)

    return unless signed_blob_id

    # Retrieve the video blob using the signed ID
    video_blob = ActiveStorage::Blob.find_signed(signed_blob_id)

    # Attach the video blob to the lesson
    lesson.video.attach(video_blob)
  rescue => e
    Rails.logger.error "Video upload failed for Lesson #{lesson_id}: #{e.message}"
  end
end
