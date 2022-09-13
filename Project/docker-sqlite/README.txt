#На примере Debian 11. 
#Первым шагом является установка docker
#Обновляем список пакетов, доступных файловому менеджеру apt
sudo apt-get update 
#Установим необходимые утилиты 
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
#Установим gpg ключ
sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#Занесем репозиторий в список
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Установка непосредственно docker 
sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
#В выбранной директории создаем файл конфигурации для сборки 
sudo nano CMakeLists.txt
#Редактируем файл CMakeLists.txt

cmake_minimum_required(VERSION 3.10)

project(sqlite3) #так будет называться конечный .so файл
set(SOURCE_FILES sqlite3.c shell.c) #в качестве исходных файлов берем тем, что совместимы с компилятором gcc; чтобы несколько раз не ссылаться на два файла задаем ассоциируемое качество SOURCE_FILES
add_library(sqlite3 SHARED ${SOURCE_FILES}) #добавляем библиотеку с параметром "разделяемая", а в качестве источника указываем SOURCE_FILES
target_link_libraries(sqlite3 PRIVATE Threads::Threads ${CMAKE_DL_LIBS}) #указываем на называние, а так же задаем библиотеку потоков
set(THREADS_PREFER_PTHREAD_FLAG ON) #задаем этот параметр дыбы не выдавало ошибок связанных с потоками
find_package(Threads REQUIRED) #задаем модуль поиска пакетов, в данном случае связанного с потоками
set(CMAKE_CXX_COMPILER gcc) #указываем исполняемые файлы сборки 
set(CMAKE_C_COMPILER gcc) #указываем исполняемые файлы сборки 

#Сохраняем и выходим, создаем Dockerfile 
sudo nano Dockerfile 
#Заполняем его 
FROM debian:11 #выбираем официальные образ debian11 для pull
WORKDIR /projectd #создаем и задаем рабочую директорию
RUN apt-get update &&  apt-get install -y unzip cmake gcc g++ wget #устанавливаем все необходимые для компиляции утилиты, с опцией -y, чтобы не нарушать процесс сборки образа
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && unzip sqlite-amalgamation-3260000.zip #скачиваем и разархивируем исходные файлы
COPY CMakeLists.txt ./ #копируем конфигурацию сборки из каталога, в данном случае, того же, где находится Dockerfile
WORKDIR /projectd/sqlite-amalgamation-3260000 #сменяем рабочую директорию
RUN cmake .. && cmake --build . #собираем .so библиотек из исходников. (Обычно создается директория build в рамках которой и проводят команды, но в данном случае, так как это демонстрация, я не посчитал это необходимым)





