function ignoreCudaWarnings()

% ignores GPU CUDA warnings caused by driver issues
try
    nnet.internal.cnngpu.reluForward(1);
catch ME
end

end

