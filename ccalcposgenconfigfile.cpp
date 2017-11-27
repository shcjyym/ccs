#include "ccalcposgenconfigfile.h"
#include "cinputfile.h"

#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QStringList>

void CCalcPosGenConfigFile::startGetOneScreenInfo(int screenId)
{
    m_curScreenInfo = new CScreenPosInfo;
    m_curScreenInfo->id=screenId;
    memset(m_curScreenInfo->mac,0xff-screenId,6);
    m_screenInfo.append(m_curScreenInfo);
}

void CCalcPosGenConfigFile::clearAllExists()
{
    for(int i=0;i<m_screenInfo.size();++i)
    {
        CScreenPosInfo* info=m_screenInfo.at(i);
        info->clearScreenPosInfoData();
        delete info;
    }
    m_screenInfo.clear();
    m_curScreenInfo=NULL;
    m_allSignals.clearAllSignalsData();
    QHash<QString,CSignalMapToScreen*>::iterator itor= m_calReduceInOneInput.begin();
    while(itor != m_calReduceInOneInput.end())
    {
        CSignalMapToScreen* mapToScreen = itor.value();
        mapToScreen->clearSignalMapToScreenData();
        ++itor;
    }
}

void CCalcPosGenConfigFile::getScreenWH(int width,int height)
{
    if(m_curScreenInfo != NULL)
    {
        m_curScreenInfo->width=width;
        m_curScreenInfo->height=height;
    }
}

//QMultiHash<QString,CScreenSignal *> m_allConfigSignal;
void CCalcPosGenConfigFile::getSignalConfigInfo(int x,int y,int width,int height,
                                                QString ip,int configScale,int signalId,QString mac)
{
    if(m_curScreenInfo != NULL)
    {
        CScreenSignal *signal=new CScreenSignal();

        QStringList macList=mac.split('-');
        bool ok;
        if(macList.size() == 6)
        {
            for(int i=0;i<6;++i)
            {
                signal->macInOutputNode[i] = macList.at(i).toInt(&ok,16);
            }
        }else{
            //报错
        }
        memcpy(m_curScreenInfo->mac,signal->macInOutputNode,6);

        if(x>=0)
            signal->x=x;
        else{
            width = width+x;
            signal->x=0;
        }
        if(y>=0)
            signal->y=y;
        else{
            height = height+y;
            signal->y=0;
        }
        signal->id=signalId;
        if(signal->x+width>m_curScreenInfo->width)
            signal->signalWidthInScreen=m_curScreenInfo->width-signal->x;
        else
            signal->signalWidthInScreen= width;
        if(signal->y+height > m_curScreenInfo->height)
            signal->signalHeightInScreen = m_curScreenInfo->height-signal->y;
        else
            signal->signalHeightInScreen=height;
        signal->ip=ip;
        signal->configScale=configScale;
        m_allSignals.m_allSignalInScreenHash.insert(signal->id,signal);

        CScreenSignal *temp=m_allSignals.findSignalOriginalWidthHeight(ip);
        signal->signalWidth=temp->signalWidth;
        signal->signalHeight=temp->signalHeight;
        qDebug()<<"getSignalConfigInfo width"<<signal->signalWidth<<signal->signalHeight;

        m_curScreenInfo->m_mapSignalId.append(signal->id);
        //获取noscale的信号的显示大小
        CSignalMapToScreen *mapToScreen= m_calReduceInOneInput.value(signal->ip);
        if(mapToScreen != NULL)
        {
            mapToScreen->mapSignalId.append(signal->id);
            if(signal->configScale == NoScale)
            {
                if(signal->screenContentSize >= signal->signalWidth*signal->signalHeight){
                    signal->reduceContentSize = signal->signalWidth*signal->signalHeight;
                }else{
                    signal->reduceContentSize = signal->screenContentSize;
                }
                mapToScreen->noScaleContentSize +=
                        signal->reduceContentSize;
            }
        }
    }
}

void CCalcPosGenConfigFile::stopGetOneScreenInfo(int screenId)
{
    m_curScreenInfo=NULL;
}
void CCalcPosGenConfigFile::genInputNodeFile()
{
    QHash<QString,CSignalMapToScreen*>::iterator itor = m_calReduceInOneInput.begin();
    int num=0;
    while(itor != m_calReduceInOneInput.end())
    {
        CInputFile inputFile;//每个输入节点一个文件
        int allPackNum=0;
        int windowStartPos=0;//因为每一个窗口都要记录在文件中属于第几个位置，所以需要记录起始号
        QVector<CalMsgProgress*> msgProgress;//记录如何将报文平均分配的结构

        CSignalMapToScreen *mapToScreen = itor.value();
        if(mapToScreen->mapSignalId.size()==0){
            ++itor;
            continue;
        }
        inputFile.header.reduceDrawCount=mapToScreen->mapSignalId.size();
        inputFile.header.reduceWindowCount=0;
        for(int i=0;i<mapToScreen->mapSignalId.size();++i)
        {
            CScreenSignal * s=m_allSignals.findSignalInScreen(mapToScreen->mapSignalId[i]);
            s->m_reduceDraw.inputFileReduceDrawId=i;
            inputFile.reduceDrawVector.append(s->m_reduceDraw);
            inputFile.header.reduceWindowCount += s->allSpliteWindowsInfo.size();

            for(int k=0;k<s->allSpliteWindowsInfo.size();++k)
            {
                QRect rc=s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify;
                qDebug()<<"splitWindowsAtInputDraw_Modify"<<rc;
                inputOutWindow tempInputOutWindow;
                tempInputOutWindow.inputReduceDrawId = s->m_reduceDraw.inputFileReduceDrawId;
                tempInputOutWindow.xOffset =rc.x();
                tempInputOutWindow.yOffset = rc.y();
                tempInputOutWindow.width = rc.width();
                tempInputOutWindow.targetWindowId = s->allSpliteWindowsInfo[k].outputWindowId;
                tempInputOutWindow.windowIdAtInput=windowStartPos+k;
                memcpy(tempInputOutWindow.mac,s->macInOutputNode,sizeof(tempInputOutWindow.mac));

                s->allSpliteWindowsInfo[k].inputWindowId=tempInputOutWindow.windowIdAtInput;
                inputFile.outWindowVector.append(tempInputOutWindow);

                for(int u=0;u<s->allSpliteWindowsInfo[k].packNum;++u)
                    s->allSendWindowDataPack.push_back(s->allSpliteWindowsInfo[k].inputWindowId);
            }
            //for(int k=0;k<s->allSendWindowDataPack.size();++k)
            {
            //    s->allSendWindowDataPack[k] += windowStartPos;
            }
            allPackNum += s->allSendWindowDataPack.size();
            windowStartPos += s->allSpliteWindowsInfo.size();

            CalMsgProgress *msg=new CalMsgProgress;
            msg->allSendWindowDataPack = &(s->allSendWindowDataPack);
            msg->initialCount = s->allSendWindowDataPack.count();
            msg->percent=0;
            msgProgress.append(msg);

            //qDebug()<<"msg x "<<msg->allSendWindowDataPack<<msg->initialCount<<s->id<<s->allSplitWindows.size()
            //       <<s->allSendWindowDataPack.size()<<allPackNum;
        }
        CalMsgProgress *emptyMsg=new CalMsgProgress;
        {
            //添加空白报文
            QVector<unsigned char> *tempEmptyPack=new QVector<unsigned char>;
            for(int p=0;p<AllMsgCount-allPackNum;++p)
            {
                tempEmptyPack->append(0xff);
            }
            emptyMsg->allSendWindowDataPack = tempEmptyPack;
            emptyMsg->initialCount = AllMsgCount-allPackNum;
            emptyMsg->percent=0;
            msgProgress.append(emptyMsg);
        }

        bool bAssign=false;
        double step=1.0/emptyMsg->initialCount;
        double runPercent=step;
        double maxPercent=1;
        int samePercentTimes=0;
        while(!bAssign)
        {
            bAssign=true;
            if(runPercent < maxPercent+2*step){
                bAssign = false;
            }
            if(bAssign) // 一旦分配完成，退出
                continue;

            samePercentTimes=0;
            for(int k=0;k<msgProgress.size();++k)
            {
                if(msgProgress[k]->percent < runPercent)
                {
                    if(msgProgress[k]->allSendWindowDataPack->size()>0)
                    {
                        inputFile.netSendOrder.append( msgProgress[k]->allSendWindowDataPack->back() );
                        msgProgress[k]->allSendWindowDataPack->pop_back();
                        msgProgress[k]->percent =
                           1.0-1.0*msgProgress[k]->allSendWindowDataPack->size()/msgProgress[k]->initialCount;
                        ++samePercentTimes;
                    }
                }
            }

            if(samePercentTimes>0)
            {
                samePercentTimes=0;
            }else
            {
                //需要执行下一步了
                runPercent += step;
            }
            //qDebug()<<"runPercent"<<samePercentTimes<<runPercent<<msgProgress.size()<<step;//<<inputFile.netSendOrder;
        }
        //qDebug()<<"分配完成"<<inputFile.netSendOrder.size()<<allPackNum<<inputFile.netSendOrder;
        for(int p=0;p<msgProgress.size();++p)
        {
            CalMsgProgress* progress=msgProgress[p];
            delete progress;
        }
        //将input中信息写入文件
        inputFile.header.fileLen = 8+16*inputFile.header.reduceDrawCount+16*inputFile.header.reduceWindowCount+AllMsgCount;
        QString name=( "input-"+itor.key());
        writeIntoInputFile(inputFile,name);

        //

        ++num;
        ++itor;
    }
    writeOutputFile();
}

void CCalcPosGenConfigFile::writeOutputFile()
{
    for(int i=0;i<m_screenInfo.size();++i)
    {
        CScreenPosInfo* screenInfo=m_screenInfo[i];

        for(int j=0;j<screenInfo->m_mapSignalId.size();++j)
        {
            CScreenSignal* signal=m_allSignals.findSignalInScreen(
                        screenInfo->m_mapSignalId[j]);
            if(signal == NULL)
            {
                //报错
                continue;
            }
            for(int k=0;k<signal->allSpliteWindowsInfo.count();++k)
            {
                outputWindow windowInfo;
                //windowInfo.startPos = startPos;
                windowInfo.windowId = signal->allSpliteWindowsInfo[k].outputWindowId;
                //windowInfo.inputWindowWidth = signal->allSpliteWindowsInfo[k].splitWindowsAtInputDraw.width();
                //windowInfo.inputWindowHeight = signal->allSpliteWindowsInfo[k].splitWindowsAtInputDraw.height();
                windowInfo.inputWindowWidth = signal->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.width();
                windowInfo.inputWindowHeight = signal->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.height();
                windowInfo.xAmplify = signal->outputAmplifyX;
                windowInfo.yAmplify = signal->outputAmplifyY;
                windowInfo.xOutputOffset = signal->allSpliteWindowsInfo[k].splitWindows.x()*windowInfo.xAmplify%256;
                windowInfo.yOutputOffset = signal->allSpliteWindowsInfo[k].splitWindows.y()*windowInfo.yAmplify%128;
                windowInfo.outputWidth = signal->allSpliteWindowsInfo[k].splitWindows.width();
                windowInfo.outputHeight = signal->allSpliteWindowsInfo[k].splitWindows.height();
                windowInfo.outputX = signal->allSpliteWindowsInfo[k].splitWindows.x();
                windowInfo.outputY = signal->allSpliteWindowsInfo[k].splitWindows.y();
                screenInfo->m_outputFile.outputWindows.append(windowInfo);
            }
        }
        screenInfo->m_outputFile.header.fileLen = 8+screenInfo->m_outputFile.outputWindows.size()*2+
                screenInfo->m_outputFile.outputWindows.size()*16;
        if(screenInfo->m_outputFile.outputWindows.size()%2 != 0)
        {
            screenInfo->m_outputFile.header.fileLen += 2;//会补0
        }
        screenInfo->m_outputFile.header.windowCount=screenInfo->m_outputFile.outputWindows.size();
        screenInfo->m_outputFile.header.crc=0xFFFF;
        {
            QString name=QString("outNode-%0-read.txt").arg(screenInfo->id);
            QFile inputFile(name);
            if (!inputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                      return;

            QTextStream outRead(&inputFile);
            outRead.setIntegerBase(16);
            outRead.setFieldWidth(0);
            outRead << tr("文件头")<<"\n";
            //outRead.setPadChar('0');
            outRead.setFieldWidth(4);
            outRead << screenInfo->m_outputFile.header.fileLen<<screenInfo->m_outputFile.header.crc;

            outRead.setFieldWidth(2);
            outRead <<screenInfo->m_outputFile.header.windowCount;

            outRead.setFieldWidth(2);
            outRead <<screenInfo->mac[0]<<screenInfo->mac[1]<<screenInfo->mac[2];

            outRead <<"\n"<< tr("窗口存放地址")<<"\n";
            outRead.setFieldWidth(4);
            int startPos=0;
            double temp=0;
            outputWindow oldWindowInfo;
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        if(k==0)
                            temp=0;
                        else
                            temp = 1.0*oldWindowInfo.inputWindowWidth*oldWindowInfo.inputWindowHeight*1.5/8192;
                        //if(temp -((int)(temp)) <= 1e-15 )//是否整数
                        if(checkIfInteger(temp))
                        {
                            //整数
                            startPos += (int)temp;
                        }else{
                            startPos += (int)temp;
                            startPos += 1;
                        }
                        screenInfo->m_outputFile.outputWindows[p].startPos = startPos;
                        windowInfo.startPos = startPos;
                        oldWindowInfo = windowInfo;


                        outRead <<"windowId "<< windowInfo.windowId <<windowInfo.startPos<<endl;
                    }
                }
            }
            if(screenInfo->m_outputFile.outputWindows.size()%2 != 0)
            {
                unsigned short temp=0x00;
                outRead <<"windowId Add"<< temp<<temp<<endl;
            }
            outRead <<"\n"<< tr("窗口放大参数")<<"\n";
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        outRead<<"windowId "<< windowInfo.windowId  << windowInfo.inputWindowWidth <<windowInfo.inputWindowHeight
                                <<windowInfo.xAmplify << windowInfo.yAmplify
                               <<windowInfo.xOutputOffset <<windowInfo.yOutputOffset
                              <<windowInfo.outputWidth <<windowInfo.outputHeight
                             <<windowInfo.outputX << windowInfo.outputY<<endl;
                        break;
                    }
                }
            }
        }
        {
            char wData[50];
            QString name=QString("outNode-%0.bin").arg(screenInfo->id);
            QFile outputFile(name);
            if (!outputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                      return;
            writeIntoFile(outputFile,wData,(char*)&(screenInfo->m_outputFile.header.fileLen),
                          sizeof(screenInfo->m_outputFile.header.fileLen));
            writeIntoFile(outputFile,wData,(char*)&(screenInfo->m_outputFile.header.crc),
                          sizeof(screenInfo->m_outputFile.header.crc));
            writeIntoFile(outputFile,wData,(char*)&(screenInfo->m_outputFile.header.windowCount),
                          sizeof(screenInfo->m_outputFile.header.windowCount));
            for(int i=0;i<3;++i)
                writeIntoFile(outputFile,wData,(char*)&(screenInfo->m_outputFile.header.hold[i]),
                          sizeof(unsigned char));
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.startPos),
                                      sizeof(windowInfo.startPos));
                    }
                }
            }
            if(screenInfo->m_outputFile.outputWindows.size()%2 != 0)
            {
                unsigned short temp=0x0000;
                writeIntoFile(outputFile,wData,(char*)&(temp),
                              sizeof(temp));
                qDebug()<<"screenInfo->m_outputFile.outputWindows.size()"<<screenInfo->m_outputFile.outputWindows.size();
            }
            //outRead <<"\n"<< tr("窗口放大参数")<<"\n";
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.inputWindowWidth),
                                      sizeof(windowInfo.inputWindowWidth));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.inputWindowHeight),
                                      sizeof(windowInfo.inputWindowHeight));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.xAmplify),
                                      sizeof(windowInfo.xAmplify));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.yAmplify),
                                      sizeof(windowInfo.yAmplify));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.xOutputOffset),
                                      sizeof(windowInfo.xOutputOffset));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.yOutputOffset),
                                      sizeof(windowInfo.yOutputOffset));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.outputWidth),
                                      sizeof(windowInfo.outputWidth));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.outputHeight),
                                      sizeof(windowInfo.outputHeight));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.outputX),
                                      sizeof(windowInfo.outputX));
                        writeIntoFile(outputFile,wData,(char*)&(windowInfo.outputY),
                                      sizeof(windowInfo.outputY));
                        break;
                    }
                }
            }

        }
        {
            QString name=QString("outNode-%0.txt").arg(screenInfo->id);
            QFile inputFile(name);
            if (!inputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                      return;
            QTextStream outRead(&inputFile);
            //outRead << screenInfo->m_outputFile.header.fileLen<<screenInfo->m_outputFile.header.crc;
            //outRead <<screenInfo->m_outputFile.header.windowCount;
            //outRead <<0xFFFFFF;
            //outRead <<"\n"<< tr("窗口存放地址")<<"\n";
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        outRead<<windowInfo.startPos;
                    }
                }
            }
            if(screenInfo->m_outputFile.outputWindows.size()%2 != 0)
            {
                unsigned short temp=0x00;
                outRead<<temp<<temp;
                qDebug()<<"screenInfo->m_outputFile.outputWindows.size()"<<screenInfo->m_outputFile.outputWindows.size();
            }

            //outRead <<"\n"<< tr("窗口放大参数")<<"\n";
            for(int k=0;k<screenInfo->m_outputFile.outputWindows.size();++k)
            {
                for(int p=0;p<screenInfo->m_outputFile.outputWindows.size();++p){
                    outputWindow windowInfo=screenInfo->m_outputFile.outputWindows[p];
                    if(windowInfo.windowId==k){
                        outRead.setFieldWidth(4);
                        outRead<<  windowInfo.inputWindowWidth <<windowInfo.inputWindowHeight;
                        outRead.setFieldWidth(2);
                        outRead <<windowInfo.xAmplify << windowInfo.yAmplify
                               <<windowInfo.xOutputOffset <<windowInfo.yOutputOffset;

                        outRead.setFieldWidth(4);
                         outRead <<windowInfo.outputWidth <<windowInfo.outputHeight
                             <<windowInfo.outputX << windowInfo.outputY;
                        break;
                    }
                }
            }
        }

    }

}

void CCalcPosGenConfigFile::writeIntoFile(QFile &file,char *dest,char *src,int len)
{
    if(m_LB_Endian == Big_Endian)
    {
        memcpy(dest,src,len);
        file.write(dest,len);
    }else if(m_LB_Endian == Little_Endian)
    {
        int j=0;
        for(int i=len-1;i>=0;--i,++j)
        {
            dest[j]= src[i];
        }
        file.write(dest,len);
    }

}

void CCalcPosGenConfigFile::writeIntoInputFile(CInputFile &inputInfo, QString name)
{
    inputInfo.header.crc=00;

    {
        char wData[50];
        QFile inputFile(name+".bin");
        if (!inputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                  return;
        writeIntoFile(inputFile,wData,(char*)&(inputInfo.header.fileLen),sizeof(inputInfo.header.fileLen));
        writeIntoFile(inputFile,wData,(char*)&(inputInfo.header.crc),sizeof(inputInfo.header.crc));
        writeIntoFile(inputFile,wData,(char*)&(inputInfo.header.reduceDrawCount),sizeof(inputInfo.header.reduceDrawCount));
        writeIntoFile(inputFile,wData,(char*)&(inputInfo.header.reduceWindowCount),sizeof(inputInfo.header.reduceWindowCount));
        writeIntoFile(inputFile,wData,(char*)&(inputInfo.header.hold),sizeof(inputInfo.header.hold));
        for(int i=0;i<inputInfo.reduceDrawVector.size();++i)
        {
            inputReduceDraw draw=inputInfo.reduceDrawVector[i];
            writeIntoFile(inputFile,wData,(char*)&(draw.xReduce),sizeof(draw.xReduce));
            writeIntoFile(inputFile,wData,(char*)&(draw.yReduce),sizeof(draw.yReduce));
            writeIntoFile(inputFile,wData,(char*)&(draw.xSpliteReduce),sizeof(draw.xSpliteReduce));
            writeIntoFile(inputFile,wData,(char*)&(draw.ySpliteReduce),sizeof(draw.ySpliteReduce));
            writeIntoFile(inputFile,wData,(char*)&(draw.xOffset),sizeof(draw.xOffset));
            writeIntoFile(inputFile,wData,(char*)&(draw.yOffset),sizeof(draw.yOffset));
            writeIntoFile(inputFile,wData,(char*)&(draw.width),sizeof(draw.width));
            writeIntoFile(inputFile,wData,(char*)&(draw.height),sizeof(draw.height));
            writeIntoFile(inputFile,wData,(char*)&(draw.hold),sizeof(draw.hold));
        }
        for(int j=0;j<inputInfo.outWindowVector.size();++j)
        {
            for(int p=0;p<inputInfo.outWindowVector.size();++p)
            {
                inputOutWindow window=inputInfo.outWindowVector[j];
                if(window.windowIdAtInput==j){
                    writeIntoFile(inputFile,wData,(char*)&(window.inputReduceDrawId),sizeof(window.inputReduceDrawId));
                    writeIntoFile(inputFile,wData,(char*)&(window.xOffset),sizeof(window.xOffset));
                    writeIntoFile(inputFile,wData,(char*)&(window.yOffset),sizeof(window.yOffset));
                    writeIntoFile(inputFile,wData,(char*)&(window.width),sizeof(window.width));
                    for(int i=0;i<6;++i)
                        writeIntoFile(inputFile,wData,(char*)&(window.mac[i]),sizeof(unsigned char));
                    writeIntoFile(inputFile,wData,(char*)&(window.targetWindowId),sizeof(window.targetWindowId));
                    writeIntoFile(inputFile,wData,(char*)&(window.hold),sizeof(window.hold));
                    break;
                }
            }
        }
        for(int i=0;i<AllMsgCount;++i)
        {
            writeIntoFile(inputFile,wData,(char*)&(inputInfo.netSendOrder[i]),1);
        }

        inputFile.close();
    }
    {
        QFile inputFile(name+".txt");
        if (!inputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                  return;
        QTextStream outRead(&inputFile);
        outRead.setIntegerBase(16);
        outRead.setFieldWidth(0);
        outRead.setPadChar('0');
        outRead.setFieldWidth(4);
        outRead << inputInfo.header.fileLen<<inputInfo.header.crc;
        outRead.setFieldWidth(2);
        outRead <<inputInfo.header.reduceDrawCount<<inputInfo.header.reduceWindowCount;
        outRead.setFieldWidth(4);
        outRead <<inputInfo.header.hold;
        for(int i=0;i<inputInfo.reduceDrawVector.size();++i)
        {
            inputReduceDraw draw=inputInfo.reduceDrawVector[i];
            outRead.setFieldWidth(0);
            outRead.setFieldWidth(4);
            outRead<<draw.xReduce<<draw.yReduce<<draw.xSpliteReduce<<draw.ySpliteReduce;
            outRead.setFieldWidth(2);
            outRead<<draw.xOffset<<draw.yOffset;
            outRead.setFieldWidth(4);
            outRead<<draw.width<<draw.height<<draw.hold;
        }
        for(int j=0;j<inputInfo.outWindowVector.size();++j)
        {
            for(int p=0;p<inputInfo.outWindowVector.size();++p)
            {
                inputOutWindow window=inputInfo.outWindowVector[j];
                if(window.windowIdAtInput==j){
                    outRead.setFieldWidth(0);
                    //outRead <<"\n"<< tr("输出窗口")<<window.windowIdAtInput<<"\n";
                    outRead.setFieldWidth(2);
                    outRead << window.inputReduceDrawId;
                    outRead.setFieldWidth(4);
                    outRead <<window.xOffset<<window.yOffset<<window.width;
                    outRead.setFieldWidth(2);
                    for(int i=0;i<6;++i)
                        outRead<<window.mac[i];
                    outRead << window.targetWindowId;
                    outRead.setFieldWidth(4);
                    outRead <<window.hold;
                    break;
                }
            }
        }

        outRead.setFieldWidth(0);
        //outRead <<"\n"<< tr("网口0发送序号表")<<"\n";
        outRead.setFieldWidth(2);
        for(int i=0;i<AllMsgCount;++i)
        {
            outRead << inputInfo.netSendOrder[i];
        }
    }

    {
        QFile inputFile(name+"-read.txt");
        if (!inputFile.open(QIODevice::WriteOnly | QIODevice::Text))
                  return;

        QTextStream outRead(&inputFile);
        outRead.setIntegerBase(16);
        outRead.setFieldWidth(0);
        outRead << tr("文件头")<<"\n";
        outRead.setPadChar('0');
        outRead.setFieldWidth(4);
        outRead << inputInfo.header.fileLen<<inputInfo.header.crc;

        outRead.setFieldWidth(2);
        outRead <<inputInfo.header.reduceDrawCount<<inputInfo.header.reduceWindowCount;

        outRead.setFieldWidth(4);
        outRead <<inputInfo.header.hold;
        for(int i=0;i<inputInfo.reduceDrawVector.size();++i)
        {
            inputReduceDraw draw=inputInfo.reduceDrawVector[i];
            outRead.setFieldWidth(0);
            outRead <<"\n"<< tr("缩小画面")<<draw.inputFileReduceDrawId<<"\n";
            outRead.setFieldWidth(4);
            outRead<<draw.xReduce<<draw.yReduce<<draw.xSpliteReduce<<draw.ySpliteReduce;

            outRead.setFieldWidth(2);
            outRead<<draw.xOffset<<draw.yOffset;
            outRead.setFieldWidth(4);
            outRead<<draw.width<<draw.height<<draw.hold;
        }
        for(int j=0;j<inputInfo.outWindowVector.size();++j)
        {
            for(int p=0;p<inputInfo.outWindowVector.size();++p)
            {
                inputOutWindow window=inputInfo.outWindowVector[j];
                if(window.windowIdAtInput==j){
                    outRead.setFieldWidth(0);
                    outRead <<"\n"<< tr("输出窗口")<<window.windowIdAtInput<<"\n";
                    outRead.setFieldWidth(2);
                    outRead << window.inputReduceDrawId;
                    outRead.setFieldWidth(4);
                    outRead <<window.xOffset<<window.yOffset<<window.width;
                    outRead.setFieldWidth(2);
                    for(int i=0;i<6;++i)
                        outRead<<window.mac[i];
                    outRead << window.targetWindowId;
                    outRead.setFieldWidth(4);
                    outRead <<window.hold;
                    break;
                }
            }
        }

        outRead.setFieldWidth(0);
        outRead <<"\n"<< tr("网口0发送序号表")<<"\n";
        outRead.setFieldWidth(2);
        for(int i=0;i<AllMsgCount;++i)
        {
            outRead << inputInfo.netSendOrder[i];
        }
    }


}

void CCalcPosGenConfigFile::calcAndGenConfigFile()
{
    if(m_curScreenInfo== NULL)
    {
        CInputFile inputFile;

        //根据面积，计算每个signal实际的覆盖面积
        calEveryScreenSignalInfo();
        //根据新加入信号的实际面积，计算缩小窗口的压缩比例
        //calEveryReduceDrawSize(signal);
        //计算每个输出窗口的信息

        //calEveryReduceDrawValideSize();
        genInputNodeFile();
    }
}

void CCalcPosGenConfigFile::getCoeficientAndWH(double allFreeFlow, double valideFlow, double &index, double calPrecision, CScreenSignal *s)
{
    index=1.000000;

    if(allFreeFlow > valideFlow)//index设置为特殊值：2
    {
        qDebug()<<"getCoeficientAndWH Index_NoScale";
        index = Index_NoScale;
        return ;
    }
    double tempValideFlow1=valideFlow*index*index;

    bool b1=( tempValideFlow1 >= (allFreeFlow-calPrecision) && tempValideFlow1<=(allFreeFlow) );
    double tempvalideFlow=0;
    while( !b1)
    {
        index -= 0.000001;
        tempvalideFlow=tempValideFlow1*index*index;

        b1=( tempvalideFlow >= (allFreeFlow-calPrecision) && tempvalideFlow<=(allFreeFlow+calPrecision) );
        if(index <= 0.000001)
        {
            qDebug()<<"精度太小，无法获取有效参数"<<calPrecision<<(int)allFreeFlow<<(int)tempvalideFlow<<(int)valideFlow;

            goto calAgain;
        }

        //qDebug()<<index<<1920*index<<1080*index<<(int)tempvalideFlow<<(int)allFreeFlow<<(int)allFreeFlow-(int)tempvalideFlow;
    }
    qDebug()<<"getCoeficientAndWH end"<<index<<1920*index<<1080*index;
    return;
calAgain:
    getCoeficientAndWH(allFreeFlow, valideFlow, index,  calPrecision+2,s);
}

//将所有信号占据的地盘分割成一个个长方形
void CCalcPosGenConfigFile::splitEverySignalAreaToRectangles()
{
    int y1=-1,x1=-1;

    for(int k=0;k<m_screenInfo.size();++k)
    {
        CScreenPosInfo* screenInfo=m_screenInfo[k];
        int windowCount=0;
        int startx=-1,starty=-1,endx=-1,endy=-1,oldSignalId=-1,maxWidth=-1,maxHeight=-1,curendx=-1,nextLine=-1;
        long scanI=0;
        for(long i=scanI;i<screenInfo->width*screenInfo->height;++i)
        {
            {
                CScreenSignal* signal=m_allSignals.findSignalInScreen(screenInfo->m_screenPointInfo[i]);
                {
                    if(startx==-1 && starty==-1 && screenInfo->m_screenPointInfo[i] != InvalideSignalId)
                    {
                        if(signal == NULL)
                        {
                            //scanI = i;
                            continue;
                        }
                        startx=i%screenInfo->width;
                        starty=i/screenInfo->width;
                        oldSignalId=signal->id;

                    }
                    if(startx>-1 && starty>-1 && oldSignalId>-1)
                    {
                        if(i ==(screenInfo->width*screenInfo->height-1))
                            qDebug()<<"end here";
                        //if(signal == NULL)
                        //    qDebug()<<"signal->id ==oldSignalId"<<i<<i/1920<<i%1920;
                        if(screenInfo->m_screenPointInfo[i] != InvalideSignalId && signal != NULL && signal->id ==oldSignalId
                                && i !=(screenInfo->width*screenInfo->height-1) )
                        {
                            endx=i%screenInfo->width;
                            endy=i/screenInfo->width;
                            if(endy == starty)//没有换行时，才需要计算这个参数
                            {
                                maxWidth= (endx-startx > maxWidth ? endx-startx : maxWidth);
                                //qDebug()<<"nextLine == -1"<<maxWidth<<i<<endx<<endy;
                            }else{
                                if(endx- startx > maxWidth)
                                {
                                    curendx = startx+maxWidth;
                                    endx=startx+maxWidth;
                                }
                            }
                            maxHeight = (endy-starty > maxHeight ? endy-starty : maxHeight);
                            oldSignalId = signal->id;
                            //qDebug()<<"screenInfo->m_screenPointInfo[i]  xxxxx"<<endx<<endy<<maxWidth<<maxHeight<<i<<signal->id;
                        }else
                        {
                            if(signal==NULL)
                            {
                                signal=m_allSignals.findSignalInScreen(oldSignalId);
                            }
                            if(oldSignalId != signal->id)
                            {
                                signal=m_allSignals.findSignalInScreen(oldSignalId);
                            }

                            curendx=i%screenInfo->width;
                            if(curendx < startx )
                                continue;
                            if(i ==(screenInfo->width*screenInfo->height-1))
                            {
                                curendx += 1;//要加1，算法与在右边碰到别的信号源相同
                            }
                            if(curendx - startx < maxWidth )//说明这个正方形到头了
                            {
                                //qDebug()<<"curendx - startx < maxWidth"<<curendx - startx << maxWidth<<maxHeight <<i <<screenInfo->m_screenPointInfo[i]
                                 //          << oldSignalId<<curendx<<startx<<endy<<starty<<maxHeight<<startx<<endx;
                                if(curendx - startx > 0){
                                    //这种情况,maxHeight要减去最后一行,因为无效
                                    maxHeight -= 1;
                                }
                                QRect rc(startx,starty,maxWidth+1,maxHeight+1);
                                int indexI=0;
                                for(int o=starty;o<=starty+maxHeight;++o)
                                {
                                    for(int p=startx;p<=startx+maxWidth;++p)
                                    {
                                        indexI=o*screenInfo->width+p;
                                        screenInfo->m_screenPointInfo[indexI]=InvalideSignalId;
                                    }
                                }
                                spliteWindowInfo info;
                                info.splitWindows=rc;
                                info.outputWindowId=windowCount;
                                signal->allSpliteWindowsInfo.append(info);
                                //signal->allSplitWindows.append(rc);
                                //signal->allWindowId.append(windowCount);
                                ++windowCount;
                                qDebug()<<"signal-rc  xx "<<rc<<signal->ip<<signal->id<<info.outputWindowId;

                                int j=scanI;
                                while(screenInfo->m_screenPointInfo[j]==InvalideSignalId)
                                {
                                    if(j<(screenInfo->width*screenInfo->height))
                                        ++j;
                                    else
                                        break;
                                }
                                scanI=j;
                                i=scanI;

                                --i;//因为循环末尾会+1
                                startx=-1;starty=-1;endx=-1;endy=-1;oldSignalId=-1;maxWidth=-1;maxHeight=-1;curendx=-1;
                                nextLine=-1;
                            }
                            if(curendx - startx-1 >= maxWidth )//最低一行满了
                            {
                                //需要换行
                                if(endy==(screenInfo->height-1))
                                {
                                    //如果已经是最后一行，则结束
                                    QRect rc(startx,starty,maxWidth+1,maxHeight+1);
                                    int indexI=0;
                                    for(int o=starty;o<=starty+maxHeight;++o)//最后一行因为满了，所以必须算
                                    {
                                        for(int p=startx;p<=startx+maxWidth;++p)
                                        {
                                            indexI=o*screenInfo->width+p;
                                            screenInfo->m_screenPointInfo[indexI]=InvalideSignalId;
                                        }
                                    }
                                    if(signal==NULL)
                                    {
                                        signal=m_allSignals.findSignalInScreen(oldSignalId);
                                    }
                                    spliteWindowInfo info;
                                    info.splitWindows=rc;
                                    info.outputWindowId=windowCount;
                                    signal->allSpliteWindowsInfo.append(info);
                                    //signal->allSplitWindows.append(rc);
                                    //signal->allWindowId.append(windowCount);
                                    ++windowCount;
                                    qDebug()<<"signal-rc  yy "<<rc<<signal->ip<<signal->id<<info.outputWindowId;
                                    //qDebug()<<"window 1"<<signal->ip<<signal->id<<signal->x<<signal->y
                                    //       <<signal->signalWidthInScreen<<signal->signalHeightInScreen<<rc<<endy<<screenInfo->height;
                                    int j=scanI;
                                    //qDebug()<<"xx scanI"<<scanI<<j;
                                    while(screenInfo->m_screenPointInfo[j]==InvalideSignalId)
                                    {
                                        if(j<(screenInfo->width*screenInfo->height))
                                            ++j;
                                        else
                                            break;
                                    }
                                    scanI=j;
                                    i=scanI;
                                    //qDebug()<<"scanI yy "<<scanI<<screenInfo->m_screenPointInfo[j]<<(screenInfo->width*screenInfo->height);
                                    --i;//因为循环末尾会+1
                                    startx=-1;starty=-1;endx=-1;endy=-1;oldSignalId=-1;maxWidth=-1;maxHeight=-1;curendx=-1;
                                    nextLine=-1;
                                }else{
                                    i=startx+(endy+1)*screenInfo->width;
                                    --i;//因为循环末尾会+1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//proc rc x:4的倍数 y:2的倍数 起点取小，终点取大
void CCalcPosGenConfigFile::procWindowRc(QRect &rc,unsigned char xAmplify,unsigned char yAmplify)
{
    double startfx=rc.x()*xAmplify*1.0/64;
    int startix=(int)(startfx);
    startix = startix-(startix%4);//4的倍数，起点取小

    double startfy=rc.y()*yAmplify*1.0/64;
    int startiy=(int)(startfy);
    startiy = startiy-(startiy%2);//2的倍数，起点取小

    double endfy=(rc.y()+rc.height())*yAmplify*1.0/64; //2的倍数，终点取大
    int endiy=0;
    //if( endfy-qAbs(endfy) <= 1e-15 )//是否有小数点
    if(checkIfInteger(endfy))
    {
        //整数
        endiy=(int)(endfy);
    }else{
        endiy=(int)(endfy)+1;
    }
    if(endiy%2 != 0)
    {
        endiy += 1;
    }

    double endfx=(rc.x()+rc.width())*xAmplify*1.0/64; //4的倍数，终点取大
    int endix=0;
    //if( endfx-qAbs(endfx) <= 1e-15 )//是否有小数点
    if(checkIfInteger(endfy))
    {
        //整数
        endix=(int)(endfx);
    }else{
        endix=(int)(endfx)+1;
    }
    if(endix%4 != 0)
    {
        endix += (4-endix%4);
    }

    rc.setX(startix);
    rc.setY(startiy);
    rc.setWidth(endix-startix);
    rc.setHeight(endiy-startiy);
}

//计算每一个屏幕中的信号占有的实际面积，要去掉被遮挡面积
void CCalcPosGenConfigFile::calEveryScreenSignalInfo()
{
    //unsigned long size=1920*1080;
    qDebug()<<"calEveryScreenSignalInfo";
    //第一遍扫描所有信号占用的位置，初始化位置后，将每个位置都设置为当前信号的标志，并将叠加的位置设置为最上方信号
    for(int i=0;i<m_screenInfo.size();++i)
    {
        CScreenPosInfo* screenInfo=m_screenInfo[i];
        memset(screenInfo->m_screenPointInfo,InvalideSignalId,screenInfo->width*screenInfo->height);
        for(int j=0;j<screenInfo->m_mapSignalId.size();++j)
        {
            CScreenSignal* signal=m_allSignals.findSignalInScreen(
                        screenInfo->m_mapSignalId[j]);
            if(signal == NULL)
            {
                //报错
                continue;
            }
            int startcol,endcol;
            int num=0;
            for(int row=signal->y;row<signal->y+signal->signalHeightInScreen;++row)
            {
                startcol=screenInfo->width*row+signal->x;
                endcol=startcol+signal->signalWidthInScreen;
                for(;startcol<endcol;++startcol)
                {
                    screenInfo->m_screenPointInfo[startcol]=signal->id;
                    ++num;
                }
            }
        }
    }

    //第二遍计算每个信号占用的有效面积
    qDebug()<<"第二遍计算每个信号占用的有效面积";
    for(int k=0;k<m_screenInfo.size();++k)
    {
        CScreenPosInfo* screenInfo=m_screenInfo[k];
        for(unsigned long i=0;i<screenInfo->width*screenInfo->height;++i)
        {
            if(screenInfo->m_screenPointInfo[i] != InvalideSignalId)
            {
                CScreenSignal* signal=m_allSignals.findSignalInScreen(screenInfo->m_screenPointInfo[i]);
                if(signal != NULL)
                    ++signal->screenContentSize;
                else{
                    //报错
                    qDebug()<<"error here!";
                }
            }
        }
    }
    //在获取每个点属于哪个信号之后，顺便计算每个信号可以分为几个窗口
    {
        splitEverySignalAreaToRectangles();
    }
    //计算每一个信号源中，需要scale的画面的实际占用的流量大小
    //第一遍循环，获取所有需要缩放的画面大小总数，作为分母
    //CSignalMapToScreen *mapToScreen= m_calReduceInOneInput.value(signal->ip);
    qDebug()<<"计算每一个信号源中，需要scale的画面的实际占用的流量大小";
    QHash<QString,CSignalMapToScreen*>::iterator itor = m_calReduceInOneInput.begin();
    while(itor != m_calReduceInOneInput.end())
    {
        CSignalMapToScreen *mapToScreen = itor.value();
        for(int i=0;i<mapToScreen->mapSignalId.size();++i)
        {
            CScreenSignal * s=m_allSignals.findSignalInScreen(mapToScreen->mapSignalId[i]);
            if(s != NULL)
            {
                if(s->configScale != NoScale)
                {
                    mapToScreen->scaleContentSize += s->screenContentSize;
                }
            }
        }
        ++itor;
    }
    //这里计算每一个输入节点，对于每一个缩小画面的压缩比例的计算
    //第二遍，将每一个画面/分母，获取一个比例，再*实际可以使用的流量，就是实际可以使用的流量
    qDebug()<<"第二遍，将每一个画面/分母，获取一个比例，再*实际可以使用的流量，就是实际可以使用的流量";
    itor = m_calReduceInOneInput.begin();
    int allReduceContentSize=0;
    int temp1=0;
    while(itor != m_calReduceInOneInput.end())
    {
        CSignalMapToScreen *mapToScreen = itor.value();
        unsigned long contentSizeCanUse=mapToScreen->allContentSize-mapToScreen->noScaleContentSize;
        qDebug()<<"mapToScreen->mapSignalId"<<mapToScreen->mapSignalId;
        for(int i=0;i<mapToScreen->mapSignalId.size();++i)
        {
            CScreenSignal * s=m_allSignals.findSignalInScreen(mapToScreen->mapSignalId[i]);
            qDebug()<<"ss"<<s->id;
            if(s != NULL)
            {
                if(s->configScale != NoScale)
                {
                    //得到的这个信号画面实际可以占用的流量带宽
                    s->reduceContentSize=
                    contentSizeCanUse*(s->screenContentSize*1.0/mapToScreen->scaleContentSize);
                    //qDebug()<<"s->reduceContentSize s="<<s->reduceContentSize;
                    //如果缩放后大小比原本还大，则选择原来尺寸
                    if(s->reduceContentSize >= s->signalWidth*s->signalHeight)
                        s->reduceContentSize = s->signalWidth*s->signalHeight;
                    allReduceContentSize += s->reduceContentSize;
                    qDebug()<<"s->reduceContentSize"<<s->reduceContentSize<<s->id<<s->ip<<contentSizeCanUse
                           <<s->screenContentSize<<mapToScreen->scaleContentSize<<
                             (unsigned long)(contentSizeCanUse*s->screenContentSize*1.0);
                    //接下来以可以占用的流量带宽计算压缩，放大参数
                    double index;
                    if(s->screenContentSize == s->signalWidthInScreen*s->signalHeightInScreen)//全屏缩小情形,或者与信号完全相同情形
                    {
                        qDebug()<<"全屏缩小情形,或者与信号完全相同情形"<<s->id<<s->ip<<s->x<<s->y<<s->signalWidthInScreen<<s->signalHeightInScreen;
                        getCoeficientAndWH(s->reduceContentSize,s->signalWidth*s->signalHeight, index, 2,s);
                    }
                    if(s->screenContentSize < s->signalWidthInScreen*s->signalHeightInScreen &&
                            s->signalWidthInScreen*s->signalHeightInScreen==s->signalWidth*s->signalHeight )
                    {
                        //整体全屏，且大小与信号源完全相同，但是中间有空洞情形
                        qDebug()<<"整体全屏，但是中间有空洞情形"<<s->id<<s->ip<<s->x<<s->y<<s->signalWidthInScreen<<s->signalHeightInScreen;
                        getCoeficientAndWH(s->reduceContentSize,s->screenContentSize, index, 2,s);
                    }
                    if(s->signalWidthInScreen*s->signalHeightInScreen < s->signalWidth*s->signalHeight &&
                           s->screenContentSize < s->signalWidthInScreen*s->signalHeightInScreen )//全屏缩小，同时中间有空洞情形
                    {
                        qDebug()<<"全屏缩小，同时中间有空洞情形"<<s->id<<s->ip<<s->x<<s->y<<s->signalWidthInScreen<<s->signalHeightInScreen;
                        //实际数据所占的比例,实际上是一个数的平方
                        double kIndex=s->screenContentSize*1.0/(s->signalWidthInScreen*s->signalHeightInScreen*1.0);
                        unsigned long tempContent=s->signalWidth*s->signalHeight*1.0*kIndex;

                        getCoeficientAndWH(s->reduceContentSize,tempContent, index, 2,s);
                        qDebug()<<"tempContent"<<tempContent<<kIndex<<s->signalWidth*index<<s->signalHeight*index;

                    }
                    if(s->reduceContentSize > s->signalWidthInScreen*s->signalHeightInScreen)//可以用的流量，比输出节点中画面还要大，则无需缩小
                    {
                        index = Index_NoScale;
                    }
                    //得到第一次输出节点的放大系数
                    int xAmplify, yAmplify;
                    if(index == Index_NoScale){
                        xAmplify=64;//不需要放大
                        yAmplify=64;
                    }else
                        getOutputNodeAmplifyCoeficient(s->signalWidth*index,s->signalHeight*index
                                ,s->signalWidthInScreen ,s->signalHeightInScreen,xAmplify,yAmplify);
                    s->outputAmplifyX=xAmplify;
                    s->outputAmplifyY=yAmplify;
                    qDebug()<<"xAmplify"<<xAmplify<<yAmplify<<s->reduceContentSize<< s->signalWidthInScreen*s->signalHeightInScreen
                           <<index;
                    //确定输入节点缩小画面大小
                    int outWidth,  outHeight;
                    if(index == Index_NoScale)
                    {
                        outWidth = s->signalWidthInScreen;
                        outHeight = s->signalHeightInScreen;
                        qDebug()<<"outWidth"<<outWidth<<outHeight<<outWidth%4<<outHeight%2;
                        if(outWidth%4 != 0)//4的倍数
                        {
                            outWidth += (4-outWidth%4);
                        }
                        if(outHeight%2 != 0)//2的倍数
                        {
                            outHeight += 1;
                        }
                        qDebug()<<"xx  outWidth"<<outWidth<<outHeight;
                    }else
                        getInputNode_OutSignalWidthHeight(s->signalWidthInScreen,s->signalHeightInScreen,xAmplify,yAmplify,outWidth,  outHeight);
                    s->m_reduceDraw.width=outWidth;
                    s->m_reduceDraw.height=outHeight;
                    qDebug()<<"输入节点缩小画面大小"<<outWidth<<outHeight<<s->signalWidthInScreen<<s->signalHeightInScreen;
                    //确定输入节点缩小系数
                    double xReduce,yReduce;
                    getInputNodeReduceCoeficient(s->signalWidth,s->signalHeight,outWidth,outHeight,xReduce,yReduce);
                    s->m_reduceDraw.xReduce=xReduce;
                    s->m_reduceDraw.yReduce=yReduce;
                    qDebug()<<"reduce 1"<<xReduce<<yReduce<<s->signalWidth<<s->signalHeight<<outWidth<<outHeight<<index;
                    //计算为了使屏幕恰好那么大，两个放大参数的分割处
                    double splitXPos, splitYPos;
                    if(!checkIfInteger(xReduce))
                        setInputNodeSplitX(s->signalWidth,outWidth,(int)xReduce,splitXPos);
                    if(!checkIfInteger(yReduce))
                        setInputNodeSplitY(s->signalHeight,outHeight,(int)yReduce,splitYPos);
                    //qDebug()<<"reduce 2"<<splitXPos<<splitYPos;
                    s->m_reduceDraw.xSpliteReduce=splitXPos;
                    s->m_reduceDraw.ySpliteReduce=splitYPos;
                    s->m_reduceDraw.xOffset=0;
                    s->m_reduceDraw.yOffset=0;

                    QRect rc;
                    for(int k=0;k<s->allSpliteWindowsInfo.size();++k)
                    {

                        rc=s->allSpliteWindowsInfo[k].splitWindows;
                        //qDebug()<<"rc old"<<rc<<s->id<<k;
                        procWindowRc(rc,s->outputAmplifyX,s->outputAmplifyY);
                        //qDebug()<<"rc new"<<rc<<s->id<<k;
                        temp1 += rc.width()*rc.height();
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw=rc;//获取压缩后的大小

                        //原始的x,y,width,height
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setX(
                                    s->m_reduceDraw.width*(s->allSpliteWindowsInfo[k].splitWindows.x()-s->x)/
                                    s->signalWidthInScreen);
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setY(
                                    s->m_reduceDraw.height*(s->allSpliteWindowsInfo[k].splitWindows.y()-s->y)/
                                    s->signalHeightInScreen);
                        double tempWidth = s->m_reduceDraw.width*s->allSpliteWindowsInfo[k].splitWindows.width()/
                                s->signalWidthInScreen;
                        if( checkIfInteger(tempWidth) )
                            s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setWidth(tempWidth);
                        else
                            s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setWidth((int)tempWidth+1);
                        double tempHeight = s->m_reduceDraw.height*s->allSpliteWindowsInfo[k].splitWindows.height()/
                                s->signalHeightInScreen;
                        if( checkIfInteger(tempHeight) )
                            s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setHeight(tempHeight);
                        else
                            s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setHeight((int)tempHeight+1);

                        qDebug()<<"before s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify"<<
                                  s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify
                               <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.x()
                              <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.y()
                             <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.right()
                            <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.bottom();

                        //再次计算x,y,width,height
                        int startix=(int)(s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.x());
                        startix = startix-(startix%4);//4的倍数，起点取小
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setX(startix);

                        int startiy=(int)(s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.y());
                        startiy = startiy-(startiy%2);//2的倍数，起点取小
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setY(startiy);


                        int endix=s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.right()+1;
                        if(endix%4 != 0)
                        {
                            endix += (4-endix%4);
                        }
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setRight(endix-1);


                        int endiy=s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.bottom()+1;
                        if(endiy%2 != 0)
                        {
                            endiy += 1;
                        }
                        s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.setBottom(endiy-1);
                        qDebug()<<"after s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify"<<
                                  s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify
                               <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.x()
                              <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.y()
                             <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.right()
                            <<s->allSpliteWindowsInfo[k].splitWindowsAtInputDraw_Modify.bottom();

                        double dPackNum=rc.width()*rc.height()*1.5/1024;
                        int iPackNum=(int)(dPackNum);
                        //if( (dPackNum-iPackNum) <= 1e-15 )//是否有小数点
                        if(checkIfInteger(dPackNum))
                        {
                            //整数
                        }else
                            iPackNum += 1;
                        s->allSpliteWindowsInfo[k].packNum=(int)iPackNum;
                        qDebug()<<"k<s->allSplitWindows"<<k<<iPackNum<<
                                  dPackNum<<dPackNum-iPackNum<<1e-15<<(0.1 <= 1e-15)
                               <<s->allSpliteWindowsInfo[k].packNum<<k<<(dPackNum-qAbs(dPackNum))<<(dPackNum-iPackNum);
                        //for(int u=0;u<iPackNum;++u)
                        //    s->allSendWindowDataPack.push_back(k);
                    }
                }
            }
        }
        ++itor;
    }
    qDebug()<<"allReduceContentSize"<<allReduceContentSize<<temp1;
}

void CCalcPosGenConfigFile::setInputNodeSplitY(int inHeight,int outHeight,int ycoeficient,double &splitYPos)
{
    splitYPos=(outHeight*1.0*ycoeficient*(ycoeficient+1)-inHeight*64*1.0*ycoeficient)/(64*1.0);
    if(splitYPos - (int)splitYPos > 0.000001)
        splitYPos = (int )splitYPos+1;
}

void CCalcPosGenConfigFile::setInputNodeSplitX(int inWidth,int outWidth,int xcoeficient, double &splitXPos)
{
    splitXPos=(outWidth*1.0*xcoeficient*(xcoeficient+1)-inWidth*64*1.0*xcoeficient)/(64*1.0);
    if(splitXPos -(int)splitXPos > 0.000001)
        splitXPos = (int)splitXPos+1;

}

//获取输入节点的缩小参数
void CCalcPosGenConfigFile::getInputNodeReduceCoeficient(int inWidth,int inHeight,int outWidth,int outHeight,double &xReduce,double &yReduce)
{
    xReduce = inWidth*1.0*64/outWidth;
    yReduce = inHeight*1.0*64/outHeight;
}

void CCalcPosGenConfigFile::getInputNode_OutSignalWidthHeight(int inWidth, int inHeight, int xIndex, int yIndex, int &outWidth, int &outHeight)
{
    outWidth = inWidth*xIndex/64;
    outHeight = inHeight*yIndex/64;

    if(outWidth%4 != 0)//4的倍数
    {
        outWidth += (4-outWidth%4);
    }
    if(outHeight%2 != 0)//2的倍数
    {
        outHeight += 1;
    }
}

void CCalcPosGenConfigFile::getOutputNodeAmplifyCoeficient(int inputWidth, int inputHeight,int outputNodeWidth,
                                    int outputNodeHeight,int &xAmplify,int &yAmplify)
{
    xAmplify = inputWidth*64/outputNodeWidth;
    yAmplify = inputHeight*64/outputNodeHeight;
}

bool CCalcPosGenConfigFile::checkIfInteger(double value)//测试value是否是整数
{
    int iValue=(int)value;
    if( (value-iValue) < 1e-15 )//是否有小数点
    {
        //整数
        return true;
    }else
        return false;
}
bool CCalcPosGenConfigFile::ifDoubleEqual(double v1,double v2)//测试两个浮点数是否相等
{
    if( v1-v2 < 1e-15 )
    {
        //相等
        return true;
    }else
        return false;
}




