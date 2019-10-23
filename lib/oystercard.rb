require_relative 'journey'
require_relative 'station'
# The Oystercard class
class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1
  attr_reader :balance, :journeys, :current_journey

  def initialize(balance = 0)
    @balance = balance
    @current_journey = nil
    @journeys = []
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if exceed_maximum?(amount)
    increase_balance(amount)
  end

  def touch_in(station)
    affordable?
    unfinished_journey_charge if @current_journey
    new_current_journey
    begin_current_journey(station)
  end

  def touch_out(station)
    @current_journey ? finish_current_journey(station) : no_current_journey_penalty(station)
  end

  private

  def begin_current_journey(station)
    @current_journey.start(station)
  end

  def increase_balance(amount)
    @balance += amount
  end

  def affordable?
    raise 'Insufficient balance to touch in' if balance < Journey::MINIMUM_FARE
  end

  def exceed_maximum?(amount)
    (balance + amount) > MAXIMUM_BALANCE
  end

  def unfinished_journey_charge
    @current_journey.finish(nil)
    deduct(@current_journey.fare)
    delete_current_journey
  end

  def no_current_journey_penalty(station)
    new_current_journey
    finish_current_journey(station)
  end

  def deduct(amount = MINIMUM_CHARGE)
    @balance -= amount
  end

  def new_current_journey
    @current_journey = Journey.new
  end

  def add_journey
    @journeys << @current_journey
    delete_current_journey
  end

  def delete_current_journey
    @current_journey = nil
  end

  def finish_current_journey(station)
    @current_journey.finish(station)
    deduct(@current_journey.fare)
    add_journey
  end
end
