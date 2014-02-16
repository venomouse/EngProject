using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.IO;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Drawing;
using System.Drawing.Imaging;
using Microsoft.Kinect;
using Microsoft.Kinect.Toolkit;
using Microsoft.Samples.Kinect.WpfViewers;
using AviFile;


public class MainWindow : Window
{
    // Fields
    private int _colorFrameCount = 0;
    private AviManager _colorRecord = null;
    private VideoStream _colorStream;
    private StreamWriter _CommentsFile = null;
    private bool _contentLoaded;
    private StreamWriter _DataFile = null;
    private int _depthFrameCount = 0;
    private AviManager _depthRecord = null;
    private VideoStream _depthStream;
    private long _lastFrameTimestamp;
    private bool _movieRecordingOn = false;
    private KinectSensor _sensor;
    private Skeleton[] _skeletonData;
    private bool _skeletonRecordingOn = false;
    private int _skelFrameCount = 0;
    internal TextBox ageBox;
    internal TextBox badDetectionBox;
    private const double BodyCenterThickness = 7.0;
    private readonly System.Windows.Media.Brush centerPointBrush = System.Windows.Media.Brushes.Blue;
    private const double ClipBoundsThickness = 7.0;
    internal TextBox commentBox;
    private DrawingGroup drawingGroup;
    internal Ellipse ellipse1;
    internal TextBox fileNameTextBox;
    internal Button flushCommentsButton;
    internal System.Windows.Controls.Image image1;
    internal System.Windows.Controls.Image image2;
    private DrawingImage imageSource;
    private readonly System.Windows.Media.Pen inferredBonePen = new System.Windows.Media.Pen(System.Windows.Media.Brushes.Gray, 1.0);
    private readonly System.Windows.Media.Brush inferredJointBrush = System.Windows.Media.Brushes.Yellow;
    private const double JointThickness = 2.0;
    internal Label label1;
    internal Label label2;
    internal Label label3;
    internal Label label4;
    internal Label label5;
    internal Label label6;
    internal Button movieButton;
    internal TextBox qualityBox;
    internal RadioButton radioButton1;
    internal Button recordButton;
    internal System.Windows.Shapes.Rectangle rectangle1;
    private const float RenderHeight = 360f;
    private const float RenderWidth = 480f;
    internal TextBox severityBox;
    internal System.Windows.Controls.Image skeletonImage;
    internal Button stopButton;
    private readonly System.Windows.Media.Pen trackedBonePen = new System.Windows.Media.Pen(System.Windows.Media.Brushes.Green, 6.0);
    private readonly System.Windows.Media.Brush trackedJointBrush = new SolidColorBrush(System.Windows.Media.Color.FromArgb(0xff, 0x44, 0xc0, 0x44));

    // Methods
    public MainWindow()
    {
        InitializeComponent();
    }

    private void _sensor_AllFramesReady(object sender, AllFramesReadyEventArgs e)
    {
        using (ColorImageFrame frame = e.OpenColorImageFrame())
        {
            if (frame != null)
            {
                byte[] pixelData = new byte[frame.PixelDataLength];
                frame.CopyPixelDataTo(pixelData);
                int stride = frame.Width * 4;
                BitmapSource source = BitmapSource.Create(frame.Width, frame.Height, 96.0, 96.0, PixelFormats.Bgr32, null, pixelData, stride);
                this.image1.Source = source;
                if (this._movieRecordingOn)
                {
                    Bitmap firstFrame = new Bitmap(source.PixelWidth, source.PixelHeight, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
                    BitmapData bitmapdata = firstFrame.LockBits(new System.Drawing.Rectangle(System.Drawing.Point.Empty, firstFrame.Size), ImageLockMode.WriteOnly, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
                    source.CopyPixels(Int32Rect.Empty, bitmapdata.Scan0, bitmapdata.Height * bitmapdata.Stride, bitmapdata.Stride);
                    firstFrame.UnlockBits(bitmapdata);
                    if (this._colorFrameCount == 0)
                    {
                        this._lastFrameTimestamp = frame.Timestamp;
                        this._colorStream = this._colorRecord.AddVideoStream(false, 25.0, firstFrame);
                        this._colorFrameCount++;
                    }
                    else
                    {
                        this._colorStream.AddFrame(firstFrame);
                        this._colorFrameCount++;
                    }
                    firstFrame.Dispose();
                }
            }
        }
    }

    private void _sensor_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
    {
        using (SkeletonFrame frame = e.OpenSkeletonFrame())
        {
            if ((frame != null) && (this._skeletonData != null))
            {
                frame.CopySkeletonDataTo(this._skeletonData);
                this.AccessSkeletonData(frame);
            }
        }
        using (DrawingContext context = this.drawingGroup.Open())
        {
            context.DrawRectangle(Brushes.Black, null, new Rect(0.0, 0.0, 480.0, 360.0));
            if (this._skeletonData.Length != 0)
            {
                foreach (Skeleton skeleton in this._skeletonData)
                {
                    RenderClippedEdges(skeleton, context);
                    if (skeleton.TrackingState == SkeletonTrackingState.Tracked)
                    {
                        this.DrawBonesAndJoints(skeleton, context);
                    }
                    else if (skeleton.TrackingState == SkeletonTrackingState.PositionOnly)
                    {
                        context.DrawEllipse(this.centerPointBrush, null, this.SkeletonPointToScreen(skeleton.Position), 7.0, 7.0);
                    }
                }
            }
            this.drawingGroup.ClipGeometry = new RectangleGeometry(new Rect(0.0, 0.0, 480.0, 360.0));
        }
    }

    private void AccessSkeletonData(SkeletonFrame skeletonFrame)
    {
        if (this._skelFrameCount == 0)
        {
            this._lastFrameTimestamp = skeletonFrame.Timestamp;
        }
        foreach (Skeleton skeleton in this._skeletonData)
        {
            if ((skeleton.TrackingState == SkeletonTrackingState.Tracked) && this._skeletonRecordingOn)
            {
                this.radioButton1.IsChecked = true;
                float num = ((float)(skeletonFrame.Timestamp - this._lastFrameTimestamp)) / 1000f;
                object[] arg = new object[0x3d];
                Joint joint = skeleton.Joints[JointType.Head];
                arg[0] = joint.Position.X;
                joint = skeleton.Joints[JointType.Head];
                arg[1] = joint.Position.Y;
                joint = skeleton.Joints[JointType.Head];
                arg[2] = joint.Position.Z;
                joint = skeleton.Joints[JointType.ShoulderCenter];
                arg[3] = joint.Position.X;
                joint = skeleton.Joints[JointType.ShoulderCenter];
                arg[4] = joint.Position.Y;
                joint = skeleton.Joints[JointType.ShoulderCenter];
                arg[5] = joint.Position.Z;
                joint = skeleton.Joints[JointType.ShoulderLeft];
                arg[6] = joint.Position.X;
                joint = skeleton.Joints[JointType.ShoulderLeft];
                arg[7] = joint.Position.Y;
                joint = skeleton.Joints[JointType.ShoulderLeft];
                arg[8] = joint.Position.Z;
                joint = skeleton.Joints[JointType.ElbowLeft];
                arg[9] = joint.Position.X;
                joint = skeleton.Joints[JointType.ElbowLeft];
                arg[10] = joint.Position.Y;
                joint = skeleton.Joints[JointType.ElbowLeft];
                arg[11] = joint.Position.Z;
                joint = skeleton.Joints[JointType.WristLeft];
                arg[12] = joint.Position.X;
                joint = skeleton.Joints[JointType.WristLeft];
                arg[13] = joint.Position.Y;
                joint = skeleton.Joints[JointType.WristLeft];
                arg[14] = joint.Position.Z;
                joint = skeleton.Joints[JointType.HandLeft];
                arg[15] = joint.Position.X;
                joint = skeleton.Joints[JointType.HandLeft];
                arg[0x10] = joint.Position.Y;
                joint = skeleton.Joints[JointType.HandLeft];
                arg[0x11] = joint.Position.Z;
                joint = skeleton.Joints[JointType.ShoulderRight];
                arg[0x12] = joint.Position.X;
                joint = skeleton.Joints[JointType.ShoulderRight];
                arg[0x13] = joint.Position.Y;
                joint = skeleton.Joints[JointType.ShoulderRight];
                arg[20] = joint.Position.Z;
                joint = skeleton.Joints[JointType.ElbowRight];
                arg[0x15] = joint.Position.X;
                joint = skeleton.Joints[JointType.ElbowRight];
                arg[0x16] = joint.Position.Y;
                joint = skeleton.Joints[JointType.ElbowRight];
                arg[0x17] = joint.Position.Z;
                joint = skeleton.Joints[JointType.WristRight];
                arg[0x18] = joint.Position.X;
                joint = skeleton.Joints[JointType.WristRight];
                arg[0x19] = joint.Position.Y;
                joint = skeleton.Joints[JointType.WristRight];
                arg[0x1a] = joint.Position.Z;
                joint = skeleton.Joints[JointType.HandRight];
                arg[0x1b] = joint.Position.X;
                joint = skeleton.Joints[JointType.HandRight];
                arg[0x1c] = joint.Position.Y;
                joint = skeleton.Joints[JointType.HandRight];
                arg[0x1d] = joint.Position.Z;
                joint = skeleton.Joints[JointType.Spine];
                arg[30] = joint.Position.X;
                joint = skeleton.Joints[JointType.Spine];
                arg[0x1f] = joint.Position.Y;
                joint = skeleton.Joints[JointType.Spine];
                arg[0x20] = joint.Position.Z;
                joint = skeleton.Joints[JointType.HipCenter];
                arg[0x21] = joint.Position.X;
                joint = skeleton.Joints[JointType.HipCenter];
                arg[0x22] = joint.Position.Y;
                joint = skeleton.Joints[JointType.HipCenter];
                arg[0x23] = joint.Position.Z;
                joint = skeleton.Joints[JointType.HipLeft];
                arg[0x24] = joint.Position.X;
                joint = skeleton.Joints[JointType.HipLeft];
                arg[0x25] = joint.Position.Y;
                joint = skeleton.Joints[JointType.HipLeft];
                arg[0x26] = joint.Position.Z;
                joint = skeleton.Joints[JointType.KneeLeft];
                arg[0x27] = joint.Position.X;
                joint = skeleton.Joints[JointType.KneeLeft];
                arg[40] = joint.Position.Y;
                joint = skeleton.Joints[JointType.KneeLeft];
                arg[0x29] = joint.Position.Z;
                joint = skeleton.Joints[JointType.AnkleLeft];
                arg[0x2a] = joint.Position.X;
                joint = skeleton.Joints[JointType.AnkleLeft];
                arg[0x2b] = joint.Position.Y;
                joint = skeleton.Joints[JointType.AnkleLeft];
                arg[0x2c] = joint.Position.Z;
                joint = skeleton.Joints[JointType.FootLeft];
                arg[0x2d] = joint.Position.X;
                joint = skeleton.Joints[JointType.FootLeft];
                arg[0x2e] = joint.Position.Y;
                joint = skeleton.Joints[JointType.FootLeft];
                arg[0x2f] = joint.Position.Z;
                joint = skeleton.Joints[JointType.HipRight];
                arg[0x30] = joint.Position.X;
                joint = skeleton.Joints[JointType.HipRight];
                arg[0x31] = joint.Position.Y;
                joint = skeleton.Joints[JointType.HipRight];
                arg[50] = joint.Position.Z;
                joint = skeleton.Joints[JointType.KneeRight];
                arg[0x33] = joint.Position.X;
                joint = skeleton.Joints[JointType.KneeRight];
                arg[0x34] = joint.Position.Y;
                joint = skeleton.Joints[JointType.KneeRight];
                arg[0x35] = joint.Position.Z;
                joint = skeleton.Joints[JointType.AnkleRight];
                arg[0x36] = joint.Position.X;
                joint = skeleton.Joints[JointType.AnkleRight];
                arg[0x37] = joint.Position.Y;
                joint = skeleton.Joints[JointType.AnkleRight];
                arg[0x38] = joint.Position.Z;
                joint = skeleton.Joints[JointType.FootRight];
                arg[0x39] = joint.Position.X;
                joint = skeleton.Joints[JointType.FootRight];
                arg[0x3a] = joint.Position.Y;
                joint = skeleton.Joints[JointType.FootRight];
                arg[0x3b] = joint.Position.Z;
                arg[60] = num;
                this._DataFile.WriteLine("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29}, {30}, {31}, {32}, {33}, {34},{35},{36},{37},{38},{39},{40}, {41}, {42}, {43},{44}, {45}, {46}, {47},{48},{49}, {50},{51},{52},{53}, {54}, {55}, {56}, {57}, {58}, {59}, {60}", arg);
            }
        }
        this._skelFrameCount++;
    }

    private void DrawBone(Skeleton skeleton, DrawingContext drawingContext, JointType jointType0, JointType jointType1)
    {
        Joint joint = skeleton.Joints[jointType0];
        Joint joint2 = skeleton.Joints[jointType1];
        if (((joint.TrackingState != JointTrackingState.NotTracked) && (joint2.TrackingState != JointTrackingState.NotTracked)) && ((joint.TrackingState != JointTrackingState.Inferred) || (joint2.TrackingState != JointTrackingState.Inferred)))
        {
            Pen inferredBonePen = this.inferredBonePen;
            if ((joint.TrackingState == JointTrackingState.Tracked) && (joint2.TrackingState == JointTrackingState.Tracked))
            {
                inferredBonePen = this.trackedBonePen;
            }
            drawingContext.DrawLine(inferredBonePen, this.SkeletonPointToScreen(joint.Position), this.SkeletonPointToScreen(joint2.Position));
        }
    }

    private void DrawBonesAndJoints(Skeleton skeleton, DrawingContext drawingContext)
    {
        this.DrawBone(skeleton, drawingContext, JointType.Head, JointType.ShoulderCenter);
        this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderLeft);
        this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderRight);
        this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.Spine);
        this.DrawBone(skeleton, drawingContext, JointType.Spine, JointType.HipCenter);
        this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipLeft);
        this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipRight);
        this.DrawBone(skeleton, drawingContext, JointType.ShoulderLeft, JointType.ElbowLeft);
        this.DrawBone(skeleton, drawingContext, JointType.ElbowLeft, JointType.WristLeft);
        this.DrawBone(skeleton, drawingContext, JointType.WristLeft, JointType.HandLeft);
        this.DrawBone(skeleton, drawingContext, JointType.ShoulderRight, JointType.ElbowRight);
        this.DrawBone(skeleton, drawingContext, JointType.ElbowRight, JointType.WristRight);
        this.DrawBone(skeleton, drawingContext, JointType.WristRight, JointType.HandRight);
        this.DrawBone(skeleton, drawingContext, JointType.HipLeft, JointType.KneeLeft);
        this.DrawBone(skeleton, drawingContext, JointType.KneeLeft, JointType.AnkleLeft);
        this.DrawBone(skeleton, drawingContext, JointType.AnkleLeft, JointType.FootLeft);
        this.DrawBone(skeleton, drawingContext, JointType.HipRight, JointType.KneeRight);
        this.DrawBone(skeleton, drawingContext, JointType.KneeRight, JointType.AnkleRight);
        this.DrawBone(skeleton, drawingContext, JointType.AnkleRight, JointType.FootRight);
        foreach (Joint joint in skeleton.Joints)
        {
            Brush trackedJointBrush = null;
            if (joint.TrackingState == JointTrackingState.Tracked)
            {
                trackedJointBrush = this.trackedJointBrush;
            }
            else if (joint.TrackingState == JointTrackingState.Inferred)
            {
                trackedJointBrush = this.inferredJointBrush;
            }
            if (trackedJointBrush != null)
            {
                drawingContext.DrawEllipse(trackedJointBrush, null, this.SkeletonPointToScreen(joint.Position), 2.0, 2.0);
            }
        }
    }

    private void flushCommentsButton_Click(object sender, RoutedEventArgs e)
    {
        this._CommentsFile.WriteLine("Age: " + this.ageBox.Text);
        this._CommentsFile.WriteLine("Dyskinesia Severity: " + this.severityBox.Text);
        this._CommentsFile.WriteLine("Recording quality:" + this.qualityBox.Text);
        this._CommentsFile.WriteLine("Bad Detection:" + this.badDetectionBox.Text);
        this._CommentsFile.WriteLine(this.commentBox.Text);
        this.ageBox.Text = "";
        this.severityBox.Text = "";
        this.qualityBox.Text = "";
        this.badDetectionBox.Text = "";
        this.commentBox.Text = "";
        this._CommentsFile.Close();
    }

   
    private void movieButton_Click(object sender, RoutedEventArgs e)
    {
        string path = this.fileNameTextBox.Text + ".txt";
        string str2 = this.fileNameTextBox.Text + "_comments.txt";
        string fileName = this.fileNameTextBox.Text + "_color.avi";
        string str4 = this.fileNameTextBox.Text + "_depth.avi";
        if (string.IsNullOrEmpty(this.fileNameTextBox.Text))
        {
            MessageBox.Show("Please enter the record file name", "Filename needed", MessageBoxButton.OK);
        }
        else if (!File.Exists(path) || (MessageBox.Show("File already exists", "File already exists", MessageBoxButton.OKCancel) != MessageBoxResult.Cancel))
        {
            try
            {
                this._DataFile = new StreamWriter(path, false);
                this._CommentsFile = new StreamWriter(str2, false);
            }
            catch (Exception)
            {
                MessageBox.Show("File creation failed", "File creation Failed", MessageBoxButton.OK);
                this._DataFile = null;
                return;
            }
            this._colorRecord = new AviManager(fileName, false);
            this._movieRecordingOn = true;
            this._skeletonRecordingOn = true;
            this.movieButton.IsEnabled = false;
        }
    }

    private void radioButton1_Checked(object sender, RoutedEventArgs e)
    {
    }

    private void recordButton_Click(object sender, RoutedEventArgs e)
    {
        string path = this.fileNameTextBox.Text + ".txt";
        string str2 = this.fileNameTextBox.Text + "_comments.txt";
        if (string.IsNullOrEmpty(this.fileNameTextBox.Text))
        {
            MessageBox.Show("Please enter the record file name", "Filename needed", MessageBoxButton.OK);
        }
        else if (!File.Exists(path) || (MessageBox.Show("File already exists", "File already exists", MessageBoxButton.OKCancel) != MessageBoxResult.Cancel))
        {
            try
            {
                this._DataFile = new StreamWriter(path, false);
                this._CommentsFile = new StreamWriter(str2, false);
            }
            catch (Exception)
            {
                MessageBox.Show("File creation failed", "File creation Failed", MessageBoxButton.OK);
                this._DataFile = null;
                return;
            }
            this._skeletonRecordingOn = true;
            this._CommentsFile.WriteLine(DateTime.Now.ToString("dd/MM/yyyy"));
            this.recordButton.IsEnabled = false;
        }
    }

    private static void RenderClippedEdges(Skeleton skeleton, DrawingContext drawingContext)
    {
        if (skeleton.ClippedEdges.HasFlag(FrameEdges.Bottom))
        {
            drawingContext.DrawRectangle(Brushes.Red, null, new Rect(0.0, 353.0, 480.0, 7.0));
        }
        if (skeleton.ClippedEdges.HasFlag(FrameEdges.Top))
        {
            drawingContext.DrawRectangle(Brushes.Red, null, new Rect(0.0, 0.0, 480.0, 7.0));
        }
        if (skeleton.ClippedEdges.HasFlag(FrameEdges.Left))
        {
            drawingContext.DrawRectangle(Brushes.Red, null, new Rect(0.0, 0.0, 7.0, 360.0));
        }
        if (skeleton.ClippedEdges.HasFlag(FrameEdges.Right))
        {
            drawingContext.DrawRectangle(Brushes.Red, null, new Rect(473.0, 0.0, 7.0, 360.0));
        }
    }

    private Point SkeletonPointToScreen(SkeletonPoint skelpoint)
    {
        DepthImagePoint point = this._sensor.CoordinateMapper.MapSkeletonPointToDepthPoint(skelpoint, DepthImageFormat.Resolution640x480Fps30);
        return new Point((double)point.X, (double)point.Y);
    }

    private void stopButton_Click(object sender, RoutedEventArgs e)
    {
        if (this._skeletonRecordingOn)
        {
            this._DataFile.Close();
            this.recordButton.IsEnabled = true;
            this.movieButton.IsEnabled = true;
            if (this._movieRecordingOn)
            {
                this._colorRecord.Close();
            }
            this._skeletonRecordingOn = false;
            this._movieRecordingOn = false;
            this._colorFrameCount = 0;
        }
    }

    private void StopKinect(KinectSensor sensor)
    {
        if (sensor != null)
        {
            sensor.Stop();
            sensor.AudioSource.Stop();
        }
    }

    

    private void Window_Loaded(object sender, RoutedEventArgs e)
    {
        this.radioButton1.IsChecked = false;
        this.fileNameTextBox.Text = @"C:\Output\test";
        this.drawingGroup = new DrawingGroup();
        this.imageSource = new DrawingImage(this.drawingGroup);
        this.skeletonImage.Source = this.imageSource;
        if (KinectSensor.KinectSensors.Count > 0)
        {
            this._sensor = KinectSensor.KinectSensors[0];
            if (this._sensor.Status == KinectStatus.Connected)
            {
                this._sensor.ColorStream.Enable();
                this._sensor.DepthStream.Enable();
                this._sensor.SkeletonStream.Enable();
                this._sensor.AllFramesReady += new EventHandler<AllFramesReadyEventArgs>(this._sensor_AllFramesReady);
                this._skeletonData = new Skeleton[this._sensor.SkeletonStream.FrameSkeletonArrayLength];
                this._sensor.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(this._sensor_SkeletonFrameReady);
                this._sensor.Start();
            }
        }
    }
}

 

 

