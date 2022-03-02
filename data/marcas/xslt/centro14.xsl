<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        
        <centro>
            <xsl:apply-templates select="centro/ciclo"/>
        </centro>
    </xsl:template>
    
    <xsl:template match="ciclo">
        <xsl:element name="{name()}">
            <xsl:attribute name="{@id/name()}" select="@id"/>
            <xsl:attribute name="grao" select="@grao"/>
            <xsl:apply-templates select="módulo"/>
            <xsl:apply-templates select="alumno"/>
        </xsl:element>
            
    </xsl:template>
    
    <xsl:template match="módulo">
      
      <xsl:element name="{name()}">
            <xsl:attribute name="id" select="@id"/>
            <xsl:attribute name="nome" select="nome"/>
            <xsl:attribute name="horas" select="horas"/>
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="alumno">
      
      <xsl:element name="{name()}">
            <xsl:attribute name="id" select="@id"/>
            <xsl:attribute name="nome_apelidos" select="nome_apelidos"/>
            <xsl:attribute name="datanacemento" select="datanacemento"/>
        </xsl:element>
        
    </xsl:template>
</xsl:stylesheet>