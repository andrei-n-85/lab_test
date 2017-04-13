function [CHconfig] = type1(fig,CHconfig)

global CharacterField

CHconfig.type = 1;
Charset = fig(1:4);
CHconfig.OE = fig(5);
CHconfig.ext = bbi2dec(fig(6:8));

data = fig(9:length(fig));
switch CHconfig.ext
    case 1  % Programm Service Label
        sr = bbi2dec(data(1:16));
        str = ['ID' int2str(sr)];
        CharacterField = data(17:144);
        text = char(bi2de(reshape(CharacterField,8,[])','left-msb')');
        %text = char(bin2decLib(CharacterField));
        CHconfig.Services.(str).ProgrammServiceLabel = text;
        CHconfig.Services.(str).CharacterFlags = data(145:160);
        CHconfig.Services.(str).Charset = Charset;
    case 0 % Ensemble Label
        %CHconfig.EnsembleLabel(ID).Identifier = bi2de(fliplr(data(1:16)));
        CharacterField = data(17:144);
        text = char(bi2de(reshape(CharacterField,8,[])','left-msb')');
        %text = char(bin2decLib(CharacterField));
        CHconfig.Ensemble.EnsembleLabel = text;
        CHconfig.Ensemble.CharacterFlags = data(145:160);
        CHconfig.Ensemble.Charset = Charset;
    case 5  % Data Label
        sr = bbi2dec(data(1:32));
        str = (strcat('ID',int2str(sr)));
        %CHconfig.DataLabel(ID).Identifier = bi2de(fliplr(data(1:32)));
        CharacterField = data(33:160);
        text = char(bi2de(reshape(CharacterField,8,[])','left-msb')');
        %text = char(bin2decLib(CharacterField));
        CHconfig.Services.(str).DataServiceLabel = text;
        CHconfig.Services.(str).CharacterFlags = data(161:176);
        CHconfig.Services.(str).Charset = Charset;
    case 4
        % service component labels
        %char(bin2decLib(data(1:end)))
    case 3
        % region label
        %char(bin2decLib(data(1:end)))
        
        
    otherwise
        disp('unknown type 1 Extension: ')
        disp(CHconfig.ext)
        
end