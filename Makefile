all:
	nvcc -DBROKE -DTHRUST_DEBUG example.cu -o broke.exe
	nvcc -DTHRUST_DEBUG example.cu -o fixed.exe
clean:
	rm -f ./*.exe
	rm -f ./*.o
