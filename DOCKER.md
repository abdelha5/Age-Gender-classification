# Running Jupyter Notebook on Hex GPU cloud

Hex GPU cloud: https://hex.cs.bath.ac.uk/

## Connecting to Hex GPU cloud

*Note: the commands in this section are dependent on the shell of your host operating system. It will work for MacOS and Linux but the command on Windows may be slightly different (not 100% sure). You can use WSL for Windows instead if necessary.*

Select a server to connect to from the [Hex GPU cloud Usage](https://hex.cs.bath.ac.uk/usage) webpage. You should select a server with free GPUs and that is marked for MSc access, e.g. `nitt` or `ogg`. We will refer to this name as `HEX_SERVER`.

**IMPORTANT:** Currently, not all servers have up-to-date GPU drivers. I have tested `nitt`, `garlick` and `ogg` nodes and only managed to get this working on `ogg`, therefore use this node for the time being.

Copy the git repository over to your user directory on the server with the following command, where `BATH_USER` is your Bath username, e.g. abc123. You will be prompted for your Bath password.

```bash
$ scp -r </path/to/Machine-learning-2-CW> <BATH_USER>@<HEX_SERVER>.cs.bath.ac.uk:/homes/<BATH_USER>/ 
```

Next, connect to the server.

```bash
$ ssh <BATH_USER>@<HEX_SERVER>.cs.bath.ac.uk
```

You will now be connected to the Hex server. You should also see the git repository we copied over.
```bash
$ ls
```

## Mapping ports

The process is to establish a connection from `host -> hex -> docker container`. To do so we will have to map network ports at each stage.

The cloud has some security controls that are tied to your user. First, we will have to reserve a port. Enter the command below, selecting a value between 10000 and 30000 for the port. Remember this value, as we will refer to this port as `PORT` hereafter.

```bash
$ hare reserve <PORT>
```

This port will be tied to your user.

**IMPORTANT:** Edit the Dockerfile to include your `PORT`, e.g. if your port is 20000, change the line `"--port", "<PORT>"` in the Dockerfile to `"--port", "20000"`.

Close the connection to the server by typing `exit` or `logout` in the terminal. We will now have to reconnect by mapping the ports from our local machine to the Hex server.

```bash
$ ssh -L 8080:localhost:<PORT> $BATH_USER@<HEX_SERVER>.cs.bath.ac.uk
```

## Running Jupyter Notebook

Change directory into the root of the git repository we copied over.

```bash
$ cd ./Machine-learning-2-CW/
```

Proceed to build the Docker image (you only need to do this step once).

```bash
$ hare build -t <BATH_USER>/ml2-cw .
```

Check what GPU resources are available on the server by running the command below. 

```bash
$ nvidia-smi
```

We can use all available GPUs or a subset of them. It's best to use GPUs that are not under heavy load. Note the ID of each GPU - this will be our `<DEVICE>` parameter. `<DEVICE>` can be:

* `all` to use all available GPUs
* `1` or `'"device=1"'` to use GPU with ID 1
* `'"device=1,2"'` to use GPUs 1 and 2

Run Jupyter inside the container. From now on every time you want to run the notebook, just run the command below.  

```bash
$ hare run --rm -it --gpus <DEVICE> -v "$(pwd)":/app -p <PORT>:<PORT> <BATH_USER>/ml2-cw
```

Open the Jupyter Notebook by opening http://localhost:8080/ in your browser. You may be prompted for a token - this usually looks like `?token=12345...` that is output by running the previous command (note: the token is the string after the equals = sign).

## Saving progress

All work done on the Jupyter Notebook in the container will automatically be saved in your user directory on the GPU server. You can then copy the notebook back to your local machine and push to the git repository. 

Run the command below from your local copy of the repository to copy the notebook over from the server.

```bash
$ scp <BATH_USER>@<HEX_SERVER>.cs.bath.ac.uk:/homes/<BATH_USER>/Machine-learning-2-CW/example.ipynb .
```
