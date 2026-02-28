function callbackInfo = simulateWithMistmatch(callbackInfo)
    % Help function for the NEUROCONT toolstrip tab.  Simulate the system
    % using the current mismatch parameters
    %
    % Description
    % -----------
    %   simulateWithMistmatch(callbackInfo)
    %
    % Inputs
    % ------
    %   callbackInfo: CallbackInfo
    %       Toolstrip callback information.

    mismatchdata = [];
    if isstruct(callbackInfo.model.Metadata)
        metadata = callbackInfo.model.Metadata;
        if isfield(metadata, "NeuromorphicControlToolbox") && ...
                isfield(metadata.NeuromorphicControlToolbox, "internal") && ...
                isfield(metadata.NeuromorphicControlToolbox.internal, "mismatch")
            mismatchdata = metadata.NeuromorphicControlToolbox.internal.mismatch;
        end
    end

    mismatchParam = struct();
    if isfield(mismatchdata, "width")
        mismatchParam.width = mismatchdata.width;
    else
        mismatchParam.width =  0.1;
    end
    if isfield(mismatchdata, "std")
        mismatchParam.std = mismatchdata.std;
    else
        mismatchParam.std = 0.025;
    end

    simin = NeuromorphicControlToolbox.mismatch.apply_to_system( ...
        callbackInfo.model.Name, mismatchParam, 1, ...
        "baseOptions", "on", "mismatchIncludeList", "all", "blockTypeIncludeList", "all");
    out = sim(simin);
    assignin('base','out',out);
end
