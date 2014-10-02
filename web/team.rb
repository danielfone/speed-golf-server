require "active_record"

class Team < ActiveRecord::Base

  serialize :scores, JSON

  after_initialize :setup_defaults

  validates :name, presence: true

  before_save :store_total

private

  def setup_defaults
    self.scores ||= {}
  end

  def store_total
    values = scores.values.compact.map &:to_f
    write_attribute :total, values.sum
  end

end
