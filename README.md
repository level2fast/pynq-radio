# **PYNQ Radio**  

![GitHub License](https://img.shields.io/github/license/level2fast/pynq-radio)<br/>
![GitHub contributors](https://img.shields.io/github/contributors/level2fast/pynq-radio) <br/>
![GitHub top language](https://img.shields.io/github/languages/top/level2fast/pynq-radio)<br/>
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/level2fast/pynq-radio) <br/>
![GitHub repo size](https://img.shields.io/github/repo-size/level2fast/pynq-radio)<br/>

## **📝 Project Description**  
This is an Embedded application that captures data from the FM Radio band, peforms FM demodulation on the data, and then plays the sound that was captured through the computer speaker. It uses an RTL-SDR antenna to capture raw I/Q data packets from within the FM Radio band over the air, process the raw data, send the data from the SDR PYNQZ2 board to a client PC, and play back the data. This project was completed using Matlab for signal processing and Python on Linux for interfacing with SDR via the PYNQ SoC. It features post processing of I/Q data from the FM band and TCP/UDP connections for transfer of the data.

---

## **🚀 Live Demo**  
[🔗 Click here to check out the presentation](https://docs.google.com/presentation/d/1Q8TwXOrxCwCUX_YepU07EQpat8sSHyaK/edit#slide=id.p1)

[🔗 Click here to check out the live version PT 1.](https://www.youtube.com/shorts/UVJiyPaBJYA)

[🔗 Click here to check out the live version PT 2.](https://youtube.com/shorts/CCUJMggXQGc?feature=share)

---

## **🛠️ Features**  
✅ Feature 1 – *Realt Time Data Capture using RTL-SDR*  
✅ Feature 2 – *UDP streaming to host PC*  
✅ Feature 3 – *Audio Playback of data capture*  

---

## **📦 Tech Stack**  
- **Languages:** bash, python, MATLAB
- **Hardware:** RTL-SDR, PYNQZ2
- **Tools & CI/CD:** Git  

---

## **📥 Installation & Setup**  
Clone the repository and run demo:  

```cmd
git clone https://github.com/your-username/your-repo.git
cd your-repo
matlab -nosplash -nodesktop -r Final.m
```
