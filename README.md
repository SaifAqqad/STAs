# STAs

## Setup development environment with scoop:
You will need the following:
* [Git](https://git-scm.com/) and [gh](https://cli.github.com/)
* [JDK 17  (Eclipse Temurin)](https://adoptium.net/)
* [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)
* [MailDev SMTP Server](https://github.com/maildev/maildev)

To install them, run the following in powershell

1. Install scoop
```Powershell
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser;
    iwr -useb get.scoop.sh | iex;
```

2. Install git and add the java bucket
```powershell
    scoop install git gh sudo;
    scoop bucket add java
```

3. Install the dependencies
```powershell
    scoop install temurin17-jdk maven nodejs-lts mysql mysql-workbench;
```

4. Install MailDev
```powershell
    npm install -g maildev
```

5. Install MySQL service
```powershell
    sudo mysqld.exe --install-manual mysql
```

7. Sign in to GitHub with gh
```powershell
    gh auth login;
    gh auth setup-git;
```

6. Clone the repo
```powershell
    gh repo clone SaifAqqad/STAs
```

### Run MySQL service:
```powershell
   sudo sc.exe start mysql
```

* <sub>MySQL default port: `3306`</sub>
* <sub>MySQL default username: `root`</sub>
* <sub>MySQL default password: `<blank>`</sub>

### Run MailDev:
```powershell
    ~\scoop\apps\nodejs-lts\current\bin\maildev.cmd
```