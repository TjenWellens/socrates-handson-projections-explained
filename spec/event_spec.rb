require 'events'

describe 'blah' do

  let(:projector) { Projector.new }

  it 'registers a new appointment' do
    given event_type: :guest_booked_appointment,
                      appointment_id: 45,
                      guest_id: 76867,
                      appointment_date: '1/1/2016'
    expect(projector.store).to eq [{appointment_id: 45,
                                    guest_id: 76867,
                                    guest_name: nil,
                                    appointment_date: "1/1/2016"}]
  end

  it('reschedules a previous appointment') do
    given event_type: :guest_booked_appointment,
          appointment_id: 45,
          guest_id: 76867,
          appointment_date: '1/1/2016'
    given event_type: :guest_rescheduled_appointment,
          appointment_id: 45,
          guest_id: 76867,
          appointment_date: '15/1/2016'
    expect(projector.store).to eq [{appointment_id: 45,
                                    guest_id: 76867,
                                    guest_name: nil,
                                    appointment_date: "15/1/2016"}]
  end

  it 'cancels a previous appointment' do
    given event_type: :guest_booked_appointment,
                      appointment_id: 45,
                      guest_id: 76867,
                      appointment_date: '1/1/2016'
    given event_type: :guest_cancelled_appointment,
                      appointment_id: 45
    expect(projector.store).to eq []
  end

  def given event
    projector.handle event
  end
end