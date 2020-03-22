import os.path
import torchvision.transforms as transforms
from data.base_dataset import BaseDataset, get_transform
from data.image_folder import make_dataset
from PIL import Image
import random

class SingleDataset(BaseDataset):
    def initialize(self, opt):
        self.opt = opt
        self.root = opt.dataroot
        self.dir_A = os.path.join(opt.dataroot, opt.phase)
        self.fineSize = opt.fineSize

        self.A_paths = make_dataset(self.dir_A)

        self.A_paths = sorted(self.A_paths)

        self.transform = get_transform(opt)

    def __getitem__(self, index):
        A_path = self.A_paths[index]
        A_img = Image.open(A_path).convert('RGB')
        A_img = self.transform(A_img)

        if self.opt.use_attimg:
            fname, fename = os.path.split(A_path)
            att_path = self.root + '/att_test/' + fename
            if not os.path.exists(att_path):
                if att_path[-4:]==".png":
                    att_path = att_path[:-4]+'.jpg'
                elif att_path[-4:]==".jpg":
                    att_path = att_path[:-4] + '.png'
            att_img = Image.open(att_path)
            att_tensor = self.transform(att_img)
        else:
            att_tensor = 0

        return {'A': A_img, 'A_paths': A_path, 'Att': att_tensor}

    def __len__(self):
        return len(self.A_paths)

    def name(self):
        return 'SingleImageDataset'
