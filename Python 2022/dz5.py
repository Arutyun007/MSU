##  Задание 5. Задание по словарям

"""
1) Даны два словаря: dictionary_1 = {'a': 300, 'b': 400} и
dictionary_2 = {'c': 500, 'd': 600}. Объедините их в один при помощи 
встроенных функций языка Python.
"""
def dictionary_union(dict_1, dict_2):
    return {**dict_1, **dict_2}


"""
2) Дан словарь с числовыми значениями. Необходимо их все перемножить и
вывести на экран.
"""
def mul_dict_values(my_dict):
    result =1
    for key in my_dict:
        result *= my_dict[key]
    return result
            

""" 
3) Создайте словарь, в котором ключами будут числа от 1 до 10, а 
значениями эти же числа, возведенные в куб.
"""
def create_dict_cube(my_list):
    for i in range(1, 11):
        my_list[i] = i ** 3
    return my_list


""" 
4) Даны два списка одинаковой длины. Необходимо создать из них словарь 
таким образом, чтобы элементы первого списка были ключами, а элементы 
второго — соответственно значениями нашего словаря.
"""
def dict_from_lists(list_1, list_2):
    return { list_1[i] : list_2[i] for i in range(len(list_1)) }


print("Lesson 5 (Homework)")
my_dict = {}
n_task = int(input("Enter task number (1, 2, 3, 4): "))
if n_task == 1:
    dictionary_1 = {'a': 300, 'b': 400} 
    dictionary_2 = {'c': 500, 'd': 600}
    my_dict = dictionary_union(dictionary_1, dictionary_2)
    print("dictionary_1:", dictionary_1)
    print("dictionary_2:", dictionary_2)
    print("Union dictionary_1 and dictionary_2:", my_dict)
elif n_task == 2:
    dictValue_mul = 0
    dictionary_1 = {'a': 300, 'b': 400}
    dictValues_mul = mul_dict_values(dictionary_1)
    print("dictionary_1:", dictionary_1)
    print("Dictionary values multiplication:", dictValues_mul)
elif n_task == 3:
    my_dict = create_dict_cube(my_dict)
    print("Dictionary with cube values:", my_dict)
elif n_task == 4:
    list_1 = ['a', 'b'] 
    list_2 = [300, 400]
    my_dict = dict_from_lists(list_1, list_2)
    print("list_1:", list_1)
    print("list_2:", list_2)
    print("Dictionary from lists:", my_dict)
else:
    print("No such task")