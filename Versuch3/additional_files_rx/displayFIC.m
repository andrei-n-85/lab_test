function chan_names = displayFIC(channelConfig)

chan_names = [];
if isfield(channelConfig,'Services')
    c = struct2cell(channelConfig.Services);
    temp = ['Ensemble Label:  ' channelConfig.Ensemble.EnsembleLabel];
    disp(temp);
    chan_names = [chan_names;temp];
    for channel = 1:size(c,1)
        if isfield(c{channel},'ProgrammServiceLabel')
            temp = ['Channel ' num2str(channel) ':  ' c{channel}.ProgrammServiceLabel '     '];
            disp(temp);
            chan_names = [chan_names;temp];
        end
    end
end