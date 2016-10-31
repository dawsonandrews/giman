namespace :giman do
  desc "Deletes unused file uploads that are older than 1 day"
  task cleanup_unused: :environment do
    scope = Giman::FileUpload.where('created_at <= ? and attachable_id is null', 1.day.ago)
    file_count = scope.count

    abort("No files to cleanup") if file_count < 1

    puts "About to delete #{file_count} Uploads. Enter 'yes' to confirm:"
    input = STDIN.gets.chomp
    abort("Aborting delete. You entered #{input}") unless input == "yes"

    scope.find_each(&:destroy)

    puts "Cleaned up #{file_count} uploads"
  end
end