FROM tensorflow/tensorflow:2.6.0-gpu-jupyter

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends apt-utils build-essential python3-dev python3-pip

WORKDIR /app
COPY . .
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "15000", "--no-browser", "--allow-root"]