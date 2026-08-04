FC = mpif90
TARGET = simulation_mpi
SOURCES = neuron.f90 main.f90

all:
	$(FC) $(SOURCES) -o $(TARGET)

run: all
	mpirun --oversubscribe -np 4 ./$(TARGET)

clean:
	rm -f $(TARGET) *.o *.mod