# Developed by Michael Jermyn for Visualization in Nirfast

import sys
import vtk
from vtk.qt4.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor
from PyQt4.QtCore import *
from PyQt4.QtGui import *

# VOLUME VIEW
class VTK_Widget1(QWidget):
    
    def __init__(self, slider_z, slider_x, slider_y, parent=None):

        super(VTK_Widget1, self).__init__(parent)
        self.source_is_connected = False
        
        self.slider_x = slider_x
        self.slider_y = slider_y
        self.slider_z = slider_z
        
        # vtk to point data
        self.c2p = vtk.vtkCellDataToPointData()
        self.opacityTransferFunction = vtk.vtkPiecewiseFunction()
        self.colorTransferFunction = vtk.vtkColorTransferFunction()
        
        # clip plane
        self.clip_plane = vtk.vtkPlane()
        self.clip_plane.SetNormal(0, 0, 1)
        
        self.clipper = vtk.vtkClipDataSet()
        self.clipper.SetClipFunction(self.clip_plane)
        self.clipper.SetInputConnection(self.c2p.GetOutputPort())

        # create a volume property for describing how the data will look
        self.volumeProperty = vtk.vtkVolumeProperty()
        self.volumeProperty.SetColor(self.colorTransferFunction)
        self.volumeProperty.SetScalarOpacity(self.opacityTransferFunction)
        self.volumeProperty.ShadeOn()
        self.volumeProperty.SetInterpolationTypeToLinear()
        
        # convert to unstructured grid volume
        self.triangleFilter = vtk.vtkDataSetTriangleFilter()
        self.triangleFilter.TetrahedraOnlyOn()
        self.triangleFilter.SetInputConnection(self.clipper.GetOutputPort())

        # create a ray cast mapper
        self.compositeFunction = vtk.vtkUnstructuredGridBunykRayCastFunction()
        self.volumeMapper = vtk.vtkUnstructuredGridVolumeRayCastMapper()
        self.volumeMapper.SetRayCastFunction(self.compositeFunction)
        self.volumeMapper.SetInputConnection(self.triangleFilter.GetOutputPort())
        
        # create a volume
        self.volume = vtk.vtkVolume()
        self.volume.SetMapper(self.volumeMapper)
        self.volume.SetProperty(self.volumeProperty)
        self.volume.VisibilityOff()
        
        # create the VTK widget for rendering
        self.vtkw=QVTKRenderWindowInteractor(self)
        self.ren = vtk.vtkRenderer()
        self.vtkw.GetRenderWindow().AddRenderer(self.ren)
        self.ren.AddVolume(self.volume)
        
        self.alphaSlider = QSlider(Qt.Horizontal)
        self.alphaSlider.setValue(33)
        self.alphaSlider.setRange(0,100)
        self.alphaSlider.setTickPosition(QSlider.NoTicks) 
        self.connect(self.alphaSlider,SIGNAL("valueChanged(int)"),self.AdjustAlpha)
        
        self.alphaLabel = QLabel("alpha: ")
        
        # layout manager
        self.layout = QVBoxLayout()
        self.layout2 = QHBoxLayout()
        self.layout2.addWidget(self.alphaLabel)
        self.layout2.addWidget(self.alphaSlider)
        self.layout.addWidget(self.vtkw)
        self.layout.addSpacing(34)
        self.layout.addLayout(self.layout2)
        
        self.setLayout(self.layout)
        
        # initialize the interactor
        self.vtkw.Initialize()
        self.vtkw.Start()
        
        # Associate the line widget with the interactor
        self.planeWidget = vtk.vtkImplicitPlaneWidget()
        self.planeWidget.SetInteractor(self.vtkw)
        self.planeWidget.AddObserver("InteractionEvent", self.PlaneWidgetCallback)
        self.planeWidget.DrawPlaneOff()
        self.planeWidget.TubingOn()
        
    def PlaneWidgetCallback(self,obj, event):
        
        obj.GetPlane(self.clip_plane)
        org = self.clip_plane.GetOrigin()
        center = self.source.GetCenter()
        bounds = self.source.GetBounds()
            
        if self.clip_plane.GetNormal() == (1.0,0.0,0.0): 
            slider_pos = 100*(org[0]-bounds[0])/(bounds[1]-bounds[0])
            self.slider_x.setValue(slider_pos)
        if self.clip_plane.GetNormal() == (0.0,1.0,0.0): 
            slider_pos = 100*(org[1]-bounds[2])/(bounds[3]-bounds[2])
            self.slider_y.setValue(slider_pos)
        if self.clip_plane.GetNormal() == (0.0,0.0,1.0): 
            slider_pos = 100*(org[2]-bounds[4])/(bounds[5]-bounds[4])
            self.slider_z.setValue(slider_pos)
        
        
    def SetSource(self,source):   

        self.source = source
        self.c2p.SetInput(self.source)
        self.volume.VisibilityOn()
        
        self.planeWidget.SetInput(self.source)
        self.planeWidget.SetPlaceFactor(1.5)
        self.planeWidget.PlaceWidget()
        
        self.planeWidget.GetPlane(self.clip_plane)
        self.planeWidget.EnabledOn()
        
        # the volume will be made completely transparent for values below 5%, 
        # somewhat transparent up to 65% of the scalar range
        # and to opaque for values between 65% and 100%
        range = source.GetScalarRange()
        zero_pc  = range[0]
        fifty_pc  = range[0]+(range[1]-range[0])*0.50
        hundred_pc  = range[1]
             
        self.opacityTransferFunction.AddPoint(zero_pc, 0.01)
        self.opacityTransferFunction.AddPoint(fifty_pc, 0.01)
        self.opacityTransferFunction.AddPoint(fifty_pc+1e-6, 0.2) # anything > 65% is transparent    
        
        self.colorTransferFunction.AddRGBPoint(zero_pc, 0.0, 0.0, 1.0)
        self.colorTransferFunction.AddRGBPoint(fifty_pc, 1.0, 0.5, 0.0)
        self.colorTransferFunction.AddRGBPoint(hundred_pc, 1.0, 0.0, 0.0)
         
        self.ren.ResetCamera() 
        self.vtkw.GetRenderWindow().Render()
        self.source_is_connected = True
            
    def AdjustAlpha(self):
        
        if self.source_is_connected:
        
            slider_pos = self.alphaSlider.value()
            
            range = self.source.GetScalarRange()
            zero_pc  = range[0]
            fifty_pc  = range[0]+(range[1]-range[0])*0.50
            hundred_pc  = range[1]
                 
            self.opacityTransferFunction.AddPoint(zero_pc, slider_pos*0.0003)
            self.opacityTransferFunction.AddPoint(fifty_pc, slider_pos*0.0003)
            self.opacityTransferFunction.AddPoint(fifty_pc+1e-6, 0.2) # anything > 65% is transparent 
                
            self.vtkw.GetRenderWindow().Render() 
        
        
# ORTHOGONAL VIEW
class VTK_Widget2(QWidget):
    def __init__(self, axis, parent=None):
        
        super(VTK_Widget2, self).__init__(parent)

        self.axis = axis; # 0 - x, 1 - y, 2 - z

        self.source_is_connected = False
        
        self.cutPlane = vtk.vtkPlane()
        if self.axis == 0:
            self.cutPlane.SetNormal(1, 0, 0)
        if self.axis == 1:
            self.cutPlane.SetNormal(0, 1, 0)
        if self.axis == 2:
            self.cutPlane.SetNormal(0, 0, 1)
            
        # ---DICOM PIPELINE---
        self.reslice = vtk.vtkImageReslice()
        self.reslice.SetInterpolationModeToLinear()
        
        self.cutter2 = vtk.vtkCutter()
        self.cutter2.SetCutFunction(self.cutPlane)
        self.cutter2.SetValue(0,0)
        self.cutter2.SetInput(self.reslice.GetOutput())

        self.cutterMapper2=vtk.vtkPolyDataMapper()
        self.cutterMapper2.SetInputConnection(self.cutter2.GetOutputPort())
        
        self.lookupTable2 = vtk.vtkLookupTable()
        self.lookupTable2.SetSaturationRange(0,0)
        self.lookupTable2.SetHueRange(1,1)
        self.lookupTable2.SetValueRange(0,1)
        self.lookupTable2.Build()
        
        self.cutterMapper2.SetLookupTable(self.lookupTable2)

        self.cutterActor2=vtk.vtkActor()
        self.cutterActor2.SetMapper(self.cutterMapper2)
        self.cutterActor2.VisibilityOff()
        
        # ---SOLUTION PIPELINE---             
        self.cutter = vtk.vtkCutter()
        self.cutter.SetCutFunction(self.cutPlane)
        self.cutter.SetValue(0,0)

        self.cutterMapper=vtk.vtkPolyDataMapper()
        self.cutterMapper.SetInputConnection(self.cutter.GetOutputPort())
        
        self.colorbar = vtk.vtkScalarBarActor()
        self.colorbar.SetLookupTable(self.cutterMapper.GetLookupTable())
        
        self.lookupTable = vtk.vtkLookupTable()
        self.lookupTable.SetSaturationRange(1,1)
        self.lookupTable.SetHueRange(0.5,0)
        self.lookupTable.SetValueRange(1,1)
        self.lookupTable.SetAlphaRange(1,1)
        self.lookupTable.Build()
        
        self.cutterMapper.SetLookupTable(self.lookupTable)
        self.colorbar.SetLookupTable(self.lookupTable)
        self.colorbar.SetOrientationToHorizontal()
        self.colorbar.GetPositionCoordinate().SetCoordinateSystemToNormalizedViewport()
        self.colorbar.GetPositionCoordinate().SetValue(.2,.05)
        self.colorbar.SetWidth( 0.7 )
        self.colorbar.SetHeight( 0.11 )
        self.colorbar.SetPosition( 0.16, 0.01 )
        self.colorbar.SetLabelFormat("%-#6.5f")
        self.colorbar.GetLabelTextProperty().SetJustificationToCentered()

        self.cutterActor=vtk.vtkActor()
        self.cutterActor.SetMapper(self.cutterMapper)
        
        # ---WIDGETS & RENDERER---        
        self.vtkw=QVTKRenderWindowInteractor(self)
      
        self.ren = vtk.vtkRenderer()
        self.vtkw.GetRenderWindow().AddRenderer(self.ren)
        self.ren.AddActor(self.cutterActor)
        self.ren.AddActor(self.cutterActor2)
        self.ren.AddActor2D(self.colorbar)
        
        self.cutterActor.VisibilityOff()
           
        self.cutPlaneSlider = QSlider(Qt.Vertical)
        self.cutPlaneSlider.setValue(50)
        self.cutPlaneSlider.setRange(0,100)
        self.cutPlaneSlider.setTickPosition(QSlider.NoTicks) 
        self.connect(self.cutPlaneSlider,SIGNAL("valueChanged(int)"),self.AdjustCutPlane)
        
        self.alphaSlider = QSlider(Qt.Horizontal)
        self.alphaSlider.setValue(100)
        self.alphaSlider.setRange(0,100)
        self.alphaSlider.setTickPosition(QSlider.NoTicks) 
        self.connect(self.alphaSlider,SIGNAL("valueChanged(int)"),self.AdjustAlpha)
        
        self.alphaLabel = QLabel("alpha: ")
        
        self.layout = QVBoxLayout()
        self.layout2 = QHBoxLayout()
        self.layout3 = QHBoxLayout()
        self.layout2.addWidget(self.vtkw)
        self.layout2.addSpacing(13)
        self.layout2.addWidget(self.cutPlaneSlider)
        self.layout3.addWidget(self.alphaLabel)
        self.layout3.addWidget(self.alphaSlider)
        self.layout3.addSpacing(30)
        self.layout.addLayout(self.layout2)
        self.layout.addSpacing(34)
        self.layout.addLayout(self.layout3)
        self.setLayout(self.layout)
        
        self.vtkw.Initialize()
        self.vtkw.Start()
        #self.vtkw.Disable()
        
    def SetSource(self,source):
        
        self.source=source
        self.cutter.SetInput(self.source)

        center = self.source.GetCenter()
        self.cutPlane.SetOrigin(center)
        self.cutPlaneSlider.setValue(50)
        self.cutterActor.VisibilityOn()
        self.cutterMapper.SetScalarRange(source.GetScalarRange())
        
        self.ren.GetActiveCamera().ParallelProjectionOn()
        if self.axis == 0:
            self.ren.GetActiveCamera().SetViewUp(0,0,1)
        if self.axis == 1:
            self.ren.GetActiveCamera().SetViewUp(0,0,1)
        if self.axis == 2:
            self.ren.GetActiveCamera().SetViewUp(0,1,0)
        self.ren.GetActiveCamera().SetFocalPoint(center)
        
        x=center[0]
        y=center[1]
        z=center[2]
        if self.axis == 0:
            x = x + 1
        if self.axis == 1:
            y = y + 1
        if self.axis == 2:
            z = z + 1
        self.ren.GetActiveCamera().SetPosition(x,y,z)
        self.ren.ResetCamera()
        cam_pos = self.ren.GetActiveCamera().GetPosition()
        bounds = self.source.GetBounds() 
        if self.axis == 0:
            clip_near = cam_pos[0]-bounds[1]
            clip_far = cam_pos[0]-bounds[0]
        if self.axis == 1:
            clip_near = cam_pos[1]-bounds[3]
            clip_far = cam_pos[1]-bounds[2]
        if self.axis == 2:
            clip_near = cam_pos[2]-bounds[5]
            clip_far = cam_pos[2]-bounds[4]
        self.ren.GetActiveCamera().SetClippingRange(clip_near,clip_far)
          
        self.vtkw.GetRenderWindow().Render()
        self.source_is_connected = True
        
    def SetSource2(self,source):   

        self.source2 = source.GetOutput()

        self.reslice.SetInput(self.source2)
        orn = source.GetImageOrientationPatient()
        center = source.GetDataOrigin()
        self.reslice.SetResliceAxesOrigin(center[0], center[1], center[2])
        self.reslice.SetResliceAxesDirectionCosines(orn[0], orn[3], (1-abs(orn[0])-abs(orn[3])), 
                                                    orn[1], orn[4], (1-abs(orn[1])-abs(orn[4])), 
                                                    orn[2], orn[5], (1-abs(orn[2])-abs(orn[5])))
       
        self.cutterActor2.VisibilityOn()
        self.cutterMapper2.SetScalarRange(self.source2.GetScalarRange())
        
        self.vtkw.GetRenderWindow().Render()
        
    def AdjustAlpha(self):
        
        slider_pos = self.sender().value() 
        self.lookupTable.SetAlphaRange(slider_pos/100.0,1)
        
        self.vtkw.GetRenderWindow().Render() 
        
    def AdjustCutPlane(self):
        
        if self.source_is_connected:
        
            slider_pos = self.sender().value() 
            center = self.source.GetCenter()
            bounds = self.source.GetBounds() 
            
            if self.axis == 0:
                cut_pos = bounds[0]+(bounds[1]-bounds[0])*(slider_pos/100.0) 
                self.cutPlane.SetOrigin(cut_pos,center[1],center[2])
            if self.axis == 1:
                cut_pos = bounds[2]+(bounds[3]-bounds[2])*(slider_pos/100.0) 
                self.cutPlane.SetOrigin(center[0],cut_pos,center[2])
            if self.axis == 2:
                cut_pos = bounds[4]+(bounds[5]-bounds[4])*(slider_pos/100.0) 
                self.cutPlane.SetOrigin(center[0],center[1],cut_pos)

            self.vtkw.GetRenderWindow().Render() 
        
        
# MAIN WINDOW                          
class MainVizWindow(QMainWindow):    
    def __init__(self, parent=None):
         
         QMainWindow.__init__(self, parent)
           
         self.setWindowTitle(self.tr("Nirfast"))
         
         # splitters are used for generating the four views
         self.VSplitter = QSplitter(Qt.Vertical)
         self.HSplitterTop = QSplitter(Qt.Horizontal)
         self.HSplitterBottom = QSplitter(Qt.Horizontal)
         
         # one instance of each of the VTK_Widget classes
         self.vtk_widget_2 = VTK_Widget2(0)
         self.vtk_widget_3 = VTK_Widget2(1)
         self.vtk_widget_4 = VTK_Widget2(2)
         self.vtk_widget_1 = VTK_Widget1(self.vtk_widget_2.cutPlaneSlider,self.vtk_widget_3.cutPlaneSlider,self.vtk_widget_4.cutPlaneSlider)
         
         # the VTK widgets are added to the splitters
         self.VSplitter.addWidget(self.HSplitterTop)
         self.VSplitter.addWidget(self.HSplitterBottom)
         self.HSplitterTop.addWidget(self.vtk_widget_1)
         self.HSplitterTop.addWidget(self.vtk_widget_2)
         self.HSplitterBottom.addWidget(self.vtk_widget_3)
         self.HSplitterBottom.addWidget(self.vtk_widget_4)
         
         # the top splitter (vertical) is set as central widget
         self.setCentralWidget(self.VSplitter)
         
         # we embed a reader in the main window, which will fan out the data to all VTK views
         self.reader = vtk.vtkUnstructuredGridReader()
         self.reader2 = vtk.vtkDICOMImageReader()
         self.reader.SetFileName('')
         self.reader2.SetDirectoryName('')
         
         # we declare a file open action
         self.fileOpenAction = QAction("&Open Solution",self)
         self.fileOpenAction.setShortcut("Ctrl+O")
         self.fileOpenAction.setToolTip("Opens a VTK volume file")
         self.fileOpenAction.setStatusTip("Opens a VTK volume file")
         
         self.fileOpenAction2 = QAction("&Open DICOMs",self)
         self.fileOpenAction2.setShortcut("Ctrl+D")
         self.fileOpenAction2.setToolTip("Opens a set of DICOMs")
         self.fileOpenAction2.setStatusTip("Opens a set of DICOMs")
     
         self.connect(self.fileOpenAction, SIGNAL("triggered()"),self.fileOpen)
         self.connect(self.fileOpenAction2, SIGNAL("triggered()"),self.fileOpen2)
         
         self.fileMenu = self.menuBar().addMenu("&File")
         self.fileMenu.addAction(self.fileOpenAction)   
         self.fileMenu.addAction(self.fileOpenAction2)
         
         # property label
         self.label_property = QLabel("Property: ")
         
         # property dropdown
         self.dropdown_property = QComboBox()
         
         # spacing label
         self.label_spacing = QLabel("      ")
         
         # clip buttons
         self.button_clipx = QPushButton('Clip x')
         self.button_clipy = QPushButton('Clip y')
         self.button_clipz = QPushButton('Clip z')
         
         # toolbar
         self.viewToolbar = self.addToolBar("View")
         self.viewToolbar.setObjectName("ViewToolbar")
         self.viewToolbar.addWidget(self.label_property)
         self.viewToolbar.addWidget(self.dropdown_property)
         self.viewToolbar.addWidget(self.label_spacing)
         self.viewToolbar.addWidget(self.button_clipx)
         self.viewToolbar.addWidget(self.button_clipy)
         self.viewToolbar.addWidget(self.button_clipz)
         
         self.connect(self.button_clipx, SIGNAL("clicked()"), self.Clipx)
         self.connect(self.button_clipy, SIGNAL("clicked()"), self.Clipy)
         self.connect(self.button_clipz, SIGNAL("clicked()"), self.Clipz)
         self.connect(self.dropdown_property, SIGNAL("currentIndexChanged(int)"), self.SetProperty)
         
         
    def Clipx(self):
        
        self.Clip(0)
        
    def Clipy(self):
        
        self.Clip(1)
        
    def Clipz(self):
        
        self.Clip(2)
         
    def Clip(self, axis):
        
        self.vtk_widget_1.hide()
        self.vtk_widget_2.hide()
        self.vtk_widget_2 = VTK_Widget2(0)
        self.vtk_widget_1 = VTK_Widget1(self.vtk_widget_2.cutPlaneSlider,self.vtk_widget_3.cutPlaneSlider,self.vtk_widget_4.cutPlaneSlider)
        self.HSplitterTop.addWidget(self.vtk_widget_1)
        self.HSplitterTop.addWidget(self.vtk_widget_2)
        if axis == 0:
            self.vtk_widget_1.planeWidget.NormalToXAxisOn()
        if axis == 1:
            self.vtk_widget_1.planeWidget.NormalToYAxisOn()
        if axis == 2:
            self.vtk_widget_1.planeWidget.NormalToZAxisOn()
        self.vtk_widget_1.planeWidget.EnabledOn()
        self.vtk_widget_1.SetSource(self.reader.GetOutput())
        self.vtk_widget_2.SetSource(self.reader.GetOutput())
            
    def setSource(self,source):
        
        self.reader.SetFileName(source)
        self.reader.ReadAllScalarsOn()
        self.reader.Update()    
        print self.reader.GetOutput().GetBounds()
        pointdata = self.reader.GetOutput().GetPointData()
        for i in range(pointdata.GetNumberOfArrays()):      
            self.dropdown_property.addItem(pointdata.GetArrayName(i))
        self.vtk_widget_1.SetSource(self.reader.GetOutput())
        self.vtk_widget_2.SetSource(self.reader.GetOutput())
        self.vtk_widget_3.SetSource(self.reader.GetOutput())
        self.vtk_widget_4.SetSource(self.reader.GetOutput())
              
    def fileOpen(self):
        
        dir ="."
        format = "*.vtk"
        self.fname = unicode(QFileDialog.getOpenFileName(self,"Open VTK File",dir,format))
                        
        if (len(self.fname)>0):         
            self.setSource(self.fname)
    
    def fileOpen2(self):
        
        dir ="."
        fname = unicode(QFileDialog.getExistingDirectory(self,"Select DICOM Directory",dir))
                        
        if (len(fname)>0):         
            self.reader2.SetDirectoryName(fname)
            self.reader2.Update()    
            print self.reader2.GetOutput().GetBounds()   
            self.vtk_widget_2.SetSource2(self.reader2)
            self.vtk_widget_3.SetSource2(self.reader2)
            self.vtk_widget_4.SetSource2(self.reader2)
            
    def SetProperty(self):
        
        property = str(self.sender().currentText())  
        pointdata = self.reader.GetOutput().GetPointData()
        pointdata.SetActiveScalars(property)
        
        self.vtk_widget_1.close()
        self.vtk_widget_2.close()
        self.vtk_widget_3.close()
        self.vtk_widget_4.close()
        del self.vtk_widget_1
        del self.vtk_widget_2
        del self.vtk_widget_3
        del self.vtk_widget_4
        
        self.vtk_widget_2 = VTK_Widget2(0)
        self.vtk_widget_3 = VTK_Widget2(1)
        self.vtk_widget_4 = VTK_Widget2(2)
        self.vtk_widget_1 = VTK_Widget1(self.vtk_widget_2.cutPlaneSlider,self.vtk_widget_3.cutPlaneSlider,self.vtk_widget_4.cutPlaneSlider)
        
        self.HSplitterTop.addWidget(self.vtk_widget_1)
        self.HSplitterTop.addWidget(self.vtk_widget_2)
        self.HSplitterBottom.addWidget(self.vtk_widget_3)
        self.HSplitterBottom.addWidget(self.vtk_widget_4)
        self.vtk_widget_1.SetSource(self.reader.GetOutput())
        self.vtk_widget_2.SetSource(self.reader.GetOutput())
        self.vtk_widget_3.SetSource(self.reader.GetOutput())
        self.vtk_widget_4.SetSource(self.reader.GetOutput())
        
                    
# START APPLICATION    
app = QApplication(sys.argv)

ow = vtk.vtkOutputWindow()
ow.SetGlobalWarningDisplay(0)

mainwindow = MainVizWindow()
mainwindow.show()
if sys.argv.__len__() > 1:
    source = sys.argv[1]
    mainwindow.setSource(source)
sys.exit(app.exec_())
