class User < ApplicationRecord
  has_giman_attachment :profile_photo
  has_giman_attachment :header_photo
end
