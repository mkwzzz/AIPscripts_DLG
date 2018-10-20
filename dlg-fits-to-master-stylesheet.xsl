<?xml version="1.0" encoding="utf-8"?>
<!-- Stylesheet to transform concatenated FITS xml to master.xml file for UGA ARCHive AIP -->
<!-- Modified from stylesheet created by Adriane Hansen Sept 2017 -->
<!-- right now this basically works if there are no disagreements on identity, creating application, or dates-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:premis="http://www.loc.gov/premis/v3" xmlns:dc="http://purl.org/dc/terms/" xmlns:fits="http://hul.harvard.edu/ois/xml/ns/fits/fits_output" xmlns:aiplevel="http://dlg.galileo.usg.edu/aiplevel">
	<xsl:template match="/">
		<master>
			<dc:title>
				<xsl:value-of select="//aiplevel:aip_title"></xsl:value-of>
			</dc:title>
			<dc:rights>
				<xsl:value-of select="//aiplevel:aip_rights"></xsl:value-of>
			</dc:rights>
			<aip>
				<premis:object>
					<!--
					(required) - PREMIS 1.1
					-->
					<premis:objectIdentifier>
						<premis:objectIdentifierType>
							<xsl:value-of select="//aiplevel:group_uri"/>
						</premis:objectIdentifierType>
						<premis:objectIdentifierValue>
							<xsl:value-of select="//aiplevel:aip_id"/>
						</premis:objectIdentifierValue>
					</premis:objectIdentifier>
					<!--  
					 (required) - PREMIS 1.1
					-->
					<premis:objectIdentifier>
						<premis:objectIdentifierType>
							<xsl:value-of select="//aiplevel:group_uri"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="//aiplevel:aip_id"/>
						</premis:objectIdentifierType>
						<premis:objectIdentifierValue>1</premis:objectIdentifierValue>
					</premis:objectIdentifier>
					<!--
					inserts representation as the object category (required) - PREMIS 1.2
					other options (as of Oct 2017) are bitstream, file, and intellectual entity
					-->
					<premis:objectCategory>representation</premis:objectCategory>
					<premis:objectCharacteristics>
						<!--
						gets every file size from fits/fileinfo/size in the FITS XML and adds the values to give the total size of aip in bytes (optional) - PREMIS 1.5.3
						-->
						<premis:size>
							<xsl:value-of select="format-number(sum(//fits:size),'#')"/>
						</premis:size>
						<!--
						gets values from various fields in fits/identification in the FITS XML and makes a unique list of file formats in the aip based on file name and version (required) - PREMIS 1.5.4
						-->
						<!--FIX: add info from format validation-->
						<xsl:for-each-group select="//fits:identity" group-by="concat(./@format,'|',./fits:version)">
							<xsl:sort select="./@format"/>
							<xsl:sort select="./fits:version"/>
							<premis:format>
								<premis:formatDesignation>
									<premis:formatName>
										<xsl:value-of select="./@format"/>
									</premis:formatName>
									<xsl:if test="./fits:version">
										<premis:formatVersion>
											<xsl:value-of select="./fits:version"/>
										</premis:formatVersion>
									</xsl:if>
								</premis:formatDesignation>
								<xsl:choose>
									<xsl:when test="./fits:externalIdentifier/@type = 'puid'">
										<premis:formatRegistry>
											<premis:formatRegistryName> https://www.nationalarchives.gov.uk/PRONOM</premis:formatRegistryName>
											<premis:formatRegistryKey>
												<xsl:value-of select="./fits:externalIdentifier"/>
											</premis:formatRegistryKey>
											<premis:formatRegistryRole>specification</premis:formatRegistryRole>
										</premis:formatRegistry>
									</xsl:when>
									<xsl:otherwise>
										<!--QUESTION - ok to list all the tools in one note or better to have as separate notes so can report by tool?-->
										<premis:formatNote>Format identified by the following tools: <xsl:for-each select="./fits:tool">
												<xsl:value-of select="@toolname"/>
												<xsl:if test="position()!=last()">
													<xsl:text>, </xsl:text>
												</xsl:if>
											</xsl:for-each>
										</premis:formatNote>
									</xsl:otherwise>
								</xsl:choose>
							</premis:format>
						</xsl:for-each-group>
						<!--
						gets creating application values from fits/fileinfo in FITS XML if present and makes a unique list of creating applications in the aip based on application name and version (optional) - PREMIS 1.5.5
						gets inhibitor values from fits/fileinfo in FITS XML if present and makes a unique list of inhibitors in the aip based on inhibitor type and target (optional) - PREMIS 1.5.6
						-->
						<!-- FIX: doesn't work if there is a conflict because that means there is more than one creatingApplicationName in the fileinfo which is not allowed-->
						<!--COMMENTING THIS OUT AT AIP LEVEL FOR TESTING-->
						<xsl:for-each-group select="//fits:fileinfo" group-by="concat(./fits:creatingApplicationName,'|',./fits:creatingApplicationVersion)">
							<xsl:sort select="./fits:creatingApplicationName"/>
							<xsl:sort select="./fits:creatingApplicationVersion"/>
							<xsl:if test="./fits:creatingApplicationName">
								<premis:creatingApplication>
									<premis:creatingApplicationName>
										<xsl:value-of select="./fits:creatingApplicationName"/>
									</premis:creatingApplicationName>
									<xsl:if test="./fits:creatingApplicationVersion">
										<premis:creatingApplicationVersion>
											<xsl:value-of select="./fits:creatingApplicationVersion"/>
										</premis:creatingApplicationVersion>
									</xsl:if>
									<!--QUESTION - decided not to include date here because I didn't think it made sense in summary form. Is that ok? Weird with deduplication-->
								</premis:creatingApplication>
							</xsl:if>
						</xsl:for-each-group>
						<!--
						gets values from fits/fileinfo in FITS XML if present (required if applicable) - PREMIS 1.5.6
						-->
						<!-- FIX: would not work if there was more than one inhibitor type or target in the same filelist because makes a concat error. But I don't know if that would happen.-->
						<!-- COMMENTING OUT INHIBITIOR SECTION BC DLG WILL NOT GENERALLY USE/TESTING -->
						<!--<xsl:for-each-group select="//fits:fileinfo" group-by="concat(./fits:inhibitorType,'|',./fits:inhibitorTarget)">
							<xsl:sort select="./fits:inhibitorType"/>
							<xsl:sort select="./fits:inhibitorTarget"/>
							<xsl:if test="./fits:inhibitorType">
								<premis:inhibitors>
									<premis:inhibitorType>
										<xsl:value-of select="./fits:inhibitorType"/>
									</premis:inhibitorType>
									<xsl:if test="./fits:inhibitorTarget">
										<premis:inhibitorTarget>
											<xsl:value-of select="./fits:inhibitorTarget"/>
										</premis:inhibitorTarget>
									</xsl:if>
								</premis:inhibitors>
							</xsl:if>
						</xsl:for-each-group>-->
					</premis:objectCharacteristics>
					<premis:relationship>
						<premis:relationshipType>structural</premis:relationshipType>
						<premis:relationshipSubType>Is Member Of</premis:relationshipSubType>
						<premis:relatedObjectIdentifier>
							<premis:relatedObjectIdentifierType>http://archive.libs.uga.edu/dlg</premis:relatedObjectIdentifierType>
							<premis:relatedObjectIdentifierValue>
								<xsl:value-of select="//aiplevel:dlg_repo"/>
							</premis:relatedObjectIdentifierValue>
						</premis:relatedObjectIdentifier>
					</premis:relationship>
					<premis:relationship>
						<premis:relationshipType>structural</premis:relationshipType>
						<premis:relationshipSubType>Is Member Of</premis:relationshipSubType>
						<premis:relatedObjectIdentifier>
							<premis:relatedObjectIdentifierType>http://archive.libs.uga.edu/dlg</premis:relatedObjectIdentifierType>
							<premis:relatedObjectIdentifierValue><xsl:value-of select="//aiplevel:dlg_repo"/>_<xsl:value-of select="//aiplevel:dlg_coll"/></premis:relatedObjectIdentifierValue>
						</premis:relatedObjectIdentifier>
					</premis:relationship>
				</premis:object>
			</aip>
			<!-- creates filelist including all non-xml files in the SIP -->
			<filelist>
				<xsl:for-each select="//fits:fits">
					<xsl:call-template name="premis_object"/>
				</xsl:for-each>
			</filelist>
		</master>
	</xsl:template>
	<xsl:template name="premis_object">
		<premis:object>
			<!--
					 (required) - PREMIS 1.1
					-->
			<premis:objectIdentifier>
				<premis:objectIdentifierType>
					<xsl:value-of select="//aiplevel:group_uri"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="//aiplevel:aip_id"/>
				</premis:objectIdentifierType>
				<premis:objectIdentifierValue>
					<xsl:value-of select="(fits:fileinfo/fits:filepath)"/>
				</premis:objectIdentifierValue>
			</premis:objectIdentifier>
			<!--  
					gets aip-id from fits/fileinfo/filepath in the FITS XML for objectIdentifierType and 	inserts version number of 1 (optional) - PREMIS 1.1 ASK SHEILA AND NICOLE IF WE WANT TO VERSION INDIVIDUAL FILES
					-->
			<!--<premis:objectIdentifier>
						-->
			<!--FIX: want the aip-id part of the fielpath, not the whole thing-->
			<!--
						<premis:objectIdentifierType>http://archive.libs.uga.edu/russell/<xsl:value-of select="(//fits:filepath)[1]"/></premis:objectIdentifierType>
						<premis:objectIdentifierValue>1</premis:objectIdentifierValue>
					</premis:objectIdentifier>-->
			<!--
					inserts representation as the object category (required) - PREMIS 1.2
					other options (as of Oct 2017) are bitstream, file, and intellectual entity 
					DLG default will be "file".
					-->
			<premis:objectCategory>file</premis:objectCategory>
			<!--
					inserts tags for preservation level (optional) - PREMIS 1.3
					DLG default will be to omit this.
					-->
			<!--
					<premis:preservationLevel>
						<premis:preservationLevelType>NEEDS-DATA</premis:preservationLevelType>
						<premis:preservationLevelValue>NEEDS-DATA</premis:preservationLevelValue>
						<premis:preservationLevelRole>NEEDS-DATA</premis:preservationLevelRole>
						<premis:preservationLevelRationale>NEEDS-DATA</premis:preservationLevelRationale>
						<premis:preservationLevelDateAssigned>NEEDS-DATA</premis:preservationLevelDateAssigned>
					</premis:preservationLevel>
					-->
			<premis:objectCharacteristics>
				<!--
						 size of file in bytes (optional) - PREMIS 1.5.3
						-->
				<premis:size>
					<xsl:value-of select="./fits:fileinfo/fits:size"/>
				</premis:size>
				<!-- Fixity -->
				<premis:fixity>
					<premis:messageDigestAlgorithm>
						<xsl:text>MD5</xsl:text>
					</premis:messageDigestAlgorithm>
					<premis:messageDigest>
						<xsl:value-of select="./fits:fileinfo/fits:md5checksum"/>
					</premis:messageDigest>
					<premis:messageDigestOriginator>
						<xsl:text>OIS File Information</xsl:text>
					</premis:messageDigestOriginator>
				</premis:fixity>
				<!--
						gets values from various fields in fits/identification in the FITS XML and makes a unique list of file formats in the aip based on file name and version (required) - PREMIS 1.5.4
						-->
				<!--FIX: add info from format validation-->
				<premis:format>
					<xsl:for-each select="./fits:identification/fits:identity">
						<premis:formatDesignation>
							<premis:formatName>
								<xsl:value-of select="./@format"/>
							</premis:formatName>
							<xsl:if test="./fits:version">
								<premis:formatVersion>
									<xsl:value-of select="./fits:version"/>
								</premis:formatVersion>
							</xsl:if>
						</premis:formatDesignation>
						<xsl:choose>
							<xsl:when test="./fits:externalIdentifier/@type = 'puid'">
								<premis:formatRegistry>
									<premis:formatRegistryName>
										<xsl:text>https://www.nationalarchives.gov.uk/PRONOM</xsl:text>
									</premis:formatRegistryName>
									<premis:formatRegistryKey>
										<xsl:value-of select="./fits:externalIdentifier"/>
									</premis:formatRegistryKey>
									<premis:formatRegistryRole>
										<xsl:text>specification</xsl:text>
									</premis:formatRegistryRole>
								</premis:formatRegistry>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="./fits:tool">
									<premis:formatNote>
										<xsl:text>Format identified by </xsl:text>
										<xsl:value-of select="@toolname"/>
										<xsl:text> version </xsl:text>
										<xsl:value-of select="@toolversion"/>
									</premis:formatNote>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test="./fits:filestatus/fits:well-formed or ./fits:filestatus/fits:valid">
						<premis:formatNote>
							<xsl:text>Format identified as </xsl:text>
							<xsl:if test="./fits:filestatus/fits:well-formed = 'true'">well-formed</xsl:if>
							<xsl:if test="./fits:filestatus/fits:well-formed = 'false'">not well-formed</xsl:if>
							<xsl:text> and </xsl:text>
							<xsl:if test="./fits:filestatus/fits:valid = 'true'">valid</xsl:if>
							<xsl:if test="./fits:filestatus/fits:valid = 'false'">not valid</xsl:if>
							<xsl:text> by </xsl:text>
							<xsl:value-of select="./fits:filestatus/fits:well-formed/@toolname"/>
							<xsl:text> version </xsl:text>
							<xsl:value-of select="./fits:filestatus/fits:well-formed/@toolversion"/>
						</premis:formatNote>
					</xsl:if>
				</premis:format>
				<!--			gets creating application values from fits/fileinfo in FITS XML (optional) - PREMIS 1.5.5
						gets inhibitor values from fits/fileinfo in FITS XML if present and makes a unique list of inhibitors in the aip based on inhibitor type and target (optional) - PREMIS 1.5.6-->
				<xsl:choose>
					<xsl:when test="./fits:fileinfo/fits:creatingApplicationName">
						<premis:creatingApplication>
							<premis:creatingApplicationName>
								<xsl:value-of select="./fits:fileinfo/fits:creatingApplicationName"/>
							</premis:creatingApplicationName>
							<xsl:if test="./fits:fileinfo/fits:creatingApplicationVersion">
								<premis:creatingApplicationVersion>
									<xsl:value-of select="./fits:fileinfo/fits:creatingApplicationVersion"/>
								</premis:creatingApplicationVersion>
							</xsl:if>
							<premis:dateCreatedByApplication>
								<xsl:call-template name="dateCreated"/>
							</premis:dateCreatedByApplication>
						</premis:creatingApplication>
					</xsl:when>
					<xsl:when test="./fits:metadata/fits:image/fits:scanningSoftwareName">
						<premis:creatingApplication>
							<premis:creatingApplicationName>
								<xsl:value-of select="./fits:metadata/fits:image/fits:scanningSoftwareName"/>
							</premis:creatingApplicationName>
						</premis:creatingApplication>
					</xsl:when>
				</xsl:choose>
				<!--
						DLG will probably never use this bc none of our files would have inhibitors. Gets values from fits/fileinfo in FITS XML if present (required if applicable) - PREMIS 1.5.6
						-->
				<!--<premis:inhibitors>
									<premis:inhibitorType><xsl:value-of select="./fits:inhibitorType"/></premis:inhibitorType>
									<xsl:if test="./fits:inhibitorTarget">
										<premis:inhibitorTarget><xsl:value-of select="./fits:inhibitorTarget"/></premis:inhibitorTarget>
									</xsl:if>
								</premis:inhibitors>-->
			</premis:objectCharacteristics>
			<!--
					for related collection (required if applicable) - PREMIS 1.13
					inserts Russell Library as the group
					need to supply collection uri for the value
					may also skip in master.xml and use the ingest interface to associate with the collection
					-->
			<premis:relationship>
				<premis:relationshipType>structural</premis:relationshipType>
				<premis:relationshipSubType>Is Member Of</premis:relationshipSubType>
				<premis:relatedObjectIdentifier>
					<premis:relatedObjectIdentifierType>
						<xsl:value-of select="//aiplevel:group_uri"/>
					</premis:relatedObjectIdentifierType>
					<premis:relatedObjectIdentifierValue>
						<xsl:value-of select="//aiplevel:aip_id"/>
					</premis:relatedObjectIdentifierValue>
				</premis:relatedObjectIdentifier>
			</premis:relationship>
		</premis:object>
	</xsl:template>
	<xsl:template name="dateCreated">
		<!-- TODO MW: change to use first instance of created (date) in case of multiple instances in one FITS record -->
		<!-- TODO MW change to fall back to first instance of date modified if created (date) unavailable-->
		<xsl:variable name="dateString">
			<xsl:value-of select="substring-before((./fits:fileinfo/fits:created), ' ')"/>
		</xsl:variable>
		<xsl:value-of select="replace($dateString, ':', '-')"/>
	</xsl:template>
</xsl:stylesheet>