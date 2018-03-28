FROM tensorflow-serving-base:latest

MAINTAINER Jakub Rozanski <jakub.rozanski@intel.com>

#Installation of tensorflow-model-server (apt package)
#Warning: this particular package may not be optimized for all your CPU capabilities.
RUN echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" \
    | tee /etc/apt/sources.list.d/tensorflow-serving.list && curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add -
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && apt-get install -y libstdc++6 tensorflow-model-server

#Examplary model serving (this shall be replaced by your model)
#In order to deploy your model prepare directiory <path>/yourModel/1 with pb file and variables.
#For reference look at deliverables of mnist_saved_model.py execution.
RUN pip install tensorflow-serving-api
RUN git clone https://github.com/tensorflow/serving.git

WORKDIR /tmp
RUN wget https://storage.googleapis.com/cvdf-datasets/mnist/train-images-idx3-ubyte.gz && \
    wget https://storage.googleapis.com/cvdf-datasets/mnist/train-labels-idx1-ubyte.gz && \
    wget https://storage.googleapis.com/cvdf-datasets/mnist/t10k-images-idx3-ubyte.gz && \
    wget https://storage.googleapis.com/cvdf-datasets/mnist/t10k-labels-idx1-ubyte.gz 

WORKDIR /serving
RUN bash -c "python tensorflow_serving/example/mnist_saved_model.py /tmp/mnist_model"

EXPOSE 9000
CMD tensorflow_model_server --port=9000 --model_name=mnist --model_base_path=/tmp/mnist_model/
