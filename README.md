# tensorflow-serving-example-docker
This repository holds Dockerfiles needed to start basic example from tensorflow-serving tutorial.

First file Dockerfile.base is taken directly from tensorflow-serving repository and installs software needed to tensorflow-model-server development. Some packages are redundant but few of them are crucial to run example.

To build first image run:

    docker build --tag=tensorflow-serving-base:latest -f Dockerfile.base .

To build second image run:

    docker build --tag=tensorflow-serving-example:latest -f Dockerfile .

To run model server run:

    docker run -p 9000:9000 tensorflow-serving-example:latest

Now you can communicate with model server on localhost:9000.
Running inference is as simple as this (taken from [tutorial page](https://www.tensorflow.org/serving/serving_basic))

    virtualenv ve
    . ve/bin/activate
    pip install tensorflow-serving-api
    
    git clone git@github.com:tensorflow/serving.git
    cd serving
    python tensorflow_serving/example/mnist_client.py --num_tests=1000 --server=localhost:9000
