<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" name="xml"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<xsl:for-each select="/aip_level/item">
			<xsl:call-template name="aipmeta"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="aipmeta">
		<xsl:variable name="filename">
			<xsl:value-of select="aip_id"/>
		</xsl:variable>
		<xsl:result-document format="xml" href="{$filename}.xml">
			<aiplevel xmlns="http://dlg.galileo.usg.edu/aiplevel">
				<item>
					<aip_id>
						<xsl:value-of select="aip_id"/>
					</aip_id>
					<aip_version>
						<xsl:value-of select="aip_version"/>
					</aip_version>
					<group_uri>
						<xsl:text>http://archive.libs.uga.edu/dlg</xsl:text>
					</group_uri>
					<aip_title>
						<xsl:value-of select="aip_title"/>
					</aip_title>
					<aip_rights>
						<xsl:value-of select="aip_rights"/>
					</aip_rights>
					<dlg_repo>
						<xsl:value-of select="dlg_repo"/>
					</dlg_repo>
					<dlg_coll>
						<xsl:value-of select="dlg_coll"/>
					</dlg_coll>
				</item>
			</aiplevel>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>