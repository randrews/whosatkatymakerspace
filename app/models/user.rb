class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable)

  validates :name, presence: true
  has_many :visits, dependent: :destroy
  has_one :active_visit, -> { where(active: true) }, class_name: 'Visit'

  after_create do
    UserMailer.welcome(self).deliver
  end

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

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(provider: access_token.provider, uid: access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(email: access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name: data["name"],
                           image: data["image"],
                           provider: access_token.provider,
                           email: data["email"],
                           uid: access_token.uid ,
                           password: Devise.friendly_token[0,20])
      end
    end
  end
end
