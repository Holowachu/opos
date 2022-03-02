<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        
        <html>
            <head>
                <title>Cursos</title>
                <style>
                table, th, tr, td {
                    border: 1px solid;
                    border-collapse: collapse;
                }
                </style>
            </head>
            <body>
                
                <xsl:for-each select="//ciclo">
                    <h1>Ciclo <xsl:value-of select="@id"/></h1>
                    <table>
                        <tr>
                        <th>Alumno</th>
                        <th>Aprobados</th>
                        <th>Suspensos</th>
                        <th>Matriculados</th>
                        </tr>
                        <xsl:apply-templates select="alumno"/>
                    </table>
                </xsl:for-each>

            </body>
        </html>
        
        
    </xsl:template>
    <xsl:template match="alumno">
        <tr>
            <td><xsl:value-of select="nome_apelidos"/></td>
            <td><xsl:value-of select="count(cursa[@nota&gt;=5])"/></td>
            <td><xsl:value-of select="count(cursa[@nota&lt;5])"/></td>
            <td><xsl:value-of select="count(cursa[not(@nota)])"/></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>