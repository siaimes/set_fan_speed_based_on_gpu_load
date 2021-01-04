# set_fan_speed_based_on_gpu_load
使用ipmitool基于GPU温度设置风扇转速，应用场景是服务器被动散热的GPU。在宝德pr2715p测试成功。ipmitool的命令许是硬件相关，其他硬件可咨询售后。

# Installing

- via `curl`
    ```
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/siaimes/set_fan_speed_based_on_gpu_load/master/set_fan_speed_based_on_gpu_load.sh)"
    ```
- via `wget`
    ```
    sudo bash -c "$(wget -O- https://raw.githubusercontent.com/siaimes/set_fan_speed_based_on_gpu_load/master/set_fan_speed_based_on_gpu_load.sh)"
    ```
