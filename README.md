# Clustering/Subspace Clustering Algorithms on MATLAB

**This repo is no longer in active development. However, any problem on implementations of existing algorithms is welcomed. [Oct, 2020]**

## 1. Clustering Algorithms
- **K-means**
- **K-means++**
    - Generally speaking, this algorithm is similar to **K-means**;
    - Unlike classic K-means randomly choosing initial centroids, a better initialization procedure is integrated into **K-means++**, where observations far from existing centroids have higher probabilities of being chosen as the next centroid.
    - The initializeation procedure can be achieved using Fitness Proportionate Selection.
- **ISODATA (Iterative Self-Organizing Data Analysis)**
    - To be brief, **ISODATA** introduces two additional operations: Splitting and Merging;
    - When the number of observations within one class is less than one pre-defined threshold, **ISODATA** merges two classes with minimum between-class distance; 
    - When the within-class variance of one class exceeds one pre-defined threshold, **ISODATA** splits this class into two different sub-classes.
- **Mean Shift**
	- For each point *x*, find neighbors, calculate mean vector *m*, update *x = m*, until *x == m*;
	- Non-parametric model, no need to specify the number of classes;
	- No structure priori.
- **DBSCAN (Density-Based Spatial Clustering of Application with Noise)**
	- Starting with pre-selected core objects, DBSCAN extends each cluster based on the connectivity between data points;
	- DBSCAN takes noisy data into consideration, hence robust to outliers;
	- Choosing good parameters can be hard without prior knowledge;
- **Gaussian Mixture Model (GMM)**
- **LVQ (Learning Vector Quantization)**

## 2. Subspace Clustering Algorithms
- **Subspace K-means**
    - This algorithm directly extends **K-means** to Subspace Clustering through multiplying each dimension *d<sub>j</sub>* by one weight *m<sub>j</sub>* (s.t. sum(*m<sub>j</sub>*)=1, *j*=1,2,...,*p*);
    - It can be efficiently sovled in an Expectation-Maximization (EM) fashion. In each E-step, it updates weights, centroids using Lagrange Multiplier;
    - This rough algorithm suffers from the problem on its favor of using just a few dimensions when clustering sparse data;
- **Entropy-Weighting Subspace K-means**
    - Generally speaking, this algorithm is similar to **Subspace K-means**;
    - In addition, it introduces one regularization item related to weight entropy into the objective function, in order to mitigate the aforementioned problem in **Subspace K-means**.
    - Apart from its succinctness and efficiency, it works well on a broad range of real-world datasets.




