# Augmented Reality Based Resume With FaceRecognition
An augmented reality based resume with Face recognition. The iOS app recognizes the face and presents you with the AR view that contains 3D mock face and details of your resume.


# Architecture

![ARResume Architecture](https://github.com/sanjeevghimire/ARBasedResumeWithFaceRecognition/blob/master/ARResume.jpg "ARResume Architecture")

# Steps

1. git clone 
2. Get IBM Visual Recognition and update the Credentials.swift
3. Get IBM Cloudant Database and update the Credentials.swift
4. Open the project using Xcode
5. Build and Run

# Test
To test you can do the following
1. Train IBM visual recognition with your head shot images. Please use atleast 10 images of your head shot and use a negative trainig by using a different head shot which is not you.
2. Update the cloudant database using the classification id from the training to store your information. The JSON will be in the format:

```
{
  "_id": "c2554847ec99e05ffa8122994f1f1cb4",
  "_rev": "3-d69a8b26c103a048b5e366c4a6dbeed7",
  "classificationId": "SanjeevGhimire_334732802",
  "fullname": "Sanjeev Ghimire",
  "linkedin": "https://www.linkedin.com/in/sanjeev-ghimire-8534854/",
  "twitter": "https://twitter.com/sanjeevghimire",
  "facebook": "https://www.facebook.com/sanjeev.ghimire",
  "phone": "1-859-684-7931",
  "location": "Austin, TX"
}
```



