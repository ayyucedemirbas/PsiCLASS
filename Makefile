# Optimized Makefile for macOS (Apple Silicon M1/M2/M3) compatibility.
# Solves 'algorithm' not found errors by enforcing C++11 and libc++.

CXX = clang++

# Compilation flags (Include paths go here)
# -std=c++11 and -stdlib=libc++ are crucial for macOS
CXXFLAGS = -Wall -O3 -std=c++11 -stdlib=libc++ -I./samtools-0.1.19

# Linking flags (Library paths go here)
LDFLAGS = -L./samtools-0.1.19 -lbam -lz -lm -lpthread -stdlib=libc++

# Source files and objects
OBJECTS = stats.o subexon-graph.o 

all: subexon-info combine-subexons classes vote-transcripts junc grader trust-splice add-genename addXS

# Check and compile internal samtools dependency if missing
samtools_lib:
	if [ ! -f ./samtools-0.1.19/libbam.a ] ; then \
		cd samtools-0.1.19 && make CC=clang CXX=clang++ ; \
	fi

# --- TARGETS ---

subexon-info: samtools_lib subexon-info.o $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ subexon-info.o $(OBJECTS) $(LDFLAGS)

combine-subexons: combine-subexons.o $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ combine-subexons.o $(OBJECTS) $(LDFLAGS)

classes: classes.o constraints.o transcript-decider.o $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ constraints.o transcript-decider.o classes.o $(OBJECTS) $(LDFLAGS)

trust-splice: trust-splice.o
	$(CXX) $(CXXFLAGS) -o $@ trust-splice.o $(OBJECTS) $(LDFLAGS)

vote-transcripts: vote-transcripts.o 
	$(CXX) $(CXXFLAGS) -o $@ vote-transcripts.o $(OBJECTS) $(LDFLAGS)

junc: junc.o
	$(CXX) $(CXXFLAGS) -o $@ junc.o $(LDFLAGS)

grader: grader.o
	$(CXX) $(CXXFLAGS) -o $@ grader.o $(LDFLAGS)

addXS: addXS.o
	$(CXX) $(CXXFLAGS) -o $@ addXS.o $(LDFLAGS)

add-genename: add-genename.o
	$(CXX) $(CXXFLAGS) -o $@ add-genename.o $(LDFLAGS)

# --- COMPILATION RULES (.cpp -> .o) ---
# Note: Only CXXFLAGS should be used here, LDFLAGS are for the linking stage.

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f *.o subexon-info combine-subexons trust-splice vote-transcripts junc grader add-genename addXS
