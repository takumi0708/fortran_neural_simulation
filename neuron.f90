module neuron_module
    implicit none

contains

    subroutine update_neuron( &
        voltage, resting_voltage, input_current, &
        synaptic_input, dt, tau, threshold, spike &
    )

        implicit none

        real, intent(inout) :: voltage
        real, intent(in) :: resting_voltage
        real, intent(in) :: input_current
        real, intent(in) :: synaptic_input
        real, intent(in) :: dt
        real, intent(in) :: tau
        real, intent(in) :: threshold
        logical, intent(out) :: spike

        voltage = voltage + dt * ( &
            -(voltage - resting_voltage) &
            + input_current &
            + synaptic_input &
        ) / tau

        spike = .false.

        if (voltage >= threshold) then
            spike = .true.
            voltage = resting_voltage
        end if

    end subroutine update_neuron

end module neuron_module