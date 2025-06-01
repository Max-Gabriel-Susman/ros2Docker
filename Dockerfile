# perhaps we can parameterize to only use the desktop version when we need it to, no point supporting GUI in a headless environment(use FROM ros:humble for headless)
FROM osrf/ros:humble-desktop-full 

# --- fix for expired ROS key, see https://github.com/osrf/docker_images/issues/807 -----------------------------------------------------
RUN rm /etc/apt/sources.list.d/ros2-latest.list \
    && rm /usr/share/keyrings/ros2-latest-archive-keyring.gpg

RUN apt-get update \
    && apt-get install -y ca-certificates curl

RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') ;\
    curl -L -s -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" \
    && apt-get update \
    && apt-get install /tmp/ros2-apt-source.deb \
    && rm -f /tmp/ros2-apt-source.deb

# ---------------------------------------------------------------------------

RUN apt-get update \
    && apt-get install -y nano \
    && rm -rf /var/lib/apt/lists/*

COPY config/ /site_config/

ARG USERNAME=ros 
ARG USER_UID=1000
ARG USER_GID=$USER_UID 

# Create a non-root user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd  --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && install -d -o ${USER_UID} -g ${USER_GID} /home/${USERNAME}/.config

# Set up sudo 
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \ 
    && rm -rf /var/lib/apt/lists/*
