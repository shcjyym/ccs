#ifndef CCALCPOSGENCONFIGFILE_H
#define CCALCPOSGENCONFIGFILE_H

#include <QObject>
#include <QVector>
#include <QDebug>
#include <QRect>
#include <QDir>

#include "cinputfile.h"

#define NoScale 1
#define InvalideSignalId    0xFFFF
#define NetBandWidth    (1920*1080)

#define Index_NoScale   2

//郑工要求处理成大端模式
#define Big_Endian  1//大端
#define Little_Endian   2//小端

#define MinValueOff (0.0000000000000000000000001)

struct CalMsgProgress
{
    QVector<unsigned char> *allSendWindowDataPack;//记录所有窗口的发送数据包的顺序，发一个，弹出一个
    int initialCount;
    double percent;
};

class spliteWindowInfo
{
public:
    QRect splitWindows; //一个信号分割开的窗口
    QRect splitWindowsAtInputDraw;//这个信号分割开的窗口，在输入节点中，输出的压缩大小
    int outputWindowId;//记录每一个window ID在输出节点文件中的id
    int inputWindowId;//记录每一个window ID在输入节点文件中的id
    int packNum;//这个窗口要发送的报文的总数
    int atReduceDrawId; //这个窗口隶属于那个缩小画面

    //
    QRect splitWindowsAtInputDraw_Modify;//这个信号分割开的窗口，在输入节点中，输出的压缩大小,经过郑工要求之后修正
};

class CScreenSignal : public QObject
{
    Q_OBJECT
public:
    CScreenSignal(QObject *parent=0){
        screenContentSize=0;
        reduceContentSize=0;
        id=-1;
    }
    int x;
    int y;
    int id;//用于识别在窗口中创建的signal身份识别
    int signalWidth;//信号源中width，height
    int signalHeight;
    int signalWidthInScreen;//信号源在屏幕中width，height
    int signalHeightInScreen;//信号源在屏幕中width，height
    QString ip;
    int configScale;
    //unsigned long allContentBytes;

public:
    unsigned long screenContentSize;//信号在屏幕中实际占用的大小
    unsigned long reduceContentSize;//信号在传输时实际占用的大小

   // QVector<QRect> allSplitWindows; //一个信号分割开的窗口
    //QVector<QRect> allSplitWindowsAtInputDraw;//这个信号分割开的窗口，在输入节点中，输出的压缩大小
    //QVector<int> allWindowId;//记录每一个window ID在输出节点文件中的id
    QVector<spliteWindowInfo> allSpliteWindowsInfo;
    QVector<unsigned char> allSendWindowDataPack;//记录所有窗口的发送数据包的顺序，发一个，弹出一个

    //一个信号源作为缩小画面，在输入文件，缩小画面中的参数
    inputReduceDraw m_reduceDraw;

    //输出节点放大系数x,输出节点放大系数y
    unsigned char outputAmplifyX;
    unsigned char outputAmplifyY;

    //
    unsigned char macInOutputNode[6];//所在输出节点的mac地址
};

class CSignalMapToScreen : public QObject
{
    Q_OBJECT
public:
    CSignalMapToScreen(QObject *parent=0){
        allContentSize=NetBandWidth;
        noScaleContentSize=0;
        scaleContentSize=0;
    }
    void clearSignalMapToScreenData()
    {
        allContentSize=NetBandWidth;
        noScaleContentSize=0;
        scaleContentSize=0;
        mapSignalId.clear();
        inputFile.clearInputFileData();
    }

    unsigned long allContentSize;

    //计算每个signal是否要压缩，压缩多少说明
    //如果signal不需要压缩，则直接取signal原大小，以及屏幕大小中，较小的值作为压缩值。
    //屏幕所有的大小,减去(所有不需要压缩的signal的大小之和) = 所有需要压缩的信号可以利用的大小
    //如果需要压缩，则把所有需要压缩的signal在屏幕中大小之和，作为分母，每个signal在屏幕大小作为分子。得到的小数比例值，再*所有需要压缩的信号可以利用的大小，
    //就是每一个信号可以利用的贷款大小
    unsigned long noScaleContentSize;
    unsigned long scaleContentSize;

    QVector<int> mapSignalId;//缩小画面个数
    CInputFile inputFile;
};

class CAllSignals : public QObject
{
    Q_OBJECT
public:
    CAllSignals(QObject *parent=0){
        CScreenSignal* signal1=new CScreenSignal;
        signal1->signalWidth=1920;
        signal1->signalHeight=1080;
        signal1->ip="208.0.1.1";
        m_signalHash.insert(signal1->ip,signal1);
        m_ipList.push_back(signal1->ip);

        CScreenSignal* signal2=new CScreenSignal;
        signal2->signalWidth=1920;
        signal2->signalHeight=1080;
        signal2->ip="208.0.1.2";
        m_signalHash.insert(signal2->ip,signal2);
        m_ipList.push_back(signal2->ip);

/*
        CScreenSignal* signal3=new CScreenSignal;
        signal3->signalWidth=1920;
        signal3->signalHeight=1080;
        signal3->ip="208.0.1.3";
        m_signalHash.insert(signal3->ip,signal3);
        m_ipList.push_back(signal3->ip);*/

    }
    CScreenSignal * findSignalOriginalWidthHeight(QString ip)
    {
        CScreenSignal *v=m_signalHash.value(ip);
        return v;
    }
    CScreenSignal * findSignalInScreen(int id)
    {
        CScreenSignal *v=m_allSignalInScreenHash.value(id);
        return v;
    }
    void clearAllSignalsData()
    {
        QHash<int,CScreenSignal*>::const_iterator i = m_allSignalInScreenHash.constBegin();
        while (i != m_allSignalInScreenHash.constEnd()) {
          CScreenSignal* s=i.value();
          delete s;

          ++i;
        }
        m_allSignalInScreenHash.clear();
    }

    //保存每个从输入节点得到的信号源信息。这个信息应该从设备读取。目前手动设置
    //这个参数重新计算时不需要清0
    QHash<QString,CScreenSignal*> m_signalHash;
    QStringList m_ipList;//这个参数重新计算时不需要清0
    QHash<int,CScreenSignal*> m_allSignalInScreenHash;//保存每个在screen中动态创建的signal，这个参数重新计算时需要清0

};

class CScreenPosInfo : public QObject
{
    Q_OBJECT
public:
    CScreenPosInfo(QObject *parent=0){
        width=1920;
        height=1080;
        m_screenPointInfo=new unsigned short[width*height];
        memset(m_screenPointInfo,InvalideSignalId,width*height*sizeof(unsigned short));
    }
    void clearScreenPosInfoData()
    {
        delete m_screenPointInfo;
        m_mapSignalId.clear();
        memset(mac,0x00,6);
    }

    int width;
    int height;
    int id;
    unsigned short *m_screenPointInfo;

    QVector<int> m_mapSignalId;//记录与当前screen有关的signalId。这样的好处是所有signal指针都保存在一个地方，没有多个地方保存。
                            //一旦删除这个signal，没有删除多处指针的问题。否则很容易漏删指针，造成内存错误
    COutputFile m_outputFile;
    unsigned char mac[6];
};

class CCalcPosGenConfigFile : public QObject
{
    Q_OBJECT
public:
    explicit CCalcPosGenConfigFile(QObject *parent = 0)
    {
        m_curScreenInfo=NULL;
        QHash<QString,CScreenSignal*>::iterator itor= m_allSignals.m_signalHash.begin();
        while(itor != m_allSignals.m_signalHash.end())
        {
            CSignalMapToScreen *signalMapToScreen=new CSignalMapToScreen;
            m_calReduceInOneInput.insert(itor.key(),signalMapToScreen);
            ++itor;
        }

        {
            union w
            {
                 int a;
                 char b;
            } c;
            c.a = 1;
            if(c.b==1)
            {
                m_LB_Endian = Little_Endian;
            }else
                m_LB_Endian = Big_Endian;
        }


    }

    Q_INVOKABLE void clearAllExists();
    Q_INVOKABLE void startGetOneScreenInfo(int screenId);
    Q_INVOKABLE void getScreenWH(int width,int height);
    Q_INVOKABLE void getSignalConfigInfo(int x, int y, int width, int height,
                                         QString ip, int configScale, int signalId, QString mac);
    Q_INVOKABLE void stopGetOneScreenInfo(int screenId);

    Q_INVOKABLE void calcAndGenConfigFile();

private:
    //void calEveryReduceDrawValideSize();
    //根据实际面积，计算缩小窗口的压缩比例
    //void calEveryReduceDrawSize(CScreenSignal *signal);
    //计算每一个屏幕中的信号占有的实际面积，要去掉被遮挡面积
    void calEveryScreenSignalInfo();
    //将所有信号占据的地盘分割成一个个长方形
    void splitEverySignalAreaToRectangles();
    //计算一个信号窗口的压缩系数
    void getCoeficientAndWH(double allFreeFlow, double valideFlow, double &index, double calPrecision,CScreenSignal *s);
    void getOutputNodeAmplifyCoeficient(int inputWidth, int inputHeight,int outputNodeWidth,
                                        int outputNodeHeight,int &xAmplify,int &yAmplify);
    void getInputNode_OutSignalWidthHeight(int inWidth, int inHeight, int xIndex, int yIndex, int &outWidth, int &outHeight);
    void getInputNodeReduceCoeficient(int inWidth,int inHeight,int outWidth,int outHeight,double &xReduce,double &yReduce);
    void setInputNodeSplitX(int inWidth,int outWidth,int xcoeficient, double &splitXPos);
    void setInputNodeSplitY(int inHeight,int outHeight,int ycoeficient,double &splitYPos);

    //proc rc x:4的倍数 y:2的倍数 起点取小，终点取大
    void procWindowRc(QRect &rc, unsigned char xAmplify, unsigned char yAmplify);
    //
    void genInputNodeFile();
    //
    void writeIntoInputFile(CInputFile &inputInfo,QString name);
    //
    void writeOutputFile();
    //
    void writeIntoFile(QFile &file, char *dest, char *src,int len);
    //
    bool checkIfInteger(double value);//测试value是否是整数
    bool ifDoubleEqual(double v1,double v2);//测试两个浮点数是否相等
signals:

public slots:

private:
    QVector<CScreenPosInfo*> m_screenInfo;
    CScreenPosInfo* m_curScreenInfo;
    CAllSignals m_allSignals;
    QHash<QString,CSignalMapToScreen*> m_calReduceInOneInput;//<IP,CSignalMapToScreen*>

    int m_LB_Endian;
};

#endif // CCALCPOSGENCONFIGFILE_H
