require_relative 'journey'
require_relative 'station'
require_relative 'journey_log'
# The Oystercard class
class Oystercard
  attr_reader :balance, :journey_log

  MAXIMUM_BALANCE = 90

  def initialize
    @balance = 0
    @journey_log = JourneyLog.new(Journey, self)
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if exceed_maximum?(amount)
    increase_balance(amount)
  end

  def deduct(amount = MINIMUM_CHARGE)
    @balance -= amount
  end

  def touch_in(entry_station)
    affordable?
    @journey_log.start(entry_station)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
  end

  private

  def increase_balance(amount)
    @balance += amount
  end

  def affordable?
    raise 'Insufficient balance to touch in' if balance < Journey::MINIMUM_FARE
  end

  def exceed_maximum?(amount)
    (balance + amount) > MAXIMUM_BALANCE
  end
end
