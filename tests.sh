#!/bin/bash

/Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia align.jl ./tiny_traceback_ties_input.txt 1 -1 -1

/Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia align.jl ./small_both_ties_input.txt 1 -1 -1

/Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia align.jl ./medium_traceback_ties_input.txt 1 -1 -1   
/Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia align.jl ./small_traceback_ties_input.txt 1 -1 -1 


