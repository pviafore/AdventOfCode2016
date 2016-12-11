#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <ostream>
#include <numeric>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

class Pixel
{
public:
    bool on;
    friend std::ostream& operator<<( std::ostream& stream, const Pixel &p);
};

std::ostream& operator<<(std::ostream & stream, const Pixel & p)
{
    stream << (p.on ? "*" : ".");
    return stream;
}

class Panel
{  
public:
    typedef std::vector<Pixel> Row;
    typedef std::vector<Row> Rows;
   
    Panel(uint8_t width, uint8_t height);
    void rect(uint8_t width, uint8_t height);
    void rotateColumn(uint8_t columnNumber, uint8_t num);
    std::vector<Pixel> getColumn(uint8_t columnNumber) const;
    void applyColumn(uint8_t columnNumber, std::vector<Pixel> column);

    void rotateRow(uint8_t rowNumber, uint8_t num);
    uint16_t getNumberOfPixelsLit() const;
    

    friend std::ostream& operator<<(std::ostream& stream, Panel panel);

private:
    Row makeRow(uint8_t width);
    
    Rows rows;

};

Panel::Panel(uint8_t width, uint8_t height) :
        rows(height, makeRow(width))
{
}

Panel::Row Panel::makeRow(uint8_t width)
{
    return Panel::Row(width, Pixel{false});
}

std::ostream& operator<<(std::ostream& stream, Panel panel)
{
    std::for_each(panel.rows.begin(), panel.rows.end(), [&stream](Panel::Row & row){
        std::copy(row.begin(), row.end(), std::ostream_iterator<Pixel>(stream));
        stream <<"\n";
    });
    return stream;
}

void Panel::rect(uint8_t width, uint8_t height)
{
    auto turnOnPixel = [](Pixel & p){p.on = true;};
    auto turnOnRowPixel = [turnOnPixel, width](Row & row){ 
        std::for_each(row.begin(), row.begin() + width, turnOnPixel);
    };
    std::for_each(rows.begin(), rows.begin() + height, turnOnRowPixel);
}

void Panel::rotateColumn(uint8_t columnNumber, uint8_t num)
{
    std::vector<Pixel> column = getColumn(columnNumber);
    std::rotate(column.rbegin(), column.rbegin()+num, column.rend() );
    applyColumn(columnNumber, column);
}

void Panel::rotateRow(uint8_t rowNumber, uint8_t num)
{
    auto& row = rows[rowNumber];
    std::rotate(row.rbegin(), row.rbegin()+num, row.rend());
}
    

std::vector<Pixel> Panel::getColumn(uint8_t columnNumber) const
{
    std::vector<Pixel> pixels;
    auto getPixel = [columnNumber](const Row & row){
        return row[columnNumber];
    };
    std::transform(rows.begin(), rows.end(), std::inserter(pixels, pixels.begin()), getPixel);
    return pixels;
}

void Panel::applyColumn(uint8_t columnNumber, std::vector<Pixel> column)
{
    uint8_t index = 0;
    std::for_each(rows.begin(), rows.end(), [&index, columnNumber, &column](Row &row){
        row[columnNumber] = column[index++];
    });
}

uint16_t Panel::getNumberOfPixelsLit() const
{
    auto isOn = [](const Pixel & p) { return p.on;};
    auto getCount = [isOn](const Row & row){ return std::count_if(row.begin(), row.end(), isOn);};
    std::vector<uint8_t> counts;
    std::transform(rows.begin(), rows.end(), std::inserter(counts, counts.begin()), getCount);
    return std::accumulate(counts.begin(), counts.end(), 0);
}

void applyRectOperationIfMatching(Panel & panel, std::string operation)
{
    std::smatch sm;
    std::regex regex("rect (\\d+)x(\\d+)");
    std::regex_match(operation, sm, regex);
    if (sm.size() == 3)
    {
        panel.rect(stoi(sm[1]), stoi(sm[2]));
    }
}

void applyRotateRowOperationIfMatching(Panel & panel, std::string operation)
{
    std::smatch sm;
    std::regex regex("rotate row y=(\\d+) by (\\d+)");
    std::regex_match(operation, sm, regex);
    if (sm.size() == 3)
    {
        panel.rotateRow(stoi(sm[1]), stoi(sm[2]));
    }
}

void applyRotateColumnOperationIfMatching(Panel & panel, std::string operation)
{
    std::smatch sm;
    std::regex rotateColumnRegex("rotate column x=(\\d+) by (\\d+)");
    std::regex_match(operation, sm, rotateColumnRegex);
    if (sm.size() == 3)
    {
        panel.rotateColumn(stoi(sm[1]), stoi(sm[2]));
    }
}

void applyOperationOnPanel(Panel & panel, std::string op)
{
    applyRectOperationIfMatching(panel, op);
    applyRotateRowOperationIfMatching(panel, op);
    applyRotateColumnOperationIfMatching(panel, op);
}

int main()
{
    Panel panel(50,6);
    std::ifstream infile; 
    infile.open("../day8.txt");
    std::string data;
    while(getline(infile, data))
    {
        applyOperationOnPanel(panel, data);
    }
    infile.close();;
    std::cout << panel << "\n" << panel.getNumberOfPixelsLit() << "\n";
}