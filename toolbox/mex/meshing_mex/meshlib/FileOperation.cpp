#include "FileOperation.h"

CFileOperation::CFileOperation(){
}

CFileOperation::~CFileOperation(){
}

void CFileOperation::readSPRHeader(std::string inputFile, short *row, short *column, 
                short *slice, short *dimension, std::string& dataType){
    

    std::ifstream fp;
    std::string s;
    char *readLine=new char[10000]; // read a line each time
    char *header;       // read the first token to decide information type
    short  numDim=0;

    fp.open(inputFile.c_str(),std::ios::in);
    if (fp.fail()) {
        std::cout << "Cannot open input file: " << inputFile << std::endl;
        exit(1);
    }  
    char seps[]   = " :";


    while ( !fp.eof() ) {
        GetLine(fp,s);
        s.copy(readLine,std::string::npos);
        readLine[s.length()]=0;
        header = strtok( readLine, seps );

        while (header != NULL /*|| !fp.eof()*/) {
            if ( ! strcmp(header, "numDim")) {
                header=strtok( NULL, seps );
                numDim = atoi(header);
            }
            if ( ! strcmp(header, "dim")) {
                *row = atoi(header=strtok( NULL, seps ));
                
                *column = atoi(header=strtok( NULL, seps ));
                if (numDim>2)
                    *slice = atoi(header=strtok( NULL, seps ));
                else
                    *slice = 1;
                if (numDim>3) {
                    header=strtok( NULL, seps );
                    if (header != NULL) {
                        *dimension = atoi(header);
                    }
                }
                else {
                    *dimension = 1;
                    continue;
                }
            }
            if ( ! strcmp(header, "dataType")) {
                header=strtok( NULL, seps );
                //temp = strtok( NULL, seps );
                dataType = header;
            }
            header = strtok(NULL, seps);
        }
    } 
    fp.close();
}
void CFileOperation::readACQPHeader(std::string inputFile, short *row, short *column, short *slice, short *dimension, std::string& dataType) {

    std::ifstream fp;
    std::string s;
    char *readLine=new char[10000]; // read a line each time
    char *header;       // read the first token to decide information type
    //short  numDim;
    int bytes;

    fp.open(inputFile.c_str(), std::ios::in);
    if (fp.fail()) {
        std::cout << "Cannot open input file: " << inputFile << std::endl;
        exit(1);
    }  
    char seps[]   = " :";


    while ( !fp.eof() ) {
        GetLine(fp,s);
        s.copy(readLine,std::string::npos);
        readLine[s.length()]=0;
        header = strtok( readLine, seps );

        while (header != NULL /*|| !fp.eof()*/) {
            if ( !strcmp(header, "Slices")) {
                header = strtok(NULL, seps);
                *slice = atoi(header);
            }
            if ( !strcmp(header, "Pixels") ) {
                header = strtok(NULL, seps);
                *row = atoi(header);
                *column = *row;
            }
            if ( !strcmp(header, "Bytes") ) {
                header = strtok(NULL, "_");
                bytes = atoi(header);
                if (bytes==32)
                    dataType = "WORD"; // Yeah, strange ! but that's what Bruker systems says for its word size !
            }
            if ( !strcmp(header, "Timesteps") ) {
                header = strtok(NULL, seps);
                *dimension = atoi(header);
            }
            header = strtok(NULL, seps);
        }
    }
    fp.close();
}

// Searches for OldExt in filename fileTarg and replaces it with NewExt
std::string CFileOperation::MakeFilename(std::string fileTarg, std::string OldExt, std::string NewExt){

    std::string ret;
    if (fileTarg.rfind(NewExt.c_str()) == fileTarg.length()-4) // if found new extension
        return fileTarg;
    if (OldExt.length() == 0 || fileTarg.find(OldExt.c_str()) == std::string::npos) // if no extion or did not find old extension
        ret = fileTarg.insert(fileTarg.length(),NewExt.c_str());
    else if (fileTarg.rfind(OldExt.c_str()) != std::string::npos) // if found oldextension
        ret = fileTarg.replace(fileTarg.rfind(OldExt.c_str()),OldExt.length(),NewExt.c_str());


    return ret;
}


// Opens and output file stream named fn and stores the stream handler in ret.
// If mode is not specified, it assumes that the write mode is binary
void CFileOperation::OpenOutFile(std::ofstream &ret, std::string fn, std::string mode) {

    if (mode == "binary")
        ret.open(fn.c_str(), std::ios::binary);
    else if (mode == "text")
        ret.open(fn.c_str(), std::ios::out);
    if (ret.fail()) {
      std::cout << "Can not open output file: " << fn;
      std::cout << std::endl << "Exitting..." << std::endl << std::endl;
        exit(1);
    }
}

// Opens an input file stream named fn and stores the stream handler in ret.
// If mode is not specified it assumes that read mode is binary
void CFileOperation::OpenInFile(std::ifstream &ret, std::string fn, std::string mode) {
    

    if (mode == "binary")
        ret.open(fn.c_str(), std::ios::binary);
    else if (mode == "text")
        ret.open(fn.c_str(), std::ios::in);
    if (ret.fail()) {
        std::cerr << "Can not open input file: " << fn;
        std::cerr << std::endl << "Exitting..." << std::endl << std::endl;
        exit(1);
    }
}

// Gets first 2048 characters of current line of file stream in_file and stores them in string s
void CFileOperation::GetLine(std::ifstream &in_file, std::string &s)
{
    char str[2048];
    in_file.getline(str, 2048, '\n');
    s = str;
    CleanString(s);
}

//Removes white spaces from beginning and end of string s
void CFileOperation::CleanString(std::string &s)
{
    s = trim(s);
    // while ( s.length()!=0 && isspace( s.at(0) ) ) {
    //  s.erase(s.begin());
    // }
    // while ( s.length()!=0 && isspace( s.at( s.length()-1 ) ) ) {
    //  s.erase(s.length()-1);
    // }
}

// Returns the portion of string s that is separated by characyer ch from rest of s
std::string CFileOperation::GetArg(std::string& s, char ch)
{
    std::string ReStr("");
    bool flag=false;

    if (ch==' ')
        flag=true;
    CleanString(s);
    if (s.length() == 0)
        return ReStr;
    if (s.at(0) == ch) {
        s.erase(0,1);
        return "0";
    }
    do {
        ReStr += s[0];
        s.erase(0,1);
    } while( ! s.empty() && (s.at(0) != ch) && (flag ? !isspace(s.at(0)) : true)/*&& !isspace(s.at(0))*/);
    s.erase(0,1);
    CleanString(s);
    return ReStr;
}

// Returns the filename extension of s inlcuding the '.' character
std::string CFileOperation::GetExtension(std::string s) {
    
    // int len = (int) s.length();
    std::string ret;

    if (s.length()<3 || s.rfind('.')==std::string::npos) {
      std::cout << std::endl << "Filename needs to have an extension!" << std::endl;
        return "";
    }
    int loc = (int) s.rfind('.');
    return s.substr(loc);
}

// Read delimeted text file 'fn' and return the list of (x,y,z) coordinates it contains
std::vector<Point *> CFileOperation::ReadXYZ(std::string fn, std::string delimeter) {
    char *pend;
    std::string x, y, z;
    std::vector<Point *> myvec;
    
    std::ifstream ifs;
    this->OpenInFile(ifs, fn, "text");
    while (!std::getline(ifs, x, *delimeter.c_str()).eof()) {
            std::getline(ifs, y, *delimeter.c_str());
            std::getline(ifs, z);
        myvec.push_back(new Point(strtod(x.c_str(), &pend), strtod(y.c_str(), &pend), strtod(z.c_str(), &pend)));
    }
    ifs.close();
    return myvec;
}























