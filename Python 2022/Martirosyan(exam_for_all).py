##  Экзамен для всех


"""
Задача №1.
Строки в Питоне сравниваются на основании значений символов.
Требуется создать класс RealString в котором реализовать сравнение строк по количеству входящих в них символов.
Сравнивать между собой можно как объекты класса, так и обычные строки с экземплярами класса RealString.
Реализовать метод isPalindrom(), возвращающий True или False в зависимости от того, является ли слово палиндромом.
"""


class RealString:
    def __init__(self, s):
        self.s = str(s)

    def __str__(self):
        return self.s

    def __eq__(self, other):
        s = str(other)
        return len(self.s) == len(s)

    def __lt__(self, other):
        s = str(other)
        return len(self.s) < len(s)

    def __gt__(self, other):
        s = str(other)
        return len(self.s) > len(s)

    def __ne__(self, other):
        s = str(other)
        return len(self.s) != len(s)

    def __le__(self, other):
        s = str(other)
        return len(self.s) <= len(s)

    def __ge__(self, other):
        s = str(other)
        return len(self.s) >= len(s)

    def isPalindrom(self):
        rev_s = self.s[::-1]
        print("String:", self.s)
        print("Reversed string:", rev_s)
        return rev_s == self.s


"""
Задача №2.
Реализовать класс Real_text. Элементом которого является список из элементов RealString.
Реализовать в этом классе конструктор чтения слов из файла.
Реализовать метод + сумма двух экземпляров,т.е. Real_text =Real_text+ Real_text.
Реализовать метод сохранения Real_text в файл. Не забываем  слова сохранять через пробел.
"""


class Real_text:

    def __init__(self, file=None):
        self.my_list = []
        if file:
            with open(file, 'r') as f:
                for line in f:
                    for word in line.split():
                        self.my_list.append(RealString(word))

    def __add__(self, other):
        res_str = self.my_list + other.my_list
        str_class = Real_text()
        str_class.my_list = res_str
        return str_class

    def save_file(self, file):
        with open(file, 'w') as f:
            f.write(str(self))
            print("Writing complete")

    def __str__(self):
        return " ".join(map(str, self.my_list))

if __name__ == '__main__':
    print("Exam for all")
    print("Task 1")
    a = RealString("abc")
    print("Compare class instance and string:")
    print(a.s, "== abcd:", a == "abcd")
    print(a.s, "== 123:", a == "123")
    print(a.s, "< abc:", a < "abc")
    print(a.s, "< ab45:", a < "ab45")
    print(a.s, "> abc:", a > "abc")
    print(a.s, "> ab:", a > "ab")
    print(a.s, "!= abc:", a != "abc")
    print(a.s, "!= ab:", a != "ab")
    print(a.s, "<= ab:", a <= "ab")
    print(a.s, "<= abc:", a <= "abc")
    print(a.s, ">= ab12:", a >= "ab12")
    print(a.s, ">= ab:", a >= "abc")

    print()
    print("Compare class instances:")
    print(a.s, "== abcd:", a == RealString("abcd"))
    print(a.s, "== 123:", a == RealString("123"))
    print(a.s, "< abc:", a < RealString("abc"))
    print(a.s, "< ab45:", a < RealString("ab45"))
    print(a.s, "> abc:", a > RealString("abc"))
    print(a.s, "> ab:", a > RealString("ab"))
    print(a.s, "!= abc:", a != RealString("abc"))
    print(a.s, "!= ab:", a != RealString("ab"))
    print(a.s, "<= ab:", a <= RealString("ab"))
    print(a.s, "<= abc:", a <= RealString("abc"))
    print(a.s, ">= ab12:", a >= RealString("ab12"))
    print(a.s, ">= ab:", a >= RealString("abc"))

    print()
    print("Palindrom:")
    print("Method isPalindrom():", a.isPalindrom())
    print("Method isPalindrom():", RealString("kazak").isPalindrom())

    print()
    print("Task 2")
    f1 = Real_text("file1.txt")
    f2 = Real_text("file2.txt")
    print("File1:", str(f1))
    print("File2:", str(f2))
    f3 = f1 + f2
    print("File3 = File1 + File2:", str(f3))

    f3.save_file('file3.txt')

