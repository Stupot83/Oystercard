require_relative 'journey'
# The JourneyLog class
class JourneyLog
  attr_reader :current_journey, :journey_class

  def initialize(journey_class, oystercard)
    @journey_class = journey_class
    @journeys = []
    @current_journey = nil
    @oystercard = oystercard
  end

  def journeys
    @journeys.dup
  end

  def start(entry_station)
    unfinished_journey_charge if @current_journey
    new_current_journey
    begin_current_journey(entry_station)
  end

  def finish(exit_station)
    @current_journey ? finish_current_journey(exit_station) : no_current_journey_penalty(exit_station)
  end

  private

  def unfinished_journey_charge
    @current_journey.finish(nil)
    @oystercard.deduct(@current_journey.fare)
    add_journey
    delete_current_journey
  end

  def no_current_journey_penalty(exit_station)
    new_current_journey
    finish_current_journey(exit_station)
  end

  def new_current_journey
    @current_journey = @journey_class.new
  end

  def add_journey
    @journeys << @current_journey
    delete_current_journey
  end

  def delete_current_journey
    @current_journey = nil
  end

  def finish_current_journey(exit_station)
    @current_journey.finish(exit_station)
    @oystercard.deduct(@current_journey.fare)
    add_journey
  end

  def begin_current_journey(entry_station)
    @current_journey.start(entry_station)
  end
end
