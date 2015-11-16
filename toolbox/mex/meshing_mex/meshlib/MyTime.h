#ifndef __CMyTime
#define __CMyTime

#include <time.h>
#include <sstream>


template <class T>
std::string LeadingZero(T a, int order);

class MyTime
{
public:
	MyTime();
	std::string GetTime();
	std::string GetDate();
	std::string GetFullDate();
	~MyTime();
private:
	tm _mytime;

};

#endif
