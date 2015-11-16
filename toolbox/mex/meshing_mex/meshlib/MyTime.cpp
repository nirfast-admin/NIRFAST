#include "MyTime.h"

MyTime::MyTime()
{
	time_t currentTime = time(&currentTime);;
	tm *temp = localtime(&currentTime);
	_mytime = *temp;
}

MyTime::~MyTime()
{
}

std::string MyTime::GetDate() {
	std::ostringstream temp;

	temp << LeadingZero<int>((this->_mytime.tm_mon+1),1) << this->_mytime.tm_mon + 1 << '/';
	temp << LeadingZero<int>((this->_mytime.tm_mday ),1) << this->_mytime.tm_mday    << '/';
	temp << this->_mytime.tm_year + 1900;
	return temp.str();
}

std::string MyTime::GetTime() {
	std::ostringstream temp;
	
	temp << LeadingZero<int>((this->_mytime.tm_hour),1) << this->_mytime.tm_hour << ':';
	temp << LeadingZero<int>((this->_mytime.tm_min ),1) << this->_mytime.tm_min  << ':';
	temp << LeadingZero<int>((this->_mytime.tm_sec ),1) << this->_mytime.tm_sec;
	return temp.str();
}

std::string MyTime::GetFullDate() {
	char *atime = asctime(&this->_mytime);
	std::string ret(atime);
	return ret;
}
template<class T>
std::string LeadingZero(T a, int order) {
	
	std::string ret("");

	if (a < order*10) {
		ret.assign("0",order);
	}
	return ret;
}
