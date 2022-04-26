import re
##  Задание 8.2. Домашнее задание по файлам и классам


"""
Задача 2.
Напишите класс-карточку товара.
Экземпляр класса должен содержать Название товара, его Цену и кол-во экземпляров В наличии.
"""


class Product:
    def __init__(self, name, price, amount):
        print("Run class")
        self.name = name
        self.price = price
        self.amount = amount

    def start_class(self):
        print("Name:", self.name)
        print("Price:", self.price)
        print("Amount:", self.amount)

if __name__ == '__main__':
    print("Lesson 8 (Homework) - Task 2:")
    product_a = Product("Car", 124000, 5)
    print(product_a.name)
    print(product_a.price)
    print(product_a.amount)