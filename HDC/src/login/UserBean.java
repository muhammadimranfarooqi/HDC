package login;




	public class UserBean {
		
	      private String username;
	      private String password;
	      private String firstName;
	      private String lastName;
	      private String emp_id;
	      private String user_id;
	      private String role;

	      public boolean valid;
		
		
	      public String getRole() {
			return role;
		}

		public void setRole(String role) {
			this.role = role;
		}

		public String getUser_id() {
			return user_id;
		}

		public void setUser_id(String user_id) {
			this.user_id = user_id;
		}

		public String getEmp_id() {
			return emp_id;
		}

		public void setEmp_id(String emp_id) {
			this.emp_id = emp_id;
		}

		public void setUsername(String username) {
			this.username = username;
		}

		public String getFirstName() {
	         return firstName;
		}

	      public void setFirstName(String newFirstName) {
	         firstName = newFirstName;
		}

		
	      public String getLastName() {
	         return lastName;
				}

	      public void setLastName(String newLastName) {
	         lastName = newLastName;
				}
				

	      public String getPassword() {
	         return password;
		}

	      public void setPassword(String newPassword) {
	         password = newPassword;
		}
		
				
	      public String getUsername() {
	         return username;
				}

	      public void setUserName(String newUsername) {
	         username = newUsername;
				}

					
	      public boolean isValid() {
	         return valid;
		}

	      public void setValid(boolean newValid) {
	         valid = newValid;
		}	
	}


