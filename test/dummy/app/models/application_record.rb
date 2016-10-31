class ApplicationRecord < ActiveRecord::Base
  include Giman::AttachmentHelpers

  self.abstract_class = true
end
