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
    real :: time !時間
    real :: threshold ! 発火閾値
	
		!静止膜電位を -65 mV とし、最初の膜電位も -65 mV
    resting_voltage = -65.0
    voltage = resting_voltage

    input_current = 30.0
    dt = 0.1
    tau = 20.0
    threshold = -50.0

    n_steps = 1000

    print *, "time, voltage"
		
		
    do step = 1, n_steps

        time = step * dt

        ! LIF（Leaky Integrate-and-Fire model）モデル　
        voltage = voltage + dt * ( &
            -(voltage - resting_voltage) + input_current &
        ) / tau

        print *, time, voltage
        
        ! 発火したら膜電位をリセット
        if(voltage >= threshold) then
          print *, "spike!"
          voltage = resting_voltage
        end if

    end do

end program main