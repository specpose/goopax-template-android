# goopax-examples SDL apk packaging test

## Info

To avoid Python scripting, this simple deployment test is based off the android-project subdirectory of [SDL3](https://github.com/libsdl-org/SDL).

It is for SDL release 3.2.8 and all of the files have to be updated from that repository with every new release version. The corresponding libSDL3.so version number can be found here: `app/src/main/java/org/libsdl/app/SDLActivity.java`.

## About the Workaround

Generating add_sdl_main for Android is broken when using the cmake built-in Android support. Instead, the android-workaround branch is using the official Google Android cmake support CMAKE_TOOLCHAIN_FILE. [Official Google cmake build Instructions](https://developer.android.com/studio/projects/configure-cmake?hl=en)

Add ANDROID_PLATFORM and CMAKE_TOOLCHAIN_FILE, remove CMAKE_SYSTEM_VERSION and CMAKE_ANDROID_STL_TYPE, replace CMAKE_ANDROID_ARCH_ABI with ANDROID_ABI and CMAKE_ANDROID_NDK with ANDROID_NDK.

Add build_sdl3 to build_external_libraries target and add the sdl3 entry to CMAKE_FIND_ROOT_PATH to revert to a working version.

## Instructions
Check out the android-workaround branch from [goopax-examples](https://github.com/specpose/goopax-examples) to the parent directory. The workaround is already applied.

Install Goopax Android to the parent directory.
Shared object files with any filename ending other than .so are ignored by gradle.
```console
cp ../goopax-5.7.0-Android-aarch64/lib/libgoopax.so app/libs/arm64-v8a/libgoopax.so
```

Follow build instructions in android-workaround branch.
Rename the executable shared object to `libmain.so`.
```console
cp ../goopax-examples/build/libfft.so app/libs/arm64-v8a/libmain.so
```
Copy the shared SDL3 build.
```console
cp ../goopax-examples/build/ext/sdl3/lib/libSDL3.so app/libs/arm64-v8a/libSDL3.so
```

`wrap.sh` needs API-level 27 on the target mobile. Edit `app/src/main/resources/lib/arm64-v8a/wrap.sh`.
For example:
```
exec env GOOPAX_ALLOW_DEPRECATED_DEVICES=1 GOOPAX_VERB=1 $cmd "$@"
```

`libfft.so`: Uncomment Android camera permissions in `app/src/main/AndroidManifest.xml`
```
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```
The camera permission has to be granted *before* running the app.

stdout is disabled on Android, but can be redirected to `Android/data/org.libsdl.app/files/fft.out`:
```
std::string dataPath(SDL_GetAndroidExternalStoragePath())
FILE* fout = freopen(std::string(dataPath + "/fft.out").c_str(), "w", stdout);
std::cout<<"Your program output here..."<<std::endl;
fflush(stdout);
if (fout!=NULL) { fclose(fout); }
fout=NULL;
```
This folder may be located under `/sdcard` or `/storage/sdcard0` depending on your phone.

At this point you should be able to `Build->Make Project` in Android Studio, run, debug and set breakpoints in the `../goopax-examples/src` files.

Follow instructions on [libsdl-org](https://github.com/libsdl-org/SDL/blob/release-3.2.8/docs/README-android.md) to customise the App. Make sure to check entries:
```
namespace "org.libsdl.app"
<activity android:name="SDLActivity"
<string name="app_name">Game</string>
```
In the files `app/build.gradle`, `app/src/main/AndroidManifest.xml` and `app/src/main/res/values/strings.xml`.

If there are graphics glitches it may be helpful to `Disable HW overlays` in `Settings->System->Developer options` on the target phone.
