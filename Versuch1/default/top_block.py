##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Mon Apr  8 15:41:20 2013
##################################################

from gnuradio import audio
from gnuradio import blks2
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import window
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from gnuradio.wxgui import fftsink2
from gnuradio.wxgui import forms
from gnuradio.wxgui import scopesink2
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
		self.vol_r = vol_r = 100
		self.vol_l = vol_l = 100
		self.tau = tau = 50e-6
		self.stereo = stereo = 0
		self.samp_rate = samp_rate = 1000000
		self.rx_gain = rx_gain = 20
		self.gain_38k = gain_38k = 39
		self.freq = freq = 107.2e6
		self.decim = decim = 80
		self.b_signal = b_signal = 50e3

		##################################################
		# Blocks
		##################################################
		_vol_r_sizer = wx.BoxSizer(wx.VERTICAL)
		self._vol_r_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_vol_r_sizer,
			value=self.vol_r,
			callback=self.set_vol_r,
			label="Volume R",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._vol_r_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_vol_r_sizer,
			value=self.vol_r,
			callback=self.set_vol_r,
			minimum=0,
			maximum=100,
			num_steps=100,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_vol_r_sizer, 2, 1, 1, 1)
		_vol_l_sizer = wx.BoxSizer(wx.VERTICAL)
		self._vol_l_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_vol_l_sizer,
			value=self.vol_l,
			callback=self.set_vol_l,
			label="Volume L",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._vol_l_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_vol_l_sizer,
			value=self.vol_l,
			callback=self.set_vol_l,
			minimum=0,
			maximum=100,
			num_steps=100,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_vol_l_sizer, 2, 0, 1, 1)
		_tau_sizer = wx.BoxSizer(wx.VERTICAL)
		self._tau_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_tau_sizer,
			value=self.tau,
			callback=self.set_tau,
			label="Zeitkonstante (Tau)",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._tau_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_tau_sizer,
			value=self.tau,
			callback=self.set_tau,
			minimum=0,
			maximum=100e-6,
			num_steps=100,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_tau_sizer, 0, 1, 1, 1)
		self._stereo_check_box = forms.check_box(
			parent=self.GetWin(),
			value=self.stereo,
			callback=self.set_stereo,
			label="Stereo",
			true=1,
			false=0,
		)
		self.GridAdd(self._stereo_check_box, 1, 2, 1, 1)
		self._samp_rate_text_box = forms.text_box(
			parent=self.GetWin(),
			value=self.samp_rate,
			callback=self.set_samp_rate,
			label="Sampling Rate",
			converter=forms.float_converter(),
		)
		self.GridAdd(self._samp_rate_text_box, 1, 0, 1, 1)
		_rx_gain_sizer = wx.BoxSizer(wx.VERTICAL)
		self._rx_gain_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_rx_gain_sizer,
			value=self.rx_gain,
			callback=self.set_rx_gain,
			label="Receiver Gain",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._rx_gain_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_rx_gain_sizer,
			value=self.rx_gain,
			callback=self.set_rx_gain,
			minimum=0,
			maximum=50,
			num_steps=50,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_rx_gain_sizer, 2, 2, 1, 1)
		self.notebook_0 = self.notebook_0 = wx.Notebook(self.GetWin(), style=wx.NB_TOP)
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "Audio L (FFT)")
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "Audio R (FFT)")
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "Audio L (Scope)")
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "Audio R (Scope)")
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "MPX-Signal (FFT)")
		self.notebook_0.AddPage(grc_wxgui.Panel(self.notebook_0), "RX FFT")
		self.GridAdd(self.notebook_0, 3, 0, 1, 3)
		_gain_38k_sizer = wx.BoxSizer(wx.VERTICAL)
		self._gain_38k_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_gain_38k_sizer,
			value=self.gain_38k,
			callback=self.set_gain_38k,
			label="Gain (38kHz-Traeger)",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._gain_38k_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_gain_38k_sizer,
			value=self.gain_38k,
			callback=self.set_gain_38k,
			minimum=0,
			maximum=100,
			num_steps=100,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_gain_38k_sizer, 0, 2, 1, 1)
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
			minimum=80e6,
			maximum=230e6,
			num_steps=1000,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_freq_sizer, 0, 0, 1, 1)
		_b_signal_sizer = wx.BoxSizer(wx.VERTICAL)
		self._b_signal_text_box = forms.text_box(
			parent=self.GetWin(),
			sizer=_b_signal_sizer,
			value=self.b_signal,
			callback=self.set_b_signal,
			label="Signalbandbreite",
			converter=forms.float_converter(),
			proportion=0,
		)
		self._b_signal_slider = forms.slider(
			parent=self.GetWin(),
			sizer=_b_signal_sizer,
			value=self.b_signal,
			callback=self.set_b_signal,
			minimum=1e3,
			maximum=400e3,
			num_steps=399,
			style=wx.SL_HORIZONTAL,
			cast=float,
			proportion=1,
		)
		self.GridAdd(_b_signal_sizer, 1, 1, 1, 1)
		self.wxgui_scopesink2_0_0 = scopesink2.scope_sink_f(
			self.notebook_0.GetPage(3).GetWin(),
			title="Audio R (Scope)",
			sample_rate=44100,
			v_scale=0,
			v_offset=0,
			t_scale=0,
			ac_couple=False,
			xy_mode=False,
			num_inputs=1,
			trig_mode=gr.gr_TRIG_MODE_AUTO,
			y_axis_label="Counts",
		)
		self.notebook_0.GetPage(3).Add(self.wxgui_scopesink2_0_0.win)
		self.wxgui_scopesink2_0 = scopesink2.scope_sink_f(
			self.notebook_0.GetPage(2).GetWin(),
			title="Audio L (Scope)",
			sample_rate=44100,
			v_scale=0,
			v_offset=0,
			t_scale=0,
			ac_couple=False,
			xy_mode=False,
			num_inputs=1,
			trig_mode=gr.gr_TRIG_MODE_AUTO,
			y_axis_label="Counts",
		)
		self.notebook_0.GetPage(2).Add(self.wxgui_scopesink2_0.win)
		self.wxgui_fftsink2_2_0 = fftsink2.fft_sink_f(
			self.notebook_0.GetPage(1).GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=10,
			ref_level=-20,
			ref_scale=2.0,
			sample_rate=44100,
			fft_size=1024,
			fft_rate=15,
			average=False,
			avg_alpha=None,
			title="Audio R (FFT)",
			peak_hold=False,
		)
		self.notebook_0.GetPage(1).Add(self.wxgui_fftsink2_2_0.win)
		self.wxgui_fftsink2_2 = fftsink2.fft_sink_f(
			self.notebook_0.GetPage(0).GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=10,
			ref_level=-20,
			ref_scale=2.0,
			sample_rate=44100,
			fft_size=1024,
			fft_rate=15,
			average=False,
			avg_alpha=None,
			title="Audio L (FFT)",
			peak_hold=False,
		)
		self.notebook_0.GetPage(0).Add(self.wxgui_fftsink2_2.win)
		self.wxgui_fftsink2_1 = fftsink2.fft_sink_c(
			self.notebook_0.GetPage(5).GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=10,
			ref_level=50,
			ref_scale=2.0,
			sample_rate=samp_rate,
			fft_size=1024,
			fft_rate=15,
			average=False,
			avg_alpha=None,
			title="FFT Plot",
			peak_hold=False,
		)
		self.notebook_0.GetPage(5).Add(self.wxgui_fftsink2_1.win)
		self.wxgui_fftsink2_0 = fftsink2.fft_sink_f(
			self.notebook_0.GetPage(4).GetWin(),
			baseband_freq=0,
			y_per_div=10,
			y_divs=5,
			ref_level=-20,
			ref_scale=2.0,
			sample_rate=samp_rate/6,
			fft_size=1024,
			fft_rate=15,
			average=True,
			avg_alpha=None,
			title="MPX-Signal",
			peak_hold=False,
		)
		self.notebook_0.GetPage(4).Add(self.wxgui_fftsink2_0.win)
		self.osmosdr_source_c_1 = osmosdr.source_c( args="nchan=" + str(1) + " " + "" )
		self.osmosdr_source_c_1.set_sample_rate(samp_rate)
		self.osmosdr_source_c_1.set_center_freq(freq, 0)
		self.osmosdr_source_c_1.set_freq_corr(0, 0)
		self.osmosdr_source_c_1.set_gain_mode(0, 0)
		self.osmosdr_source_c_1.set_gain(rx_gain, 0)
		self.osmosdr_source_c_1.set_if_gain(24, 0)
			
		self.low_pass_filter_2_1_0_0 = gr.fir_filter_fff(20, firdes.low_pass(
			1, samp_rate, 15000, 1000, firdes.WIN_HANN, 6.76))
		self.low_pass_filter_2_1_0 = gr.fir_filter_fff(20, firdes.low_pass(
			1, samp_rate, 15000, 1000, firdes.WIN_HANN, 6.76))
		self.low_pass_filter_1 = gr.fir_filter_fff(6, firdes.low_pass(
			1, samp_rate, 60e3, 1000, firdes.WIN_HANN, 6.76))
		self.low_pass_filter_0 = gr.fir_filter_ccf(1, firdes.low_pass(
			1, samp_rate, b_signal, 10000, firdes.WIN_HANN, 6.76))
		self.gr_sub_xx_0 = gr.sub_ff(1)
		self.gr_multiply_xx_2 = gr.multiply_vff(1)
		self.gr_multiply_xx_1 = gr.multiply_vff(1)
		self.gr_multiply_xx_0 = gr.multiply_vcc(1)
		self.gr_multiply_const_vxx_2 = gr.multiply_const_vff((stereo, ))
		self.gr_multiply_const_vxx_1 = gr.multiply_const_vff((vol_l/100*3, ))
		self.gr_multiply_const_vxx_0 = gr.multiply_const_vff((vol_r/100*3, ))
		self.gr_iir_filter_ffd_1_0 = gr.iir_filter_ffd(((1.0/(1+tau*2*samp_rate), 1.0/(1+tau*2*samp_rate))), ((1, -(1-tau*2*samp_rate)/(1+tau*2*samp_rate))))
		self.gr_iir_filter_ffd_1 = gr.iir_filter_ffd(((1.0/(1+tau*2*samp_rate), 1.0/(1+tau*2*samp_rate))), ((1, -(1-tau*2*samp_rate)/(1+tau*2*samp_rate))))
		self.gr_delay_0 = gr.delay(gr.sizeof_gr_complex*1, 1)
		self.gr_conjugate_cc_0 = gr.conjugate_cc()
		self.gr_complex_to_arg_0 = gr.complex_to_arg(1)
		self.gr_add_xx_0 = gr.add_vff(1)
		self.blks2_rational_resampler_xxx_0_0 = blks2.rational_resampler_fff(
			interpolation=441,
			decimation=500,
			taps=None,
			fractional_bw=None,
		)
		self.blks2_rational_resampler_xxx_0 = blks2.rational_resampler_fff(
			interpolation=441,
			decimation=500,
			taps=None,
			fractional_bw=None,
		)
		self.band_pass_filter_0_1 = gr.fir_filter_fff(1, firdes.band_pass(
			1, samp_rate, 38e3-15000, 38e3+15000, 10000, firdes.WIN_HANN, 6.76))
		self.band_pass_filter_0_0 = gr.fir_filter_fff(1, firdes.band_pass(
			gain_38k, samp_rate, 38e3-1000, 38e3+1000, 5000, firdes.WIN_HANN, 6.76))
		self.band_pass_filter_0 = gr.fir_filter_fff(1, firdes.band_pass(
			1, samp_rate, 19e3-500, 19e3+500, 5000, firdes.WIN_HANN, 6.76))
		self.audio_sink_0 = audio.sink(44100, "", True)

		##################################################
		# Connections
		##################################################
		self.connect((self.gr_delay_0, 0), (self.gr_conjugate_cc_0, 0))
		self.connect((self.gr_multiply_xx_0, 0), (self.gr_complex_to_arg_0, 0))
		self.connect((self.low_pass_filter_0, 0), (self.gr_multiply_xx_0, 1))
		self.connect((self.low_pass_filter_0, 0), (self.gr_delay_0, 0))
		self.connect((self.gr_conjugate_cc_0, 0), (self.gr_multiply_xx_0, 0))
		self.connect((self.gr_complex_to_arg_0, 0), (self.band_pass_filter_0, 0))
		self.connect((self.gr_multiply_xx_1, 0), (self.band_pass_filter_0_0, 0))
		self.connect((self.band_pass_filter_0, 0), (self.gr_multiply_xx_1, 1))
		self.connect((self.band_pass_filter_0, 0), (self.gr_multiply_xx_1, 0))
		self.connect((self.gr_complex_to_arg_0, 0), (self.low_pass_filter_1, 0))
		self.connect((self.low_pass_filter_1, 0), (self.wxgui_fftsink2_0, 0))
		self.connect((self.gr_complex_to_arg_0, 0), (self.gr_iir_filter_ffd_1, 0))
		self.connect((self.gr_complex_to_arg_0, 0), (self.band_pass_filter_0_1, 0))
		self.connect((self.band_pass_filter_0_1, 0), (self.gr_multiply_xx_2, 0))
		self.connect((self.band_pass_filter_0_0, 0), (self.gr_multiply_xx_2, 1))
		self.connect((self.gr_multiply_xx_2, 0), (self.gr_iir_filter_ffd_1_0, 0))
		self.connect((self.gr_iir_filter_ffd_1_0, 0), (self.gr_multiply_const_vxx_2, 0))
		self.connect((self.gr_sub_xx_0, 0), (self.gr_multiply_const_vxx_0, 0))
		self.connect((self.gr_multiply_const_vxx_0, 0), (self.audio_sink_0, 1))
		self.connect((self.gr_multiply_const_vxx_1, 0), (self.audio_sink_0, 0))
		self.connect((self.gr_add_xx_0, 0), (self.gr_multiply_const_vxx_1, 0))
		self.connect((self.gr_multiply_const_vxx_1, 0), (self.wxgui_fftsink2_2, 0))
		self.connect((self.gr_multiply_const_vxx_0, 0), (self.wxgui_fftsink2_2_0, 0))
		self.connect((self.gr_multiply_const_vxx_1, 0), (self.wxgui_scopesink2_0, 0))
		self.connect((self.gr_multiply_const_vxx_0, 0), (self.wxgui_scopesink2_0_0, 0))
		self.connect((self.gr_multiply_const_vxx_2, 0), (self.low_pass_filter_2_1_0, 0))
		self.connect((self.low_pass_filter_2_1_0, 0), (self.blks2_rational_resampler_xxx_0, 0))
		self.connect((self.blks2_rational_resampler_xxx_0, 0), (self.gr_sub_xx_0, 1))
		self.connect((self.blks2_rational_resampler_xxx_0, 0), (self.gr_add_xx_0, 1))
		self.connect((self.low_pass_filter_2_1_0_0, 0), (self.blks2_rational_resampler_xxx_0_0, 0))
		self.connect((self.gr_iir_filter_ffd_1, 0), (self.low_pass_filter_2_1_0_0, 0))
		self.connect((self.blks2_rational_resampler_xxx_0_0, 0), (self.gr_sub_xx_0, 0))
		self.connect((self.blks2_rational_resampler_xxx_0_0, 0), (self.gr_add_xx_0, 0))
		self.connect((self.osmosdr_source_c_1, 0), (self.low_pass_filter_0, 0))
		self.connect((self.osmosdr_source_c_1, 0), (self.wxgui_fftsink2_1, 0))

	def get_vol_r(self):
		return self.vol_r

	def set_vol_r(self, vol_r):
		self.vol_r = vol_r
		self._vol_r_slider.set_value(self.vol_r)
		self._vol_r_text_box.set_value(self.vol_r)
		self.gr_multiply_const_vxx_0.set_k((self.vol_r/100*3, ))

	def get_vol_l(self):
		return self.vol_l

	def set_vol_l(self, vol_l):
		self.vol_l = vol_l
		self._vol_l_slider.set_value(self.vol_l)
		self._vol_l_text_box.set_value(self.vol_l)
		self.gr_multiply_const_vxx_1.set_k((self.vol_l/100*3, ))

	def get_tau(self):
		return self.tau

	def set_tau(self, tau):
		self.tau = tau
		self.gr_iir_filter_ffd_1_0.set_taps(((1.0/(1+self.tau*2*self.samp_rate), 1.0/(1+self.tau*2*self.samp_rate))), ((1, -(1-self.tau*2*self.samp_rate)/(1+self.tau*2*self.samp_rate))))
		self._tau_slider.set_value(self.tau)
		self._tau_text_box.set_value(self.tau)
		self.gr_iir_filter_ffd_1.set_taps(((1.0/(1+self.tau*2*self.samp_rate), 1.0/(1+self.tau*2*self.samp_rate))), ((1, -(1-self.tau*2*self.samp_rate)/(1+self.tau*2*self.samp_rate))))

	def get_stereo(self):
		return self.stereo

	def set_stereo(self, stereo):
		self.stereo = stereo
		self._stereo_check_box.set_value(self.stereo)
		self.gr_multiply_const_vxx_2.set_k((self.stereo, ))

	def get_samp_rate(self):
		return self.samp_rate

	def set_samp_rate(self, samp_rate):
		self.samp_rate = samp_rate
		self.gr_iir_filter_ffd_1_0.set_taps(((1.0/(1+self.tau*2*self.samp_rate), 1.0/(1+self.tau*2*self.samp_rate))), ((1, -(1-self.tau*2*self.samp_rate)/(1+self.tau*2*self.samp_rate))))
		self.band_pass_filter_0.set_taps(firdes.band_pass(1, self.samp_rate, 19e3-500, 19e3+500, 5000, firdes.WIN_HANN, 6.76))
		self.band_pass_filter_0_1.set_taps(firdes.band_pass(1, self.samp_rate, 38e3-15000, 38e3+15000, 10000, firdes.WIN_HANN, 6.76))
		self.band_pass_filter_0_0.set_taps(firdes.band_pass(self.gain_38k, self.samp_rate, 38e3-1000, 38e3+1000, 5000, firdes.WIN_HANN, 6.76))
		self.low_pass_filter_1.set_taps(firdes.low_pass(1, self.samp_rate, 60e3, 1000, firdes.WIN_HANN, 6.76))
		self.gr_iir_filter_ffd_1.set_taps(((1.0/(1+self.tau*2*self.samp_rate), 1.0/(1+self.tau*2*self.samp_rate))), ((1, -(1-self.tau*2*self.samp_rate)/(1+self.tau*2*self.samp_rate))))
		self.low_pass_filter_2_1_0.set_taps(firdes.low_pass(1, self.samp_rate, 15000, 1000, firdes.WIN_HANN, 6.76))
		self.low_pass_filter_2_1_0_0.set_taps(firdes.low_pass(1, self.samp_rate, 15000, 1000, firdes.WIN_HANN, 6.76))
		self._samp_rate_text_box.set_value(self.samp_rate)
		self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.b_signal, 10000, firdes.WIN_HANN, 6.76))
		self.osmosdr_source_c_1.set_sample_rate(self.samp_rate)
		self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate/6)
		self.wxgui_fftsink2_1.set_sample_rate(self.samp_rate)

	def get_rx_gain(self):
		return self.rx_gain

	def set_rx_gain(self, rx_gain):
		self.rx_gain = rx_gain
		self._rx_gain_slider.set_value(self.rx_gain)
		self._rx_gain_text_box.set_value(self.rx_gain)
		self.osmosdr_source_c_1.set_gain(self.rx_gain, 0)

	def get_gain_38k(self):
		return self.gain_38k

	def set_gain_38k(self, gain_38k):
		self.gain_38k = gain_38k
		self.band_pass_filter_0_0.set_taps(firdes.band_pass(self.gain_38k, self.samp_rate, 38e3-1000, 38e3+1000, 5000, firdes.WIN_HANN, 6.76))
		self._gain_38k_slider.set_value(self.gain_38k)
		self._gain_38k_text_box.set_value(self.gain_38k)

	def get_freq(self):
		return self.freq

	def set_freq(self, freq):
		self.freq = freq
		self._freq_slider.set_value(self.freq)
		self._freq_text_box.set_value(self.freq)
		self.osmosdr_source_c_1.set_center_freq(self.freq, 0)

	def get_decim(self):
		return self.decim

	def set_decim(self, decim):
		self.decim = decim

	def get_b_signal(self):
		return self.b_signal

	def set_b_signal(self, b_signal):
		self.b_signal = b_signal
		self._b_signal_slider.set_value(self.b_signal)
		self._b_signal_text_box.set_value(self.b_signal)
		self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.b_signal, 10000, firdes.WIN_HANN, 6.76))

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	tb = top_block()
	tb.Run(True)

