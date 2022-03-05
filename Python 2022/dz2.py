##  Задание 2. делимость

"""
1.За день машина проезжает n километров. Сколько дней нужно, чтобы проехать
маршрут длиной m километров?
"""
def calc_car_day (n, m):
    n_days = 0
    n_days = m / n
    return int(-1 * n_days // 1 * -1)  ## округление в большую сторону

"""
2. Улитка ползет по вертикальному шесту высотой h метров, поднимаясь за день на 
a метров, а за ночь спускаясь на b метров. На какой день улитка доползет до 
вершины шеста?
"""
def calc_snail_day(h, a, b):
    if b > a:
        return -1
    else:
        return int((h - b - 1) // (a - b) + 1)
    
    
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
3. Даны значения двух моментов времени, принадлежащих одним и тем же суткам: 
часы, минуты и секунды для каждого из моментов времени.
Известно, что второй момент времени наступил не раньше первого. Определите, 
сколько секунд прошло между двумя моментами времени.
"""
def calc_time_dif(h1, m1, s1, h2, m2, s2):
    t1 = h1 * 60 * 60 + m1 * 60 + s1
    t2 = h2 * 60 * 60 + m2 * 60 + s2
    return (t1 - t2)

""" 
4. Парты. За каждой партой может сидеть два учащихся. Известно количество 
учащихся в каждом из трех классов. Выведите наименьшее число парт, которое 
нужно приобрести для них.
"""
def calc_min_desks(class1, class2, class3):
    return (class1 // 2 + class2 // 2 + class3 // 2 + class1 % 2 + class2 % 2 + class3 % 2)


print("Howework 2")
n_task = int(input("Enter task number (1, 2, 3, 4): "))
if n_task == 1:
    total_day = 0
    n, m = int(input("Enter n (km per day): ")), int(input("Enter m (distance): "))
    total_day = calc_car_day(n, m)
    print("Total days (car):", total_day)
elif n_task == 2:
    h, a, b = int(input("Enter h (total height): ")), int(input("Enter a (day distance): ")), int(input("Enter b (night distance): "))
    total_day = calc_snail_day(h, a, b)
    print("Total days (snail):", total_day)
elif n_task == 3:
    time_dif = 0
    h1, m1, s1 = int(input("Enter h1: ")), int(input("Enter m1: ")), int(input("Enter s1: "))
    h2, m2, s2 = int(input("Enter h2: ")), int(input("Enter m2: ")), int(input("Enter s2: "))
    time_dif = calc_time_dif(h1, m1, s1, h2, m2, s2)
    print("Seconds difference (t1-t2):", time_dif)
elif n_task == 4:
    min_table = 0
    class1, class2, class3 = int(input("Enter class1: ")), int(input("Enter class2: ")), int(input("Enter class3: "))
    min_table = calc_min_desks(class1, class2, class3)
    print("Minimum number of desks:", min_table)
else:
    print("No such task")
