##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Tue May  7 10:48:41 2013
##################################################

from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import window
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from gnuradio.wxgui import fftsink2
from gnuradio.wxgui import forms
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import osmosdr
import wx

class top_block(grc_wxgui.top_block_gui):

	def __init__(self):
		grc_wxgui.top_block_gui.__init__(self, title="Top Block")

		##################################################
		# Variables
		##################################################
		self.gain = gain = 20
		self.freq = freq = 100.0e6

		##################################################
		# Blocks
		##################################################
		_freq_sizer = wx.BoxSizer(wx.VERTICAL)
		self._freq_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_freq_sizer,
			value=self.freq,
			callback=self.set_freq,
			label="Frequenz (UKW)",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._freq_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_freq_sizer,
			value=self.freq,
			callback=self.set_freq,
			minimum=87.5e6,
			maximum=220.352e6,
			num_steps=205,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_freq_sizer, 0, 0, 1, 1)
		self.wxgui_fftsink2_0 = fftsink2.fft_sink_c(
			self.GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=10,
			ref_level=-60,
			ref_scale=2.0,
			sample_rate=2048000,
			fft_size=1024,
			fft_rate=15,
			average=True,
			avg_alpha=None,
			title="Spektrum",
			peak_hold=False,
		)
		self.GridAdd(self.wxgui_fftsink2_0.win, 2, 0, 1, 1)
		self.osmosdr_source_c_1 = osmosdr.source_c( args="nchan=" + str(1) + " " + "" )
		self.osmosdr_source_c_1.set_sample_rate(2048000)
		self.osmosdr_source_c_1.set_center_freq(freq, 0)
		self.osmosdr_source_c_1.set_freq_corr(0, 0)
		self.osmosdr_source_c_1.set_iq_balance_mode(0, 0)
		self.osmosdr_source_c_1.set_gain_mode(0, 0)
		self.osmosdr_source_c_1.set_gain(10, 0)
		self.osmosdr_source_c_1.set_if_gain(24, 0)
		self.osmosdr_source_c_1.set_bb_gain(20, 0)
		self.osmosdr_source_c_1.set_antenna("", 0)
		self.osmosdr_source_c_1.set_bandwidth(0, 0)
		  
		_gain_sizer = wx.BoxSizer(wx.VERTICAL)
		self._gain_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_gain_sizer,
			value=self.gain,
			callback=self.set_gain,
			label="Gain [dB]",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._gain_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_gain_sizer,
			value=self.gain,
			callback=self.set_gain,
			minimum=0,
			maximum=30,
			num_steps=60,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.Add(_gain_sizer)

		##################################################
		# Connections
		##################################################
		self.connect((self.osmosdr_source_c_1, 0), (self.wxgui_fftsink2_0, 0))

	def get_gain(self):
		return self.gain

	def set_gain(self, gain):
		self.gain = gain
		self._gain_slider.set_value(self.gain)
		self._gain_text_box.set_value(self.gain)

	def get_freq(self):
		return self.freq

	def set_freq(self, freq):
		self.freq = freq
		self.osmosdr_source_c_1.set_center_freq(self.freq, 0)
		self._freq_slider.set_value(self.freq)
		self._freq_text_box.set_value(self.freq)

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	tb = top_block()
	tb.Run(True)

