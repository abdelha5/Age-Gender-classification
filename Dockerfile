FROM tensorflow/tensorflow:2.6.0-gpu-jupyter

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends apt-utils build-essential python3-dev python3-pip graphviz

RUN pip3 install -U pip
RUN pip3 install pandas plotly pillow pydot

WORKDIR /app
COPY . .
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "<PORT>", "--no-browser", "--allow-root"]