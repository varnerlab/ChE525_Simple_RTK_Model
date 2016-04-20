include("Simulations.jl")
using PyPlot

function plot_steady_state_experiment()

  # Run the simulation -
  xss = Simulate_SS_Experiment([]);

  # plot -
  plot(xss[:,2],xss[:,3],"o-")
  xlabel(L"[LR]_{s}",fontsize=18)
  ylabel(L"[LR]_{s}/[L]",fontsize=18)

end

function plot_add_inhibitor_1_experiment()

  # rate of I1 addition -
  inhibitor_addition_rate_array = [0.01 0.1 1.0 10]

  for (index, value) in enumerate(inhibitor_addition_rate_array)

    # load the data file -
    data_dictionary = DataFile(0.0,0.0,0.0)

    # Add ligand -
    data_dictionary["KINETIC_PARAMETER_VECTOR"][8] = value

    # Run the simulation -
    (T,X) = Simulate_Add_Ligand_Washout(data_dictionary)

    # plot -
    plot(T.*(1/60.0) - 1,X[:,3])
  end

  xlabel("Time [min]",fontsize=18)
  ylabel(L"[LR]_{s}",fontsize=18)

end

function plot_add_inhibitor_2_experiment()

  # rate of I1 addition -
  inhibitor_addition_rate_array = [0.01 0.1 1.0 10]

  for (index, value) in enumerate(inhibitor_addition_rate_array)

    # load the data file -
    data_dictionary = DataFile(0.0,0.0,0.0)

    # Add ligand -
    data_dictionary["KINETIC_PARAMETER_VECTOR"][11] = value

    # Run the simulation -
    (T,X) = Simulate_Add_Ligand_Washout(data_dictionary)

    # plot -
    plot(T.*(1/60.0) - 1,X[:,9])
  end

  xlabel("Time [min]",fontsize=18)
  ylabel(L"[LRI_{2}]_{i}",fontsize=18)

end

function plot_washout_affinity_experiment()

  # affinity rate -
  kd_array = [0.01 0.1 1.0 10]
  for (index, kd_value) in enumerate(kd_array)

    # load the data file -
    data_dictionary = DataFile(0.0,0.0,0.0)

    # Add ligand -
    data_dictionary["KINETIC_PARAMETER_VECTOR"][5] = kd_value

    # Run the simulation -
    (T,X) = Simulate_Add_Ligand_Washout(data_dictionary)

    # plot -
    plot(T.*(1/60.0) - 1,X[:,3])
  end

  xlabel("Time [min]",fontsize=18)
  ylabel(L"[LR]_{s}",fontsize=18)

end

function plot_washout_internalization_experiment()

  # Internalization rate -
  internalization_rate_array = [0.01 0.1 1.0 10]
  for (index,internalization_rate) in enumerate(internalization_rate_array)

    # load the data file -
    data_dictionary = DataFile(0.0,0.0,0.0)

    # Add ligand -
    data_dictionary["KINETIC_PARAMETER_VECTOR"][3] = internalization_rate

    # Run the simulation -
    (T,X) = Simulate_Add_Ligand_Washout(data_dictionary)

    # plot -
    plot(T.*(1/60.0) - 1,X[:,3])
  end

  xlabel("Time [min]",fontsize=18)
  ylabel(L"[LR]_{s}",fontsize=18)

end


function plot_internalization_experiment()

  # Internalization rate -
  internalization_rate_array = logspace(-2,1,10)
  for (index,internalization_rate) in enumerate(internalization_rate_array)

    # load the data file -
    data_dictionary = DataFile(0.0,0.0,0.0)

    # Add ligand -
    data_dictionary["KINETIC_PARAMETER_VECTOR"][3] = internalization_rate

    # Run the simulation -
    (T,X) = Simulate_Add_Ligand(data_dictionary)

    # plot -
    plot(T.*(1/60.0) - 1,X[:,3])
  end

  xlabel("Time [min]",fontsize=18)
  ylabel(L"[LR]_{s}",fontsize=18)

end
