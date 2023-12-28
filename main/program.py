from pathlib import Path

folder_dir = 'img'
images = Path(folder_dir).glob('*.jpg')

for image in images:
    print(image, ' Object Type: ', type(image))
    image = image.__str__()
    print('After Conversion Type: ', type(image))


