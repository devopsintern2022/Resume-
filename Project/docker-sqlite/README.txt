#�� ������� Debian 11. 
#������ ����� �������� ��������� docker
#��������� ������ �������, ��������� ��������� ��������� apt
sudo apt-get update 
#��������� ����������� ������� 
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
#��������� gpg ����
sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#������� ����������� � ������
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#��������� ��������������� docker 
sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
#� ��������� ���������� ������� ���� ������������ ��� ������ 
sudo nano CMakeLists.txt
#����������� ���� CMakeLists.txt

cmake_minimum_required(VERSION 3.10)

project(sqlite3) #��� ����� ���������� �������� .so ����
set(SOURCE_FILES sqlite3.c shell.c) #� �������� �������� ������ ����� ���, ��� ���������� � ������������ gcc; ����� ��������� ��� �� ��������� �� ��� ����� ������ ������������� �������� SOURCE_FILES
add_library(sqlite3 SHARED ${SOURCE_FILES}) #��������� ���������� � ���������� "�����������", � � �������� ��������� ��������� SOURCE_FILES
target_link_libraries(sqlite3 PRIVATE Threads::Threads ${CMAKE_DL_LIBS}) #��������� �� ���������, � ��� �� ������ ���������� �������
set(THREADS_PREFER_PTHREAD_FLAG ON) #������ ���� �������� ���� �� �������� ������ ��������� � ��������
find_package(Threads REQUIRED) #������ ������ ������ �������, � ������ ������ ���������� � ��������
set(CMAKE_CXX_COMPILER gcc) #��������� ����������� ����� ������ 
set(CMAKE_C_COMPILER gcc) #��������� ����������� ����� ������ 

#��������� � �������, ������� Dockerfile 
sudo nano Dockerfile 
#��������� ��� 
FROM debian:11 #�������� ����������� ����� debian11 ��� pull
WORKDIR /projectd #������� � ������ ������� ����������
RUN apt-get update &&  apt-get install -y unzip cmake gcc g++ wget #������������� ��� ����������� ��� ���������� �������, � ������ -y, ����� �� �������� ������� ������ ������
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && unzip sqlite-amalgamation-3260000.zip #��������� � ������������� �������� �����
COPY CMakeLists.txt ./ #�������� ������������ ������ �� ��������, � ������ ������, ���� ��, ��� ��������� Dockerfile
WORKDIR /projectd/sqlite-amalgamation-3260000 #������� ������� ����������
RUN cmake .. && cmake --build . #�������� .so ��������� �� ����������. (������ ��������� ���������� build � ������ ������� � �������� �������, �� � ������ ������, ��� ��� ��� ������������, � �� �������� ��� �����������)





