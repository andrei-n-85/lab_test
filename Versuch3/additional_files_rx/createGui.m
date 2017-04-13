function fig_param = createGui()

fig_param.fig_handle = figure('Position',[1 800 1200 800]);
set(gcf,'toolbar','figure');
fig_param.mTextBox = uicontrol('style','listbox');
set(fig_param.mTextBox,'units','normalized');
set(fig_param.mTextBox,'Position',[0.05 0.01 0.25 0.13])

fig_param.mTextBox2 = uicontrol('style','text');
set(fig_param.mTextBox2,'units','normalized');
set(fig_param.mTextBox2,'Position',[0.05 0.15 0.25 0.02])
set(fig_param.mTextBox2,'HorizontalAlignment','left');
%set(fig_param.mTextBox2,'String',['#           f' char(39) '                      k' char(39) '           tau'])
set(fig_param.mTextBox2,'String',['#         Fine F.          Coarse F.     Fine T.'])

fig_param.mListbox2= uicontrol('style','listbox');
set(fig_param.mListbox2,'units','normalized');
%set(mListbox2,'Position',[400 1 320 100])
set(fig_param.mListbox2,'Position',[0.70 0.01 0.25 0.13])

fig_param.mTextBox3 = uicontrol('style','text');
set(fig_param.mTextBox3,'units','normalized');
set(fig_param.mTextBox3,'Position',[0.70 0.15 0.25 0.02])
set(fig_param.mTextBox3,'HorizontalAlignment','center');
set(fig_param.mTextBox3,'String','Program Labels')

fig_param.mListbox4= uicontrol('style','listbox');
set(fig_param.mListbox4,'units','normalized');
set(fig_param.mListbox4,'Position',[0.375 0.01 0.25 0.13])

fig_param.mTextBox4 = uicontrol('style','text');
set(fig_param.mTextBox4,'units','normalized');
set(fig_param.mTextBox4,'Position',[0.375 0.15 0.25 0.02])
set(fig_param.mTextBox4,'HorizontalAlignment','center');
set(fig_param.mTextBox4,'String','Performance')

