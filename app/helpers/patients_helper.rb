module PatientsHelper
  def setup_patient(patient)
    unless patient.tags.any?
      5.times do
        patient.tags.build
      end
    end
    patient
  end
end
