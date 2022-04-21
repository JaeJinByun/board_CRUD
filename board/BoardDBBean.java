package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

//싱글톤 패턴 
public class BoardDBBean {
	
	private static BoardDBBean instance = new BoardDBBean();  //static 인스턴스 
	public static BoardDBBean getInstance() {
		return instance;
	}
	public Connection getConnection() throws NamingException, SQLException {
		Context initCtx = new InitialContext();
		Context envCtx  = (Context)initCtx.lookup("java:comp/env");
		DataSource ds   = (DataSource)envCtx.lookup("jdbc/joeun");
		
		return ds.getConnection();
		
	}
	
	public int getCount() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0 ;
		
		try {
			con = getConnection();
			String sql = "select count(*) from board";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1); //1번째의 value 를 가져온다	.							
			}
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {			
			e.printStackTrace();
		} finally {
			try {
				if(con != null) con.close();
				if(pstmt != null)pstmt.close();
				if(rs != null)rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}	
		return count;
	}
	
	public int insertArticle(BoardDataBean dto) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int num = dto.getNum();
		int ref = dto.getRef();
		int re_step = dto.getRe_step();
		int re_level = dto.getRe_level();
		
		/*		제목		ref	   re_step		re_level
		 *	제목글		 8		  0			   0
		 *	 ㄴ답변글		 8		  1			   1
		 *    ㄴ재답변글	 8		  2			   2
		 *  ㄴ나중 답변글    8      0->1		  0->1
		 *
		 */
		
		/*
		 *		제목		ref	   re_step		re_level
		 *	제목글		 8		  0			   0
		 *  ㄴ나중 답변글    8        1		       1
		 *	 ㄴ답변글		 8		  2			   2
		 *    ㄴ재답변글	 8		  3			   3
		 */
		
		String sql = null;
		
		try {
			con = getConnection();
			if(num == 0) {	//제목글인경우
				sql = "select max(num) from board";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if (rs.next()) {	//글이 있는경우
					ref = rs.getInt(1) + 1; //글번호 최대값 + 1
				}else {				//글이 없는경우 
					ref = 1; 				//그룹화 아이디 1부터 시작
				}
				re_step = 0;		//들여쓰기
				re_level = 0;		//
			}else {			//답변글인경우
				sql = "update board set re_step = re_step +1 where ref = ? and re_step > ?"; //나중에 달린 답변글을 위로 올려주기 위함
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_level);
				pstmt.executeUpdate();
				
				re_step++;
				re_level++;
			}
			sql = "insert into board ( num, writer, email, subject, passwd, reg_date, "
					+ "ref, re_step, re_level, content, ip) "
					+ "values(board_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt.close(); //한번 닫고 다시 써야함
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getEmail());
			pstmt.setString(3, dto.getSubject());
			pstmt.setString(4, dto.getPasswd());
			pstmt.setTimestamp(5, dto.getReg_date());
			pstmt.setInt(6, ref);		//ref 를 가공한값으로 넣어야함 
			pstmt.setInt(7, re_step);	//동일
			pstmt.setInt(8, re_level);	//동일
			pstmt.setString(9, dto.getContent());
			pstmt.setString(10,dto.getIp());
			
			result = pstmt.executeUpdate();
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e)    {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
		return result;
	}
	
	//페이징처리
	public ArrayList<BoardDataBean> getArticles( int start, int end){
		ArrayList<BoardDataBean> dtos = null;
		Connection con =null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = getConnection();
			String sql = "select num,writer,email,subject,passwd,";
			sql+= "reg_date,ref,re_step,re_level,content,ip,readcount,r ";
			sql+= "from (select num,writer,email,subject,passwd,reg_date,ref,re_step";
			sql+= ",re_level,content,ip,readcount,rownum r from ";
			sql+= "(select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level ";
			sql+= ",content,ip,readcount from board order by ref desc, re_step asc) ";
			sql+= "order by ref desc, re_step asc ) where r >= ? and r <= ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dtos = new ArrayList<BoardDataBean>();  
				do {
				   BoardDataBean dto = new BoardDataBean();
				   dto.setNum(rs.getInt("num"));
				   dto.setWriter(rs.getString("writer"));
				   dto.setEmail(rs.getString("email"));
				   dto.setSubject(rs.getString("subject"));
				   dto.setPasswd(rs.getString("passwd"));
				   dto.setReg_date(rs.getTimestamp("reg_date"));
				   dto.setReadcount(rs.getInt("readcount"));
				   dto.setRef(rs.getInt("ref"));
				   dto.setRe_step(rs.getInt("re_step"));
				   dto.setRe_level(rs.getInt("re_level"));
				   dto.setContent(rs.getString("content"));
				   dto.setIp(rs.getString("ip"));
				   
				   dtos.add(dto);
				}while(rs.next());
			}
			
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return dtos;
	}
	
	public BoardDataBean getArticle( int num ) {
		BoardDataBean dto = null;
		Connection con =null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = getConnection();
			String sql = "select * from board where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new BoardDataBean();
				dto.setNum(rs.getInt("num"));
				dto.setWriter(rs.getString("writer"));
				dto.setEmail(rs.getString("email"));
				dto.setSubject(rs.getString("subject"));
				dto.setPasswd(rs.getString("passwd"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setRe_level(rs.getInt("re_level"));
				dto.setContent(rs.getString("content"));
				dto.setIp(rs.getString("ip"));
			}
			
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return dto;
	}
	
	//조회수 처리
	public void addCount(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = getConnection();
			String sql = "update board set readcount = readcount + 1 where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
				
	}
	
	
	public int check (int num, String passwd) {
		int result = 0;
		BoardDataBean dto = getArticle( num );
		if(passwd.equals(dto.getPasswd())) {
			result = 1; //비번같다
		}else {
			result = 0; //틀리다
		}
		
		return result;
	}
	
	public int deleteArticle(int num) {
		int result = 0;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; 	//답글이 달린 게시글을 삭제할때 확인하기 위해
		try {
			con = getConnection();
			String sql = "select * from board where ref = ? and re_step = ?+1 and re_level > ?";
			BoardDataBean dto = getArticle(num);
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, dto.getRef());
			pstmt.setInt(2, dto.getRe_step());
			pstmt.setInt(3, dto.getRe_level());
			rs = pstmt.executeQuery();
			
			/*			 ref		re_step			re_level
			 * 제목글 	 10			   0				0	
			 *  ㄴ답글	 10 		   2				1
			 * 	 ㄴ재답글	 10			   3				2
			 * 	ㄴ나중답글	 10			   1				1
			 *  
			 * ref	    ==
			 * re_step  > + 1
			 * re_level >
			 * 
			 */

			if( rs.next() ) { //답글이 있는 경우
				if(pstmt != null) pstmt.close();
				sql = "update board set subject='삭제된 글입니다.',readcount=-1 where num=?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, num);
				result = pstmt.executeUpdate();
				
			} else {	//답글이 없는 경우
				if(pstmt != null) pstmt.close();
				sql = "update board set re_step=re_step-1 where ref=? and re_step>?";
				pstmt = con.prepareStatement(sql); 
				pstmt.setInt(1, dto.getRef());
				pstmt.setInt(2, dto.getRe_step());
				pstmt.executeUpdate();
				if(pstmt != null) pstmt.close();
				
				sql = "delete from board where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, num);
				result = pstmt.executeUpdate();
			}
			
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return result;
	}
	
	public int modifyArticle(BoardDataBean dto) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con =getConnection();
			String sql = "update board set email=?, subject=?, content=?, passwd=? where num=?";
			pstmt = con.prepareCall(sql);
			pstmt.setString(1, dto.getEmail());
			pstmt.setString(2, dto.getSubject());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getPasswd());
			pstmt.setInt(5, dto.getNum());
			
			result = pstmt.executeUpdate();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(con != null) con.close();
				if(pstmt != null) pstmt.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return result;
	}
		
}


















































