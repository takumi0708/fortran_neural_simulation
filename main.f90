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
		
    ! ファイル保存
    ! 同じファイルあれば上書き
    ! 10 は識別番号
    open(10, file="output.dat", status = "replace")
		
    do step = 1, n_steps

        time = step * dt

        ! LIF（Leaky Integrate-and-Fire model）モデル　
        voltage = voltage + dt * ( &
            -(voltage - resting_voltage) + input_current &
        ) / tau
        
        ! 発火したら膜電位をリセット
        if(voltage >= threshold) then
          
          voltage = resting_voltage
        end if

        write(10, *) time, voltage

    end do
    close(10)

end program main