#! /bin/bash
echo "Instalando repositorios de Microsoft..."
rm packages-microsoft-prod.deb
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
if [ $? -ne 0 ]; then
    echo "Hubo un problema descargando el repositorio de Microsoft. Compruebe su conexión a internet."
    return
fi
sudo dpkg -i packages-microsoft-prod.deb
if [ $? -ne 0 ]; then
    sudo dpkg --configure -a
    sudo dpkg -i packages-microsoft-prod.deb
    if [ $? -ne 0 ]; then
        echo "Fallo al instalar el paquete de repositorios de Microsoft."
        return
    fi
fi
rm packages-microsoft-prod.deb

echo "Instalando repositorios de Mono..."
sudo apt install apt-transport-https dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-vs.list
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

echo "Actualizando el sistema..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt clean

echo "Instalando dotnet y mono..."
sudo apt install dotnet-sdk-2.1 aspnetcore-runtime-2.1 mono-{complete,dbg,devel,csharp-shell,xsp,apache-server,vbnc} monodevelop{,-{nunit,versioncontrol}} monodoc-{gtk2.0-manual,browser} referenceassemblies-pcl ca-certificates-mono exuberant-ctags --install-recommends -y
if [ "$(which dotnet)" == "" ]; then
    echo "Hubo un problema instalando dotnet y no se puede continuar. Bummer."
    return
fi

# Plantillas geniales
echo "Instalando plantillas geniales..."

dotnet dev-certs https --trust
dotnet new -i "GtkSharp.Template.CSharp"
dotnet new -i "MonoGame.Template.CSharp"
dotnet new -i "RaspberryPi.Template::*"
dotnet new -i "Prism.Forms.QuickstartTemplates::*"
dotnet new -i "GtkSharp.Template.VBNet"
dotnet new -i "Auth0.Templates::*"
dotnet new -i "MvxScaffolding.Templates::*"
dotnet new -i "DotVVM.Templates::*"
dotnet new -i "Eto.Forms.Templates::*"
