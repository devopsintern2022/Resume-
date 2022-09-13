FROM debian:11
WORKDIR /projectd
RUN apt-get update &&  apt-get install -y unzip cmake gcc g++ wget 
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && unzip sqlite-amalgamation-3260000.zip
COPY CMakeLists.txt ./
WORKDIR /projectd/sqlite-amalgamation-3260000 
RUN cmake .. && cmake --build .

