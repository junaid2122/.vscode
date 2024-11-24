import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.Scanner;

public class jdbc {
    public static void main(String[] args) {
        Connection con = null;
        Statement stmt = null;
        Scanner scanner = new Scanner(System.in);

        try {
            // Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection to the MySQL database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/databasePr", "root", "root2122");
            stmt = con.createStatement();
            
            int choice;
            do {
                // Display menu options to the user
                System.out.println("\n--- Menu ---");
                System.out.println("1. Create Table");
                System.out.println("2. Insert Records");
                System.out.println("3. Update Record");
                System.out.println("4. Delete Record");
                System.out.println("5. Display Records");
                System.out.println("6. Exit");
                System.out.print("Enter your choice: ");
                choice = scanner.nextInt();

                switch (choice) {
                    case 1:
                        // Create table
                        String createQuery = "CREATE TABLE IF NOT EXISTS Stud (id INT PRIMARY KEY, name VARCHAR(50), marks INT)";
                        stmt.executeUpdate(createQuery);
                        System.out.println("Table created.");
                        break;

                    case 2:
                        // Insert records dynamically
                        System.out.print("Enter student ID: ");
                        int id = scanner.nextInt();
                        scanner.nextLine();  // Consume the newline character
                        System.out.print("Enter student name: ");
                        String name = scanner.nextLine();
                        System.out.print("Enter student marks: ");
                        int marks = scanner.nextInt();

                        String insertQuery = "INSERT INTO Stud (id, name, marks) VALUES (" + id + ", '" + name + "', " + marks + ")";
                        stmt.executeUpdate(insertQuery);
                        System.out.println("Record inserted.");
                        break;

                    case 3:
                        // Update record
                        System.out.print("Enter the ID of the student to update: ");
                        int idToUpdate = scanner.nextInt();
                        System.out.print("Enter new marks: ");
                        int newMarks = scanner.nextInt();
                        String updateQuery = "UPDATE Stud SET marks=" + newMarks + " WHERE id=" + idToUpdate;
                        stmt.executeUpdate(updateQuery);
                        System.out.println("Record updated.");
                        break;

                    case 4:
                        // Delete record
                        System.out.print("Enter the ID of the student to delete: ");
                        int idToDelete = scanner.nextInt();
                        String deleteQuery = "DELETE FROM Stud WHERE id=" + idToDelete;
                        stmt.executeUpdate(deleteQuery);
                        System.out.println("Record deleted.");
                        break;

                    case 5:
                        // Display records
                        String selectQuery = "SELECT * FROM Stud";
                        ResultSet rs = stmt.executeQuery(selectQuery);
                        System.out.println("\nID\tName\tMarks");
                        while (rs.next()) {
                            System.out.println(rs.getInt("id") + "\t" + rs.getString("name") + "\t" + rs.getInt("marks"));
                        }
                        break;

                    case 6:
                        // Exit
                        System.out.println("Exiting program...");
                        break;

                    default:
                        System.out.println("Invalid choice! Please select a valid option.");
                        break;
                }
            } while (choice != 6);

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
                scanner.close();
            } catch (Exception e) {
                System.out.println("Error closing resources: " + e);
            }
        }
    }
}