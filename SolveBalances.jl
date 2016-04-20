include("Balances.jl")
include("DataFile.jl")
using Sundials;

# ----------------------------------------------------------------------------------- #
# Copyright (c) 2015 Varnerlab
# School of Chemical Engineering Purdue University
# W. Lafayette IN 46907 USA

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
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
# Input arguments:
# TSTART  - Time start
# TSTOP  - Time stop
# Ts - Time step
# data_dictionary  - Data dictionary instance (holds model parameters)
#
# Return arguments:
# TSIM - Simulation time vector
# X - Simulation state array (NTIME x NSPECIES)
# ----------------------------------------------------------------------------------- #
function SolveBalances(TSTART,TSTOP,Ts,data_dictionary)

# If we do *not* have the data_dictionary, load default values -
if (isempty(data_dictionary) == true)
  data_dictionary = DataFile(0,0,0)
end

# throw an error if can't load stmatrix -
if (data_dictionary == 0 || isempty(data_dictionary) == true)
  throw(UndefVarError(:data_dictionary))
end

# Get required stuff from DataFile struct -
TSIM = collect(TSTART:Ts:TSTOP);
initial_condition_vector = vec(data_dictionary["INITIAL_CONDITION_VECTOR"])

# Call the ODE solver -
fbalances(t,y,ydot) = Balances(t,y,ydot,data_dictionary);
X = Sundials.cvode(fbalances,initial_condition_vector,TSIM);

return (TSIM,X);
end
