import org.apache.pdfbox.exceptions.COSVisitorException;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.util.PDFTextStripper;
import java.io.File;



public class StripText{



  public static void main(String[] args) throws Exception{
    File arquivoEntrada = new File(args[0]);
    PDDocument previa = PDDocument.load(arquivoEntrada);
    PDFTextStripper ts = new PDFTextStripper();
    System.out.println(ts.getText(previa));
    previa.close();


  }
}