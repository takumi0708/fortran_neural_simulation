program main_mpi
    use mpi
    use neuron_module
    implicit none

    integer :: ierr
    integer :: rank
    integer :: n_processes

    integer :: step
    integer :: n_steps
    integer :: i
    integer :: n_neurons
    integer :: local_n
    integer :: file_unit

    real :: resting_voltage
    real :: dt
    real :: tau
    real :: time
    real :: threshold

    real :: synaptic_input
    real :: random_value
    real :: noise_strength

    real :: local_sum
    real :: global_sum
    real :: eeg

    real, allocatable :: voltage(:)
    real, allocatable :: input_current(:)
    logical, allocatable :: spike(:)

    ! MPI開始
    call MPI_Init(ierr)

    call MPI_Comm_rank( &
        MPI_COMM_WORLD, rank, ierr &
    )

    call MPI_Comm_size( &
        MPI_COMM_WORLD, n_processes, ierr &
    )

    ! 基本設定
    resting_voltage = -65.0
    dt = 0.1
    tau = 20.0
    threshold = -50.0

    n_steps = 1000
    n_neurons = 10000

    ! ノイズの強さ
    noise_strength = 5.0

    ! 各プロセスの担当数
    local_n = n_neurons / n_processes

    ! 配列作成
    allocate(voltage(local_n))
    allocate(input_current(local_n))
    allocate(spike(local_n))

    voltage = resting_voltage
    spike = .false.

    ! 乱数の初期化
    call random_seed()

    ! ニューロンごとに異なる入力電流を設定
    do i = 1, local_n

        call random_number(random_value)

        ! 25～35程度の入力
        input_current(i) = 25.0 + 10.0 * random_value

    end do

    ! rank 0だけがファイルを作る
    if (rank == 0) then

        open( &
            newunit=file_unit, &
            file="eeg.dat", &
            status="replace" &
        )

    end if

    ! 時間発展
    do step = 1, n_steps

        time = step * dt

        do i = 1, local_n

            ! 毎ステップ異なるランダムノイズ
            call random_number(random_value)

            synaptic_input = noise_strength * ( &
                2.0 * random_value - 1.0 &
            )

            call update_neuron( &
                voltage(i), &
                resting_voltage, &
                input_current(i), &
                synaptic_input, &
                dt, &
                tau, &
                threshold, &
                spike(i) &
            )

        end do

        ! 各プロセスの膜電位合計
        local_sum = sum(voltage)

        ! rank 0へ合計を集める
        call MPI_Reduce( &
            local_sum, &
            global_sum, &
            1, &
            MPI_REAL, &
            MPI_SUM, &
            0, &
            MPI_COMM_WORLD, &
            ierr &
        )

        ! 全ニューロンの平均を擬似脳波として保存
        if (rank == 0) then

            eeg = global_sum / real(n_neurons)

            write(file_unit, *) time, eeg

        end if

    end do

    if (rank == 0) then
        close(file_unit)
        print *, "eeg.datを保存しました"
    end if

    deallocate(voltage)
    deallocate(input_current)
    deallocate(spike)

    ! MPI終了
    call MPI_Finalize(ierr)

end program main_mpi