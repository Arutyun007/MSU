"""
Во всех заданиях использование специальных встроенных функций математической
библиотеки Python не допускается.
"""
"""
1. Написать программу, вычисляющую НОД двух целых чисел
https://ru.wikipedia.org/wiki/Алгоритм_Евклида
"""
def GCD (a, b):
    while (a != 0 and b != 0):
        if a > b:
            a = a % b
        else:
            b = b % a
    print(a + b)

"""
2. Реализовать алгоритм "решето эратосфена". На вход подается натуральное число N,
необходимо вывести на печать все простые числа не превосходящие данное.
https://ru.wikipedia.org/wiki/Решето_Эратосфена
"""
def eratosthenes(n):
    my_list = []
    for i in range(n+1):
        my_list.append(int(1))
    i = 2
    while (i * i <= n):
        if my_list[i] == 1:
            j = i * i
            while (j <= n):
                my_list[j] = 0
                j += i
        i += 1
    print(*[i for i in range(2,n+1) if my_list[i] == 1])

""" 
3. Поиск корня из натурального числа.
Необходимо реализовать алгоритм поиска корня из натурального числа с заданной
точностью. На входе 2 параметра N- число и e- точность, с которой необходимо вычислить
корень.
Пример: my_sqrt(2, 0.01) возвращает 1.41
"""
def my_sqrt(n, eps):
    x = n
    y = (x+1.0) / 2.0
    while y < x:
        x = y
        y = (x + (n / x)) / 2.0
    t = 0
    while (eps < 1 ):
        eps *= 10
        t += 1
    print(round(x, t))

n_task = int(input("Enter task number (1, 2, 3) "))
if n_task == 1:
    a, b = int(input("Enter first number ")), int(input("Enter second number "))
    GCD(a, b)
elif n_task == 2:
    N = int(input("Enter N "))
    eratosthenes(N)
elif n_task == 3:
    N, eps = int(input("Enter N ")), float(input("Enter eps "))
    my_sqrt(N, eps)
else:
    print("No such task")
