# goopax-examples SDL apk packaging test

To avoid Python scripting, this simple deployment test is based off the android-project subdirectory of [SDL3](https://github.com/libsdl-org/SDL).

It is for SDL release 3.3.0 and all of the files have to be updated from that repository with every new release version. The corresponding libSDL3.so version number can be found here: `app/src/main/java/org/libsdl/app/SDLActivity.java`.

Install Goopax Android to the parent directory.
Shared object files with any filename ending other than .so are ignored by gradle.
```console
cp ../goopax-5.7.0-Android-aarch64/lib/libgoopax.so app/libs/arm64-v8a/libgoopax.so
```

Check out the android-shared branch of [goopax-examples](https://github.com/specpose/goopax-examples) to the parent directory.
Follow build instructions.
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
exec env GOOPAX_VERB=3 $cmd "$@"
```

`libfft.so`: Uncomment Android camera permissions in `app/src/main/AndroidManifest.xml`
```
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```
Additional permissions have to be granted before running the app.

stdout is disabled on Android, but can be redirected to a file:
```
std::string dataPath("/data/data/org.libsdl.app");
FILE* fout = freopen(std::string(dataPath + "/fft.out").c_str(), "w", stdout);
std::cout<<"Your program output here..."<<std::endl;
fflush(stdout);
if (fout!=NULL) { fclose(fout); }
fout=NULL;
```
The phone has to be rooted for that particular file to be accessible from adb shell.
