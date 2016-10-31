desc "Deletes unused file uploads that are older than 1 day"
task :cleanup_unused do
  scope = Giman::FileUpload.where('created_at >= ? and attachable_id is null', 1.day.ago)

  puts "About to delete #{scope.count} Uploads"

  # confirm..
end
