# AIPscripts_DLG
Scripts used to create AIPs for the Digital Library of Georgia for ingest into preservation repository
************************
These files are presented with no guarantees of fitness for a particular purpose, safety, or that they will work for your needs. They are very specific to our workflow and rely on a particular folder structure (noted below) to work. Please be sure to **_always_** work from a copy of your data! However, with those caveats in mind I hope you can figure out a way to reuse them to save some time and trouble.
************************
This process requires a number of dependencies that are not included in this distribution, but all are freely available online. All of these should be available from your system path so that they can be run on the command line:

* JAVA 8 (1.8) https://java.com/en/download/
* Perl 5.16 https://www.perl.org/
* Python 3.x https://www.python.org/
* FITS (File Information Tool Set) 1.3x https://projects.iq.harvard.edu/fits/home
* 7zip 17 https://www.7-zip.org/
* Bzip2 for Windows 1.0.2 http://gnuwin32.sourceforge.net/packages/bzip2.htm
* Grep for Windows 2.5.4 http://gnuwin32.sourceforge.net/packages/grep.htm



In addition to the files in this repository, you will also need to download the following and make sure the executable files are available in your working directory: 

* Find and Replace Text (http://fart-it.sourceforge.net/) fart.exe must be in your working folder
* Saxon HE XSLT processor (http://saxon.sourceforge.net/) saxon9he.jar must be in your working folder. If the name of the jar file you download is different, you will need to edit this in the stylesheets.
* python-bagit (https://github.com/LibraryOfCongress/bagit-python) bagit.py must be in your working folder
	

NB: the dlg-fits-to-master-stylesheet.xsl will fail if there are conflicting identifications in your FITS xml output. You may need to adjust the tools used in FITS to reconcile conflicts or adjust the stylesheet to accomidate conflicts if you run into issues with this.

# Instructions

## Part 1:

In order for this to work you need to start with this folder structure
Working_folder
	[AIP_NAME] <--folder named with name to be given to eventual AIP
		objects 
			[NAME OF DIGITAL OBJECT] <-- generally this is the same as the AIP name. Your files are in this folder.

The batch files in the make_stub_filesystem directory can help you arrange files into this structure.

## Part 2:

You will also need an xml file containing AIP level metadata. This can be created using a spreadsheet and extracted using XMLBlueprint, Microsoft Excel, or some other utility that is in that line of work. It should look like this example: 

<aip_level>
	<item>
		<aip_id>auu_scimgbng_sc-002-0046</aip_id>
		<aip_version>1</aip_version>
		<group_uri>http://archive.libs.uga.edu/dlg</group_uri>
		<aip_title>Title 1</aip_title>
		<aip_rights>http://rightsstatements.org/vocab/InC/1.0/</aip_rights>
		<dlg_repo>auu</dlg_repo>
		<dlg_coll>scimgbng</dlg_coll>
	</item>
	<item>
		<aip_id>auu_scimgbng_sc-002-0047</aip_id>
		<aip_version>1</aip_version>
		<group_uri>http://archive.libs.uga.edu/dlg</group_uri>
		<aip_title>Title 2</aip_title>
		<aip_rights>http://rightsstatements.org/vocab/InC/1.0/</aip_rights>
		<dlg_repo>auu</dlg_repo>
		<dlg_coll>scimgbng</dlg_coll>
	</item>
	
</aip_level>

Where <aip_id> matches the name of the folder referenced in PART 1.

## Part 3:

Move the runfits_external.bat file to the home directory of your FITS 1.3 installation (where fits.bat is located). To run this script, navigate to the FITS directory and double click it. It will ask you to input the path to the directory containing the folders you are transforming into AIPs (working directory). This can be on your local drive (c) or on an external drive (any letter). Make sure you include the full path including the drive letter (ex: D:\my_working_directory). 

When called by this script, FITS will recursively process the directories in the working folder and put the output (*.fits.xml) in the working directory[aip_id]\objects folder. 

## Part 4:

Copy all other files to the working directory and run the .bat files in the order they are numbered (1.0_move_fits_xml.bat, 2.3-big_combine_xml.bat, 3.3-makemaster.bat, 4.2-prep_bags.bat). Be sure to follow any instructions that appear in the command window and be sure not to close any windows prematurely-- they should close on their own when finished if you follow the screen prompts.


