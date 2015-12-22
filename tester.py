from os import path

from PraatPlugin.analyze_wave import VoiceAnalyzer

v = VoiceAnalyzer()
l = v.analyze_wave_file(path.abspath('voice_samples\sample2.wav'), 'C:\Users\Maxim\PycharmProjects\VoiceLearning')

print l


