require "active_record"

class Team < ActiveRecord::Base

  serialize :scores, JSON

  validates :name, presence: true

  before_save :store_total

  def scores
    @scores ||= Hash.new(1).merge read_attribute(:scores) || {}
  end

private

  def store_total
    values = scores.values.compact.map &:to_f
    write_attribute :total, values.sum
  end

end
