# Лабораторная работа №6

Монгуш Темир Мергенович · ИУ5-35Б · вариант 11.

[Отчёт](Lab_6.ipynb) · [Colab](https://colab.research.google.com/github/tem1rka/System_programming/blob/main/Lab_6/Lab_6.ipynb) · [Условие](https://github.com/junaart/System_programming/blob/master/Lab_6/Lab_6.ipynb)

Движение №8: спираль из центра вниз, вправо, вверх и влево. Длины отрезков — 1, 1, 2, 2, 3, 3 и далее. При достижении границы рабочей области программа начинает новый проход из центра. След меняет цвет с белого на жёлтый и обратно. Верхняя строка отведена под подсказку.

В новом Linux-терминале проекта VS Code:

```bash
lab6
run spiral
```

Клавиша `j` завершает программу, `l` переключает задержку шага: 90, 30, 5 мс. Используй английскую раскладку. Для запуска нужен цветной терминал размером от 40 столбцов и 5 строк.

Ручная сборка в Linux x86-64, из `Lab_6`:

```bash
sudo apt-get install fasm gcc libncurses-dev
fasm spiral.asm spiral.o
gcc -no-pie -Wl,-z,noexecstack spiral.o -lncurses -o spiral
./spiral
```

Все движения реализованы в `spiral.asm`. GCC используется для компоновки с ncurses и стандартным кодом запуска `main`. Для отчёта `check_spiral.py` запускает этот же бинарник в псевдотерминале, отправляет клавиши и сохраняет два кадра реального вывода. Для запуска проверки вручную нужны пакеты `python3-pyte`, `python3-pil` и `fonts-dejavu-core`.
