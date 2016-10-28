module Giman
  module AttachmentHelpers
    extend ActiveSupport::Concern

    included do
      after_save :save_pending_giman_attachments
    end

    class_methods do
      def has_giman_attachment(name = :upload)
        belongs_to name.to_sym, class_name: "Giman::FileUpload", required: false

        define_method("#{name}_id=".to_sym) do |val|
          super(val)
          if upload = Giman::FileUpload.find_by(id: val)
            @giman_unsaved_attachments ||= []
            @giman_unsaved_attachments << upload
            self.send("#{name}=".to_sym, upload)
          end
        end

        define_method("#{name}_url".to_sym) do
          self.send("#{name}".to_sym).try(:url)
        end
      end

      def has_giman_attachments(name = :uploads)
        has_many name.to_sym, class_name: "Giman::FileUpload", as: :attachable
      end
    end

    def save_pending_giman_attachments
      if @giman_unsaved_attachments
        @giman_unsaved_attachments.each(&:save)
      end
    end
  end
end