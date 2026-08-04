program main
    implicit none
		
		! 変数宣言
    integer :: step !現在の計算回数
    integer :: n_steps !計算する合計回数
		
    real :: voltage ! 現在の膜電位
    real :: resting_voltage ! 静止膜電位
    real :: input_current !外部から与える刺激
    real :: dt
    real :: tau !膜電位の変化の速さを決める値
	
		!静止膜電位を -65 mV とし、最初の膜電位も -65 mV
    resting_voltage = -65.0
    voltage = resting_voltage

    input_current = 20.0
    dt = 0.1
    tau = 20.0

    n_steps = 100

    print *, "step, voltage"
		
		
    do step = 1, n_steps
		
        voltage = voltage + dt * ( &
            -(voltage - resting_voltage) + input_current &
        ) / tau

        print *, step, voltage

    end do

end program main