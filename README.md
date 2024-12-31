![Swift Version](https://img.shields.io/badge/Swift-5.7-orange.svg)

# Cats vs Dogs

This repository contains example algorithms designed to classify images of cats and dogs, using two approaches:

1. **Apple's Vision Framework** - Utilizes the [`RecognizeAnimalsRequest`](https://developer.apple.com/documentation/vision/recognizeanimalsrequest) API to recognize animal types in images.
2. **Custom Image Classifier** - A custom classifier trained on the [Kaggle Dogs vs. Cats dataset](https://www.kaggle.com/competitions/dogs-vs-cats/), created with [CreateML](https://developer.apple.com/documentation/createml).

<p align="center">
  <img src="https://github.com/user-attachments/assets/16c72227-3b7a-4eab-9d0c-cf567d29662e" width="300" alt="Cats vs Dogs Image"/>
</p>

---

### Requirements

- iOS 18.0+
- Xcode 16+
- CreateML (for training custom classifiers)
- Access to Kaggle's Dogs vs. Cats dataset
