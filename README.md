# ViaRE 

**ViaRE is a Real Emulator.** (Yup, a recursive acronym)

Also, by the nature of ViaRE, and its deep relations with the concepts of
"Origin" and "Beginning", we tought it nice to have a name inspired by them.

And the italian word **avviare** (to start, initiate, begin) fitted perfectly.

For now, we just **avviamo** the project, and we don't have any realease of it.

Because of it, this README will be only useful to developers who may want to
get a working copy of the code.

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

Source code is in [D](https://dlang.org/), so make sure you install a D Compiler.
We use DMD.

You can follow [Linux](https://dlang.org/dmd-linux.html),
[Windows](https://dlang.org/dmd-windows.html), or [OSX](https://dlang.org/dmd-osx.html)
instructions to get it installed.

To make sure it's working, run

```bash
$ dmd --version
# DMD64 D Compiler vX.XXX.XX
```
---

To build, run, and test the source code, we use [DUB](https://github.com/dlang/dub).

To install it, follow [these instructions](https://github.com/dlang/dub#installation).

To make sure it's working, run

```bash
$ dub --version
# DUB version Version: X.X.X-X
```

---

ViaRE is built using [SDL2](https://www.libsdl.org/download-2.0.php) and Open GL.

Doing a proper SDL2 installation for development on Windows can be tricky.
[This video](https://www.youtube.com/watch?v=ybYMOKEW9IY) could be useful.

To install SDL2 on Linux, follow official [SDL instructions](https://wiki.libsdl.org/Installation).
We recommend to follow "The Unix Way", as it will avoid missing .so files.

### Installing ViaRE

You'll need [Git](https://git-scm.com/) installed, to clone the repository*.

```
# Clone this repository
$ git clone https://github.com/davidomarf/viare

# Go into the repository
$ cd viare

# Run the app
$ dub run
```

*If you don't want to install git, you can [download it in zip](https://github.com/davidomarf/viare/archive/master.zip),
and unpack it.*

## Running the tests

Just use:

```
dub test
```

This will run every `unittest` inside sourcecode.

## Authors

- [**bitobs**](https://github.com/bitobs) - *Initial work* 
- [**davidomarf**](https://github.com/davidomarf) - *Initial work*

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* **Martin O'Leary**, [@mewo2](https://twitter.com/mewo2), for writing an extensive guide
on [generating fantasy maps](http://mewo2.com/notes/terrain/) and [naming languages](http://mewo2.com/notes/naming-language/)
* **Amit Patel**, [@redblobgames](https://twitter.com/redblobgames), for his writing about
[polygonal map generation](http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation/)

<!---
### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```
### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system
-
## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 
-->
