import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import java.io.*;
import java.util.*; 
import javax.xml.parsers.*; 
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.*;

class OpositorException extends Exception {

    public OpositorException(String texto) {
        /* Opción 1 */
        // super("Excepción Opositor: "+texto);
        super(texto);
    }

    // Opción 2 por la descripción debe ser la que querían => CHAPUZADA
    @Override
    public String getMessage() {
        return "Excepción Opositor: " + super.getMessage();
    }

}

class XmlFileGenerator {
    /*
     * public static List<String> splitTokenFromExtring(String linea) throws
     * OpositorException {
     * try {
     * List<String> tokens = List.of(linea.split(","));
     * return tokens;
     * } catch (Exception e) {
     * throw new OpositorException("Error separando tokens: "+e.getMessage());
     * }
     * }
     */
    public static List<String> splitTokenFromExtring(String linea) {
        List<String> tokens = List.of(linea.split(","));
        return tokens;
    }

    public static Opositor createOpositorXmlNode(List<String> datos) throws OpositorException {
        Opositor o = new Opositor();
        try {
            o.setDNI(datos.get(0));
            datos.remove(0);
            for (String correo : datos) {
                o.setCorreo(correo);
            }
        } catch (Exception e) {
            throw new OpositorException("Error creando Opositor: " + e.getMessage());
        }
        return o;
    }
}

public class Opositor implements Serializable {
    private String DNI;
    private Set<String> correos;

    public Opositor() {
        correos = new HashSet<String>();
    }

    public void setDNI(String dni) throws OpositorException {
        Pattern p = Pattern.compile("^[0-9]{7,8}[a-zA-Z]$");
        Matcher m = p.matcher(dni);
        if (!m.find()) {
            throw new OpositorException("DNI no válido: " + dni);
        }
        DNI = dni.toUpperCase();
    }

    public String getDNI() {
        return DNI;
    }

    public void setCorreo(String correo) throws OpositorException {
        Pattern p = Pattern.compile(
                "^[a-zA-Z\\_][0-9a-zA-Z\\_\\.]*@[0-9a-zA-Z]{2,}[0-9a-zA-Z\\_\\.]*\\.[0-9a-zA-Z\\_]{2,}$");
        Matcher m = p.matcher(correo);
        if (!m.find()) {
            throw new OpositorException("correo no válido: " + correo);
        }
        correos.add(correo.toUpperCase());
    }

    public List<String> getCorreos() {
        return correos.stream().toList();
    }

    public static void createXMLFile(String txtFile, String xmlFile) throws OpositorException{
        try{ 
            // Ler o ficheiro de texto e gardar os datos nunha lista de obxectos de 
            // tipo Opositor:

        //A DESENVOLVER APARTADO D[...] 
        Scanner lectorFicheiro = null;
        StringReader sr = new StringReader(txtFile); // si tiene el texto
        FileReader fr = new FileReader(txtFile);  //Si tiene el nombre del fichero
        lectorFicheiro = new Scanner(fr);
        List<Opositor> lo =  new ArrayList<Opositor>();
        while (lectorFicheiro.hasNextLine()) {
            String linea = lectorFicheiro.nextLine();
            lo.add(XmlFileGenerator.createOpositorXmlNode(XmlFileGenerator.splitTokenFromExtring(linea))) ;
        }

        // Create DOM:

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(); 
        DocumentBuilder builder = factory.newDocumentBuilder(); 
        DOMImplementation implementation = builder.getDOMImplementation(); 
        // Create document (root of the XML file) and set version:
        Document doc = implementation.createDocument(null, "opositores", null); 
        doc.setXmlVersion("1.0"); 
        // Get the root element:
        Element root = doc.getDocumentElement(); 
        // Recorrer a lista de opositores e ir xerando a estrutura XML 
        // que logo se almacenará no ficheiro:

        //A DESENVOLVER APARTADO D[...] 
        for (Opositor opositor : lo) {
           var op = doc.createElement("opositor");
           var dni = doc.createElement("dni");
           dni.setNodeValue(opositor.getDNI());
           op.appendChild(dni);
           for (String email : opositor.getCorreos()) {
            var c = doc.createElement("correo");
            c.setNodeValue(email);
            c.setAttribute("name", "value");
            /*
            c.setAttribute("name", "value");
            //otra forma
            var test = doc.createAttribute("test");
            test.setNodeValue("valor atributo");
            c.setAttributeNode(test);

            
            */
            op.appendChild(c);
           }
           root.appendChild(op);
        }
       
        // Write to file:

        Source source = new DOMSource(doc); 
        Result result = new StreamResult(new java.io.File(xmlFile)); 
        Transformer trans = TransformerFactory.newInstance().newTransformer(); 
        trans.setOutputProperty(OutputKeys.INDENT, "yes");
        trans.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); trans.transform(source, result);
        } catch (Exception e) { 
            //A DESENVOLVER APARTADO D[…]
            throw new OpositorException(e.getMessage());
        }
    }
    public static void main(String[] args) {
        try {
            Opositor o = new Opositor();
            o.setDNI("1234567a");
            o.setDNI("1234567A");
            o.setDNI("12345678a");
            o.setDNI("12345678B");
            // o.setDNI("12345,b");
            o.setCorreo("luis@tonto.pepe.com");
            System.out.println(List.of("12,2,3".split(",")));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        System.out.println("Funcionando correctamente");
    }
}
