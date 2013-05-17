default:
	clang  main.m DemoObj.m  -framework Foundation -o binary
	./binary
	
clean:
	rm binary


