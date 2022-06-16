<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="html" />
    <xsl:template match="/">
        <html>
            <head>
                <title>Historial de compras</title>
                <style>
                    th {
                        text-align: center;
                        background-color: #ddd;
                    }
                    table, tr, td, th {
                        border: solid;
                        border-collapse: collapse;
                    }
                </style>
            </head>
            <body>

                <xsl:for-each select="//cliente">
                            <xsl:sort select="@ID" />
                            <h2><xsl:value-of select="concat(nombre,' (', @ID, ')')"/></h2>
                            <xsl:for-each select=".//compra">
                                <h3>Compra realizada el <xsl:value-of select="@fecha"/></h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Artículo</th>
                                            <th>Cantidad</th>
                                            <th>Precio por unidad</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select=".//articulo">
                                            <tr>
                                                <td><xsl:value-of select="//producto[@ID = current()/producto]/nombreProducto"/></td>
                                                <td><xsl:value-of select="cantidad"/></td>
                                                <td><xsl:value-of select="//producto[@ID = current()/producto]/precio"/></td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="3">
                                                <xsl:call-template name="sum">
                                                    <xsl:with-param name="nodes" select="current()//articulo"/>
                                                </xsl:call-template>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </xsl:for-each>
                            
                </xsl:for-each>
                
            </body>
        </html>

    </xsl:template>

    <xsl:template name="sum">
        <xsl:param name="nodes" />
        <xsl:param name="sum" select="0" />

        <xsl:variable name="current" select="$nodes[1]" />

        <xsl:if test="$current"> 
            <xsl:call-template name="sum">
                <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]" />
                <xsl:with-param name="sum" select="$sum + $current/cantidad *  //producto[@ID = $current/producto]/precio" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="not($current)">
            <xsl:value-of select="$sum" />
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>