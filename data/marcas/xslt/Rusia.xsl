<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

<xsl:template match="/">

<xsl:element name="resultados">
    <xsl:for-each select="/rusia2018/partidos">
        <xsl:element name="jornada">
            <xsl:attribute name="numero" select="@jornada"/>
            <xsl:for-each select="partido">
                <xsl:element name="{name()}">
                    <xsl:element name="selecciones">
                        <xsl:value-of select="concat(@equi1,'-',@equi2)"/>
                    </xsl:element>
                    <xsl:element name="resultado">
                        <xsl:value-of select="concat(count(gol[@equipo=parent::partido/@equi1]),'-',count(gol[@equipo=../@equi2]))"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:for-each>
</xsl:element>

</xsl:template>
</xsl:stylesheet>