CXX = clang++
CXXFLAGS = -Wall -O3 -std=c++11 -stdlib=libc++ -I./samtools-0.1.19


LDFLAGS = -L./samtools-0.1.19 -lbam -lz -lm -lpthread -stdlib=libc++


OBJECTS = stats.o subexon-graph.o 

all: subexon-info combine-subexons classes vote-transcripts junc grader trust-splice add-genename addXS


samtools_lib:
	if [ ! -f ./samtools-0.1.19/libbam.a ] ; then \
		cd samtools-0.1.19 && make CC=clang CXX=clang++ ; \
	fi


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


subexon-info.o: SubexonInfo.cpp alignments.hpp blocks.hpp support.hpp defs.h stats.hpp
	$(CXX) $(CXXFLAGS) -c SubexonInfo.cpp -o subexon-info.o

combine-subexons.o: CombineSubexons.cpp alignments.hpp blocks.hpp support.hpp defs.h stats.hpp SubexonGraph.hpp
	$(CXX) $(CXXFLAGS) -c CombineSubexons.cpp -o combine-subexons.o

stats.o: stats.cpp stats.hpp
	$(CXX) $(CXXFLAGS) -c stats.cpp -o stats.o

subexon-graph.o: SubexonGraph.cpp SubexonGraph.hpp 
	$(CXX) $(CXXFLAGS) -c SubexonGraph.cpp -o subexon-graph.o

constraints.o: Constraints.cpp Constraints.hpp SubexonGraph.hpp alignments.hpp BitTable.hpp
	$(CXX) $(CXXFLAGS) -c Constraints.cpp -o constraints.o

transcript-decider.o: TranscriptDecider.cpp TranscriptDecider.hpp Constraints.hpp BitTable.hpp
	$(CXX) $(CXXFLAGS) -c TranscriptDecider.cpp -o transcript-decider.o

classes.o: classes.cpp SubexonGraph.hpp SubexonCorrelation.hpp BitTable.hpp Constraints.hpp alignments.hpp TranscriptDecider.hpp
	$(CXX) $(CXXFLAGS) -c classes.cpp -o classes.o

trust-splice.o: GetTrustedSplice.cpp alignments.hpp
	$(CXX) $(CXXFLAGS) -c GetTrustedSplice.cpp -o trust-splice.o

vote-transcripts.o: Vote.cpp TranscriptDecider.hpp
	$(CXX) $(CXXFLAGS) -c Vote.cpp -o vote-transcripts.o

junc.o: FindJunction.cpp
	$(CXX) $(CXXFLAGS) -c FindJunction.cpp -o junc.o

grader.o: grader.cpp
	$(CXX) $(CXXFLAGS) -c grader.cpp -o grader.o

addXS.o: AddXS.cpp
	$(CXX) $(CXXFLAGS) -c AddXS.cpp -o addXS.o

add-genename.o: AddGeneName.cpp
	$(CXX) $(CXXFLAGS) -c AddGeneName.cpp -o add-genename.o

clean:
	rm -f *.o subexon-info combine-subexons trust-splice vote-transcripts junc grader add-genename addXS
