CC=gcc -O3
SRC=pb.c
OBJ=pb.o
TARGET=pb.so

CFLAGS=$(shell pkg-config --cflags luajit)
LDFLAGS=$(shell pkg-config --libs luajit)

all:$(OBJ) $(TARGET)

$(OBJ):$(SRC)
	$(CC) -o $@ -c -fPIC $^ $(CFLAGS) 

$(TARGET):$(OBJ)
	$(CC) -o $@ -O3 -shared $(LDFLAGS) $^

clean:
	rm -rf *.so *.o
