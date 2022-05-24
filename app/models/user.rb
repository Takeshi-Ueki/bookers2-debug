class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :room_users
  has_many :chats


  # フォロワー機能
  # ーーーーーーーーーーーーーーーーーーーー
    #自分がフォローされる関係
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    # 自分がフォローされている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

    #自分がフォローする関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    #自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  # ーーーーーーーーーーーーーーーーーーーー

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # フォロワー機能メソッド
  # ーーーーーーーーーーーーーーーーーーーー
  # フォローした時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # ーーーーーーーーーーーーーーーーーーーー

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backword_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io:File.open(file_path), filename: 'default-image.jpg' )
    end
      profile_image.variant(resize_to_limit: [100, 100]).processed
  end
end
