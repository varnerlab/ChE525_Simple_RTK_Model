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
# Kinetics.jl
# Calculates the kientic rate vector given the state and parameter vectors
#
# Arguments:
# t - time step (provided by the ODE solver)
# x  - state vector (provided by the ODE solver)
# DF - data file instance (holds parameters)
#
# rate_array - Kinetic rate vector (NRATES x 1)
# ------------------------------------------------------------------------------------- #
function Kinetics(t,x,data_dictionary)

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

 # Initialize the rate_vector -
 rate_array = zeros(18)

 # Alias the species -
 L = x[1]
 R = x[2]
 LR = x[3]
 LRi = x[4]
 I1 = x[5]
 LI1 = x[6]
 I2 = x[7]
 RI2 = x[8]
 RI2i = x[9]

 # Get the parameter vector -
 parameter_array = data_dictionary["KINETIC_PARAMETER_VECTOR"]

 # rates -
 rate_array[1] = parameter_array[1]
 rate_array[2] = parameter_array[2]
 rate_array[3] = parameter_array[3]*R
 rate_array[4] = parameter_array[4]*(L)*(R)
 rate_array[5] = parameter_array[5]*(LR)
 rate_array[6] = parameter_array[6]*(LR)
 rate_array[7] = parameter_array[7]*(LRi)
 rate_array[8] = parameter_array[8]
 rate_array[9] = parameter_array[9]*(L)*(I1)
 rate_array[10] = parameter_array[10]*LI1
 rate_array[11] = parameter_array[11]
 rate_array[12] = parameter_array[12]*(R)*(I2)
 rate_array[13] = parameter_array[13]*RI2
 rate_array[14] = parameter_array[14]*RI2
 rate_array[15] = parameter_array[15]*RI2i
 rate_array[16] = parameter_array[16]*L
 rate_array[17] = parameter_array[17]*I1
 rate_array[18] = parameter_array[18]*I2

 # return the array -
 return rate_array
end
