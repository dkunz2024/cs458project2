import numpy as np
import csv

NUM_COLS = 144 #number of factor levels in "make"
NUM_ROWS = 2765 #number of factor levels in "engine"
fieldnames = ['Source', 'Target', 'Weight']

def main():

    #create matrix
    x = np.zeros((NUM_COLS, NUM_ROWS))

    #open file and generate matrix from csv data
    with open("engine_by_make.csv", "r") as f:
        cf = csv.reader(f)
        next(cf) #skip header row

        #populate data
        for line in cf:
            x[int(line[2])-1, int(line[3])-1] = 1

    write_matrix_to_csv(x)

def write_matrix_to_csv(a):
    with open("edge_info.csv", "w", newline='') as new_file:
        cf = csv.writer(new_file)
        cf.writerow(fieldnames)
        for i in range(NUM_COLS):
            for j in range(i, NUM_ROWS):
                if(a[i,j]==1):
                    cf.writerow([i+1, j+1, 1])

main()