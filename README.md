# Prepare host

```bash
sudo apt install -y docker.io
```

# Build
```bash
sudo docker build -t thedeveloper/lvim .
sudo docker run -it lvim:latest /bin/bash
docker push thedeveloper/lvim
```

# Use
```bash
source lvim
lvim <path>
```