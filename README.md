# Classifier Image Viewer

This is a custom made output module for Wekinator (www.wekinator.org). It reads a folder of images ("img"). It has two states: one of text, and other that exhibits the images in a fast sequence.

In order to control these states, set Wekinator to send its output on port 12000 (Wekinator's default) for OSC messages ("/wek/outputs"). Use only one classifier output, with two classes.
Class 1 sets the module to text mode.
Class 2 sets the module to image sequence mode.

Put any jpg or png images inside "img" folder.
