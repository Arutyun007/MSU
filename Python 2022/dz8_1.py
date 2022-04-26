##  Задание 8.1. Домашнее задание по файлам и классам


"""
Задача 1.
Отсортируйте список участников олимпиады из файла input4.txt:
1) По убыванию набранного балла.
2) При равных значениях балла - по фамилии в лексикографическом порядке.
3) При совпадающих баллах и фамилии - по имени в лексикографическом порядке.
"""


def descending_sort(file):
    with open(file, "r", encoding = 'utf-8') as inf:
        my_dict = {}
        for line in inf.readlines():
            key = " ".join(line.split()[:2])
            value = line.split()[2:]
            my_dict[key] = value

    for key, value in my_dict.items():
        my_dict[key] = [int(value[i]) for i in range(len(value))]
    print('Unsorted dictionary from file:')
    print(my_dict)
    print()

    print('Sorted dictionary from file:')
    sort_my_dict = dict(sorted(my_dict.items(), key=lambda item: (-sum(item[1]), item[0])))
    print(sort_my_dict)
    print()

    print('Sorted list from file:')
    for key, value in sort_my_dict.items():
        print(key, *value, sep = ' ')


if __name__ == '__main__':
    print("Lesson 8 (Homework) - Task 1:")
    descending_sort('input4.txt')
