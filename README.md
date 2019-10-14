# Docker image with CUDA10.0 and cuDNN7.5 for TensorFlow-GPU/PyTorch

Проект содержит bash-скрипты для подготовки хост-машины к запуску [TensorFlow](https://www.tensorflow.org/install/gpu) или [PyTorch](https://pytorch.org/) на GPU и `Dockerfile` для сборки docker-образа с библиотеками [CUDA 10.0](https://developer.nvidia.com/cuda-toolkit-archive) и [cuDNN 7.5.0.56](https://developer.nvidia.com/cudnn) (на основе dockerfiles из репозитория [nvidia](https://gitlab.com/nvidia/cuda/tree/ubuntu18.04/10.0)), на основе которого затем можно собирать любые пользовательские образы с TensorFlow-GPU или PyTorch (с минимальными изменениями пользовательского `Dockerfile`).

**ВНИМАНИЕ!** Все нижеописанные инструкции проверены в Ubuntu 16.04/18.04. В других ОС работоспособность не гарантируется!

Для выполнения всех действий в чистой ОС (требуется установленный docker) можно воспользоваться скриптом `install_all.sh` (выполнит установку nvidia-driver-410, nvidia-docker и сборку docker-образа с CUDA 10.0 и cuDNN 7.5.0.56 на основе Ubuntu 18.04 с меткой `cuda10.0_cudnn7.5:1.0`). Например, так:
```bash
sudo ./install_all.sh
```
После выполнения скрипта необходмо перезагрузить хост-машину. Проверить работоспособность можно следующим образом:
```bash
sudo docker run --runtime=nvidia -ti --rm cuda10.0_cudnn7.5:1.0 nvidia-smi
```
Результат должен быть такой же, как и в [подразделе 1](https://github.com/Desklop/Docker_image_CUDA10.0_cuDNN7.5/tree/master#1-установка-драйвера-для-видеокарты-nvidia) ниже.

---

# Подготовка хост-машины

Перед сборкой и запуском TensorFlow/PyTorch в docker-образе на GPU сначала надо подготовить хост-машину. Подготовка состоит из двух этапов:
1. Установка драйвера необходимой версии для видеокарты [nvidia](https://www.nvidia.ru/Download/index.aspx?lang=ru) в ОС;
2. Установка [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

---

### 1. Установка драйвера для видеокарты nvidia

Для работы с [CUDA 10.0](https://developer.nvidia.com/cuda-toolkit-archive) необходим драйвер версии 410.104. Установить его можно следующими способами:
1. Самостоятельно, загрузив необходимый пакет с официального сайта [nvidia](https://www.nvidia.ru/Download/index.aspx?lang=ru);

2. Воспользоваться скриптом `install_nvidia-driver-410.sh`, для этого необходимо перейти в терминале в папку со скриптом и выполнить:
```bash
sudo ./install_nvidia-driver-410.sh
```

3. Вручную в терминале выполнить следующие действия:
```bash
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get -y update
sudo apt-get -y install nvidia-driver-410
```

После установки необходимо перезагрузить хост-машину. Что бы убедиться, что драйвер успешно установлен, можно ввести в терминале `nvidia-smi`. Результат должен быть примерно следующий:
```
Fri May  3 16:06:10 2019
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.104      Driver Version: 410.104      CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1070    Off  | 00000000:01:00.0  On |                  N/A |
|  0%   44C    P5    16W / 180W |   1277MiB /  8116MiB |      3%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1908      G   /usr/lib/xorg/Xorg                            26MiB |
|    0      1985      G   /usr/bin/gnome-shell                          51MiB |
|    0      4112      G   /usr/lib/xorg/Xorg                           367MiB |
|    0      4226      G   /usr/bin/gnome-shell                         295MiB |
|    0     27572      G   /opt/teamviewer/tv_bin/TeamViewer             11MiB |
+-----------------------------------------------------------------------------+
```

---

### 2. Установка [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

Для того, что бы видеокарта была доступна внутри docker-образа, необходимо установить [nvidia-docker](https://github.com/NVIDIA/nvidia-docker). Сделать это можно следующими способами:
1. Воспользоваться скриптом `install_nvidia-docker2.sh`, для этого необходимо перейти в терминале в папку со скриптом и выполнить:
```bash
sudo ./install_nvidia-docker2.sh
```

2. Вручную в терминале выполнить следующие действия (взято [отсюда](https://github.com/NVIDIA/nvidia-docker#ubuntu-140416041804-debian-jessiestretch)):
```bash
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd
```

Что бы убедиться, что установка прошла успешно, можно выполнить в терминале:
```bash
sudo docker run --runtime=nvidia --rm nvidia/cuda:10.0-base nvidia-smi
```
Результат должен быть такой же, как и в [подразделе 1](https://github.com/Desklop/Docker_image_CUDA10.0_cuDNN7.5/tree/master#1-установка-драйвера-для-видеокарты-nvidia).

---

В процессе установки может возникнуть следующая ошибка (с которой столкнулся я):
```bash
nvidia-docker2 : Зависит: docker-ce (= 5:18.09.5~3-0~ubuntu-bionic) но он не может быть установлен или
                          docker-ee (= 5:18.09.5~3-0~ubuntu-bionic) но он не может быть установлен
E: Невозможно исправить ошибки: у вас зафиксированы сломанные пакеты.
```

Для её решения можно воспользоваться скриптом `fix_install_nvidia-docker2.sh` или вручную в терминале выполнить следующие действия (взято [отсюда](https://github.com/NVIDIA/nvidia-docker/issues/607)):
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo service docker restart
```

После чего скрипт `install_nvidia-docker2.sh` необходимо выполнить заново, или, если установка проводилась вручную, продолжить её следующими действиями:
```bash
# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd
```

---

# Сборка docker-образа с библиотеками CUDA 10.0 и cuDNN 7.5.0.56

Что бы [TensorFlow](https://www.tensorflow.org/install/gpu) или [PyTorch](https://pytorch.org/) успешно запустились на GPU в docker-контейнере, необходимы так же библиотеки [CUDA 10.0](https://developer.nvidia.com/cuda-toolkit-archive) и [cuDNN 7.5.0.56](https://developer.nvidia.com/cudnn).

Для сборки отдельного docker-образа с CUDA 10.0 и cuDNN 7.5.0 на основе содержащегося в проекте `Dockerfile` (в качестве исходного образа при сборке используется Ubuntu 18.04) нужно выполнить в терминале, находясь в папке с `Dockerfile`, следующее:
```bash
sudo docker build -t cuda10.0_cudnn7.5:1.0 .
```

После успешной сборки, проверить работоспособность образа можно следующим образом:
```bash
sudo docker run --runtime=nvidia -ti --rm cuda10.0_cudnn7.5:1.0 nvidia-smi
```
Результат должен быть такой же, как и в [подразделе 1](https://github.com/Desklop/Docker_image_CUDA10.0_cuDNN7.5/tree/master#1-установка-драйвера-для-видеокарты-nvidia).

**Примечание:** размер собранного docker-образа с CUDA 10.0 и cuDNN 7.5.0 равен **3.1 Гб**.

---

# Сборка пользовательского образа с TensorFlow-GPU/PyTorch

Для сборки любого пользовательского образа с использованием [TensorFlow-GPU](https://www.tensorflow.org/install/gpu) нужно:
1. Изменить образ, на основе которого собирается пользовательский образ, на созданный выше `cuda10.0_cudnn7.5:1.0` (если при создании не было указано другое имя);
2. При установке пакетов для python изменить `tensorflow` на `tensorflow-gpu`.

Для сборки пользовательского образа с использованием [PyTorch](https://pytorch.org/) нужно только изменить образ, на основе которого собирается ваш образ, на созданный выше `cuda10.0_cudnn7.5:1.0` (если при создании не было указано другое имя) и предусмотреть запуск на GPU с использованием CUDA в вашем исходном коде.

Что бы Tensorflow-GPU/PyTorch в пользовательском образе имел доступ к видеокарте, при запуске образа необходимо передать параметр `--runtime=nvidia`, например:
```bash
sudo docker run --runtime=nvidia -ti --rm my_image:0.1
```

**ВНИМАНИЕ!** По умолчанию Tensorflow-GPU в пользовательском образе будут доступны все имеющиеся видеокарты. Если их больше одной, будет автоматически выбрана та, порядковый номер в названии которой наименьший. Если необходимо запустить TensorFlow-GPU на конкретной видеокарте, при запуске пользовательского образа необходимо дополнительно передать параметр `-e NVIDIA_VISIBLE_DEVICES=0`, где `0` - порядковый номер желаемой видеокарты, которая будет доступна TensorFlow-GPU. Например:
```bash
sudo docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 -ti --rm my_image:0.1
```

**ВНИМАНИЕ!** Если крайняя версия PyTorch из pip не поддерживает CUDA 10.0, можно найти подходящую версию [тут](https://download.pytorch.org/whl/cu100/torch_stable.html). Для её установки достаточно скопировать прямую ссылку на загрузку необходимой версии и выполнить (в примере PyTorch 1.3.0 для Python 3.6 и Linux):
```bash
pip install https://download.pytorch.org/whl/cu100/torch-1.3.0%2Bcu100-cp36-cp36m-linux_x86_64.whl
```

---

## Динамическое выделение памяти GPU в TensorFlow-GPU

По умолчанию TensorFlow-GPU занимает всю доступную видеопамять, по этому не получится одновременно запустить несколько docker-образов, использующих TensorFlow-GPU. Если ваш проект написан на Python и для работы с TensorFlow вы используете [Keras](https://keras.io/), можно исправить это следующим образом (данный фрагмент кода необходимо добавить в самое начало `.py` файла, перед использованием TensorFlow-GPU) (взято [отсюда](https://www.tensorflow.org/guide/using_gpu?hl=ru#allowing_gpu_memory_growth)):
```python
import tensorflow as tf
from keras.backend.tensorflow_backend import set_session

# Необходимо, что бы TensorFlow использовал столько памяти GPU, сколько ему реально нужно, а не всю доступную
config = tf.ConfigProto()
config.gpu_options.allow_growth = True  # динамическое выделение памяти GPU

sess = tf.Session(config=config)
set_session(sess)  # установка данной сессии TensorFlow в качестве основной для Keras
```

---

Если у вас возникнут вопросы или вы хотите сотрудничать, можете написать мне на почту: vladsklim@gmail.com или в [LinkedIn](https://www.linkedin.com/in/vladklim/).