#!/usr/bin/env bash
python train.py --dataroot ./imgs/Gogh --name Gogh_model --model test --which_model_netG resnet_9blocks --n_downsampling_G 3 --which_model_netD n_layers --n_layers_D 4 --which_direction AtoB --dataset_mode single --norm batch --resize_or_crop none --fineSize 128 --use_attimg --gpu_ids 0 --which_epoch 14000

# ice (no salient structure)
# python train.py --dataroot ./imgs/ice --name ice_model --model test --which_model_netG resnet_9blocks --n_downsampling_G 3 --which_model_netD n_layers --n_layers_D 4 --which_direction AtoB --dataset_mode single --norm batch --resize_or_crop none --fineSize 128 --gpu_ids 0 --which_epoch 14000