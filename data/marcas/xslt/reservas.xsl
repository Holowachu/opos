<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
 <head>
     <title>Tabla reservas</title>
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
    <table>
      <thead>
        <tr><th colspan="3">Reserva de salones</th></tr>
       <tr><th>Fecha entrada</th><th>Cliente</th><th>Observaciones</th></tr>
      </thead>
      <tbody>
          <xsl:for-each select="//reserva_salón">
            <xsl:sort select="fechaEntrada/@mes"/>
                <tr>
                    <td><xsl:value-of select="fechaEntrada/@día"/>-<xsl:value-of select="fechaEntrada/@mes"/>-<xsl:value-of select="fechaEntrada/@año"/></td>
                    <td><xsl:value-of select="@cliente"/></td>
                    <td><xsl:value-of select="observaciones"/></td>
                </tr>
        </xsl:for-each>
      </tbody>

    </table>
</body>
</html>

</xsl:template>
</xsl:stylesheet>