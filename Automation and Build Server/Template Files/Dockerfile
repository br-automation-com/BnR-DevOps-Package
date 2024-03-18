FROM mcr.microsoft.com/dotnet/framework/runtime:3.5-windowsservercore-ltsc2022

ENV TZ=America/New_York

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#########################
# jenkins agent install #
#########################

# install choco to allow for easy software installation
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# install needed utitilies
RUN choco install -y git 
RUN choco install -y python
RUN choco install -y 7zip
RUN choco install -y nssm
RUN choco install -y temurin17 
RUN choco install -y pwsh

# install python 
RUN py -m pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org python-certifi-win32
RUN py -m ensurepip --upgrade
RUN py -m pip install GitPython
RUN py -m pip install pyinstaller
RUN py -m pip install requests
RUN py -m pip install junitparser

# set global git options
RUN git config --global core.longpaths true
RUN git config --global http.sslBackend schannel

# setup jenkins agent
ARG user=jenkins
ARG AGENT_FILENAME=agent.jar
ARG AGENT_HASH_FILENAME=$AGENT_FILENAME.sha1

RUN net accounts /maxpwage:unlimited ; \
    net user "$env:user" /add /expire:never /passwordreq:no ; \
    net localgroup Administrators /add $env:user ; \
    Set-LocalUser -Name $env:user -PasswordNeverExpires 1; \
    New-Item -ItemType Directory -Path C:/ProgramData/Jenkins | Out-Null

ARG AGENT_ROOT=C:/Users/$user
ARG AGENT_WORKDIR=${AGENT_ROOT}/Work

ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# Get the Agent from the Jenkins Artifacts Repository
ARG VERSION=3085.vc4c6977c075a
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; \
    Invoke-WebRequest $('https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/{0}/remoting-{0}.jar' -f $env:VERSION) -OutFile $(Join-Path C:/ProgramData/Jenkins $env:AGENT_FILENAME) -UseBasicParsing ; \
    Invoke-WebRequest $('https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/{0}/remoting-{0}.jar.sha1' -f $env:VERSION) -OutFile (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME) -UseBasicParsing ; \
    if ((Get-FileHash (Join-Path C:/ProgramData/Jenkins $env:AGENT_FILENAME) -Algorithm SHA1).Hash -ne (Get-Content (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME))) {exit 1} ; \
    Remove-Item -Force (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME)

USER $user

RUN New-Item -Type Directory $('{0}/.jenkins' -f $env:AGENT_ROOT) | Out-Null ; \
    New-Item -Type Directory $env:AGENT_WORKDIR | Out-Null

VOLUME "${AGENT_ROOT}"/.jenkins
VOLUME "${AGENT_WORKDIR}"
WORKDIR "${AGENT_ROOT}"

RUN New-Item -ItemType Directory -Path C:/workspace | Out-Null
# change url for your setup
ENV JENKINS_URL="http://<jenkins url>:8080"
ENV JENKINS_AGENT_WORKDIR="C:\workspace"
ENV AGENT_WORKDIR="C:\workspace"
ENV JENKINS_WEB_SOCKET="true"

COPY jenkins-agent.ps1 C:/ProgramData/Jenkins

ENV JENKINS_SECRET="<your jenkins secret for this agent>"
ENV JENKINS_AGENT_NAME="AS_412"
CMD ["powershell.exe", "-f", "C:/ProgramData/Jenkins/jenkins-agent.ps1"]

#############################
# Automation Studio Install #
#############################

# The Automation Studio installation folder should exist in the same directory as the DockerFile
# Install Automation Studio: ( Please NOTE: THE INSTALL STEP TAKES A LONG TIME )
# note: you can reduce the installation size and time by removing the help sections from Automation Studio.ini file
# Automation Studio.ini file in the templates folder is for AS 4.12

COPY AS_4.12.2.93_Install C:/Temp/AS_Install
SHELL ["cmd", "/c"]
RUN "C:\Temp\AS_Install\Setups\Automation Studio.exe"  /R /S /D=C:\BrAutomation
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Remove-Item -Path C:/Temp/AS_Install -Force -Recurse

# install any needed upgrades
COPY AS_Upgrades C:/Temp/AS_Upgrades

RUN Get-ChildItem "C:\Temp\AS_Upgrades" -Filter *.exe | Foreach-Object { \
    Write-Output 'installing ' $_.Name; \
    & $_.FullName -G='C:\BrAutomation' -V='C:\BrAutomation\AS412' -R | Out-Null; \
    }
RUN Remove-Item -Path C:/Temp/AS_Upgrades -Force -Recurse

# install any XDD files
COPY AS_3rd_Party_Files/ C:/ProgramData/BR/AS412/Hardware/Modules
