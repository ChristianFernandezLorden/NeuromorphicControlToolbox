function queryMismatchData(callbackInfo)
    % Help function for the NEUROCONT toolstrip tab. Set the mismatch
    % parameters for the Mismatched Run toolstrip.
    %
    % Description
    % -----------
    %   queryMismatchData(callbackInfo)
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

    fig = uifigure('Name','Mismatch Parameters','WindowStyle','alwaysontop');
    fig.Position(3:4) = [280 100];
    g = uigridlayout(fig,[2,2]);
    g.RowHeight = {22,22,22};
    g.ColumnWidth = {150,100};

    labelwidth = uilabel(g);
    labelwidth.Text = "Width";
    widthfield = uieditfield(g,"numeric");
    widthfield.Limits = [0,Inf];
    if isfield(mismatchdata, "width")
        widthfield.Value = mismatchdata.width;
    else
        widthfield.Value = 0.1;
    end
    %widthfield.ValueChangedFcn = @(src,event) editFieldValueChanged(src,event,callbackInfo,"width");
    labelwidth.Layout.Row = 1;
    widthfield.Layout.Row = 1;
    labelwidth.Layout.Column = 1;
    widthfield.Layout.Column = 2;

    labelstd = uilabel(g);
    labelstd.Text = "Standard Deviation (std)";
    stdfield = uieditfield(g,"numeric");
    stdfield.Limits = [0,Inf];
    if isfield(mismatchdata, "std")
        stdfield.Value = mismatchdata.std;
    else
        stdfield.Value = 0.025;
    end
    %stdfield.ValueChangedFcn = @(src,event) editFieldValueChanged(src,event,callbackInfo,"std");
    labelstd.Layout.Row = 2;
    stdfield.Layout.Row = 2;
    labelstd.Layout.Column = 1;
    stdfield.Layout.Column = 2;

    cancelBtn = uibutton(g);
    cancelBtn.Text = "Cancel";
    cancelBtn.ButtonPushedFcn = @(src,event) cancelBtnPushed(fig);
    validateBtn = uibutton(g);
    validateBtn.Text = "Ok";
    validateBtn.ButtonPushedFcn = @(src,event) validateBtnPushed(fig, widthfield, stdfield, callbackInfo);

    uiwait(fig);
end

function validateBtnPushed(fig, widthfield, stdfield, cb)
    metadata = cb.model.Metadata;
    if isempty(metadata)
        metadata = struct();
    end
    metadata.NeuromorphicControlToolbox.internal.mismatch.width = widthfield.Value;
    metadata.NeuromorphicControlToolbox.internal.mismatch.std = stdfield.Value; 
    cb.model.Metadata = metadata;
    close(fig);
end

function cancelBtnPushed(fig)
    close(fig);
end
