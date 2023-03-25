import numpy as np  # linear algebra
import pandas as pd  # data processing, CSV file I/O (e.g. pd.read_csv)
import matplotlib.pyplot as plt
import seaborn as sn
from sklearn import metrics
from sklearn.cluster import KMeans
from sklearn import preprocessing
from sklearn.metrics import silhouette_score
from sklearn.decomposition import PCA


class Model:
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
        self.kmeans = KMeans(algorithm='lloyd', n_clusters=2, init='k-means++', n_init=10, max_iter=150, tol=0.0001,
                             random_state=42).fit(self.df2)
        print('kmeans score: {}'.format(silhouette_score(self.df2, self.kmeans.labels_, metric='euclidean')))
        # print(self.kmeans.fit_predict(pd.DataFrame([319.871200, 654.391660, 319.871400, 319.871500, 319.871450])))
        # self.plot_clusters()
        self.predict()
        self.pca_model()
        self.save_result()

    def read_data(self):
        self.collist = ['ID_REF', 'GSM701542', 'GSM701543', 'GSM701544', 'GSM701545', 'mutation', 'log 2 fold change']
        self.df = pd.read_csv("F:\\flutter\\alzheimer\\backend\model\GSE28379 - GSE28379_series_matrix.csv",
                              usecols=self.collist)
        self.ann = pd.read_csv("F:\\flutter\\alzheimer\\backend\model\gene.csv", usecols=['ID', 'Gene.symbol'])
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
            self.kmeans = KMeans(algorithm='lloyd', n_clusters=i, init='k-means++', n_init=i, max_iter=150, tol=0.0001,
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


import xlwt
from xlwt import Workbook

# Workbook is created
# print(len(df2) - df2.count())
#
# # %% [code]
# # To make assure about the null or missing values and to proceed with kmeans clustering
#
# # Prepare models


#
# # %% [code] {"id":"OFcP_1EMm1bM","outputId":"1974ba16-11a4-49c8-81e4-6c3d638a93bf"}
# .dropna(axis=0)
#

# test_y = KMeans(n_clusters=3, init='k-means++', n_init=3, max_iter=50, tol=0.0001,
#                          random_state=42)
# test_y_pred = test_y.fit_predict(self.df2)
# pred_2 = pd.DataFrame(test_y_pred)
# temp = self.df3
# temp = pd.DataFrame(temp)
# temp['predicted'] = pred_2
# temp['predicted'].unique()
# temp = temp.dropna(axis=0)
# result = temp[['ID', 'predicted', 'Gene.symbol']]
# result.to_csv('output2.csv', index=False)
# print("yes")
