<p align="center">
  <img src="https://raw.githubusercontent.com/PKief/vscode-material-icon-theme/ec559a9f6bfd399b82bb44393651661b08aaf7ba/icons/folder-markdown-open.svg" width="100" alt="project-logo">
</p>
<p align="center">
    <h1 align="center">SPAPS Art Photogrammetry Robot</h1>
</p>
<p align="center">
    <em><code>SPAPS (Stereo-Photogrammetry Art Preservation System) MATLAB code to control a custom made robot designed to create 3D models of paintings and sculptures based on orthogonally-taken pictures.</code></em>
</p>

<br><!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary><br>

- [ Overview](#-overview)
- [ Features](#-features)
- [ Repository Structure](#-repository-structure)
- [ Modules](#-modules)
- [ Getting Started](#-getting-started)
  - [ Installation](#-installation)
  - [ Usage](#-usage)
  - [ Tests](#-tests)
- [ Project Roadmap](#-project-roadmap)
- [ Contributing](#-contributing)
- [ License](#-license)
- [ Acknowledgments](#-acknowledgments)
</details>
<hr>

##  Overview

<code>This repository contains the MATLAB code for a custom-made robotic system designed to create 3D models of paintings and sculptures using orthogonally-taken pictures via stereophotogrammetry. The system manages motor control, camera operations, lighting adjustments, and integrates user inputs through a sophisticated MATLAB GUI.</code>

Find more information in [Informe de Diseño de Software](#acknowledgments)

---

##  Features

**Motor Control:** Adjust motor positions manually through interface sliders or input fields for precise movement control.
**Lighting System:** Utilize the slider to adjust LED wavelengths and use the sequence button to cycle through different wavelengths automatically.
**Camera Control:** Set camera parameters such as shutter speed, aperture, and ISO through respective sliders. Use autofocus or manual focus to adjust the camera's focus settings.
**Automation:** Set up initial positions and define grid size and step size for automated 3D model creation. Start the automated process via the interface and monitor progress through a dynamic progress bar.

---

## Directory Description

**`/libximc-2.13.3-all`** - Contains the libximc library needed for motor control.
**`LibXimc.m`** - MATLAB class for interfacing with the libximc motor control library.
**`PhotogrammetryRobot.m`** - Main MATLAB class file for controlling the robotic system. Main class file containing methods for system operations including motors, camera, and lighting.
**`PhotogrammetryRobotApp.mlapp`** - MATLAB App Designer file for the GUI.
**`escudo.jpg`** - Institution image file used within the app.

---

##  Repository Structure

```sh
└── spaps_art_photogrammetry/
    ├── README.md
    └── RobotApp
        ├── LibXimc.m
        ├── PhotogrammetryRobot.m
        ├── PhotogrammetryRobotApp.mlapp
        ├── escudo.jpg
        └── libximc-2.13.3-all
```

---

##  Modules

<details closed><summary>RobotApp</summary>

| File                                                                                                                              | Summary                         |
| ---                                                                                                                               | ---                             |
| [LibXimc.m](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/LibXimc.m)                         | <code>► INSERT-TEXT-HERE</code> |
| [PhotogrammetryRobot.m](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/PhotogrammetryRobot.m) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.driver</summary>

| File                                                                                                                                                  | Summary                         |
| ---                                                                                                                                                   | ---                             |
| [Standa_8SMC4-5.inf](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/driver/Standa_8SMC4-5.inf) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc</summary>

| File                                                                                                                                  | Summary                         |
| ---                                                                                                                                   | ---                             |
| [test.txt](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/test.txt)       | <code>► INSERT-TEXT-HERE</code> |
| [LICENSE.txt](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/LICENSE.txt) | <code>► INSERT-TEXT-HERE</code> |
| [ximc.h](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/ximc.h)           | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win64</summary>

| File                                                                                                                                        | Summary                         |
| ---                                                                                                                                         | ---                             |
| [libximc.def](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win64/libximc.def) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win64.wrappers.matlab</summary>

| File                                                                                                                                                | Summary                         |
| ---                                                                                                                                                 | ---                             |
| [ximcm.h](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win64/wrappers/matlab/ximcm.h) | <code>► INSERT-TEXT-HERE</code> |
| [ximcm.m](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win64/wrappers/matlab/ximcm.m) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win64.wrappers.csharp</summary>

| File                                                                                                                                                      | Summary                         |
| ---                                                                                                                                                       | ---                             |
| [ximcnet.cs](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win64/wrappers/csharp/ximcnet.cs) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.crossplatform.wrappers.python</summary>

| File                                                                                                                                                            | Summary                         |
| ---                                                                                                                                                             | ---                             |
| [pyximc.py](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/crossplatform/wrappers/python/pyximc.py) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win32</summary>

| File                                                                                                                                        | Summary                         |
| ---                                                                                                                                         | ---                             |
| [libximc.def](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win32/libximc.def) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win32.wrappers.matlab</summary>

| File                                                                                                                                                | Summary                         |
| ---                                                                                                                                                 | ---                             |
| [ximcm.h](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win32/wrappers/matlab/ximcm.h) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win32.wrappers.delphi</summary>

| File                                                                                                                                                  | Summary                         |
| ---                                                                                                                                                   | ---                             |
| [ximc.pas](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win32/wrappers/delphi/ximc.pas) | <code>► INSERT-TEXT-HERE</code> |

</details>

<details closed><summary>RobotApp.libximc-2.13.3-all.ximc.win32.wrappers.csharp</summary>

| File                                                                                                                                                      | Summary                         |
| ---                                                                                                                                                       | ---                             |
| [ximcnet.cs](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/master/RobotApp/libximc-2.13.3-all/ximc/win32/wrappers/csharp/ximcnet.cs) | <code>► INSERT-TEXT-HERE</code> |

</details>

---

##  Getting Started

**Prerequisites**

Ensure you have MATLAB installed with the following toolboxes:

* Image Acquisition Toolbox
* Instrument Control Toolbox
* MATLAB Support Package for Arduino Hardware

Also, ensure the following hardware is connected:

* 3-axis motor system
* Arduino board
* Camera (compatible with Image Acquisition Toolbox)
* Joystick (compatible with Instrument Control Toolbox)

**Libraries and Packages**

Before running the software, load the required libraries:

* `libximc` for motor control
* Driver for the camera (ensure `tisimaq_r2013_64` or similar is installed)

###  Installation

<h4>From <code>source</code></h4>

> 1. Clone the spaps_art_photogrammetry repository:
>
> ```console
> $ git clone https://github.com/Alexpascual28/spaps_art_photogrammetry.git
> ```
>
> 2. Change to the project directory:
> ```console
> $ cd spaps_art_photogrammetry
> ```
>
> 3. Ensure that the **libximc** library is properly set up by following these steps:
> 
> Navigate to the `libximc-2.13.3-all` directory.
> Depending on your operating system, install the necessary drivers and bindings for MATLAB.

###  Usage

To start the application, run the **`PhotogrammetryRobotApp.mlapp`** file in MATLAB. The GUI will guide you through the process of connecting to the hardware components and starting the image capture process.

###  Tests

> Run the test suite using the command below:
> ```console
> $ /* No common unit test framework in C */
> ```

---

##  Project Roadmap

- [X] `► INSERT-TASK-1`
- [ ] `► INSERT-TASK-2`
- [ ] `► ...`

---

##  Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/issues)**: Submit bugs found or log feature requests for the `spaps_art_photogrammetry` project.
- **[Submit Pull Requests](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/Alexpascual28/spaps_art_photogrammetry.git/discussions)**: Share your insights, provide feedback, or ask questions.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/Alexpascual28/spaps_art_photogrammetry.git
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="center">
   <a href="https://github.com{/Alexpascual28/spaps_art_photogrammetry.git/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=Alexpascual28/spaps_art_photogrammetry.git">
   </a>
</p>
</details>

---

##  License

This project is protected under the [SELECT-A-LICENSE](https://choosealicense.com/licenses) License. For more details, refer to the [LICENSE](https://choosealicense.com/licenses/) file.

---

##  Acknowledgments

- List any resources, contributors, inspiration, etc. here.

[**Return**](#-overview)

---
