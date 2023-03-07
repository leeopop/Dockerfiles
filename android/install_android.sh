cat <<EOF >> ~/.profile
PATH="\$PATH:\$HOME/.gradle/gradle-6.3/bin"
PATH="\$PATH:\$HOME/.android-sdk/tools/bin"
ANDROID_HOME=\$HOME/.android-sdk
ANDROID_SDK_PATH=\$HOME/.android-sdk
EOF
source ~/.profile

cd ~/.gradle
wget https://services.gradle.org/distributions/gradle-6.3-bin.zip
unzip gradle-6.3-bin.zip
rm gradle-6.3-bin.zip

cd ~/.android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
unzip commandlinetools-linux-6200805_latest.zip
rm commandlinetools-linux-6200805_latest.zip
yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses
sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-21" "platforms;android-22" "platforms;android-23" "platforms;android-24" "platforms;android-25" "platforms;android-26" "platforms;android-27" "platforms;android-28" "platforms;android-29"
sdkmanager --sdk_root=${ANDROID_HOME} "ndk-bundle"
