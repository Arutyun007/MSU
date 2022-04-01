##  Задание 6. Задание по теме строки

"""
Задача 1.

Из входной строки удалить все пробелы и определить, является ли новая 
строка палиндроном. 
Если строка — палиндром, удалить из неё все повторяющиеся символы, 
если нет, то напечатать перевёрнутую строку. 
"""
def is_palindrome(s):
    s_rev = s[::-1]
    if s == s_rev:
        return True
    else:
        return False

def remove_repeat_symbols(s):
    new_s = ""
    for i in range(len(s)):
        if s[i] not in new_s:
            new_s += s[i]
    return new_s

"""
Задача 2. 

1) Из входной строки определить 3 наиболее часто встречаемых символа в ней. 
2) Пробелы нужно игнорировать (не учитывать при подсчете). 
3) Для выведения результатов вычислений требуется написать функцию top3(str)
4) Итог работы функции top3 —строка следующего вида: символ – количество раз, 
символ – количество раз... например       ‘a-5, m-3, h-1’
"""
def top3(s):
    my_dict = {}
    for i in range(len(s)):
        if s[i] not in my_dict:
            my_dict[s[i]] = 1
        else:
            my_dict[s[i]] += 1
    sorted_dict = sorted(my_dict.items(), key=lambda x: (x[1],x[0]), reverse=True)
    my_list = []
    temp = ""
    for i in range(3):
        temp = sorted_dict[i][0] + '-' + str(sorted_dict[i][1])
        my_list.append(temp)
        temp = ""
    result = ",".join(my_list)
    return result
            

print("Lesson 6 (Homework)")
my_dict = {}
n_task = int(input("Enter task number (1, 2): "))
if n_task == 1:
    s = input("Input string: ")
    print("String is palindrom:", is_palindrome(s))
    if is_palindrome(s) == True:
        new_s = remove_repeat_symbols(s)
        print("String without repeat symbols:", new_s)
    else:
        new_s = s[::-1]
        print("Reverse string:", new_s)
        
elif n_task == 2:
    s = input("Input string: ")
    print("'", top3(s), "'", sep="")
else:
    print("No such task")
