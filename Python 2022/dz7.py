import re
##  Задание 7. Рекурсия. Лямбда-функции. Работа с файлами


"""
Задача 1.
Дана последовательность целых чисел, заканчивающаяся числом 0. Выведите эту последовательность в обратном порядке.
# При решении этой задачи нельзя пользоваться массивами и прочими динамическими структурами данных. Рекурсия вам поможет.
"""


def recursion_reverse():
    n = int(input("Input numbers: "))
    if n != 0:
        recursion_reverse()
    print(n)


"""
Задача 2.
Во входном файле записано два целых числа, которые могут быть разделены пробелами и концами строк.
Выведите в выходной файл их сумму.
Указание. Считайте весь файл в строковую переменную при помощи метода read() и разбейте ее на части при помощи метода split().
"""


def sum_from_file(file):
    f = open(file, 'r')
    numbers = f.read().strip()
    f.close()
    numbers = re.split(" |\n", numbers)

    numbers = [int(numbers[i]) for i in range(len(numbers))]

    f = open("res_sum_from_file.txt", "w")
    f.write(str(numbers[0] + numbers[1]))
    f.close()
    print("Writing complete")


"""
Задача 3.
Во входном файле записана одна текстовая строка, возможно, содержащая пробелы. Выведите эту строку в обратном порядке.
Строка во входном файле заканчивается символом конца строки '\n'.
"""


def rev_str_from_file(file):
    f = open(file, 'r')
    rev_str = f.read().strip()
    f.close()
    print(rev_str[::-1])


"""" 
Задача 4. 
Выведите все строки данного файла в обратном порядке. Для этого считайте список всех строк при помощи метода
readlines(). Последняя строка входного файла обязательно заканчивается символом '\n'. 
"""


def rev_each_str_from_file(file):
    f = open(file, 'r')
    rev_each_str = f.readlines()
    f.close()

    for line in rev_each_str:
        print(line[::-1].strip())


"""
Задача 5.
В выходной файл выведите все строки наибольшей длины из входного файла, не меняя их порядок.
В данной задаче удобно считать список строк входного файла целиком при помощи метода readlines
"""


def max_str_from_file(file):
    f = open(file, 'r')
    max_str = f.readlines()
    f.close()

    max_len = len(max_str[0].strip())
    for line in max_str:
        if len(line.strip()) > max_len:
            max_len = len(line.strip())

    f = open("res_max_str_equal.txt", "w")
    for line in max_str:
        if len(line.strip()) == max_len:
            f.write(line)
    f.close()
    print("Writing complete")


if __name__ == '__main__':
    print("Lesson 7 (Homework)")
    n_task = int(input("Enter task number (1, 2, 3, 4, 5): "))
    if n_task == 1:
        print("Task 1")
        recursion_reverse()
    elif n_task == 2:
        print("Task 2")
        sum_from_file('sum_from_file.txt')
    elif n_task == 3:
        print("Task 3")
        rev_str_from_file("rev_from_file.txt")
    elif n_task == 4:
        print("Task 4")
        rev_each_str_from_file("rev_each_str_from_file.txt")
    elif n_task == 5:
        print("Task 5")
        max_str_from_file("max_str_from_file.txt")
    else:
        print("No such task")
