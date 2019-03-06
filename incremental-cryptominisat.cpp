#include <cryptominisat5/cryptominisat.h>
#include <vector>
#include <sstream>
#include <stdlib.h>
#include <string.h>

using namespace CMSat;

bool starts_with(std::string s, const char* prefix) {
    return strncmp(s.c_str(), prefix, strlen(prefix)) == 0;
}

int main(int argc, const char* argv[]) {
    SATSolver solver (NULL, NULL);

    while (true) {
        std::string line;
        if (!std::getline(std::cin, line)) {
            break;
        }

        if (starts_with(line, "p cnf")) {
            std::istringstream iss(line);
            std::string _;
            int nov, noc;
            iss >> _ >> _ >> nov >> noc;
            solver.new_vars(nov);
        } else if (starts_with(line, "solve")) {
            lbool res = solver.solve();
            if (res == l_True) {
                std::cout << "SAT" << std::endl;
                std::vector<lbool> model = solver.get_model();
                std::cout << "v ";
                for (size_t i = 0; i < model.size(); i++) {
                    std::cout << (model[i] == l_True ? "" : "-") << (i + 1) << " ";
                }
                std::cout << std::endl;
            } else if (res == l_False) {
                std::cout << "UNSAT" << std::endl;
            } else {
                std::cout << "UNKNOWN" << std::endl;
            }
        } else if (starts_with(line, "new_vars")) {
            std::istringstream iss(line);
            std::string sub;
            iss >> sub;
            iss >> sub;
            int num = atoi(sub.c_str());
            solver.new_vars(num);
        } else if (line == "halt") {
            break;
        } else if (line.empty() || starts_with(line, "c ")) {
            // skip comments and empty lines
        } else {
            std::vector<Lit> lits;
            std::istringstream iss(line);
            int literal;
            do {
                iss >> literal;
                if (literal == 0) {
                    break;
                }
                if (abs(literal) >= solver.nVars()) {
                    solver.new_vars(abs(literal) - solver.nVars());
                }
                lits.push_back(Lit(abs(literal) - 1, literal < 0));
            } while (iss);
            // std::cout << "c clause: <" << lits << ">" << std::endl;
            if (lits.size() > 0) solver.add_clause(lits);
        }
    }

    return 0;
}
