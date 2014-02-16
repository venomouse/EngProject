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
using Microsoft.Kinect;
using Microsoft.Kinect.Toolkit;
using Microsoft.Samples.Kinect.WpfViewers;
using AviFile;



namespace KinectAttempt1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        /// <summary>
        /// Width of output drawing
        /// </summary>
        private const float RenderWidth = 480.0f;

        /// <summary>
        /// Height of our output drawing
        /// </summary>
        private const float RenderHeight = 360.0f;

        /// <summary>
        /// Thickness of drawn joint lines
        /// </summary>
        private const double JointThickness = 2;

        /// <summary>
        /// Thickness of body center ellipse
        /// </summary>
        private const double BodyCenterThickness =7;

        /// <summary>
        /// Thickness of clip edge rectangles
        /// </summary>
        private const double ClipBoundsThickness = 7;

        /// <summary>
        /// Brush used to draw skeleton center point
        /// </summary>
        private readonly Brush centerPointBrush = Brushes.Blue;

        /// <summary>
        /// Brush used for drawing joints that are currently tracked
        /// </summary>
        private readonly Brush trackedJointBrush = new SolidColorBrush(Color.FromArgb(255, 68, 192, 68));

        /// <summary>
        /// Brush used for drawing joints that are currently inferred
        /// </summary>        
        private readonly Brush inferredJointBrush = Brushes.Yellow;

        /// <summary>
        /// Pen used for drawing bones that are currently tracked
        /// </summary>
        private readonly Pen trackedBonePen = new Pen(Brushes.Green, 6);

        /// <summary>
        /// Pen used for drawing bones that are currently inferred
        /// </summary>        
        private readonly Pen inferredBonePen = new Pen(Brushes.Gray, 1);

        /// <summary>
        /// Drawing group for skeleton rendering output
        /// </summary>
        private DrawingGroup drawingGroup;

        /// <summary>
        /// Drawing image that we will display
        /// </summary>
        private DrawingImage imageSource;


        int _colorFrameCount = 0;
        AviManager _colorRecord = null;
        VideoStream _colorStream;
        private StreamWriter _CommentsFile = null;
        private StreamWriter _DataFile = null;
        /*private int _depthFrameCount = 0;
        private AviManager _depthRecord = null;
        private VideoStream _depthStream;*/
        private long _firstSkelFrameTimestamp;
        private long _firstColorFrameTimestamp;
        private bool _movieRecordingOn = false;
        private KinectSensor _sensor;
        private Skeleton[] _skeletonData;
        private bool _skeletonRecordingOn = false;
        private int _skelFrameCount = 0;
        private float _skelFrameTime = 0;
        private float _colorFrameTime = 0;
        BitmapEncoder _imEncoder;
        List<System.Drawing.Bitmap> _frameList;

        public MainWindow()
        {
            InitializeComponent();
        }


        /// <summary>
        /// Draws indicators to show which edges are clipping skeleton data
        /// </summary>
        /// <param name="skeleton">skeleton to draw clipping information for</param>
        /// <param name="drawingContext">drawing context to draw to</param>
        private static void RenderClippedEdges(Skeleton skeleton, DrawingContext drawingContext)
        {
            if (skeleton.ClippedEdges.HasFlag(FrameEdges.Bottom))
            {
                drawingContext.DrawRectangle(
                    Brushes.Red,
                    null,
                    new Rect(0, RenderHeight - ClipBoundsThickness, RenderWidth, ClipBoundsThickness));
            }

            if (skeleton.ClippedEdges.HasFlag(FrameEdges.Top))
            {
                drawingContext.DrawRectangle(
                    Brushes.Red,
                    null,
                    new Rect(0, 0, RenderWidth, ClipBoundsThickness));
            }

            if (skeleton.ClippedEdges.HasFlag(FrameEdges.Left))
            {
                drawingContext.DrawRectangle(
                    Brushes.Red,
                    null,
                    new Rect(0, 0, ClipBoundsThickness, RenderHeight));
            }

            if (skeleton.ClippedEdges.HasFlag(FrameEdges.Right))
            {
                drawingContext.DrawRectangle(
                    Brushes.Red,
                    null,
                    new Rect(RenderWidth - ClipBoundsThickness, 0, ClipBoundsThickness, RenderHeight));
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            radioButton1.IsChecked = false;
            this.fileNameTextBox.Text = "C:\\Output\\test";
            
            // Create the drawing group we'll use for drawing
            this.drawingGroup = new DrawingGroup();

            this._imEncoder = new PngBitmapEncoder();

            // Create an image source that we can use in our image control
            this.imageSource = new DrawingImage(this.drawingGroup);

            this._frameList = new List<System.Drawing.Bitmap>();

            // Display the drawing using our image control
            skeletonImage.Source = this.imageSource;

            if (KinectSensor.KinectSensors.Count > 0)
            {
                _sensor = KinectSensor.KinectSensors[0];

                if (_sensor.Status == KinectStatus.Connected)
                {
                    _sensor.ColorStream.Enable();
                    _sensor.DepthStream.Enable();
                    _sensor.SkeletonStream.Enable();
                    _sensor.AllFramesReady += new EventHandler<AllFramesReadyEventArgs>(_sensor_AllFramesReady);

                    _skeletonData = new Skeleton[_sensor.SkeletonStream.FrameSkeletonArrayLength];
                    _sensor.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(_sensor_SkeletonFrameReady);

                    _sensor.Start();
                }
            }

        }

        void _sensor_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null && this._skeletonData != null)
                {
                    skeletonFrame.CopySkeletonDataTo(this._skeletonData);
                    AccessSkeletonData(skeletonFrame);
                }
            }

            using (DrawingContext dc = this.drawingGroup.Open())
            {
                // Draw a transparent background to set the render size
                dc.DrawRectangle(Brushes.Black, null, new Rect(0.0, 0.0, RenderWidth, RenderHeight));

                if (_skeletonData.Length != 0)
                {
                    foreach (Skeleton skel in _skeletonData)
                    {
                        
                        RenderClippedEdges(skel, dc);

                        if (skel.TrackingState == SkeletonTrackingState.Tracked)
                        {
                            this.DrawBonesAndJoints(skel, dc);
                        }
                        else if (skel.TrackingState == SkeletonTrackingState.PositionOnly)
                        {
                            dc.DrawEllipse(
                            this.centerPointBrush,
                            null,
                            this.SkeletonPointToScreen(skel.Position),
                            BodyCenterThickness,
                            BodyCenterThickness);
                        }
                    }
                }

                // prevent drawing outside of our render area
                this.drawingGroup.ClipGeometry = new RectangleGeometry(new Rect(0.0, 0.0, RenderWidth, RenderHeight));
            }

        }


        /// <summary>
        /// Draws a skeleton's bones and joints
        /// </summary>
        /// <param name="skeleton">skeleton to draw</param>
        /// <param name="drawingContext">drawing context to draw to</param>
        private void DrawBonesAndJoints(Skeleton skeleton, DrawingContext drawingContext)
        {
            // Render Torso
            this.DrawBone(skeleton, drawingContext, JointType.Head, JointType.ShoulderCenter);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderLeft);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderRight);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.Spine);
            this.DrawBone(skeleton, drawingContext, JointType.Spine, JointType.HipCenter);
            this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipLeft);
            this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipRight);

            // Left Arm
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderLeft, JointType.ElbowLeft);
            this.DrawBone(skeleton, drawingContext, JointType.ElbowLeft, JointType.WristLeft);
            this.DrawBone(skeleton, drawingContext, JointType.WristLeft, JointType.HandLeft);

            // Right Arm
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderRight, JointType.ElbowRight);
            this.DrawBone(skeleton, drawingContext, JointType.ElbowRight, JointType.WristRight);
            this.DrawBone(skeleton, drawingContext, JointType.WristRight, JointType.HandRight);

            // Left Leg
            this.DrawBone(skeleton, drawingContext, JointType.HipLeft, JointType.KneeLeft);
            this.DrawBone(skeleton, drawingContext, JointType.KneeLeft, JointType.AnkleLeft);
            this.DrawBone(skeleton, drawingContext, JointType.AnkleLeft, JointType.FootLeft);

            // Right Leg
            this.DrawBone(skeleton, drawingContext, JointType.HipRight, JointType.KneeRight);
            this.DrawBone(skeleton, drawingContext, JointType.KneeRight, JointType.AnkleRight);
            this.DrawBone(skeleton, drawingContext, JointType.AnkleRight, JointType.FootRight);

            // Render Joints
            foreach (Joint joint in skeleton.Joints)
            {
                Brush drawBrush = null;

                if (joint.TrackingState == JointTrackingState.Tracked)
                {
                    drawBrush = this.trackedJointBrush;
                }
                else if (joint.TrackingState == JointTrackingState.Inferred)
                {
                    drawBrush = this.inferredJointBrush;
                }

                if (drawBrush != null)
                {
                    drawingContext.DrawEllipse(drawBrush, null, this.SkeletonPointToScreen(joint.Position), JointThickness, JointThickness);
                }
            }
        }


        /// <summary>
        /// Maps a SkeletonPoint to lie within our render space and converts to Point
        /// </summary>
        /// <param name="skelpoint">point to map</param>
        /// <returns>mapped point</returns>
        private Point SkeletonPointToScreen(SkeletonPoint skelpoint)
        {
            // Convert point to depth space.  
            // We are not using depth directly, but we do want the points in our 640x480 output resolution.
            DepthImagePoint depthPoint = this._sensor.CoordinateMapper.MapSkeletonPointToDepthPoint(skelpoint, DepthImageFormat.Resolution640x480Fps30);
            return new Point(depthPoint.X, depthPoint.Y);
        }

        /// <summary>
        /// Draws a bone line between two joints
        /// </summary>
        /// <param name="skeleton">skeleton to draw bones from</param>
        /// <param name="drawingContext">drawing context to draw to</param>
        /// <param name="jointType0">joint to start drawing from</param>
        /// <param name="jointType1">joint to end drawing at</param>
        private void DrawBone(Skeleton skeleton, DrawingContext drawingContext, JointType jointType0, JointType jointType1)
        {
            Joint joint0 = skeleton.Joints[jointType0];
            Joint joint1 = skeleton.Joints[jointType1];

            // If we can't find either of these joints, exit
            if (joint0.TrackingState == JointTrackingState.NotTracked ||
                joint1.TrackingState == JointTrackingState.NotTracked)
            {
                return;
            }

            // Don't draw if both points are inferred
            if (joint0.TrackingState == JointTrackingState.Inferred &&
                joint1.TrackingState == JointTrackingState.Inferred)
            {
                return;
            }

            // We assume all drawn bones are inferred unless BOTH joints are tracked
            Pen drawPen = this.inferredBonePen;
            if (joint0.TrackingState == JointTrackingState.Tracked && joint1.TrackingState == JointTrackingState.Tracked)
            {
                drawPen = this.trackedBonePen;
            }

            drawingContext.DrawLine(drawPen, this.SkeletonPointToScreen(joint0.Position), this.SkeletonPointToScreen(joint1.Position));
        }



        private void AccessSkeletonData(SkeletonFrame skeletonFrame)
        {
            if (this._skelFrameCount == 0)
            {
                this._firstSkelFrameTimestamp = skeletonFrame.Timestamp;
            }

            foreach (Skeleton skeleton in this._skeletonData)
            {
                if (skeleton.TrackingState == SkeletonTrackingState.Tracked && _skeletonRecordingOn)
                {
                    this._skelFrameTime = ((float)(skeletonFrame.Timestamp - this._firstSkelFrameTimestamp)) / 1000f;
                    radioButton1.IsChecked = true;
                   _DataFile.WriteLine( "{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29}, {30}, {31}, {32}, {33}, {34},{35},{36},{37},{38},{39},{40}, {41}, {42}, {43},{44}, {45}, {46}, {47},{48},{49}, {50},{51},{52},{53}, {54}, {55}, {56}, {57}, {58}, {59}, {60}",
                       
                       skeleton.Joints[JointType.Head].Position.X,
                       skeleton.Joints[JointType.Head].Position.Y,
                       skeleton.Joints[JointType.Head].Position.Z,
                       skeleton.Joints[JointType.ShoulderCenter].Position.X,
                       skeleton.Joints[JointType.ShoulderCenter].Position.Y,
                       skeleton.Joints[JointType.ShoulderCenter].Position.Z,
                       skeleton.Joints[JointType.ShoulderLeft].Position.X,
                       skeleton.Joints[JointType.ShoulderLeft].Position.Y,
                       skeleton.Joints[JointType.ShoulderLeft].Position.Z,
                       skeleton.Joints[JointType.ElbowLeft].Position.X, 
                       skeleton.Joints[JointType.ElbowLeft].Position.Y,
                       skeleton.Joints[JointType.ElbowLeft].Position.Z,
                       skeleton.Joints[JointType.WristLeft].Position.X,
                       skeleton.Joints[JointType.WristLeft].Position.Y,
                       skeleton.Joints[JointType.WristLeft].Position.Z,
                       skeleton.Joints[JointType.HandLeft].Position.X,
                       skeleton.Joints[JointType.HandLeft].Position.Y,
                       skeleton.Joints[JointType.HandLeft].Position.Z,
                       skeleton.Joints[JointType.ShoulderRight].Position.X,
                       skeleton.Joints[JointType.ShoulderRight].Position.Y,
                       skeleton.Joints[JointType.ShoulderRight].Position.Z,
                       skeleton.Joints[JointType.ElbowRight].Position.X,
                       skeleton.Joints[JointType.ElbowRight].Position.Y,
                       skeleton.Joints[JointType.ElbowRight].Position.Z,
                       skeleton.Joints[JointType.WristRight].Position.X,
                       skeleton.Joints[JointType.WristRight].Position.Y,
                       skeleton.Joints[JointType.WristRight].Position.Z,
                       skeleton.Joints[JointType.HandRight].Position.X,
                       skeleton.Joints[JointType.HandRight].Position.Y,
                       skeleton.Joints[JointType.HandRight].Position.Z,
                       skeleton.Joints[JointType.Spine].Position.X,
                       skeleton.Joints[JointType.Spine].Position.Y,
                       skeleton.Joints[JointType.Spine].Position.Z, 
                       skeleton.Joints[JointType.HipCenter].Position.X,
                       skeleton.Joints[JointType.HipCenter].Position.Y,
                       skeleton.Joints[JointType.HipCenter].Position.Z,
                       skeleton.Joints[JointType.HipLeft].Position.X,
                       skeleton.Joints[JointType.HipLeft].Position.Y,
                       skeleton.Joints[JointType.HipLeft].Position.Z,
                       skeleton.Joints[JointType.KneeLeft].Position.X,
                       skeleton.Joints[JointType.KneeLeft].Position.Y,
                       skeleton.Joints[JointType.KneeLeft].Position.Z,
                       skeleton.Joints[JointType.AnkleLeft].Position.X,
                       skeleton.Joints[JointType.AnkleLeft].Position.Y,
                       skeleton.Joints[JointType.AnkleLeft].Position.Z,
                       skeleton.Joints[JointType.FootLeft].Position.X,
                       skeleton.Joints[JointType.FootLeft].Position.Y,
                       skeleton.Joints[JointType.FootLeft].Position.Z,
                       skeleton.Joints[JointType.HipRight].Position.X,
                       skeleton.Joints[JointType.HipRight].Position.Y,
                       skeleton.Joints[JointType.HipRight].Position.Z,
                       skeleton.Joints[JointType.KneeRight].Position.X,
                       skeleton.Joints[JointType.KneeRight].Position.Y,
                       skeleton.Joints[JointType.KneeRight].Position.Z,
                       skeleton.Joints[JointType.AnkleRight].Position.X,
                       skeleton.Joints[JointType.AnkleRight].Position.Y,
                       skeleton.Joints[JointType.AnkleRight].Position.Z,
                       skeleton.Joints[JointType.FootRight].Position.X,
                       skeleton.Joints[JointType.FootRight].Position.Y,
                       skeleton.Joints[JointType.FootRight].Position.Z, 
                       this._skelFrameTime);
                }
            }
            this._skelFrameCount++;
        }
       



       void _sensor_AllFramesReady(object sender, AllFramesReadyEventArgs e)
        {

           /* using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null && this._skeletonData != null)
                {
                    skeletonFrame.CopySkeletonDataTo(this._skeletonData);
                    AccessSkeletonData(skeletonFrame);
                }
            }*/
         
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
                        System.Drawing.Bitmap firstFrame = new System.Drawing.Bitmap(source.PixelWidth, source.PixelHeight, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
                        System.Drawing.Imaging.BitmapData bitmapdata = firstFrame.LockBits(new System.Drawing.Rectangle(System.Drawing.Point.Empty, firstFrame.Size), System.Drawing.Imaging.ImageLockMode.WriteOnly, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
                        source.CopyPixels(Int32Rect.Empty, bitmapdata.Scan0, bitmapdata.Height * bitmapdata.Stride, bitmapdata.Stride);
                        firstFrame.UnlockBits(bitmapdata);
                        if (this._colorFrameCount == 0)
                        {
                            this._firstColorFrameTimestamp = frame.Timestamp;
                            this._colorStream = this._colorRecord.AddVideoStream(false, 25.0, firstFrame);
                            this._colorFrameCount++;
                        }
                        else
                        {
                            //float colorFrameTime = ((float)(frame.Timestamp - this._firstColorFrameTimestamp)) / 1000f;
                            //string filename = this.fileNameTextBox.Text + _colorFrameCount.ToString() + "_" + colorFrameTime.ToString("000.000") + ".png";
                           // firstFrame.Save(filename);
                            _frameList.Add(firstFrame);
                            this._colorStream.AddFrame(firstFrame);
                            this._colorFrameCount++;
                        }
                        firstFrame.Dispose();
                    }
                }
            }

            

       }

       
 
        void StopKinect(KinectSensor sensor)
        {
            if (sensor != null)
            {
                sensor.Stop();
                sensor.AudioSource.Stop();
            }
        }


        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            StopKinect(_sensor);
            if (_DataFile != null)
            {
                _DataFile.Close();
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


        private void stopButton_Click(object sender, RoutedEventArgs e)
        {
            if (this._skeletonRecordingOn)
            {
                this._DataFile.Close();
                if (this._movieRecordingOn)
                {
                    for (int i = 0; i < _frameList.Count; i++)
                    {
                        string filename = this.fileNameTextBox.Text + i.ToString() + ".png";
                      
                        _frameList[i].Save(filename);
                    }
                    this._colorRecord.Close();

                }
                this.recordButton.IsEnabled = true;
                this.movieButton.IsEnabled = true;
                this._skeletonRecordingOn = false;
                this._movieRecordingOn = false;
                this._colorFrameCount = 0;
            }
        }


        
    }
}
