using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Timers;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace SwRel
{
    public enum MessageType
    {
        Error,
        Connected,
        CommandSent,
        MessageRecived
    }
    public class MessageResult
    {
        public MessageType ResultCode { get; set; }
        public string Message { get; set; }
    }
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window ,INotifyPropertyChanged
    {
        System.Threading.Timer m_Timer = null;
        private MessageResult _MessageResult;
        public MessageResult MessageResult
        {
            get
            {
                return _MessageResult;
            }
            set
            {
                if(_MessageResult != value)
                {
                    _MessageResult = value;
                    switch(_MessageResult.ResultCode)
                    {
                        case MessageType.Connected:
                            {
                                ThreadInvoker.Instance.RunByUiThread(() =>
                                {
                                    int intervaal = 1000;
                                    if (!int.TryParse(txtInterval.Text, out intervaal))
                                        intervaal = 1000;
                                    m_Timer = new System.Threading.Timer(TimerCallback, null, intervaal, intervaal);
                                    this.Status = _MessageResult.Message;
                               
                                    DoConnect.Content = "Stop Listening";
                                });
                                break;
                            }
                        case MessageType.CommandSent:
                            {
                                this.Status = _MessageResult.Message;
                                break;
                            }
                        case MessageType.Error:
                            {
                                this.Status = _MessageResult.Message;
                                break;
                            }
                        case MessageType.MessageRecived:
                            {
                                this.Result = string.Format(" {0} at ( {1} )", _MessageResult.Message ,DateTime.Now.ToString("hh:mm:ss.FFF")) ;
                                ParseMessage(_MessageResult.Message);
                                break;
                            }
                    }
                }
            }
        }

        private void ParseMessage(string msg)
        {
            try
            {
                msg = msg.Replace("$", string.Empty).Replace("\n", string.Empty).Replace("\r", string.Empty);
                var parts = msg.Split(',');
                var target = parts[3];
                //target = "00101000";
                UpSwitch = target[2].ToString().Equals("1") ? true : false;
                DownSwitch = target[3].ToString().Equals("1") ? true : false;
                EyeSenasor = target[4].ToString().Equals("1") ? true : false;
            }
            catch
            {
                this.Status = "Error in parsing data";
            }
            
        }

        private string _Result = string.Empty;
        public string Result
        {
            get
            {
                return _Result;
            }
            set
            {
                if(_Result != value)
                {
                    _Result = value;
                    NotifyPropertyChanged("Result");
                }
            }
        }


        private string _Status = string.Empty;
        public string Status
        {
            get
            {
                return _Status;
            }
            set
            {
                if(_Status != value)
                {
                    _Status = value;
                    NotifyPropertyChanged("Status");
                }
            }
        }


        private bool _UpSwitch = false;
        public bool UpSwitch
        {
            get
            {
                return _UpSwitch;
            }
            set
            {
                if(_UpSwitch != value)
                {
                    _UpSwitch = value;
                    NotifyPropertyChanged("UpSwitch");
                }
            }
        }

        private bool _DownSwitch = false;
        public bool DownSwitch
        {
            get
            {
                return _DownSwitch;
            }
            set
            {
                if (_DownSwitch != value)
                {
                    _DownSwitch = value;
                    NotifyPropertyChanged("DownSwitch");
                }
            }
        }

        private bool _EyeSenasor = false;
        public bool EyeSenasor
        {
            get
            {
                return _EyeSenasor;
            }
            set
            {
                if (_EyeSenasor != value)
                {
                    _EyeSenasor = value;
                    NotifyPropertyChanged("EyeSenasor");
                }
            }
        }


        protected void TimerCallback(object state)
        {
            try
            {
                this.Dispatcher.Invoke((Action)(() =>
                    {
                        string IP = txtIP.Text;
                        string Port = txtPort.Text;
                        ThreadInvoker.Instance.RunByNewThread(() =>
                        {
                            this.MessageResult = connectSocket(IP, Port, "X");
                        });
                    }));
            }
            catch(Exception ex)
            {

            }
        }

        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = this;
            ThreadInvoker.Instance.InitDispatcher();

            ThreadInvoker.Instance.RunByNewThread(() => {
                UpSwitch = false;
                DownSwitch = false;
                EyeSenasor = false;
                System.Threading.Thread.Sleep(500);
                UpSwitch = true;
                DownSwitch = true;
                EyeSenasor = true;
                System.Threading.Thread.Sleep(500);
                UpSwitch = false;
                DownSwitch = false;
                EyeSenasor = false;
            });
        }

        private void DocommandO_Click(object sender, RoutedEventArgs e)
        {
            string IP = txtIP.Text;
            string Port = txtPort.Text;
            ThreadInvoker.Instance.RunByNewThread(() =>
                {
                    this.MessageResult = connectSocket(IP, Port, "O");
                });
        }

        private void DocommandC_Click(object sender, RoutedEventArgs e)
        {
            string IP = txtIP.Text;
            string Port = txtPort.Text;
            ThreadInvoker.Instance.RunByNewThread(() =>
            {
                this.MessageResult = connectSocket(IP, Port, "C");
            });
        }

        private void DocommandX_Click(object sender, RoutedEventArgs e)
        {
            string IP = txtIP.Text;
            string Port = txtPort.Text;
            ThreadInvoker.Instance.RunByNewThread(() =>
            {
                this.MessageResult = connectSocket(IP, Port, "X");
            });
        }

        private void DoConnect_Click(object sender, RoutedEventArgs e)
        {
            if (DoConnect.Content.Equals("Start Listening"))
            {
                string IP = txtIP.Text;
                string Port = txtPort.Text;
                ThreadInvoker.Instance.RunByNewThread(() =>
                {
                    this.MessageResult = connectSocket(IP, Port, "");
                });
            }
            else
            {
                DoConnect.Content = "Start Listening";
                m_Timer.Dispose();
            }
        }

        private MessageResult connectSocket(string IP, string Port, string msg)
        {
            string str1 = string.Empty;
            MessageResult result = new  MessageResult();
            Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            try
            {
                socket.ReceiveTimeout = 10000;
                socket.SendTimeout = 10000;
                try
                {
                    IPAddress ip;
                    if (!IPAddress.TryParse(IP, out ip))
                    {
                        throw new FormatException("Invalid ip-adress");
                    }
                    int port;
                    if (!int.TryParse(Port, NumberStyles.None, NumberFormatInfo.CurrentInfo, out port))
                    {
                        throw new FormatException("Invalid port");
                    }
                    socket.Connect(ip, port);
                }
                catch(Exception ex)
                {
                    result.ResultCode = MessageType.Error;
                    result.Message = ex.Message.ToString();
                    return result;
                }
                socket.Send(Encoding.UTF8.GetBytes(msg));
                if (msg.Equals("X"))
                {
                    byte[] numArray = new byte[8192];
                    int length = socket.Receive(numArray);
                    if (length != 0)
                    {
                        string str2 = Encoding.Default.GetString(numArray).Substring(0, length);
                        str1 = str2;
                    }
                }
                else
                {
                    if (msg.Length < 1)
                    {
                        result.ResultCode = MessageType.Connected;
                        result.Message = "Connected";
                        return result;
                    }
                    else
                    {
                        result.ResultCode = MessageType.CommandSent;
                        result.Message = "Command was sent";
                        return result;
                    }
                }
            }
            catch (Exception ex)
            {
                result.ResultCode = MessageType.Error;
                result.Message = ex.Message.ToString();
                return result;
            }
            finally
            {
                try
                {
                    socket.Shutdown(SocketShutdown.Both);
                }
                catch
                {
                }
            }
            result.ResultCode = MessageType.MessageRecived;
            result.Message = str1;
            return result;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        private void Window_Closing(object sender, CancelEventArgs e)
        {
            try
            {
                ThreadInvoker.Instance.Dispose();
            }
            catch { }
        }
    }
}
