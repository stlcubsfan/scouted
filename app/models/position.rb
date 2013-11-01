class Position < ActiveRecord::Base
  belongs_to :user

  scope :open, -> {where(sold_date: nil)}

  def self.closed
     where ("sold_date is not null")
  end
  default_scope {order('symbol')}
end
