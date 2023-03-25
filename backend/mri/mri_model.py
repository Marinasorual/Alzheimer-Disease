import tensorflow as tf 
import matplotlib.pyplot as plt 
import numpy as np 
import os 
import pathlib 
import random
from flask import Flask
from tensorflow.keras.utils import image_dataset_from_directory
from tensorflow.keras import layers

class MRI_Model:
    def __init__(self):
        self.batch_size = 32
        self.img_height = 224
        self.img_width = 224
        self.epochs = 10
        print("Create object")
        return
    def read_training_data(self, path):
        self.data_dir = pathlib.Path(path) 
        self.class_names = np.array([sorted(item.name for item in self.data_dir.glob("*"))])
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
                                            image_size=(self.img_height,self.img_width),
                                            batch_size=self.batch_size)

        plt.figure(figsize=(20, 20))
        result = ' | True'
        imageCount = len(list(self.data_dir.glob("*/*.jpg") ))
        #number_of_images = len(np.concatenate([i for x, i in value_data], axis=0))
        for images, labels in value_data.take(1):
            for i in range(imageCount):
                ax = plt.subplot(5, 5, i + 1)
                img = images[i].numpy().astype("uint8")
                img = tf.expand_dims(img, axis=0)
                
                predictions = self.model.predict(img)
                predicted_class = np.argmax(predictions)
                if self.class_names[predicted_class] == self.class_names[labels[i]]:
                    result = ' | True'
                    
                plt.imshow(images[i].numpy().astype("uint8"))
                plt.title(self.class_names[predicted_class]+result  )
                plt.axis("off")
    
model = MRI_Model()
model.read_training_data('F:/dataset/')
model.plot_random_sample() 
model.prepare_training_data()
model.build_model()
model.compile_model()
model.fit_model()
model.plot_result()




