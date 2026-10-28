import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SqlInjectionDemo {
    public ResultSet findUser(Connection connection, String username) throws SQLException {
        String query = "SELECT * FROM users WHERE username = '" + username + "'";
        Statement statement = connection.createStatement();
        return statement.executeQuery(query);
    }
}
