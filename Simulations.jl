include("DataFile.jl")
include("SolveBalances.jl")
using Debug

function Simulate_SS_Experiment(data_dictionary)

  # Do we have a data_dictionary (if not load a new one)
  if (isempty(data_dictionary))
    data_dictionary = DataFile(0.0,0.0,0.0)
  end

  # Ligand -
  number_of_experimemts = 10
  ligand_series = logspace(-2,1,number_of_experimemts)

  # simulate each ligand -
  steady_state_results_array = zeros(number_of_experimemts,3)
  for (index,ligand_value) in enumerate(ligand_series)

      # Add ligand -
      data_dictionary["KINETIC_PARAMETER_VECTOR"][1] = ligand_value

      # Run the model to steady-state -
      steady_state = EstimateSteadyState(data_dictionary)

      # Grab the results -
      steady_state_results_array[index,1] = steady_state[1]
      steady_state_results_array[index,2] = steady_state[3]
      steady_state_results_array[index,3] = steady_state[3]/steady_state[1]

  end

  return (steady_state_results_array)

end

function Simulate_Add_Ligand(data_dictionary)

  # Do we have a data_dictionary (if not load a new one)
  if (isempty(data_dictionary))
    data_dictionary = DataFile(0.0,0.0,0.0)
  end

  # Run the model to steady-state -
  steady_state = EstimateSteadyState(data_dictionary)

  # Phase 1 - run the model for a bit
  TSTART = 0.0
  TSTOP = 60.0
  Ts = 1.0
  (T1,X1) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary);

  # Phase 2 - add ligand
  TSTART = TSTOP + Ts
  TSTOP = TSTOP + 1200.0
  Ts = 0.1
  ICV = transpose(X1[end,:])
  data_dictionary["INITIAL_CONDITION_VECTOR"] = ICV
  data_dictionary["KINETIC_PARAMETER_VECTOR"][1] = 0.1
  (T2,X2) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary)

  # Phase 3 - wash out ligand
  TSTART = TSTOP + Ts
  TSTOP = TSTOP + 600.0
  Ts = 0.1
  ICV = transpose(X2[end,:])
  data_dictionary["INITIAL_CONDITION_VECTOR"] = ICV
  data_dictionary["KINETIC_PARAMETER_VECTOR"][1] = 0.1
  (T3,X3) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary)

  # Phase 3 - package
  final_tsim_array = [T1 ; T2 ; T3]
  final_xsim_array = [X1 ; X2 ; X3]
  return (final_tsim_array,final_xsim_array)

end

# Add Ligand to the media, then washout the ligand -
function Simulate_Add_Ligand_Washout(data_dictionary)

  # Do we have a data_dictionary (if not load a new one)
  if (isempty(data_dictionary))
    data_dictionary = DataFile(0.0,0.0,0.0)
  end

  # Run the model to steady-state -
  steady_state = EstimateSteadyState(data_dictionary)

  # Phase 1 - run the model for a bit
  TSTART = 0.0
  TSTOP = 60.0
  Ts = 1.0
  (T1,X1) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary);

  # Phase 2 - add ligand
  TSTART = TSTOP + Ts
  TSTOP = TSTOP + 1200.0
  Ts = 0.1
  ICV = transpose(X1[end,:])
  data_dictionary["INITIAL_CONDITION_VECTOR"] = ICV
  data_dictionary["KINETIC_PARAMETER_VECTOR"][1] = 0.1
  (T2,X2) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary)

  # Phase 3 - wash out ligand
  TSTART = TSTOP + Ts
  TSTOP = TSTOP + 600.0
  Ts = 0.1
  ICV = transpose(X2[end,:])
  data_dictionary["INITIAL_CONDITION_VECTOR"] = ICV
  data_dictionary["KINETIC_PARAMETER_VECTOR"][1] = 0.0
  (T3,X3) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary)

  # Phase 3 - package
  final_tsim_array = [T1 ; T2 ; T3]
  final_xsim_array = [X1 ; X2 ; X3]
  return (final_tsim_array,final_xsim_array)
end


# Run the model to steady state -
function EstimateSteadyState(data_dictionary)

  # Setup loop -
  EPSILON = 1e-3;
  TSTART = 0.0;
  Ts = 1.0;
  TSTOP = 100;

  # Do we have a data_dictionary (if not load a new one)
  if (isempty(data_dictionary))
    data_dictionary = DataFile(TSTART,TSTOP,Ts)
  end


  did_reach_steady_state = false
  while (!did_reach_steady_state)

    # solve the balances -
    (TSIM,X1) = SolveBalances(TSTART,TSTOP,Ts,data_dictionary);

    # Take a few additional steps -
    TNEXT_START = TSTOP+Ts;
    TNEXT_STOP = TNEXT_START+1000.0;
    Ts = 1.0;

    # solve the balances again 0
    initial_condition_array = vec(X1[end,:])
    data_dictionary["INITIAL_CONDITION_ARRAY"] = initial_condition_array;
    (TSIM,X2) = SolveBalances(TNEXT_START,TNEXT_STOP,Ts,data_dictionary);

    # Find the difference -
    DIFF = norm((X2[end,:] - X1[end,:]));

    # Should we stop -or- go around again?
    if (DIFF<EPSILON)
      did_reach_steady_state = true;
      return (X2[end,:]);
    else

      # No, we did *not* reach steady state ....
      TSTART = TSTOP+Ts
      TSTOP = 1000 + TSTART;
      Ts = 100.0;

      initial_condition_array = vec(X2[end,:])
      data_dictionary["INITIAL_CONDITION_ARRAY"] = initial_condition_array;
    end
  end

  # return
  return XSS;

end
