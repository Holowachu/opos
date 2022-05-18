#!/bin/sh
#npx xslt3 -xsl:Rusia.xsl -s:Rusia2018.xml -o:test.html
npx xslt3 -xsl:$1 -s:$2 -o:$3