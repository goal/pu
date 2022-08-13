#### 
在登录机上设置.ssh/config
Host xxx
  Hostname xxx
  User xxx
  Port 9222   --> 端口为服务器的sshd映射到host的端口


在服务器上设置.ssh/config
Host self
  Hostname xxx
  User xxx
  Port 32222    --> 真正物理机的sshd端口

在服务器对应用户，将key加到authorized_keys.

先et登录至服务器（容器），再ssh到物理机
