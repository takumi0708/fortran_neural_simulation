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

    real :: resting_voltage
    real :: dt
    real :: tau
    real :: time
    real :: threshold
    real :: synaptic_input

    real, allocatable :: voltage(:)
    real, allocatable :: input_current(:)
    logical, allocatable :: spike(:)

    ! MPI開始
    call MPI_Init(ierr)

    ! 自分のプロセス番号
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    ! 全プロセス数
    call MPI_Comm_size(MPI_COMM_WORLD, n_processes, ierr)

    ! 基本設定
    resting_voltage = -65.0
    dt = 0.1
    tau = 20.0
    threshold = -50.0
    synaptic_input = 0.0

    n_steps = 1000
    n_neurons = 10000

    ! 各プロセスが担当するニューロン数
    local_n = n_neurons / n_processes

    allocate(voltage(local_n))
    allocate(input_current(local_n))
    allocate(spike(local_n))

    voltage = resting_voltage
    input_current = 30.0
    spike = .false.

    do step = 1, n_steps

        time = step * dt

        do i = 1, local_n

            call update_neuron( &
                voltage(i), resting_voltage, input_current(i), &
                synaptic_input, dt, tau, threshold, spike(i) &
            )

        end do

    end do

    print *, "rank =", rank, "担当数 =", local_n, &
             "最終膜電位 =", voltage(1)

    deallocate(voltage)
    deallocate(input_current)
    deallocate(spike)

    ! MPI終了
    call MPI_Finalize(ierr)

end program main_mpi