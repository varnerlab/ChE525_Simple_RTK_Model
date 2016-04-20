# ------------------------------------------------------------------------------------- #
# Copyright (c) 2016 Varnerlab,
# School of Chemical and Biomolecular Engineering,
# Cornell University, Ithaca NY 14853 USA.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# DataFile.m
# Parameter structure which holds data and parameter values
#
# Arguments:
# TSTART  - Time start
# TSTOP  - Time stop
# Ts - Time step
# data_dictionary  - Dictionary instance which hold parameters and experimental data
# ------------------------------------------------------------------------------------- #
function DataFile(TSTART,TSTOP,Ts)

# Initialize the data_dictionary -
data_dictionary = Dict()

# Load the stoichiometric_matrix -
stoichiometric_matrix = 0;
if (isfile("./network/Network.txt") == true)
  # Load the stoichiometric matrix -
  stoichiometric_matrix = readdlm("./network/Network.txt")
end

# throw an error if can't load stmatrix -
if (stoichiometric_matrix == 0)
  throw(UndefVarError(:stoichiometric_matrix))
end

# Rates -
# 1    Source of L
# 2    Synthesis of R
# 3    Internalization of R
# 4    Association of L with R (forms LR)
# 5    Dissssociation of LR
# 6    Internalization of LR
# 7    Hydrolysis of LRi
# 8    Source I1
# 9    Association of L with I1 (forms LI1)
# 10   Dissssociation of LI1
# 11   Source I2
# 12   Association of R with I2 (forms RI2)
# 13   Dissssociation of RI2
# 14   Internalization of RI2 (forms RI2i)
# 15   Hydrolysis of RI2i
# 16   Loss of L
# 17   Loss of I1
# 18   Loss of I2

# Kinetic parameters -
KPV = [
  0.0	;	# 1 [] -> L
  1.0	;	# 2 [] -> R
  0.1	;	# 3	R -> []
  0.1	;	# 4	L+R -> LR
  0.01	;	# 5 LR -> L + R
  0.01	;	# 6	LR -> LRi
  0.01	;	# 7 LRi -> []
  0.0 ; # 8 [] -> I1
  1.0 ; # 9 L+I1 -> LI1
  0.01 ; # 10 LI1 -> L+I1
  0.0 ; # 11 [] -> I2
  1.0 ; # 12 R+I2 -> RI2
  0.01 ; # 13 RI1 -> R+I2
  0.01  ; # 14 RI2 -> RI2i
  0.01 ; # 15 RI2i -> []
  0.01 ; # 16 L -> []
  0.01 ; # 17 I1 -> []
  0.01 ; # 18 I2 -> []
];

# Initial conditions -
ICV = [
  0.0	  ;	# 1 L = x[1]
  1.0		;	# 2 R = x[2]
  0.0		;	# 3	LR = x[3]
  0.0		;	# 4	LRi = x[4]
  0.0	  ;	# 5 I1 = x[5]
  0.0   ; # 6 LI1 = x[6]
  0.0   ; # 7 I2 = x[7]
  0.0   ; # 8 RI2 = x[8]
  0.0   ; # 9 RI2i = x[9]
];

# ================ DO NOT EDIT BELOW THIS LINE ============================= #
data_dictionary["KINETIC_PARAMETER_VECTOR"] = KPV;
data_dictionary["INITIAL_CONDITION_VECTOR"] = ICV;
data_dictionary["STOICHIOMETRIC_MATRIX"] = stoichiometric_matrix;
# ========================================================================== #

return data_dictionary
end
