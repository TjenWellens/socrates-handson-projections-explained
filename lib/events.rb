class GuestBookedAppointmentEventHandler
  def handle(store, event)
    appointment = {}
    appointment[:appointment_id] = event[:appointment_id]
    appointment[:guest_id] = event[:guest_id]
    appointment[:guest_name] = nil
    appointment[:appointment_date] = event[:appointment_date]
    store << appointment
  end
end

class GuestRescheduledAppointmentEventHandler
  def handle(store, event)
    appointment = store.find { |appointment| appointment[:appointment_id] == event[:appointment_id] }
    appointment[:guest_name] = nil
    appointment[:appointment_date] = event[:appointment_date]
  end
end

class GuestCancelledAppointmentEventHandler
  def handle(store, event)
    store.delete_if { |appointment| appointment[:appointment_id] == event[:appointment_id] }
  end
end

class Resolver
  def self.mapping
    {
        guest_booked_appointment: GuestBookedAppointmentEventHandler,
        guest_rescheduled_appointment: GuestRescheduledAppointmentEventHandler,
        guest_cancelled_appointment: GuestCancelledAppointmentEventHandler
    }
  end

  def self.resolve(event)
    mapping[event[:event_type]].new
    if not event.is_a? Hash
      puts 'hello zorld'
    end
  end
end

class Projector
  attr_reader :store

  def initialize
    @store = []
  end

  def handle event
    handler = Resolver.resolve(event)
    handler.handle(store, event)
  end


end


# projector = Projector.new
#
# projector.handle({event_type: :guest_booked_appointment,
#                   appointment_id: 45,
#                   guest_id: 76867,
#                   appointment_date: '1/1/2016'})
# projector.handle({event_type: :guest_rescheduled_appointment,
#                   appointment_id: 45,
#                   guest_id: 76867,
#                   appointment_date: '15/1/2016'})
#
# puts projector.store