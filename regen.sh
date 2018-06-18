#! /bin/bash
#
# Regenerates Dart facade for "three.js" using TypeScript definitions from the
# DefinitelyTyped project.

# Make sure that dart_js_facade_gen is installed.
if ! [[ -x "$(command -v dart_js_facade_gen)" ]]; then
    echo 'dart_js_facade_gen is not installed.' >&2
    echo 'Please follow the instructions at https://github.com/dart-lang/js_facade_gen#installation.' >&2
    exit 1
fi

# In order to generate the Dart facade, we need local access to the TypeScript
# definitions. Unfortunately, DefinitelyTyped includes all of their TypeScript
# definitions in the same GitHub repository, so there's not an easy way to just
# pull out the three.js definitions. This means we'll have to clone their entire
# repo.
echo 'Cloning DefinitelyTyped repo into ~/tmp...'
git clone \
    https://github.com/DefinitelyTyped/DefinitelyTyped.git \
    ~/tmp/DefinitelyTyped

# Generate our Dart facade!
# This generates files in the current directory's "tmp" folder (I know this is
# weird, but the arguments to "dart_js_facade_gen" are unclear and I couldn't
# figure out a better way to get it to work).
echo 'Generating Dart facade files...'
dart_js_facade_gen ~/tmp/DefinitelyTyped/types/three/*.d.ts --base_path=. --destination=~/tmp/threejs-dart-facade

# Copy Dart facade files to "lib" (and remove existing lib contents if
# necessary).
echo 'Copying Dart facade files to lib...'
mkdir -p lib
rm -rf lib/*
cp -rf tmp/DefinitelyTyped/types/* lib

# Next few steps are to clean up the generated Dart files.

# Dart convention is to put implementation files under `lib/src`, but all of the
# files we just generated are in `lib/three`. We'll move these to `lib/src` for
# the sake of aesthetics.
echo 'Moving implementation files from lib/three to lib/src...'
mv lib/three lib/src

# All of our generated Dart files have "library tmp.DefinitelyTyped.types.three"
# at the top. We'd like these files to be in the "threejs_facade_test" library.
echo 'Replacing tmp.DefinitelyTyped.types.three library directives with threejs_facade_test library directives...'
for i in lib/src/* lib/three.dart
do
    # This "sed" usage is a little wonky in order to be compatiable with both GNU
    # and BSD/macOS Sed, due to a *non-empty* option-argument: Create a backup
    # file *temporarily* and remove it on success.
    sed -i.bak \
    's:library tmp.DefinitelyTyped.types.three:library threejs_facade_test:g' \
    "$i" && rm "$i.bak"
done

# The main "three.dart" file is trying to export implementation files directly
# from "lib", so we'll update that file's contents to export implementation
# files from "lib/src".
#
# This "sed" usage is a little wonky in order to be compatiable with both GNU
# and BSD/macOS Sed, due to a *non-empty* option-argument: Create a backup file
# *temporarily* and remove it on success.
echo 'Replacing incorrect "export"s in lib/three.dart...'
sed -i.bak 's:export ":export "src/:g' lib/three.dart && rm lib/three.dart.bak

# Remove temporary files.
echo 'Removing temporary files...'
rm -rf tmp
rm -rf ~/tmp/DefinitelyTyped