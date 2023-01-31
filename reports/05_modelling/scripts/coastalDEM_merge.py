#script to import and merge over 5,000 tiles from CoastalDEM product
# using python within QGIS
# 10.01.23
#script from https://www.giscourse.com/automatically-merge-raster-files-using-pyqgis/

# step 1 import libraries os and pathlib that help explore folders and files 
from pathlib import Path
from osgeo import gdal
import os 

# step 2 : import all .tif files in the desired folder
folder_path = 'C:/Users/Tania/Desktop/For_GEE_upload/CoastalDEM_tiles'
BASE_PATH = os.path.dirname(os.path.abspath(folder_path))
folder = Path(folder_path)

l = []

for f in folder.glob('**/*.tif'):
    f_path = f.as_posix()
    l.append(f_path)

#step 2: create a VRT file = virtual dataset that contains all of the images merged
vrt_path = os.path.join(BASE_PATH, 'prov_vrt.vrt') # path for the VRT file 
vrt = gdal.BuildVRT(vrt_path, l)

#step 3 : have that file translated to the desired extension (GTiff) 
result = os.path.join(BASE_PATH, 'CoastalDEM_merged.tif') # path for the geotif
gdal.Translate(result, vrt, format = 'GTiff')