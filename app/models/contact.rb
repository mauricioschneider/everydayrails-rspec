class Contact < ActiveRecord::Base
  has_many :phones
  accepts_nested_attributes_for :phones

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phones, length: { is: 3 }

  def name
    [firstname, lastname].join(' ')
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "#{letter}%").order(:lastname)
  end

  def change_visibility command
    if command == :hide && !hidden?
      update_attribute(:hidden, true)
    elsif command == :unhide && hidden?
      update_attribute(:hidden, false)
    end
  end
end
