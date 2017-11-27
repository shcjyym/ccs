#ifndef CINPUTFILE_H
#define CINPUTFILE_H

#include <QObject>
#include <QVector>

#define AllMsgCount 3300

struct inputFileHeader
{
    unsigned short fileLen;
    unsigned short crc;
    unsigned char reduceDrawCount;
    unsigned char reduceWindowCount;
    unsigned short hold;
};

struct inputReduceDraw
{
    unsigned short xReduce;
    unsigned short yReduce;
    unsigned short xSpliteReduce;
    unsigned short ySpliteReduce;
    unsigned char xOffset;
    unsigned char yOffset;
    unsigned short width;
    unsigned short height;
    unsigned short hold;

public:
    int inputFileReduceDrawId;//在输入节点中，缩小画面的编号
};

class inputOutWindow
{
public:
    inputOutWindow(){
        memset(mac,0xff,6);
        hold=0;
    }

    unsigned char inputReduceDrawId;
    unsigned short xOffset;
    unsigned short yOffset;
    unsigned short width;
    unsigned char mac[6];
    unsigned char targetWindowId;
    unsigned short hold;

public:
    int windowIdAtInput;
};


class CInputFile : public QObject
{
    Q_OBJECT

public:
    explicit CInputFile(QObject *parent=0);
    inputFileHeader header;
    QVector<inputReduceDraw> reduceDrawVector;
    QVector<inputOutWindow> outWindowVector;
    QVector<unsigned char> netSendOrder;

    void clearInputFileData()
    {
        memset(&header,0,sizeof(header));
        reduceDrawVector.clear();
        outWindowVector.clear();
        netSendOrder.clear();
    }
};


class outputFileHeader
{
public:
    unsigned short fileLen;
    unsigned short crc;
    unsigned char windowCount;
    unsigned char hold[3];


};

class outputWindow
{
 public:
    int windowId;
    unsigned short startPos;

public:
    unsigned short inputWindowWidth;//原始窗口宽度
    unsigned short inputWindowHeight;//原始窗口高度
    unsigned char xAmplify;//放大系数X
    unsigned char yAmplify;//放大系数Y
    unsigned char xOutputOffset;//起点在原始窗口偏移X
    unsigned char yOutputOffset;//起点在原始窗口偏移Y
    unsigned short outputWidth;//放大窗口宽度
    unsigned short outputHeight;
    unsigned short outputX;//放大窗口存储起始地址x
    unsigned short outputY;

};

class COutputFile : public QObject
{
    Q_OBJECT

public:
    explicit COutputFile(QObject *parent=0)
    {

    }

    outputFileHeader header;
    QVector<outputWindow> outputWindows;

};


#endif // CINPUTFILE_H
