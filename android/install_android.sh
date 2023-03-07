# Beginning of android user install
cat <<EOF >> ~/.profile
PATH="\$PATH:\$HOME/.gradle/gradle-8.0/bin"
PATH="\$PATH:\$HOME/.android-sdk/cmdline-tools/bin"
ANDROID_HOME=\$HOME/.android-sdk
ANDROID_SDK_PATH=\$HOME/.android-sdk
EOF
source ~/.profile

mkdir -p ~/.gradle
cd ~/.gradle
wget https://services.gradle.org/distributions/gradle-8.0-bin.zip
unzip gradle-8.0-bin.zip
rm gradle-8.0-bin.zip

mkdir -p ~/.android-sdk
cd ~/.android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
rm commandlinetools-linux-9477386_latest.zip
yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses
# sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-32"
# sdkmanager --sdk_root=${ANDROID_HOME} "ndk-bundle"
source ~/.profile
cd ~/
# End of android user install
