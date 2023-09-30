# numc

### Provide answers to the following questions.
- How many hours did you spend on the following tasks?
  - Task 1 (Matrix functions in C): ???
  - Task 2 (Speeding up matrix operations): ???
- Was this project interesting? What was the most interesting aspect about it?
  - <b>???</b>
- What did you learn?
  - <b>???</b>
- Is there anything you would change?
  - <b>???</b>

### 环境问题

需要安装Cunit库，并将Makefile文件中的

`CUNIT = -L/home/ff/cs61c/cunit/install/lib -I/home/ff/cs61c/cunit/install/include -lcunit`

修改为

`CUNIT = -lcunit`

python环境使用venv构建了numc环境，因为没有hive机器的环境，利用setup.py构建了一个基础的dumbpy包作为基准点，并将Makefile文件中的

`PYTHON`

修改为对应版本的python

`PYTHON = -I/usr/include/python3.10 -lpython3.10`
