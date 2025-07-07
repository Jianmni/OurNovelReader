#include "textmanager.h"
#include <QDebug>

TextManager::TextManager(QObject *parent)
    : QObject{parent}
{}

// 格式化文本
// 读取整个文本，把每一段按照软件一行字数截断，然后加入到一组数组中
// 每页按照行数一次读取数组中的文字，读够一页，拼接传递给Text显示
QList<QString> TextManager::formulaTxt(QList<QString> txt)
{
    QList<QString> ret {};
    if( txt.isEmpty())      // previous or next chapter is null
    {
        return ret;
    }
    // num   第n章
    ret.append(txt[0]);
    // title
    ret += processTitle(txt[1]);
    // septerator
    ret.append("#");    // 2
    // 正文
    int len = txt.length();
    if (len < 2)
    {
        ret.append("-");
        return ret;
    }
    for (int i=2; i<len; ++i)
    {
        QList<QString> lines = processLine(txt[i]);
        ret += lines;
    }

    qDebug() << ret.length();
    return ret;
}

// 但配置字体改变时，改变此处信息
void TextManager::changeInfo(int cn, int tc)
{
    m_charNum = cn;
    m_ttChNum = tc;
}

// 处理标题
// 标题的大小和普通文本不一样
QList<QString> TextManager::processTitle(QString title)
{
    QList<QString> ret {};
    int len = title.length();
    if (len > m_ttChNum)
    {
        int lineNum = len / m_ttChNum;
        int remainder = len % m_ttChNum;
        if (remainder != 0) lineNum++;

        int pos = 0;
        while (lineNum) // pos < len
        {
            QString tmp {};
            if ((pos + m_ttChNum) > len)
                tmp = title.sliced(pos, len - pos);
            else
                tmp = title.sliced(pos, m_ttChNum);
            ret.append(tmp);
            pos += m_ttChNum;
            --lineNum;
        }
    }
    else ret.append(title);
    return ret;
}

// 处理单行文字
QList<QString> TextManager::processLine(QString line)
{
    QList<QString> ret {};
    int len = line.length();

    QString firstLine {"       "};        // two spaces
    if (len <= m_charNum-2)
    {
        firstLine += line;
        ret.append(firstLine);
    }
    else
    {
        int lineNum = len / m_charNum;
        int remainder = (len + 2) % m_charNum;
        if (remainder != 0) lineNum++;

        firstLine += line.sliced(0, m_charNum-2);
        ret.append(firstLine);
        lineNum--;

        int pos = m_charNum - 2;
        while (lineNum)
        {
            QString tmp {};
            if ((pos + m_charNum) >= len)
                tmp = line.sliced(pos, len - pos);
            else
                tmp = line.sliced(pos, m_charNum);
            ret.append(tmp);
            pos += m_charNum;
            lineNum--;
        }
    }

    return ret;
}
