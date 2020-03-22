
def create_model(opt):
    model = None
    print(opt.model)
    if opt.model == 'texture_transfer':
        assert (opt.dataset_mode == 'patch')
        from .texture_transfer import TextureTransfer
        model = TextureTransfer()
    elif opt.model == 'test':
        assert(opt.dataset_mode == 'single')
        from .test_model import TestModel
        model = TestModel()
    else:
        raise ValueError("Model [%s] not recognized." % opt.model)
    model.initialize(opt)
    print("model [%s] was created" % (model.name()))
    return model
