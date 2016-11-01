module Giman
  module AttachmentHelpers
    extend ActiveSupport::Concern

    included do
      after_save :save_pending_giman_attachments
    end

    class_methods do
      def has_giman_attachment(name = :upload)
        has_one name.to_sym, -> { where('attachable_column = ?', name).order(created_at: :desc) }, class_name: "Giman::FileUpload", as: :attachable

        define_method("#{name}_id=".to_sym) do |val|
          if upload = Giman::FileUpload.find_by(id: val)
            if upload.attachable != self && upload.attachable_column != name.to_s
              @giman_unsaved_attachments ||= []
              @giman_unsaved_attachments << upload
              upload.attachable = self
              upload.attachable_column = name.to_s

              # Delete all old uploads
              Giman::FileUpload.where("attachable_column = ? and attachable_id = ? and attachable_type = ? and id != ?", name.to_s, id, self.class.name, id).delete_all
            end
          end
        end

        define_method("#{name}_id".to_sym) do
          self.send("#{name}".to_sym).try(:id)
        end

        define_method("#{name}_url".to_sym) do
          self.send("#{name}".to_sym).try(:url)
        end
      end

      def has_giman_attachments(name = :uploads)
        has_many name.to_sym, -> { where('attachable_column = ?', name) }, class_name: "Giman::FileUpload", as: :attachable
      end
    end

    def save_pending_giman_attachments
      if @giman_unsaved_attachments
        @giman_unsaved_attachments.each(&:save)
      end
    end
  end
end