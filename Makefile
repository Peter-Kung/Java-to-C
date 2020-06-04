j2c:	main.o j_tree.o j_parse.o j_lex.o
	gcc -o j2c main.o j_tree.o j_parse.o j_lex.o

debug:
	bison -d --report=all -o j_parse.c j_parse.y

j_parse.c:	j_parse.y
	bison -d -o j_parse.c j_parse.y

j_parse.h:	j_parse.y
	bison -d -o j_parse.c j_parse.y

j_parse.o:	j_parse.c j_lex.h j_parse.h j_tree.h
	gcc -c -o j_parse.o j_parse.c

j_lex.c:	j_lex.l
	flex -oj_lex.c j_lex.l

j_lex.o:	j_lex.c j_lex.h j_parse.h
	gcc -c -o j_lex.o j_lex.c

j_tree.o:	j_tree.c j_tree.h j_lex.h j_parse.h
	gcc -c -o j_tree.o j_tree.c

main.o:	main.c j_lex.h j_parse.h j_tree.h
	gcc -c -o main.o main.c

clean:
	rm j2c *.o j_lex.c j_parse.c j_parse.h j_lex.h test1.c test1

