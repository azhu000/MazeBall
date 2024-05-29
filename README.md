A physics simulation of a ball moving through a maze by utilizing the sensors (mainly the accelerometer and gyroscope) from a mobile device such as a phone or tablet. 

Given a maze, where the boundaries of the maze are black, an algorithm scans the image of the maze and maps the coordinates of the maze to be classified open space or a wall. 

Using physics and the sensors of the phone, a ball is given simulated movement depending on angle and tilt of the mobile device. 

Using the mapped boundaries, the ball is not permitted to move through the walls of the maze when it is displaced during each update of the sensor. 
This was done via ultizing the Bresenham Line Drawing Algoirthm to determine if the updated position of the ball intersects with a known wall coordinate.

![alt text]([http://url/to/img.png](https://github.com/azhu000/MazeBall/blob/master/example.png))
