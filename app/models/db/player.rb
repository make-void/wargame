module DB # Database
  class Player < ActiveRecord::Base
    set_table_name "wg_players" 
    set_primary_key "player_id"
    
    belongs_to :alliance
    has_many :cities
    has_many :upgrades
    
    validates_presence_of :name, :password, :email
    validates_uniqueness_of :name, :email
    
    validates_confirmation_of :new_password, :if => :password_changed?
    before_validation :hash_new_password, :if => :password_changed?
    
    
    attr_accessor :new_password, :new_password_confirmation
    
    def self.authenticate(test_email, test_password)
      if user = Player.find(:first, conditions: { email: test_email })
        if user.password == Digest::SHA2.hexdigest(user.salt + test_password)
          return user
        end
      end
      return nil
    end
    
    ######################################################
    #                   LOGIN UTILITIES                  #
    ######################################################
    def password_changed?
      !@new_password.blank?
    end
    
    def hash_new_password
      self.salt = ActiveSupport::SecureRandom.base64(8)
      self.password = Digest::SHA2.hexdigest(self.salt + @new_password)
    end
    
  end
end