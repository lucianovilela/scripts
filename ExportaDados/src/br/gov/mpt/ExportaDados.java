package br.gov.mpt;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ExportaDados {

	/**
	 * @param args
	 * @throws ClassNotFoundException 
	 */
	
	private static final String URL="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac-pgt.pgt.mpt.gov.br)(PORT=1521))(LOAD_BALANCE=YES)(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=bnpd)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=180)(DELAY=5))))";
	private static final String USER = "bnpd";
	private static final String PASSWD="2btty7xk";
	private static final String SQL_PROC = "select c.nrsequencial, c.nrcodigo_regional, c.nrcodigo_oficio, c.nrano, "+
										"c.nrdigito_verificador, replace(d.stsigla, ' ', '_') tipo,  a.dtdocumento, a.blarquivo, "+
										"to_char(a.dtinclusao, 'dd_mm_rrrr')  dtinclusao "+
										"from dddocumento a, processo_documento b, "+
										"ppprocesso c, axtipodocumento d "+
										"where "+
										"a.iddocumento = b.iddocumento and "+
										"b.idprocesso = c.idprocesso and "+
										"c.idregional = 12 and "+
										"a.dtinclusao >= to_date('13/02/2011', 'dd/mm/rrrr') and "+
										"a.dtinclusao <= to_date( '23/02/2011', 'dd/mm/rrrr') and "+
										"b.idtipo_documento = d.idtipo";
	
	private static final String SQL_JUD = " select c.stnumero_processo_judicial_cnj, c.stnumero_processo_judicial,  replace(d.stsigla, ' ', '_') tipo,  a.dtdocumento, a.blarquivo, "+
										"to_char(a.dtinclusao, 'dd_mm_rrrr')  dtinclusao  "+
										"from dddocumento a, processo_judicial_documento b, "+
										"ppprocesso_judicial c, axtipodocumento d "+
										"where "+
										"a.iddocumento = b.iddocumento and "+
										"b.idprocesso_judicial = c.idprocesso_judicial and "+
										"c.idregional = 12 and "+
										"a.dtinclusao >= to_date('13/01/2011', 'dd/mm/rrrr') and "+
										"a.dtinclusao <= to_date( '23/01/2011', 'dd/mm/rrrr') and "+
										"b.idtipo_documento = d.idtipo ";
	
	private static final String DIR = "/tmp/export";
	
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		Class.forName("oracle.jdbc.OracleDriver");
		Connection con = DriverManager.getConnection(URL, USER, PASSWD);
		Statement stmt = con.createStatement();
		
		ResultSet rs = stmt.executeQuery(SQL_PROC);
		while(rs.next()){
			String fileName = String.format("%06d.%s.%s.%03d.%s-%s-%s.pdf", rs.getInt("nrsequencial"), rs.getString("nrano"), rs.getString("nrcodigo_regional"),
					rs.getInt("nrcodigo_oficio"), rs.getString("nrdigito_verificador"), 
					rs.getString("tipo"), rs.getString("dtinclusao"));
			printFile(fileName, rs);

			
			
		}
		
		
		rs.close();
		
		rs = stmt.executeQuery(SQL_JUD);
		while(rs.next()){
			String numProc = rs.getString("stnumero_processo_judicial")==null?rs.getString("stnumero_processo_judicial_cnj"):rs.getString("stnumero_processo_judicial");
			String fileName = String.format("%s-%s-%s.pdf",  numProc,
					rs.getString("tipo"), rs.getString("dtinclusao"));
			printFile(fileName, rs);

			
			
		}
		
		stmt.close();
		con.close();

	}
	
	private static void printFile(String fileName, ResultSet rs) throws SQLException{
		byte[] buffer = new byte[2048];
		try {
			FileOutputStream out = new FileOutputStream(DIR + File.separator + fileName );
			InputStream in = rs.getBinaryStream("blarquivo");
			int i = 0;
			while((i=in.read(buffer)) >= 0){
				out.write(buffer, 0, i);
			}
			in.close();
			out.close();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
