import threading
import time
import random

class Philosopher(threading.Thread):
    def __init__(self, index, left_fork, right_fork):
        super(Philosopher, self).__init__()
        self.index = index
        self.left_fork = left_fork
        self.right_fork = right_fork

    def run(self):
        for _ in range(5):  # философ ест 5 раз
            self.think()
            self.pick_up_forks()
            self.eat()
            self.put_down_forks()

    def think(self):
        print(f"Философ {self.index} размышляет.")
        time.sleep(random.uniform(1, 3))

    def pick_up_forks(self):
        print(f"Философ {self.index} хочет взять вилки.")
        self.left_fork.acquire()
        self.right_fork.acquire()
        print(f"Философ {self.index} взял вилки.")

    def eat(self):
        print(f"Философ {self.index} ест.")
        time.sleep(random.uniform(2, 5))

    def put_down_forks(self):
        print(f"Философ {self.index} кладет вилки на место.")
        self.left_fork.release()
        self.right_fork.release()
        print(f"Философ {self.index} положил вилки.")

def dining_philosophers():
    num_philosophers = 12
    forks = [threading.Lock() for _ in range(num_philosophers)]
    philosophers = [Philosopher(i, forks[i], forks[(i + 1) % num_philosophers]) for i in range(num_philosophers)]

    for philosopher in philosophers:
        philosopher.start()

    for philosopher in philosophers:
        philosopher.join()

if __name__ == "__main__":
    dining_philosophers()
