import os
import numpy as np
import cv2
import matlab.engine
import pandas as pd
from pathlib import Path
from skimage.metrics import peak_signal_noise_ratio, mean_squared_error
from multiprocessing import Pool

#Creating all the engines and dataframes MATLAB and Pandas respectively
eng = matlab.engine.start_matlab()
dict = {'Image':[], 'NoiseType':[], 'NoiseIntensity':[], 'PSNR_B':[], 'SNR_B':[], 'PSNR_A':[], 'SNR_A':[], 'RMSE':[]}
metrics = pd.DataFrame(dict)
noiseTypes = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar", "rayleigh", "gamma", "periodic", "rician", "quantization"]

def psnr(img1, img2, peakval = 255):
    mse = np.sum(np.square(img1-img2))/(img1.shape[0]*img1.shape[1])
    snr = 10*np.log10(np.sum(np.square(img1)/(img1.shape[0]*img1.shape[1])))
    psnr = 20*np.log10((peakval**2)/(np.sqrt(mse)))
    
    return (mse, snr, psnr)

def log(index, noiseType, intensity, original, noisy, denoised):
  '''
  This function logs the results in a .csv file.
  The skimage library is used to compute the MSE and PSNR
  '''
  psnr_b, snr_b, mse = psnr(original, noisy)
  psnr_a, snr_a, mse = psnr(original, denoised)
  metrics.loc[len(metrics.index)] = [index, noiseType, psnr_b, snr_b, psnr_a, snr_a, mse]

def findAllNeighbors(padImg,small_window,big_window,h,w):
    # Finding width of the neighbor window and padded image from the center pixel
    smallWidth = small_window//2
    bigWidth = big_window//2

    # Initializing the result
    neighbors = np.uint8(np.zeros((padImg.shape[0],padImg.shape[1],small_window,small_window)))

    # Finding the neighbors of each pixel in the original image using the padded image
    for i in range(bigWidth,bigWidth + h):
        for j in range(bigWidth,bigWidth + w):   
            neighbors[i,j] = padImg[(i - smallWidth):(i + smallWidth + 1) , (j - smallWidth):(j + smallWidth + 1)]
    
    return neighbors

def evaluateNorm(pixelWindow, neighborWindow, Nw):
    # Initialize numerator and denominator of Ip (Ip = Ip_Numerator/Z)
    Ip_Numerator,Z = 0,0

    # Calculating Ip for pixel p using neighborood pixels q
    for i in range(neighborWindow.shape[0]):
        for j in range(neighborWindow.shape[1]):
        # (small_window x small_window) array for pixel q
            q_window = neighborWindow[i,j]

            # Coordinates of pixel q
            q_x,q_y = (q_window.shape[0]//2),(q_window.shape[1]//2)

            # Iq value
            Iq = q_window[q_x, q_y]

            # Norm of Ip - Iq
            w = np.exp(-1*((np.sum((pixelWindow - q_window)**2))/Nw))

            # Calculating Ip
            Ip_Numerator = Ip_Numerator + (w*Iq)
            Z = Z + w

    return Ip_Numerator/Z

def NLM(padImg, img, h, small_window, big_window):
    # Calculating neighborhood window
    Nw = (h**2)*(small_window**2)

    # Getting dimensions of the image
    h,w = img.shape

    # Initializing the result
    result = np.zeros(img.shape)

    # Finding width of the neighbor window and padded image from the center pixel
    bigWidth = big_window//2
    smallWidth = small_window//2

    # Preprocessing the neighbors of each pixel
    neighbors = findAllNeighbors(padImg, small_window, big_window, h, w) 

    # NL Means algorithm
    for i in range(bigWidth, bigWidth + h):
        for j in range(bigWidth, bigWidth + w):
            # (small_window x small_window) array for pixel p
            pixelWindow = neighbors[i,j]

            # (big_window x big_window) pixel neighborhhod array for pixel p
            neighborWindow = neighbors[(i - bigWidth):(i + bigWidth + 1) , (j - bigWidth):(j + bigWidth + 1)]

            # Calculating Ip using pixelWindow and neighborWindow
            Ip = evaluateNorm(pixelWindow, neighborWindow, Nw)

            # Cliping the pixel values to stay between 0-255 
            result[i - bigWidth, j - bigWidth] = max(min(255, Ip), 0)

    return result


def main(index):
    
    h, bigWindow, smallWindow = 30, 21, 7
    num1, num2 = 1, 1
    image = 'img/{i}.jpg'.format(i=index)
    img = cv2.imread(image, 0)

    #Looping through different noises
    for noiseType in noiseTypes:
        
        #Looping through different densities
        for i in range(1, 10):
                
            density = i/10
                
            imgNoise = np.uint8(eng.Noise(img, noiseType, density))
            cv2.imwrite('output/imgNoise{a1}{a}{b}.jpg'.format(a1=index ,a=noiseType, b=num2), imgNoise)
            imgNoisePad = np.pad(imgNoise, bigWindow//2, 'reflect')
                
            imgDenoise = NLM(imgNoisePad, imgNoise, h, smallWindow, bigWindow)
            cv2.imwrite('output/imgDenoise{a1}{a}{b}.jpg'.format(a1=index ,a=noiseType, b=num2), imgDenoise)
                
            fileName = image.removeprefix('img/')
            fileName = fileName.removesuffix('.jpg')
            log(filename, noiseType, img, imgNoise, imgDenoise)
            num2 += 1
    

if __name__ == "__main__":
    pool = Pool(processes=os.cpu_count())
    pool.map(main, [1, 2, 3, 4, 5])
    metrics.to_csv('output/metrics.csv')
