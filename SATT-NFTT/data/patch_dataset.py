import os.path
import torchvision.transforms as transforms
from data.base_dataset import BaseDataset, get_transform
from data.image_folder import make_dataset
from PIL import Image, ImageStat
import numpy as np
import PIL
from pdb import set_trace as st
import random

class PatchDataset(BaseDataset):
    def initialize(self, opt):
        self.opt = opt
        self.root = opt.dataroot
        self.dir = os.path.join(opt.dataroot, opt.phase)
        self.paths = make_dataset(self.dir)
        self.paths = sorted(self.paths)
        self.size = len(self.paths)
        self.fineSize = opt.fineSize
        self.transform = get_transform(opt)

    def __getitem__(self, index):
        path = self.paths[index % self.size]
        fname, fename = os.path.split(path)
        img = Image.open(path).convert('RGB')

        w, h = img.size
        w2 = int(w / 2)

        # laod A-semantics, B-realImage
        A_img = img.crop((0, 0, w2, h))
        B_img = img.crop((w2, 0, w, h))

        # random a patch with finesize
        rw = random.randint(0, w2 - self.fineSize)
        rh = random.randint(0, h - self.fineSize)
        A_img = A_img.crop((rw, rh, rw + self.fineSize, rh + self.fineSize))
        B_img = B_img.crop((rw, rh, rw + self.fineSize, rh + self.fineSize))

        # whether use pre-computed attention image
        # if no salient structure contained or the depth of label is small, no attention image also performs well
        if self.opt.use_attimg:
            fname, fename = os.path.split(path)
            att_path = self.root + '/att_train/' + fename[:-4] + '.jpg'
            att_img = Image.open(att_path)
            att_img = att_img.crop((rw, rh, rw + self.fineSize, rh + self.fineSize))
            att_tensor = self.transform(att_img)
        else:
            att_tensor = 0

        # whether use local discriminoator
        if self.opt.use_local:
            # extract salient part (left-up point, size:fineSize/2)
            salh, salw = self.extractSal(fename, rw, rh)
        else:
            salh= salw=0

        A_img = self.transform(A_img)
        B_img = self.transform(B_img)


        return {'A': A_img, 'B': B_img, 'Att': att_tensor,
                'sal_region': [(salh, salw)],
                'A_paths': path, 'B_paths': path,
                'A_start_point':[(rw, rh)]}

    def __len__(self):
        return self.size

    def name(self):
        return 'PatchDataset'

    # extract salient region with the max average saliency-score
    def extractSal(self, fename, rw, rh):
        ps = self.fineSize / 2
        sal_path = self.root + '/sal_train/' + fename[:-4] + '.npy'
        if not os.path.exists(sal_path):
            salimg_path = self.root + '/sal_train/' + fename[:-4] + '.jpg'
            if not os.path.exists(salimg_path):
                salimg_path = salimg_path[:-4] + '.png'
            img = Image.open(salimg_path)
            w, h = img.size

            salmap = np.zeros((h, w))
            for i in range(h - ps + 1):
                for j in range(w - ps + 1):
                    tmp = img.crop((j, i, j + ps, i + ps))
                    stat = ImageStat.Stat(tmp)
                    salmap[i][j] = stat.sum[0] / stat.count[0]
            np.save(sal_path, salmap)

        else:
            salmap = np.load(sal_path)

        salpart = salmap[rh:rh+self.fineSize, rw:rw+self.fineSize]
        salpart[self.fineSize - ps:self.fineSize,:]=0
        salpart[:, self.fineSize - ps:self.fineSize] = 0
        maxh, maxw = np.where(salpart==np.max(salpart))
        # print(maxh,maxw)
        return maxh,maxw




