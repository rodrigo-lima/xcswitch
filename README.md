# xcswitch
Switch between Xcode versions but keeping current Xcode version as `/Applications/Xcode.app`

All other versions will remain under `/Applications` with their corresponding versions appended to its name.

```
~ % ls -1d /Applications/Xcode*
/Applications/Xcode.app         -- Current Version is 8.3.3
/Applications/Xcode8.2.1.app    -- other Xcode's
/Applications/Xcode9.0.app
```

## Why not 'xcode-select'?
That's the official and correct way of doing this, but I found out that some older projects still have (or generate) map files that depend on `Applications/Xcode.app` being **the** Xcode location.

If you `xcode-select` and point it to, for example, `/Applications/Xcode8.2.1.app` the build will probably fail and/or you'll spend 100 hours trying to figure out why things don't work as they should. Trust me, it happened before...

## Usage
When running the script without any arguments, it prints the current version and lists all other Xcode versions you have installed under `/Applications`.

> **Note:** when creating the list, the script strips out `/Applications/Xcode` and `.app` from the directory names, so you'll only see the version. This assumes you're using a similar naming convention as shown above. i.e. `Xcode8.2.1.app, Xcode9.0.app, etc.`

```
~ % ./xcswitch.sh
Xcode switcher -- Currently: [8.3.3]

1) 8.2.1
2) 9.0
Select Xcode version to use: (CTRL+C to quit)
```

If you know the version you want to switch to, just type it as argument.

```
~ % ./xcswitch.sh 9.0
Xcode switcher -- Currently: [8.3.3]

Switching from: [8.3.3] - to: [9.0]
...
Password:
Double check versions below:
Xcode 9.0
Build version 9A235
Apple Swift version 4.0 (swiftlang-900.0.65 clang-900.0.37)
Target: x86_64-apple-macosx10.9
```

You might be asked for your user password as the script required `sudo` privileges.
