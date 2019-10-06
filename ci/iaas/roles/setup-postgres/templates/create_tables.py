import psycopg2

def create_tables():
    """ create tables in the PostgreSQL database"""
    commands = (
        """
        CREATE TABLE task 
        (
            taskID SERIAL PRIMARY KEY, 
            task_lat FLOAT, 
            task_lon FLOAT, 
            description TEXT,
            category VARCHAR(50), 
            comments TEXT,
            photo_id TEXT, 
            originator VARCHAR(40),
            status_code INT   
        )
        """, 
        """ 
        CREATE TABLE public_works
        (
            pwID SERIAL PRIMARY KEY, 
            department VARCHAR(50), 
            email VARCHAR(50)
        )
        """, 
        """
        INSERT INTO public_works (department, email) 
        VALUES ('Drainage Problems', 'cat4manager@gmail.com'), 
               ('Signal Malfunction', 'cat4manager@gmail.com'), 
               ('Sign Damage', 'cat4manager@gmail.com'),
               ('Sidewalk Repair', 'cat4manager@gmail.com'), 
               ('Pothole Hotline', 'cat4manager@gmail.com')
        """
        )

    conn = None

    try:
        # connect to the PostgreSQL server
        conn = psycopg2.connect(host = 'pbc311-db.hackathon2019.nmetech.com', 
                                dbname='pbc311', user='pgadmin', password='{{ postgres_pw }}')
        cur = conn.cursor()

        # create table one by one
        for command in commands:
            cur.execute(command)
        
        # close communication with the PostgreSQL database server
        cur.close()
        
        # commit the changes
        conn.commit()
    
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    
    finally:
        if conn is not None:
            conn.close()
 
 
if __name__ == '__main__':
    create_tables()