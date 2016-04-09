class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable)

  has_many :visits
  has_one :active_visit, -> { where(active: true) }, class_name: 'Visit'

  if Rails.env.production?
    has_attached_file(:image, styles: {thumb: "100x100>"},
                      storage: :s3,
                      s3_credentials: {
                        bucket: ENV['S3_BUCKET'],
                        access_key_id: ENV['ACCESS_KEY_ID'],
                        secret_access_key: ENV['SECRET_ACCESS_KEY']
                      })

  else
    has_attached_file(:image, styles: {thumb: "100x100>"})
  end

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
