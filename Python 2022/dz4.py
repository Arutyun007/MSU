##  Задание 4. Задание на массивы

"""
1. Дан одномерный массив числовых значений, насчитывающий N элементов. 
Определить, имеются ли в массиве два подряд идущих нуля.
"""
def two_zero (my_list):
    for i in range(1, len(my_list)):
        if my_list[i-1] == 0 and my_list[i] == 0:
            return "YES"
    return "NO"


"""
2. Дан одномерный массив числовых значений, насчитывающий N элементов. Вместо 
каждого элемента с нулевым значением поставить сумму двух предыдущих элементов 
массива.
"""
def zero_to_sum(my_list):
    new_list = []
    for i in range(0, 2):
        new_list.append(my_list[i])
    for i in range(2, len(my_list)):
        if my_list[i] == 0:
            new_list.append(my_list[i - 1] + my_list[i - 2])
        else:
            new_list.append(my_list[i])
    return new_list
            

""" 
3. Дан одномерный массив числовых значений, насчитывающий N элементов. 
Исключить из массива элементы, принадлежащие промежутку [B; C].
"""
def del_interval(my_list, B, C):
    del my_list[B:C]
    return my_list
    

""" 
4. Дан одномерный массив числовых значений, насчитывающий N элементов. Добавить 
к элементам массива такой новый элемент, чтобы сумма элементов с положительными 
значениями стала бы равна модулю суммы элементов с отрицательными значениями.
"""
def new_elem(my_list):
    sum_pos = 0
    sum_neg = 0
    for i in range(len(my_list)):
        if my_list[i] < 0:
            sum_neg += abs(my_list[i])
        else:
            sum_pos += my_list[i]
    if sum_neg > sum_pos:
        my_list.append (sum_neg - sum_pos)
    elif sum_neg < sum_pos:
        my_list.append (-(sum_pos - sum_neg))
    return my_list


print("Lesson 4 (Homework)")
my_list = []
n_task = int(input("Enter task number (1, 2, 3, 4): "))
if n_task == 1:
    my_list = input("Input list: ").split()
    my_list = [int(my_list[i]) for i in range(len(my_list))]
    print("Two zero:", two_zero(my_list))
elif n_task == 2:
    my_list = input("Input list: ").split()
    my_list = [int(my_list[i]) for i in range(len(my_list))]
    my_list = zero_to_sum(my_list)
    print("New list:", *my_list)
elif n_task == 3:
    my_list = input("Input list: ").split()
    my_list = [int(my_list[i]) for i in range(len(my_list))]
    B, C = int(input("Enter B: ")), int(input("Enter C: "))
    my_list = del_interval(my_list, B, C)
    print("New list:", *my_list)
elif n_task == 4:
    my_list = input("Input list: ").split()
    my_list = [int(my_list[i]) for i in range(len(my_list))]
    my_list = new_elem(my_list)
    print("New list:", *my_list)
else:
    print("No such task")
