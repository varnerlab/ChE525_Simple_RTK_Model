include("Kinetics.jl");
using Debug

# ----------------------------------------------------------------------------------- #
# Copyright (c) 2016 Varnerlab
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
# ----------------------------------------------------------------------------------- #
@debug function Balances(t,x,dxdt_vector,data_dictionary)
# ---------------------------------------------------------------------- #
# Balances.jl was generated using the Kwatee code generation system.
# Username: jeffreyvarner
# Version: 1.0
# Generation timestamp: 04-22-2016 09:23:48
#
# Arguments:
# t  - current time
# x  - state vector
# dxdt_vector - right hand side vector
# data_dictionary  - Data dictionary instance (holds model parameters)
# ---------------------------------------------------------------------- #

# Get data from the data_dictionary -
S = data_dictionary["STOICHIOMETRIC_MATRIX"];

# Correct nagative x's = throws errors in control even if small -
idx = find(x->(x<1-6),x);
x[idx] = 0.0;

# Call the kinetics function -
(rate_vector) = Kinetics(t,x,data_dictionary);

# Encode the biochemical balance equations as a matrix vector product -
tmp_vector = S*rate_vector
for (state_index,x_value) in enumerate(collect(x))
	dxdt_vector[state_index] = tmp_vector[state_index]
end

# Is this faster?
#map!(*,dxdt_vector,tau_array,tmp_vector)

end
