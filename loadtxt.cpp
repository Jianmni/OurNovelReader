// WF 2023051604037
// edit at 2025/6/19 ...  6/23
// correct some liitle logic error
#include "loadtxt.h"
#include <QFile>
#include <QDir>

LoadTxt::LoadTxt(QObject *parent) : QObject(parent)
{}

// 每次都需要调用这个函数添加新书
// 初始化各项数据：章节数=0，初始化书籍文件夹，目录内容清除
// 新建各个文件：新建目录文本文件，书籍信息文本文件，新建用来保存各章的子文件夹
// 处理文本内容，划分各章节，保存章节目录
// 处理书籍信息
// 失败时全书删除，导入失败
bool LoadTxt::loadLocalBook(const QString &filepath, int id)
{
    /* prepare  */
    m_chapterCount = 0;
    m_bookDir = tr("books/%1/").arg(id); // ./books/20 dir
    qDebug() << "On LoadTxt::loadLocalBook: m_bookDir " << m_bookDir;
    m_content.clear();

    // create files to store txt info and context
    createFiles();

    return processText(filepath);    // then process info
}

// 新建文件
// 如果books目录不存在，则需要初始化。一般在第一次打开应用时进行
// 新建目录文本文件，书籍信息文本文件，新建用来保存各章的子文件夹
// 失败时全书删除，导入失败
void LoadTxt::createFiles()
{
    QDir cur(".");
    if (!cur.exists("books"))
    {
        cur.mkdir("books");
        emit shouldInit();  // let book list manager create booklist.json
    }

    cur.mkdir(m_bookDir);
    qDebug() << "On LoadTxt createFiles: mkdir" << m_bookDir;

    QFile first(m_bookDir+"content.txt");     // for content
    first.open(QIODeviceBase::NewOnly);

    QFile second(m_bookDir+"info.txt");       // for read info
    second.open(QIODeviceBase::NewOnly);
}

// 处理文本
// 各章节应该从“第”开始，到下一个“第”结束，中间是正文内容
// 如果超过百行不存在“第”字开头行，认为不存在章节划分，不继续处理，加载失败
// 先读取一章，等到下一章开始，保存章节内容，保存添加章节目录，处理下一章
// 处理完毕，保存章节目录
// 处理书籍信息
// 失败时全书删除，导入失败
bool LoadTxt::processText(const QString& filepath)
{
    QFile text(filepath);
    if (!text.open(QIODeviceBase::ReadOnly | QIODeviceBase::Text))
    {
        qWarning() << "On LoadTxt processTxt: File open failed: " + filepath;
        deleteBook();
        return false;
    }
    QTextStream in(&text);

    QString title;          //   title of a chapter

    // find first titel
    int count = 0;
    while (!in.atEnd() && count < 100)
    {
        count++;
        QString line = in.readLine();
        if (line.isEmpty()) continue;

        if (line.first(1) != "第" && line.first(1) != "前")  continue; // 第一章， 前言
        else if (line.length() > 30) continue;

        int spacePos = line.lastIndexOf(" ");
        if (spacePos == -1) continue;
        m_chapterCount++;
        title = line.last(line.length() - spacePos);
        title = tr("第%1章 %2").arg(m_chapterCount).arg(title);

        break;
    }

    // 这本书很可能没有章节划分
    // this book propably has no chapters
    if (count == 100)
    {
        qDebug() << "On LoadTxt processTxt:(count == 100): " << (count == 100);
        deleteBook();
        return false;
    }

    qDebug() << "On LoadTxt processTxt: Find first title: " << title;

    // process line by line
    QStringList context;    // context of a chapter
    // count = 0;
    while(!in.atEnd())
    {
        QString line = in.readLine() ;
        if (line.isEmpty()) continue;

        if (line.length()>4 &&  line.last(4) == "---") continue;
        else if (line.first(1) == "第")
        {
            if (line.length() > 24) continue;
            int spacePos = line.lastIndexOf(" ");
            if (spacePos == -1) continue;

            // write context to file
            if (!writeChapter(context, title)) {
                deleteBook();
                return false;
            }
            context.clear();        // clear for next chapter

            // next chapter
            m_chapterCount++;
            title = line.last(line.length() - spacePos);
            title = tr("第%1章 %2").arg(m_chapterCount).arg(title);
        }
        else    // true line of context
        {
            QString pure = line.remove(' ');
            context.append(pure);
        }
        // qDebug() << "On LoadTxt processText: Line: " << count;
        // count++;
    }
    if (!context.isEmpty())
        if (!writeChapter(context, title)) {
            deleteBook();
            return false;
        }

    // write content
    QFile ctt(m_bookDir + "content.txt");
    if (!ctt.open(QIODevice::WriteOnly))
    {
        deleteBook();
        return false;
    }
    QTextStream out(&ctt);
    for (auto &item: m_content)
        out << item << '\n';


    return processInfo(filepath);
}

// 处理书籍信息
// 读取书籍名字
// 6/23
// 读取作者、简介信息。我得到的文本只有在网站界面存在，文本内没有，所以暂时处理不了
// 写入当前阅读章节 = 0 ===> 阅读时从封面开始
// 当前页 = 0          ===> 阅读时从封面开始
// 总章节数
// 总页数 0            ===> 第一次阅读时处理
// 写入书名、作者
// 写入简介
// 失败时全书删除，导入失败
bool LoadTxt::processInfo(const QString &filepath)
{
    QString bkname {"未知书籍"};                // write after read all text
    int ltcolon = filepath.lastIndexOf('/');
    bkname = filepath.last(filepath.length() - ltcolon-1);  // Love.txt
    int ltdot = bkname.lastIndexOf(".");
    bkname = bkname.first(ltdot);                           // Love

    QString author {"佚名"};
    // get author name
    // ...
    QString brief {"无简介"};
    // get book introduction
    // ...

    QString infoPath = m_bookDir + "info.txt";
    QFile info(infoPath);
    if(!info.open(QIODeviceBase::WriteOnly))
    {
        qWarning() << "On  LoadTxt::processInfo: Open file failed: " + filepath;
        deleteBook();
        return false;
    }
    QTextStream out(&info);
    out << "0\n0\n";                         // current read content, apge
    out << m_content.size() << "\n0\n";      // total content num, total page num
    out << bkname << '\n' <<author << '\n';
    out << 0 << '\n' << 0 << '\n' << 0 << '\n'; // read hour, minute, second
    out << brief << '\n';
    return true;
}


// 保存章节内容
// 先写入章节号，再写入章节名称，再写入正文内容
// 失败时全书删除，导入失败
bool LoadTxt::writeChapter(const QStringList &context, const QString &title)
{
    QString last = tr("%1%2.txt").arg(m_bookDir).arg(m_chapterCount);
    QFile lastChapter(last);
    if (!lastChapter.open(QIODeviceBase::NewOnly | QIODeviceBase::ReadWrite))
    {
        qWarning() << "On LoadTxt writeChapter: Error happened. Load stopped.";
        return false;
    }
    // write
    QTextStream out(&lastChapter);
    // seperate title num and name
    int pos = title.indexOf(' ');   // 第一章 芜芜芜, 3
    QString num = title.first(pos);                     // 第一章
    QString name = title.last(title.length() - pos -2); // 芜芜芜, 7 - 3 - 1 = 3
    out << num << '\n' << name <<'\n';
    for (const auto &line : context)
        out << line << '\n';

    lastChapter.close();
    m_content.append(title);
    return true;
}

// 导入失败，删除书籍
// 进入书籍目录，删除所有txt文件
// 删除目录
void LoadTxt::deleteBook()      // delete when import book failed
{
    QDir dir(m_bookDir);
    QStringList files = dir.entryList();
    for (auto &file: files)
    {
        QString path = m_bookDir + file;
        QFile::remove(path);
    }
    dir.cdUp();
    dir.rmdir(m_bookDir);
}

// 保存信息失败、从书架移除，根据id删除书籍
// 可能在导入，保存当前书籍目录，删除指定书籍后恢复
// 进入书籍目录，删除所有txt文件
// 删除目录
void LoadTxt::deleteBook(int id)    // delete when load info to booklist.json failed
{
    QString tmp = m_bookDir;        // when load new book, save current book path
    m_bookDir = tr("books/%1/").arg(id); // ./books/20 dir
    deleteBook();
    m_bookDir = tmp;
}
