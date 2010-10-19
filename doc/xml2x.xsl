<?xml version="1.0" encoding="iso-8859-1"?>

<!--
Copyright (C) 2010 Ludovic Stordeur <ludovic@okazoo.eu>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation; version 2.1 only. with the special
exception on linking described in file LICENSE.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.
-->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="iso-8859-1" indent="yes"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>


  <xsl:param name="backend">html</xsl:param>


  <xsl:template match="/onotify">
    <html>

      <head>
	<title> <xsl:apply-templates select="pagetitle"/> </title>
        <link rel="stylesheet" href="style.css" type="text/css"/>
      </head>

      <body>
	<xsl:if test="$backend='html'"> <h1> <xsl:apply-templates select="title"/> </h1> </xsl:if>

	<xsl:choose>
	  <xsl:when test="$backend='html'">   <xsl:apply-templates select="section|web-section"/> </xsl:when>
	  <xsl:when test="$backend='readme'"> <xsl:apply-templates select="section"/>		  </xsl:when>
	</xsl:choose>

	<xsl:apply-templates select="authors"/>


	<!-- Onotify is W3C compliant -->
	<xsl:if test="$backend='html'">
	  <p>
	    <a href="http://validator.w3.org/check?uri=referer">
	      <img style="border:0;width:88px;height:31px"
		   src="http://www.w3.org/Icons/valid-xhtml10"
		   alt="Valid XHTML 1.0 Strict"/>
	    </a>

	    <a href="http://jigsaw.w3.org/css-validator/check/referer">
              <img style="border:0;width:88px;height:31px"
		   src="http://jigsaw.w3.org/css-validator/images/vcss"
		   alt="CSS Valide !"/>
	    </a>
	  </p>
	</xsl:if>

      </body>
    </html>
  </xsl:template>


  <xsl:template match="/onotify/section//contact">
    <xsl:choose>
      <xsl:when test="$backend='html'">
	<a>
	  <xsl:attribute name="href">mailto:<xsl:value-of select="@email"/> </xsl:attribute>
	  <xsl:value-of select="text()"/>
	</a>
      </xsl:when>
      <xsl:when test="$backend='readme'">
	<xsl:value-of select="text()"/> &lt;<xsl:value-of select="@email"/>&gt;
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template
     match="/onotify/section//* | /onotify/section//@* | /onotify/web-section//* | /onotify/web-section//@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="section" match="/onotify/section">
    <h2> <xsl:value-of select="@name"/> </h2>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/onotify/web-section">
    <xsl:call-template name="section"/>
  </xsl:template>


  <xsl:template match="/onotify/authors">
    <h2>Authors</h2>
    <xsl:apply-templates select="author"/>
  </xsl:template>

  <xsl:template match="/onotify/authors/author">
    <p>
      <xsl:value-of select="text()"/>
      &lt;<xsl:choose>
	<xsl:when test="$backend='html'">
	  <a>
	    <xsl:attribute name="href">mailto:<xsl:value-of select="@email"/> </xsl:attribute>
	    <xsl:value-of select="@email"/>
	  </a>
	</xsl:when>
	<xsl:when test="$backend='readme'"> <xsl:value-of select="@email"/> </xsl:when>
      </xsl:choose>&gt;
    </p>
  </xsl:template>

</xsl:stylesheet>
