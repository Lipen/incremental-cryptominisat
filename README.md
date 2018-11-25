[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg)](https://hub.docker.com/r/lipen/incremental-cryptominisat)


# incremental-cryptominisat

Wrapper for _iterative_ (_incremental_) SAT solving using [cryptominisat](https://github.com/msoos/cryptominisat).

Original idea and base code is taken from [EFSM-tools](https://github.com/ulyantsev/EFSM-tools/tree/master/incremental-cryptominisat).

## Installation

### Old-fashioned binary

Simply execute `make`.

### Docker image

Pull from [Docker Hub](https://hub.docker.com):

```
docker pull lipen/incremental-cryptominisat
```

or build it yourself:

```
docker build -t incremental-cryptominisat .
```


## Usage

```
docker run --rm -i lipen/incremental-cryptominisat < icnf
## SAT
## v -1 -2 -3
## SAT
## v 1 -2 3
## UNSAT
```


## iCNF format

iCNF format is very similar to the standard DIMACS format:

* _Iterative_ (_incremental_) SAT problem is represented by _blocks_ -- each block is a set of clauses and the `solve` statement.
* Each clause is represented with a single line containing a sequence of positive/negative variables, ending with 0 (zero).
* The `solve` statement indicates when the solver have to actually solve the SAT problem and print the result: satisfying assignment, or "UNSAT".
* The standard DIMACS header (`p cnf <num-of-cons> <num-of-vars>`) is not required, but may be useful to specify the total number of variables in advance.
* The `halt` statement forces the solver to halt. The solver automatically exits on EOF, so it is not required to have the `halt` statement at the end.

```
1 -3 0
2 3 -1 0
solve
1 0
-2 0
solve
-3
solve
halt
```
