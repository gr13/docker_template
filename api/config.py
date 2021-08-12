import os

SQLALCHEMY_DATABASE_URI = f"mysql+mysqlconnector://{os.environ['MYSQL_USER']}:{os.environ['MYSQL_PASSWORD']}@localhost:32000/{os.environ['MYSQL_DB']}"
# SQLALCHEMY_DATABASE_URI = f"mysql+pymysql://{os.environ['MYSQL_USER']}:{os.environ['MYSQL_PASSWORD']}@localhost/{os.environ['MYSQL_DB']}"
print("")
print("SQLALCHEMY_DATABASE_URI:", SQLALCHEMY_DATABASE_URI)