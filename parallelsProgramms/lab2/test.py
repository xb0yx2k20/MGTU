from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

if rank == 0:
    data = 42
    comm.send(data, dest=1)
    print(f"Процесс 0 отправил значение {data}.")

# Не забудьте завершить MPI
if rank == 1:
    received_data = comm.recv(source=0)
    print(f"Процесс 1 получил значение {received_data}.", size)