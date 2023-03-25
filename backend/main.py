import numpy as np  # linear algebra
import pandas as pd  # data processing, CSV file I/O (e.g. pd.read_csv)
import matplotlib.pyplot as plt
import seaborn as sn
from sklearn import metrics
from sklearn.cluster import KMeans
from sklearn import preprocessing
from sklearn.metrics import silhouette_score
from sklearn.decomposition import PCA
import tensorflow as tf 
import matplotlib.pyplot as plt 
import os 
import pathlib 
import random
from flask import Flask
from tensorflow.keras.utils import image_dataset_from_directory
from tensorflow.keras import layers
from flask import Flask
from PIL import Image
from PIL import Image
class genes_model:
    def __init__(self):
        self.kmeans = None
        self.min_samples = None
        self.clus = None
        self.correlation = None
        self.df1 = None
        self.df2 = None
        self.df3 = None
        self.ann = None
        self.df = None
        self.collist = None
        self.pred = None

    def run_model(self):
        self.read_data()
        self.df2 = self.df2[1:-1]
        # self.prepare_model()
        self.kmeans = KMeans(algorithm='auto', n_clusters=2, init='k-means++', n_init=10, max_iter=150, tol=0.0001,
                             random_state=42).fit(self.df2)
        #print('kmeans score: {}'.format(silhouette_score(self.df2, self.kmeans.labels_, metric='euclidean')))
        # print(self.kmeans.fit_predict(pd.DataFrame([319.871200, 654.391660, 319.871400, 319.871500, 319.871450])))
        # self.plot_clusters()
        self.predict()
        self.pca_model()
        self.save_result()

    def read_data(self):
        self.collist = ['ID_REF', 'GSM701542', 'GSM701543', 'GSM701544', 'GSM701545', 'mutation', 'log 2 fold change']
        self.df = pd.read_csv("F:\\flutter\\alzheimer\\backend\\genes_dataset\\GSE28379 - GSE28379_series_matrix.csv",
                              usecols=self.collist)
        self.ann = pd.read_csv("F:\\flutter\\alzheimer\\backend\\genes_dataset\\gene.csv", usecols=['ID', 'Gene.symbol'])
        self.df3 = self.ann.merge(self.df, how='inner', left_on='ID', right_on='ID_REF')
        self.df2 = self.df[['GSM701542', 'GSM701543', 'GSM701544', 'GSM701545', 'mutation']]
        self.df1 = self.df2

    def test_gene_from_front(self, gene1, gene2, gene3, gene4, mutation):
        print(gene1, gene2, gene3, gene4, mutation)
        received = pd.DataFrame([gene1, gene2, gene3, gene4, mutation])
        print(received)
        result = self.kmeans.fit_predict(received)
        print(result)
        # result = pd.DataFrame(result)
        return f'{result}'

    def plot_correlation(self):
        """
            The correlation between different feature help to make the relationship
            among gene expression and mutation of different samples
        """
        self.correlation = self.df2.corr()
        plt.figure()
        sn.heatmap(self.correlation, vmax=1, square=True, annot=True, cmap='viridis')
        plt.title('Correlation between different fearures')
        sn.pairplot(self.df2, kind='reg', diag_kind='kde', height=4)

    def prepare_model(self):
        self.clus = []
        self.pred = []
        for i in range(1, 11):
            self.kmeans = KMeans(algorithm='auto', n_clusters=i, init='k-means++', n_init=i, max_iter=150, tol=0.0001,
                                 random_state=42).fit(self.df2)  # , verbose=0
            self.clus.append(self.kmeans.inertia_)
        self.min_samples = self.df2.shape[1] + 1
        # print('kmeans score: {}'.format(silhouette_score(self.df2, self.kmeans.labels_, metric='euclidean')))
        self.pred = [self.kmeans.labels_]
        print(self.pred)
        # print("Minimum number of samples=", self.min_samples)

    def plot_clusters(self):
        p1 = range(1, 11)
        import matplotlib.pyplot as plt2
        plt2.plot(p1, self.clus)
        plt2.xlabel('Number of clusters')
        plt2.title('The Elbow Method Graph')
        plt2.ylabel('clus')
        # plt2.show()
        plt2.savefig('../assets/images/clusters.jpg')
        plt2.close()

    def predict(self):
        # self.kmeans = KMeans(n_clusters=3, init='k-means++', n_init=10, max_iter=50, tol=0.0001,
        #                      random_state=42)
        y_kmeans = self.kmeans.fit_predict(self.df2)
        self.pred = pd.DataFrame(y_kmeans)
        self.df3['predicted'] = self.pred
        self.df3['predicted'].unique()
        self.df3 = self.df3.dropna(axis=0)

    def prep_pca(self, components, data, kmeans_labels):
        names = ['x', 'y', 'z']
        matrix = PCA(n_components=components).fit_transform(data)
        df_matrix = pd.DataFrame(matrix)
        df_matrix.rename({i: names[i] for i in range(components)}, axis=1, inplace=True)
        df_matrix['labels'] = kmeans_labels
        return df_matrix

    def pca_model(self):
        pca_df = self.prep_pca(2, self.df2, self.kmeans.labels_)
        sn.scatterplot(x=pca_df.x, y=pca_df.y, hue=pca_df.labels, palette="Set1")
        import matplotlib.pyplot as plt4
        plt4.scatter(self.kmeans.cluster_centers_[:, 0], self.kmeans.cluster_centers_[:, 1], s=50, c='k')
        # plt4.show()
        plt4.savefig('../assets/images/samples.jpg')
        import matplotlib.pyplot as plt5
        fig = plt5.figure(figsize=(10, 10))
        ax = fig.add_subplot(111, projection='3d')
        ax.scatter(pca_df.x, pca_df.y, pca_df.labels, s=20, c='b')
        str_labels = list(map(lambda label: '% s' % label, self.kmeans.labels_))
        list(map(lambda data1, data2, data3, str_label:
                 ax.text(data1, data2, data3, s=str_label, size=16,
                         zorder=10, color='k'), pca_df.x, pca_df.y,
                 pca_df.labels, str_labels))
        # plt2.show()
        plt5.savefig('../assets/images/data.jpg')

    def save_result(self):
        result = self.df3[['ID', 'predicted', 'Gene.symbol']]
        result.to_csv('output.csv', index=False)

class mri_model:
    def __init__(self):
        self.batch_size = 32
        self.img_height = 224
        self.img_width = 224
        self.epochs = 1
        print("Create object")
        return
    
    def run_model(self):
        self.read_training_data('F:/Alzheimer_s Dataset/train/')
        self.plot_random_sample() 
        self.prepare_training_data()
        self.build_model()
        self.compile_model()
        self.fit_model()
        self.plot_result()
    
    def read_training_data(self, path):
        self.data_dir = pathlib.Path(path) 
        self.class_names = np.array([sorted(item.name for item in self.data_dir.glob("*"))])
        print(self.class_names)
        imageCount = len(list(self.data_dir.glob("*/*.jpg") ))
        print(f'number of images: {imageCount}')
        return
    
    def plot(self, path,class_name):
        print(path)
        plt.figure(figsize=(8,8))
        
        img = plt.imread(path)
        
        plt.xticks([])
        plt.yticks([])
        plt.title("Class Name: "+class_name)
        plt.imshow(img)
        
    def plot_random_sample(self):
        Mild_Demented = random.choice(list(self.data_dir.glob("MildDemented/*.jpg")))

        self.plot(str(Mild_Demented),"MildDemented")

        Moderate_Demented = random.choice(list(self.data_dir.glob("ModerateDemented/*.jpg")))

        self.plot(str(Moderate_Demented),"Moderate_Demented")

        Non_Demented = random.choice(list(self.data_dir.glob("NonDemented/*.jpg")))

        self.plot(str(Non_Demented),"Non_Demented")

        Very_Mild_Demented = random.choice(list(self.data_dir.glob("VeryMildDemented/*.jpg")))

        self.plot(str(Very_Mild_Demented),"Very_Mild_Demented")
        return
    def prepare_training_data(self):
        self.train_data = image_dataset_from_directory(
                          self.data_dir,
                          validation_split=0.2,
                          subset="training",
                          seed=123,
                          image_size=(self.img_height, self.img_width),
                          batch_size=self.batch_size)
        self.val_data = image_dataset_from_directory(self.data_dir,
                                                validation_split=0.2,
                                                subset="validation",
                                                seed=123,
                                                image_size=(self.img_height, self.img_width),
                                                batch_size=self.batch_size)
        return
    
    def build_model(self):
        self.model = tf.keras.Sequential([
            
           layers.Rescaling(1./255, input_shape=(self.img_height, self.img_width, 3)),
            
          layers.Conv2D(16, 3, padding='same', activation='relu'),
          layers.MaxPooling2D(),
            
          layers.Conv2D(32, 3, padding='same', activation='relu'),
          layers.MaxPooling2D(),
            
          layers.Conv2D(64, 3, padding='same', activation='relu'),
          layers.MaxPooling2D(),
            
          layers.Dropout(0.5),
          layers.Flatten(),
            
          layers.Dense(128, activation='relu'),
          layers.Dense(4,activation="softmax")
        ])
        return
    
    def compile_model(self):
        #Compile the model
        self.model.compile(optimizer="Adam",
                    loss=tf.keras.losses.SparseCategoricalCrossentropy(),
                    metrics=["accuracy"])
        #Fit the model
    def fit_model(self):      
        self.history = self.model.fit(self.train_data,
                            epochs=self.epochs,
                            validation_data=self.val_data, 
                            batch_size=self.batch_size)
    def plot_result(self):
        # Plot the result
        acc = self.history.history['accuracy']
        val_acc =  self.history.history['val_accuracy']

        loss = self.history.history['loss']
        val_loss = self.history.history['val_loss']

        epochs_range = range(self.epochs)

        plt.figure(figsize=(8,8))
        plt.subplot(1,2,1)
        plt.plot(epochs_range,acc,label='Accuracy')
        plt.plot(epochs_range,val_acc,label="Validation Accuracy")
        plt.legend()

        plt.subplot(1,2,2)
        plt.plot(epochs_range,loss,label='Loss')
        plt.plot(epochs_range,val_loss,label="Validation Loss")
        plt.legend()
        plt.show()
        return
    def predict(self, path):
        data_dir = pathlib.Path(path)
        value_data = image_dataset_from_directory(data_dir,
                                            validation_split=0.2,
                                            subset="validation",
                                            seed=123,
                                            image_size=(224,224),
                                            batch_size=32)
        

        #plt.figure(figsize=(20, 20))
        result = ' | True'
        #imageCount = len(list(data_dir.glob(".jpg") ))
        #number_of_images = len(np.concatenate([i for x, i in value_data], axis=0))
        for images, labels in value_data.take(1):
            for i in range(1):
                ax = plt.subplot(5, 5, i + 1)
                img = images[i].numpy().astype("uint8")
                img = tf.expand_dims(img, axis=0)
                
                predictions = mri.model.predict(img)
                predicted_class = np.argmax(predictions)
                if mri.class_names[0][predicted_class] == mri.class_names[0][labels[i]]:
                    result = ' | True'
                print(type(images[i]))
                im = Image.fromarray(images[i].numpy().astype("uint8"))
                im.save("test.png")
                #plt.imshow(images[i].numpy().astype("uint8"))
                #plt.title(value_data.class_names[predicted_class]+result  )
                #plt.axis("off")
        return mri.class_names[0][predicted_class]
                
                
g_model = genes_model()            
g_model.run_model()
mri = mri_model()
mri.run_model()

app = Flask(__name__)
@app.route("/genes/test/<g1>/<g2>/<g3>/<g4>/<mu>", methods=['POST', 'GET'])
def genes_test(g1, g2, g3, g4, mu):
    res = g_model.test_gene_from_front(float(g1), float(g2), float(g3), float(g4), float(mu))
    return {"response": res}

@app.route("/choose", methods=['POST'])
def choose_image():
    path = str(request.form.get('path'))

    res = mri.predict(path) 
    return {
            "res": res,
            "data": data["MildDemented"],
            "recomendations": recomendations["MildDemented"]
            } 
app.run(debug=False)


from flask import Flask, request, jsonify
app = Flask(__name__)
@app.route('/example', methods=['POST'])
def example():
    # retrieve parameters from request
    param1 = str(request.form.get('param1'))
    param2 = str(request.form.get('param2'))

    # add code to process parameters
    result = param1 + param2

    # return response as JSON object
    response = {'result': result}
    return jsonify(response)
app.run(debug=False)

mri.predict('F:/test/') 
data = {
        "MildDemented": 
            [
                "Mild cognitive impairment (MCI) is a condition characterized by a slight but noticeable decline in cognitive abilities, such as memory and thinking skills. MCI can be a precursor to dementia, including Alzheimer's disease, but not everyone with MCI will develop dementia.",
                "When a patient is diagnosed with MCI, it is important to monitor their symptoms and cognitive abilities over time. Early intervention and management of underlying conditions that may be contributing to cognitive decline, such as hypertension or depression, may help slow the progression of cognitive decline and delay the onset of dementia.",
                "Additionally, there are several lifestyle modifications that may help improve cognitive function and overall health in individuals with MCI. These may include engaging in regular exercise, maintaining a healthy diet, staying socially active, and engaging in mentally stimulating activities, such as reading or playing games.",
                "In some cases, medications such as cholinesterase inhibitors or memantine may be prescribed to help manage symptoms of MCI or delay the onset of dementia.",
                "It is important for individuals with MCI to work closely with their healthcare provider to develop a personalized treatment plan that takes into account their unique needs and goals. With proper management and care, many individuals with MCI are able to maintain their cognitive function and quality of life for years to come."
            ],
        "VeryMildDemented":
            [
                "Very mild dementia is a term used to describe individuals who are experiencing early stages of cognitive decline, which may be indicative of Alzheimer's disease or another form of dementia. At this stage, individuals may experience mild memory loss, difficulty with problem-solving or decision-making, and changes in mood or behavior.",
                "It is important for individuals with very mild dementia to receive a comprehensive medical evaluation, including cognitive testing and brain imaging, to determine the underlying cause of their symptoms and rule out other potential causes of cognitive impairment.",
                "While there is currently no cure for dementia, there are several medications and non-pharmacological interventions that may help manage symptoms and slow the progression of the disease. For example, cholinesterase inhibitors, which work by increasing levels of acetylcholine in the brain, may help improve memory and cognitive function in some individuals with very mild dementia.",
                "In addition to medications, non-pharmacological interventions such as cognitive training, physical exercise, and social engagement may also be beneficial in managing symptoms and improving quality of life for individuals with very mild dementia.",
                "It is important for individuals with very mild dementia to work closely with their healthcare provider to develop a personalized treatment plan that takes into account their unique needs and goals. With proper management and care, many individuals with very mild dementia are able to maintain their cognitive function and quality of life for an extended period."
            ],
        "ModerateDemented": 
            [
                "Moderate dementia is a term used to describe individuals who are experiencing a more advanced stage of cognitive decline, typically as a result of Alzheimer's disease or another form of dementia. At this stage, individuals may experience significant memory loss, difficulty with communication, changes in mood or behavior, and challenges with daily activities such as dressing, bathing, and eating.",
                "It is important for individuals with moderate dementia to receive a comprehensive medical evaluation and ongoing care from a healthcare provider experienced in managing dementia. Treatment options for moderate dementia may include medications to manage symptoms such as agitation or depression, as well as non-pharmacological interventions such as occupational therapy to assist with activities of daily living and improve quality of life.",
                "In addition, caregivers and family members of individuals with moderate dementia may benefit from support and education on how to manage the challenges associated with caring for someone with dementia. This may include resources such as respite care, support groups, and counseling.",
                "While there is currently no cure for dementia, proper management and care can help improve quality of life for individuals with moderate dementia and their caregivers. Ongoing monitoring and assessment of symptoms, as well as regular adjustments to treatment plans as needed, can help individuals with moderate dementia maintain their cognitive function and quality of life for as long as possible."
            ],
        "NonDemented":
            [
                "When a patient is diagnosed as non-demented, it means that they are currently not experiencing any significant cognitive impairment or decline. This is a positive diagnosis, indicating that the individual's cognitive abilities are within a normal range for their age and other factors.",
                "While a diagnosis of non-demented does not necessarily mean that an individual is free from all cognitive or neurological conditions, it does indicate that they are currently not experiencing significant symptoms of dementia or other cognitive impairments.",
                "To maintain optimal cognitive health and reduce the risk of future cognitive decline, individuals who are non-demented can take several steps. These may include engaging in regular physical exercise, maintaining a healthy diet, staying socially engaged, and engaging in mentally stimulating activities such as reading, solving puzzles, or learning a new skill.",
                "In addition, it is important to manage any underlying health conditions that may contribute to cognitive decline, such as hypertension, high cholesterol, or diabetes. Regular medical check-ups and screenings can help detect these conditions early and allow for prompt treatment.0",
                "Overall, a diagnosis of non-demented is a positive outcome, indicating that an individual's cognitive health is within normal limits. However, it is still important to maintain a healthy lifestyle and manage any underlying health conditions to promote optimal cognitive health and reduce the risk of future cognitive decline."
            ]
        }



recomendations = {
        "MildDemented": 
            [
                "Maintain cognitive function: Individuals with mild dementia can benefit from engaging in mentally stimulating activities such as reading, writing, or playing games that challenge the brain. This can help maintain cognitive function and delay further decline.",
                "Exercise regularly: Regular exercise can help improve mood, cognitive function, and overall health for individuals with mild dementia. This may include activities such as walking, swimming, or gentle yoga.",
                "Manage other health conditions: Individuals with mild dementia may have other health conditions that can contribute to cognitive decline, such as hypertension, high cholesterol, or diabetes. It is important to manage these conditions through regular medical check-ups and appropriate treatment.",
                "Stay socially engaged: Social engagement can help improve mood and cognitive function for individuals with mild dementia. This may include participating in social activities, attending community events, or spending time with friends and family.",
                "Use memory aids: Memory aids such as calendars, reminder notes, and pill organizers can help individuals with mild dementia remember important information and stay on track with their daily routines.",
                "Simplify the environment: Individuals with mild dementia may benefit from a simplified living environment that is free from clutter and distractions. This can help reduce confusion and anxiety and make it easier for them to navigate their surroundings.",
                "Seek support from healthcare professionals: Individuals with mild dementia and their caregivers may benefit from ongoing support and care from healthcare professionals experienced in managing dementia. This may include regular check-ups, medication management, and counseling or support groups.",
            ],
        "VeryMildDemented": 
            [
                "Maintain cognitive function: Engaging in mentally stimulating activities such as reading, writing, or playing games that challenge the brain can help maintain cognitive function and delay further decline.",
                "Stay physically active: Regular exercise can help improve mood, cognitive function, and overall health for individuals with very mild dementia. This may include activities such as walking, swimming, or gentle yoga.",
                "Practice good sleep hygiene: Getting enough restful sleep is important for maintaining cognitive function. Practicing good sleep hygiene, such as going to bed and waking up at the same time each day and avoiding stimulating activities before bedtime, can help improve sleep quality.",
                "Stay socially engaged: Social engagement can help improve mood and cognitive function for individuals with very mild dementia. This may include participating in social activities, attending community events, or spending time with friends and family.",
                "Use memory aids: Memory aids such as calendars, reminder notes, and pill organizers can help individuals with very mild dementia remember important information and stay on track with their daily routines.",
                "Seek support from healthcare professionals: Individuals with very mild dementia and their caregivers may benefit from ongoing support and care from healthcare professionals experienced in managing dementia. This may include regular check-ups, medication management, and counseling or support groups.",
                "Plan for the future: Individuals with very mild dementia and their caregivers should consider planning for the future, such as discussing advance care planning and legal arrangements. This can help ensure that the individual's wishes are respected and that appropriate care is provided in the event of further cognitive decline."
            ],
        "ModerateDemented": 
            [
                 "Create a structured routine: Establishing a daily routine can help provide structure and stability for individuals with moderate dementia. This may include regular mealtimes, bedtime routines, and daily activities that are familiar and enjoyable.",
                 "Simplify the environment: Individuals with moderate dementia may benefit from a simplified living environment that is free from clutter and distractions. This can help reduce confusion and anxiety and make it easier for them to navigate their surroundings.",
                 "Provide assistance with daily tasks: Individuals with moderate dementia may require assistance with daily tasks such as dressing, bathing, and eating. Caregivers should provide assistance in a compassionate and patient manner, allowing the individual to maintain as much independence as possible.",
                 "Use memory aids: Memory aids such as calendars, reminder notes, and pill organizers can help individuals with moderate dementia remember important information and stay on track with their daily routines.",
                 "Stay socially engaged: Social engagement can help improve mood and cognitive function for individuals with moderate dementia. This may include activities such as attending social events, participating in group activities, or spending time with friends and family.",
                 "Consider occupational therapy: Occupational therapy can help individuals with moderate dementia maintain their independence and improve their ability to perform daily tasks. An occupational therapist can provide personalized recommendations and support to help the individual maintain their cognitive function and quality of life.",
                 "Seek support from healthcare professionals: Individuals with moderate dementia and their caregivers may benefit from ongoing support and care from healthcare professionals experienced in managing dementia. This may include regular check-ups, medication management, and counseling or support groups."
            ],
        "NonDemented": 
            [
                "Engage in mentally stimulating activities: Engaging in mentally stimulating activities such as reading, puzzles, learning a new skill or language, or playing games can help maintain cognitive function and improve brain health.",
                "Eat a healthy diet: Eating a diet that is rich in fruits, vegetables, lean protein, and healthy fats can help promote brain health and cognitive function.",
                "Exercise regularly: Regular exercise can help improve mood, cognitive function, and overall health. This may include activities such as walking, running, biking, or swimming.",
                "Manage stress: Chronic stress can negatively impact brain health and cognitive function. Practicing stress-reduction techniques such as mindfulness, meditation, or yoga can help promote relaxation and reduce stress.",
                "Get enough restful sleep: Getting enough restful sleep is important for maintaining cognitive function. Practicing good sleep hygiene, such as going to bed and waking up at the same time each day and avoiding stimulating activities before bedtime, can help improve sleep quality.",
                "Stay socially engaged: Social engagement can help improve mood and cognitive function. This may include participating in social activities, attending community events, or spending time with friends and family.",
                "Manage other health conditions: Managing other health conditions such as hypertension, high cholesterol, or diabetes can help promote brain health and cognitive function."
            ]
            
        
        }














def predict( path):
    data_dir = pathlib.Path(path)
    value_data = image_dataset_from_directory(data_dir,
                                        validation_split=0.2,
                                        subset="validation",
                                        seed=123,
                                        image_size=(224,224),
                                        batch_size=32)
    

    #plt.figure(figsize=(20, 20))
    result = ' | True'
    #imageCount = len(list(data_dir.glob(".jpg") ))
    #number_of_images = len(np.concatenate([i for x, i in value_data], axis=0))
    for images, labels in value_data.take(1):
        for i in range(1):
            ax = plt.subplot(5, 5, i + 1)
            img = images[i].numpy().astype("uint8")
            img = tf.expand_dims(img, axis=0)
            
            predictions = mri.model.predict(img)
            predicted_class = np.argmax(predictions)
            if mri.class_names[0][predicted_class] == mri.class_names[0][labels[i]]:
                result = ' | True'
            print(type(images[i]))
            im = Image.fromarray(images[i].numpy().astype("uint8"))
            im.save("test.png")
            #plt.imshow(images[i].numpy().astype("uint8"))
            #plt.title(value_data.class_names[predicted_class]+result  )
            #plt.axis("off")
    return mri.class_names[0][predicted_class]
predict('F:/test/')




import threading
import time

def thread_function1():
    print("Thread 1 started")
    time.sleep(5)
    print("Resuming program after 5 seconds")
    # add code to be executed in thread 1

def thread_function2():
    print("Thread 2 started")

thread1 = threading.Thread(target=thread_function1)
thread2 = threading.Thread(target=thread_function2)

# start both threads
thread1.start()
thread2.start()









