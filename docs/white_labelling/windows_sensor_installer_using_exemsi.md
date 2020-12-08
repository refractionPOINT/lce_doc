# White labelling the LimaCharlie installer for Windows

You can white label the LimaCharlie installer for Windows by using an MSI wrapper.  By going through this process you can not only brand the installer to show your name / details, but you can also make installation of the sensor easier for end users.  We have provided instructions below on how to use a 3rd party tool called [exemsi](exemsi.com).



<u>Table of Contents</u>

[Prerequisites](#Prerequisites)

[Instructions](#Instructions)

[Experience when running the MSI](#Experience)




<a name="Prerequisites"></a>
## Prerequisites

1.  An MSI wrapper application, such as the exemsi application referenced in the instructions below

2. A digital code signing certificate from Microsoft (optional, but highly recommended)



Without a digital code signing certificate from Microsoft, the installer will show a warning that the MSI installer is from an unknown publisher.

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/uac-signed.png" alt="UAC Signed" style="zoom:80%;" /> - vs - <img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/uac-warning.png" alt="UAC Warning" style="zoom:80%;" />



<a name="Instructions"></a>
## Instructions

1. Download the [LimaCharlie sensor EXE](https://app.limacharlie.io/get/windows/64)
2. Download the [MSI Wrapper application from exemsi.com](https://exemsi.com)
3. Install the exemsi application on your computer
4. Launch the exemsi application and go through the EXE to MSI Converter Wizard steps as shown below:

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_1_-_First_screen_after_launch.png" alt="exemsi" style="zoom:100%;" />



5. Select the executable

- Set the `Setup executable input file name` to be the LimaCharlie EXE that you'd downloaded
- Optionally, specify a MSI output file name of your choosing (e.g. Acme_Installer.msi)
- Set the MSI platform architecture to match the executable (i.e. x86 for 32-bit, and x64 for 64-bit)

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_2_-__Select_the_executable.png" alt="exemsi" style="zoom:100%;" />



6. Set the visibility in Apps & features

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_3_-_Visibility_in_Apps_&_features.png" alt="exemsi" style="zoom:100%;" />



7. Set the Security and User Context

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_4_-_Security_and_User_Context.png" alt="exemsi" style="zoom:100%;" />



8. Specify Application IDs

- In the Upgrade Code section, click the "Create New" button next to generate a code.  This will be used to allow uninstallation.

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_5_-_Application_Ids.png" alt="exemsi" style="zoom:100%;" />



9. Specify Properties (optional: customize options here to have the installer show your brand)

- You can change the drop-down menu of each line item from "Executable" to "Manual" in order to set your own values for the Product Name, Manufacturer, Version, Comments, and Product icon

*Original*

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_6a_-_Properties_-_Defaults.png" alt="exemsi" style="zoom:100%;" />



*Customized*

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_6b_-_Properties_-_Customized.png" alt="exemsi" style="zoom:100%;" />



10. Specify More Properties (optional)

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_7_-_More_properties.png" alt="exemsi" style="zoom:100%;" />



11. Specify Parameters
    - In the "Install arguments" box, enter "-i", add a space and then enter your [installation key](https://doc.limacharlie.io/docs/documentation/docs/manage_keys.md)
    - -i YOUR_INSTALLATION_KEY_GOES_HERE

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_8b_-_Parameters_-_filled.png" alt="exemsi" style="zoom:100%;" />



To provide the option to uninstall, set the Uninstall argument to "-c" (note that you do not need to specify your installation key for uninstallation).



12. Actions

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_9_-_Actions.png" alt="exemsi" style="zoom:100%;" />



13. Summary

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_10_-_Summary.png" alt="exemsi" style="zoom:100%;" />



14. Status

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Wrapper_-_11_-_Status.png" alt="exemsi" style="zoom:100%;" />


Once you have created the MSI package you should sign it using your digital signature.  You can [learn more about signing the MSI on the exemsi website](https://www.exemsi.com/documentation/sign-your-msi/).

***


<a name="Experience"></a>
## Experience when running the MSI

When installing the application using the MSI you'll see your application name in the title bar.

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/MSI_Installation.png" alt="exemsi" style="zoom:100%;" />



When inspecting the properties of the MSI you'll see the details you'd specified.

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/Created_MSI_Properties-Details.png" alt="exemsi" style="zoom:100%;" />



In the Apps & Features section of Windows, you'll see the application listed under your name.

<img src="https://storage.googleapis.com/limacharlie-io/doc/white-label/exemsi-instructions/Shown_in_Control_Panel_-_Apps_and_Features.png" alt="exemsi" style="zoom:100%;" />

***
