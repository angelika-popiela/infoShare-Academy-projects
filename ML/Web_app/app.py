from flask import Flask, render_template, request
import pickle
from sklearn.preprocessing import StandardScaler

app = Flask(__name__)
model = pickle.load(open('1_model_pickled_pisanki.pkl','rb'))

@app.route('/', methods=['GET'])
def Home():
    return render_template('index.html')

stdscale = StandardScaler()
@app.route("/predict", methods=['POST', 'GET'])

def predict():
    if request.method == 'POST':
        global age, anaemia, creatinine_phosphokinase, diabetes, ejection_fraction, high_blood_pressure, platelets, serum_creatinine, serum_sodium, sex, smoking
        age = int(request.form['age'])
        anaemia = int(request.form['anaemia'])
        creatinine_phosphokinase = int(request.form['creatinine_phosphokinase'])
        diabetes = int(request.form['diabetes'])
        ejection_fraction = int(request.form['ejection_fraction'])
        high_blood_pressure = int(request.form['high_blood_pressure'])
        platelets = int(request.form['platelets'])
        serum_creatinine = float(request.form['serum_creatinine'])
        serum_sodium = int(request.form['serum_sodium'])
        sex = int(request.form['sex'])
        smoking = int(request.form['smoking'])
        
        lst1 = [[age, anaemia, creatinine_phosphokinase, diabetes, ejection_fraction, high_blood_pressure, platelets, serum_creatinine, serum_sodium, sex, smoking]]
        lst2 = stdscale.fit_transform(lst1)
        prediction = model.predict(lst1)
        prediction = int(prediction)
        
        if prediction == 1:
            return render_template('index.html', 
                                    prediction_text=f'type {prediction}. Bad news sir; chances of getting heart failure is high, I\'d advise to take good care of yourself!', 
                                    entrance_for_user='prediction is valid for the following data:',
                                    first = f'age: {age},',
                                    second = f'anaemia: {anaemia} (1/0 = yes/no),',
                                    third = f'creatinine_phosphokinase: {creatinine_phosphokinase},',
                                    fourth = f'diabetes: {diabetes} (1/0 = yes/no),',
                                    fifth = f'ejection_fraction: {ejection_fraction},',
                                    sixth = f'high_blood_pressure: {high_blood_pressure} (1/0 = yes/no),',
                                    seventh = f'platelets: {platelets},',
                                    eighth = f'serum_creatinine: {serum_creatinine},',
                                    ninth = f'serum_sodium: {serum_sodium},',
                                    tenth = f'sex: {sex} (1/0 = male/fem),',
                                    eleventh = f'smoking: {smoking} (1/0 = yes/no)'
                                    )

        elif prediction == 0:
            return render_template('index.html', 
                                    prediction_text=f'type {prediction}. Such person will survive for some time, nothing to worry', 
                                    entrance_for_user='prediction is valid for the following data:',
                                    first = f'age: {age},',
                                    second = f'anaemia: {anaemia} (1/0 = yes/no),',
                                    third = f'creatinine_phosphokinase: {creatinine_phosphokinase},',
                                    fourth = f'diabetes: {diabetes} (1/0 = yes/no),',
                                    fifth = f'ejection_fraction: {ejection_fraction},',
                                    sixth = f'high_blood_pressure: {high_blood_pressure} (1/0 = yes/no),',
                                    seventh = f'platelets: {platelets},',
                                    eighth = f'serum_creatinine: {serum_creatinine},',
                                    ninth = f'serum_sodium: {serum_sodium},',
                                    tenth = f'sex: {sex} (1/0 = male/fem),',
                                    eleventh = f'smoking: {smoking} (1/0 = yes/no)'
                                    )
        else:
            return render_template('index.html', prediction_text='smthg is wrong with the model read')

    else:
        return render_template('index.html')

if __name__=="__main__":
    app.run(debug=True)