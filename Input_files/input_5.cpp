#include <iostream>

int main()
{
	int z = 10;
	do
	{
		z = z-1;
		do
		{
			do
			{
				z = z-1;
				
			} while(z>0);
			z = z-1;
			
		} while(z>0);
		
	} while(z>0);
	
	int b = z - 1;
	z = b-1;
	cout << "Out of loop";
	return 0;
}
