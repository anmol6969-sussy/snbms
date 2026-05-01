<%@ page import="java.sql.*, com.snbms.config.DatabaseConfig" %>
<%
try (Connection conn = DatabaseConfig.getConnection();
     Statement stmt = conn.createStatement();
     ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {
    out.println("USERS DUMP:<br>");
    while (rs.next()) {
        out.println("ID=" + rs.getInt("id") + 
                    ", User=" + rs.getString("username") + 
                    ", Pass=" + rs.getString("password") + 
                    ", Role=" + rs.getString("role") + 
                    ", Status=" + rs.getString("status") + "<br/>");
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
