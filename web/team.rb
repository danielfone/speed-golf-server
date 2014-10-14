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
    values = HOLES.map {|h| scores[h] }.compact.map &:to_f
    total = 1 + values.sum - values.count
    write_attribute :total, total
  end

end
