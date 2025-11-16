from msilib import sequence
from types import NoneType
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from requests import head
import tensorflow as tf
from tensorflow import keras
from datetime import datetime, date 
import matplotlib.dates
from matplotlib import dates as mdates
from sklearn.model_selection import train_test_split

#Import Flask modules
from flask import Flask, request, render_template
from wtforms import SelectField
from dateutil import parser
from flask import Markup
from sklearn.preprocessing import MinMaxScaler


from keras.utils import Sequence, pad_sequences
from keras import preprocessing
import joblib


app3 = Flask(__name__, template_folder = 'template')

minmaxscaler = MinMaxScaler()
model_loaded_k0 = tf.keras.models.load_model("/Users/Dell/Desktop/kurs_data_science/DL/DL PROJEKT/app_clusters/modele_klastry/model_k0_new.h5")
model_loaded_k1 = tf.keras.models.load_model("/Users/Dell/Desktop/kurs_data_science/DL/DL PROJEKT/app_clusters/modele_klastry/model_k1.h5")
model_loaded_k2 = tf.keras.models.load_model("/Users/Dell/Desktop/kurs_data_science/DL/DL PROJEKT/app_clusters/modele_klastry/model_k2.h5")
scaler = joblib.load("scaler.save") 

@app3.route('/')
def home():
    return render_template("index.html")


@app3.route('/', methods=['GET', 'POST'])
def main():
    if request.method == "POST":
        
        Store = float(request.form.get("Store"))
        Weekly_sales = float(request.form.get("Weekly_Sales"))
        Holiday_Flag = float(request.form.get("Holiday_Flag"))
        Temperature = float(request.form.get("Temperature"))
        Fuel_price = float(request.form.get("Fuel_price"))
        CPIu = float(request.form.get("CPI"))
        Unemployment = float(request.form.get("Unemployment"))
        yyyy = float(request.form.get('yyyy'))               
        mm = float(request.form.get('mm'))
        ch = datetime.strptime(request.form.get("week_absolute"),'%Y-%m-%d')
        ch = ch.isocalendar()[1]
        week_absolute = float(ch)




        seqLen = 6
        featNum = 9
        X = np.array([
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute],
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute],
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute],
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute],
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute],
            [Weekly_sales, Holiday_Flag, Temperature, Fuel_price, CPIu, Unemployment, yyyy, mm, week_absolute]
            ])

        # test_np_input_sc = minmaxscaler.fit_transform(test_np_input)
        test_np_input_sc = scaler.transform(X.reshape(-1,1))

        # Get prediction
        list_store_1 = [3,5,7,9,15,16,21,25,29,30,33,36,37,38,42,43,44,45]
        list_store_2 = [2,4,10,13,14,20,27]
        list_store_3 = [8,11,12,17,18,19,22,23,24,26,28,31,32,34,39,40,41]

        Cluster_number  = []

        if Store in list_store_1:
            prediction = model_loaded_k0.predict(test_np_input_sc.reshape(-1,seqLen,featNum))[0][0]
            preds_float = (float(prediction)*100000000)
            Cluster_number = '1'
        elif Store in list_store_2:
            prediction = model_loaded_k1.predict(test_np_input_sc.reshape(-1,seqLen,featNum))[0][0]
            preds_float = (float(prediction)*100000000)
            Cluster_number = '2'
        else:
            prediction = model_loaded_k2.predict(test_np_input_sc.reshape(-1,seqLen,featNum))[0][0]
            preds_float = (float(prediction)*100000000)            
            Cluster_number = '3'

  
        if prediction < 0:
            return render_template("index.html", prediction_text = "Predicted Sale is negative, entered values not reasonable")
        elif prediction > 0:
            return render_template("index.html", prediction_text = 'Week number: {}, Cluster number: {} Predicted Sale: {:,} $'.format(round(week_absolute), Cluster_number, round(preds_float,2)))  
    else:
        prediction = "Something is wrong, check your input variables please"
        

if __name__ == "__main__":
    app3.run(debug=True)



 


