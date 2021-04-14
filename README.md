# Docker image with CUDA 10 and cuDNN 7

Проект содержит **bash-скрипты для подготовки хост-машины** для предоставления доступа **к GPU в [docker](https://docs.docker.com/) контейнерах**. Подготовка состоит из:

1. Установка драйвера для [NVIDIA GPU](https://www.nvidia.com/en-gb/graphics-cards/) необходимой версии
2. Установка [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-docker)
3. Сборка базового docker образа с [CUDA 10.X](https://developer.nvidia.com/cuda-zone) и [cuDNN 7.6](https://developer.nvidia.com/cudnn)

**Внимание!** Все нижеописанные **инструкции** предназначены **для Ubuntu 16.04-20.04**. В других ОС работоспособность не гарантируется!

**Примечание:** после клонирования проекта, скорее всего нужно будет **предоставить скриптам права на запуск**. Это можно сделать следующим способом (находясь в папке с проектом):

```bash
chmod +x *.sh
```

---

## Зависимости

Для успешной подготовки хост-машины **требуется** установленный **[Docker](https://docs.docker.com/) версии [19.03](https://docs.docker.com/engine/reference/commandline/version/) или выше**.

Для установки Docker в Ubuntu 16.04-20.04 воспользуйтесь [официальной инструкцией](https://docs.docker.com/install/linux/docker-ce/ubuntu/) или скриптом [`install_docker-ubuntu.sh`](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/install_docker-ubuntu.sh):

```bash
sudo ./install_docker-ubuntu.sh
```

Так же можно вручную в терминале выполнить (краткая выжимка из официальной инструкции):

```bash
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose
```

---

## Подготовка хост-машины одним скриптом

Для **выполнения всех действий сразу** можно воспользоваться скриптом [`install_all.sh`](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/install_all.sh). Поддерживается **`CUDA` версии `10.0`, `10.1` и `10.2`**. Для того, что бы указать конкретную версию `CUDA`, нужно **передать аргумент при запуске**:

```bash
sudo ./install_all.sh [cuda10.0|cuda10.1|cuda10.2]
```

Значения аргумента (если не передавать аргумент - использовать значение `cuda10.2`):

- `cuda10.0`: установка `nvidia-driver-440`, `nvidia-container-toolkit` и сборка docker-образа с `CUDA 10.0` и `cuDNN 7.6` на основе Ubuntu 19.10 с меткой `cuda10.0_cudnn7.6:devel`
- `cuda10.1`: установка `nvidia-driver-440`, `nvidia-container-toolkit` и сборка docker-образа с `CUDA 10.1` и `cuDNN 7.6` на основе Ubuntu 19.10 с меткой `cuda10.1_cudnn7.6:devel`
- `cuda10.2`: установка `nvidia-driver-440`, `nvidia-container-toolkit` и сборка docker-образа с `CUDA 10.2` и `cuDNN 7.6` на основе Ubuntu 19.10 с меткой `cuda10.2_cudnn7.6:devel`

После выполнения скрипта необходмо **перезагрузить хост-машину**. Проверить работоспособность можно следующим образом:

```bash
sudo docker run --gpus all -ti --rm cuda10.2_cudnn7.6:devel nvidia-smi
```

Результат должен быть такой же, как и в [разделе 1](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/tree/master#1-установка-драйвера-для-видеокарты-nvidia) ниже.

---

## 1. Установка драйвера для видеокарты NVIDIA

Для работы с [CUDA 10.X](https://developer.nvidia.com/cuda-toolkit-archive) необходим **драйвер для видеокарты** определённой версии ([источник](https://docs.nvidia.com/deploy/cuda-compatibility/index.html#binary-compatibility__table-toolkit-driver)):

- CUDA 10.0: драйвер версии 410.48 или выше
- CUDA 10.1: драйвер версии 418.39 или выше
- CUDA 10.2: драйвер версии 440.33 или выше

**Установить драйвер** нужной версии можно следующими способами:

1. Самостоятельно, загрузив необходимый пакет с официального сайта [nvidia](https://www.nvidia.ru/Download/index.aspx?lang=ru)
2. Воспользоваться скриптом [`install_nvidia-driver.sh`](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/install_nvidia-driver.sh), который в качестве аргумента принимает версию драйвера (если не передавать аргумент - установить версию `440`):

```bash
sudo ./install_nvidia-driver.sh [410|418|440|...]
```

3. Вручную в терминале выполнить:

```bash
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get -y update
sudo apt-get -y install nvidia-driver-440
```

После установки необходимо **перезагрузить хост-машину**. Что бы убедиться, что драйвер успешно установлен, можно **вызвать в терминале `nvidia-smi`**. Результат должен быть примерно следующий:

```bash
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.59       Driver Version: 440.59       CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce RTX 208...  Off  | 00000000:08:00.0 Off |                  N/A |
| 39%   42C    P0    18W / 250W |      0MiB / 11019MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

---

## 2. Установка [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-docker)

Что бы видеокарта была доступна в docker-контейнере, необходимо **установить [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-docker)**. Сделать это можно следующими способами:

1. Воспользоваться скриптом [`install_nvidia-container-toolkit.sh`](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/install_nvidia-container-toolkit.sh):

```bash
sudo ./install_nvidia-container-toolkit.sh
```

2. Вручную в терминале выполнить (краткая выжимка из [репозитория](https://github.com/NVIDIA/nvidia-docker#ubuntu-16041804-debian-jessiestretchbuster)):

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get -y update
sudo apt-get -y install nvidia-container-toolkit
sudo systemctl restart docker
```

Что бы убедиться, что установка прошла успешно, можно выполнить в терминале:

```bash
sudo docker run --gpus all -ti --rm nvidia/cuda:10.2-base nvidia-smi
```

Результат должен быть такой же, как и в [подразделе 1](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/tree/master#1-установка-драйвера-для-видеокарты-nvidia).

---

## 3. Сборка docker-образа с CUDA 10.X и cuDNN 7.6

Для работы с библиотеками машинного обучения на GPU, такими как [TensorFlow](https://www.tensorflow.org/) и [PyTorch](https://pytorch.org/), так же **необходимы библиотеки [CUDA 10.X](https://developer.nvidia.com/cuda-toolkit-archive) и [cuDNN 7.6](https://developer.nvidia.com/cudnn)**. Для упрощения сборки пользовательских docker-образов, можно **использовать заранее собранный docker-образ** с данными библиотеками **в качестве основы** (т.е. в качестве базового образа).

В проекте доступны **2 вида Dockerfile**: `runtime` и `devel`. Образы с меткой `runtime` используются для **запуска** уже **готовых проектов** на GPU, а с меткой `devel` - для **сборки проектов из исходников** с поддержкой GPU (подробно про разницу между ними можно посмотреть в репозитории [nvidia-docker](https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#description)).

**Для сборки docker-образа с `CUDA 10.2` и `cuDNN 7.6`**, находясь в папке с проектом, нужно выполнить (`-f Dockerfile_cuda10.2_runtime` — использовать файл `Dockerfile_cuda10.2_runtime` в качестве Dockerfile для сборки образа, `-t` — запуск в терминале, `.` — директория, из которой вызывается docker build (точка — значит в текущей директории находятся все файлы для образа), `cuda10.2_cudnn7.6:runtime` — метка образа и его версия):

```bash
sudo docker build -f Dockerfile_cuda10.2_runtime -t cuda10.2_cudnn7.6:runtime .
```

В качестве **базовой ОС** для образа используется **Ubuntu 20.04**.

Для сборки docker-образов **с другими версиями CUDA** в проекте присутствуют **соответствующие Dockerfile**:

- CUDA 10.0: [Dockerfile_cuda10.0_runtime](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.0_runtime) и [Dockerfile_cuda10.0_devel](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.0_devel)
- CUDA 10.1: [Dockerfile_cuda10.1_runtime](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.1_runtime) и [Dockerfile_cuda10.1_devel](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.1_devel)
- CUDA 10.2: [Dockerfile_cuda10.2_runtime](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.2_runtime) и [Dockerfile_cuda10.2_devel](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/blob/master/Dockerfile_cuda10.2_devel)

Данные Dockerfiles сделаны на основе Dockerfiles из репозитория [nvidia](https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist%2Fubuntu18.04).

После успешной сборки, проверить работоспособность образа можно следующим образом (`--gpus all` - предоставить контейнеру доступ ко всем GPU на хост-машине, `-t` — запуск терминала, `-i` — интерактивный режим, `--rm` — удалить контейнер после завершения его работы):

```bash
sudo docker run --gpus all -ti --rm cuda10.2_cudnn7.6:runtime nvidia-smi
```

Результат должен быть такой же, как и в [подразделе 1](https://github.com/Desklop/Docker_image_with_CUDA10_cuDNN7/tree/master#1-установка-драйвера-для-видеокарты-nvidia).

**Примечание:** размер собранного docker-образа с `CUDA 10.X` и `cuDNN 7.6` равен **1.3-1.8 Гб** для `runtime` и **3.1-3.8 Гб** для `devel`.

---

### Сборка пользовательского docker-образа с CUDA 10.X и cuDNN 7.6

**Для сборки** любого **пользовательского docker-образа с** библиотеками **`CUDA 10.X` и `cuDNN 7.6`** нужно:

1. Изменить образ, на основе которого собирается пользовательский образ, на созданный ранее `cuda10.2_cudnn7.6:runtime`
2. При установке пакетов для Python использовать версии библиотек для работы на GPU, например, вместо TensorFlow использовать [TensorFlow-GPU](https://www.tensorflow.org/install/gpu)
3. Предусмотреть в исходном коде запускаемого в docker-контейнере проекта обнаружение и использование GPU

Что бы docker-образ имел доступ к видеокарте, **при запуске** образа необходимо **передать параметр `--gpus all`**, например:

```bash
sudo docker run --gpus all -ti --rm my_image:version
```

Параметр `--gpus all` предоставит контейнеру доступ сразу ко всем имеющимся на хост-машине видеокартам. Что бы указать, сколько видеокарт использовать или какие именно, нужно вместо `all` передать `2` (использовать первые 2 видеокарты) или `"device=2,3"` (использовать 2 и 3 видеокарту), например:

```bash
sudo docker run --gpus '"device=1,2"' -ti --rm my_image:version
```

Более подробно про параметр `--gpus` можно посмотреть в репозитории [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker#usage).

---

## Динамическое выделение памяти GPU в TensorFlow-GPU

По умолчанию **[TensorFlow-GPU](https://www.tensorflow.org/install/gpu) использует всю** доступную **видеопамять**, по этому не получится одновременно запустить несколько docker-образов, использующих [TensorFlow-GPU](https://www.tensorflow.org/install/gpu) на одном GPU.

Если проект написан на Python и для работы с TensorFlow используется [Keras](https://keras.io/), **можно** это **исправить** следующим образом (данный фрагмент кода необходимо добавить в самое начало `.py` файла, перед первым использованием TensorFlow-GPU) ([источник](https://www.tensorflow.org/guide/using_gpu?hl=ru#allowing_gpu_memory_growth)):

```python
import tensorflow as tf
from keras.backend.tensorflow_backend import set_session

# Включение динамического выделения памяти GPU в TensorFlow
config = tf.ConfigProto()
config.gpu_options.allow_growth = True

sess = tf.Session(config=config)  # применение новой конфигурации для сессии TensorFlow
set_session(sess)  # установка данной сессии TensorFlow в качестве основной для Keras
```

---

Если у вас возникнут вопросы или вы хотите сотрудничать, можете написать мне на почту: vladsklim@gmail.com или в [LinkedIn](https://www.linkedin.com/in/vladklim/).
