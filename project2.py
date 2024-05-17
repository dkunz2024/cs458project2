import numpy as np
import csv

#cols/rows is confusing because I use NUM_COLS for the matrix rows. It's because python/R difference
NUM_COLS = 144 #number of factor levels in "make"
NUM_ROWS = 2765 #number of factor levels in "engine"
fieldnames = ['Source', 'Target', 'Weight']

def main():
    make_engine_matrix = create_make_engine_matrix()
    make_make_matrix = create_make_make_matrix(make_engine_matrix)
    write_matrix_to_csv(make_make_matrix)

def create_make_engine_matrix():
    #create matrix where rows signify make and columns are 1 if that make has a model with that engine
    x = np.zeros((NUM_COLS, NUM_ROWS))

    #open file and generate matrix from csv data
    with open("engine_by_make.csv", "r") as f:
        cf = csv.reader(f)
        next(cf) #skip header row

        #populate data
        for line in cf:
            x[int(line[2])-1, int(line[3])-1] = 1

    return x

def create_make_make_matrix(x):
    #create matrix where rows AND columns are make and == 1 if that make shares an engine with the other make
    a = np.zeros((NUM_COLS, NUM_COLS))

    #go over all the engines
    for j in range(NUM_ROWS):
        #compare each make to each other make
        for i1 in range(NUM_COLS-1):
            for i2 in range(i1+1, NUM_COLS):
                if(x[i1, j]==1 and x[i2, j]==1):
                    a[i1, i2] = 1
                    a[i2, i1] = 1
    return a

def write_matrix_to_csv(a):
    with open("edge_info.csv", "w", newline='') as new_file:
        cf = csv.writer(new_file)
        cf.writerow(fieldnames)
        for i in range(NUM_COLS):
            for j in range(i, NUM_COLS):
                if(a[i,j]==1):
                    cf.writerow([i, j, 1])

main()