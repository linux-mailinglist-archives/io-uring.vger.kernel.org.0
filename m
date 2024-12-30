Return-Path: <io-uring+bounces-5628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AC99FE368
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 08:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E57EA188219C
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 07:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3F019F13B;
	Mon, 30 Dec 2024 07:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yeNLXiNM"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797C155345;
	Mon, 30 Dec 2024 07:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735544861; cv=none; b=M0l7+tuOIC2Bc+5plK2b2qIVItfUsCnplajxNDpQD8oIOKfn0uivsGX1uYVGK2sHoHhUJtpA5queAjt5AXPaQROK454QNrSbggzDkupJD9kAWJRCFLDuppuSLEkvsyp0vWi86FocwjymboLBbder1jJD64aORzbg2KfetDpVIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735544861; c=relaxed/simple;
	bh=S4wyVh8bgI+5iwQAypm2B1A1qlCaf8xm+WuEjqqB14w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mm9QhDzLGR4DWnBxapIBX/aWNKEB5n7TsyXLSi0GCFILNDdhFh/FoqFTel0PMSbxPSJWv2A/JNEdbblNlU+X5hN91aqrf1M2pNT6O5h1Fag6DAusFkXHkfno+GASrUNaQ32otRDzS5KZlBgMoKR06Qrrbl0GjAq17bIkWnudHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yeNLXiNM; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735544850; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q89ZrFao1DqP4ZXjkltYWF7Oqwsz2Y8oiw0M0MX52R4=;
	b=yeNLXiNMtamFGwcDpgEs2XBUJdNcTDFdiLNL4rHTmG14c8QJaJxihggGOWKPmbqzd3x+I9sDEQl/P+HIKS/ouNaQvdHjuXqj5d9GrUTx2kJMCDe9MgmbVrquzSPE901d9EXR4uvOYQh3qU5dT2KX8QQKCEjmEvZL5RBu5eUn+vo=
Received: from 30.221.129.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMU8xBE_1735544848 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Dec 2024 15:47:29 +0800
Message-ID: <9ac0d010-0592-4047-8e59-2db72dfe5111@linux.alibaba.com>
Date: Mon, 30 Dec 2024 15:47:27 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] virtio-blk: add virtio-blk chardev support.
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Stefan Hajnoczi <stefanha@redhat.com>, Christoph Hellwig
 <hch@infradead.org>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 virtualization@lists.linux.dev
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
 <20241218092435.21671-2-mengferry@linux.alibaba.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241218092435.21671-2-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/18 17:24, Ferry Meng wrote:
> Introduce character interfaces for block device (per-device), facilitating
> access to block devices through io_uring I/O passsthrough.
> 
> Besides, vblk initialize only use kmalloc with GFP_KERNEL flag, but for
> char device support, we should ensure cdev kobj must be zero before
> initialize. So better initial this struct with __GFP_ZERO flag.
> 
> Now the character devices only named as
> 
> 	- /dev/vdXc0
> 
> Currently, only one character interface is created for one actual
> virtblk device, although it has been partitioned.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> ---
>  drivers/block/virtio_blk.c | 84 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 194417abc105..3487aaa67514 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -17,6 +17,7 @@
>  #include <linux/numa.h>
>  #include <linux/vmalloc.h>
>  #include <uapi/linux/virtio_ring.h>
> +#include <linux/cdev.h>
>  
>  #define PART_BITS 4
>  #define VQ_NAME_LEN 16
> @@ -25,6 +26,8 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>  
> +#define VIRTBLK_MINORS		(1U << MINORBITS)
> +
>  #ifdef CONFIG_ARCH_NO_SG_CHAIN
>  #define VIRTIO_BLK_INLINE_SG_CNT	0
>  #else
> @@ -45,6 +48,10 @@ MODULE_PARM_DESC(poll_queues, "The number of dedicated virtqueues for polling I/
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>  
> +static DEFINE_IDA(vd_chr_minor_ida);
> +static dev_t vd_chr_devt;
> +static struct class *vd_chr_class;
> +
>  static struct workqueue_struct *virtblk_wq;
>  
>  struct virtio_blk_vq {
> @@ -84,6 +91,10 @@ struct virtio_blk {
>  
>  	/* For zoned device */
>  	unsigned int zone_sectors;
> +
> +	/* For passthrough cmd */
> +	struct cdev cdev;
> +	struct device cdev_device;
>  };
>  
>  struct virtblk_req {
> @@ -1239,6 +1250,55 @@ static const struct blk_mq_ops virtio_mq_ops = {
>  	.poll		= virtblk_poll,
>  };
>  
> +static void virtblk_cdev_rel(struct device *dev)
> +{
> +	ida_free(&vd_chr_minor_ida, MINOR(dev->devt));
> +}
> +
> +static void virtblk_cdev_del(struct cdev *cdev, struct device *cdev_device)
> +{
> +	cdev_device_del(cdev, cdev_device);
> +	put_device(cdev_device);
> +}
> +
> +static int virtblk_cdev_add(struct virtio_blk *vblk,
> +		const struct file_operations *fops)
> +{
> +	struct cdev *cdev = &vblk->cdev;
> +	struct device *cdev_device = &vblk->cdev_device;
> +	int minor, ret;
> +
> +	minor = ida_alloc(&vd_chr_minor_ida, GFP_KERNEL);
> +	if (minor < 0)
> +		return minor;
> +
> +	cdev_device->parent = &vblk->vdev->dev;
> +	cdev_device->devt = MKDEV(MAJOR(vd_chr_devt), minor);
> +	cdev_device->class = vd_chr_class;
> +	cdev_device->release = virtblk_cdev_rel;
> +	device_initialize(cdev_device);
> +
> +	ret = dev_set_name(cdev_device, "%sc0", vblk->disk->disk_name);
> +	if (ret)
> +		goto err;
> +
> +	cdev_init(cdev, fops);
> +	ret = cdev_device_add(cdev, cdev_device);
> +	if (ret) {
> +		put_device(cdev_device);
> +		goto err;

put_device() will call cdev_device->release() to free vd_chr_minor_ida.

> +	}
> +	return ret;
> +
> +err:
> +	ida_free(&vd_chr_minor_ida, minor);
> +	return ret;
> +}
> +
> +static const struct file_operations virtblk_chr_fops = {
> +	.owner		= THIS_MODULE,
> +};
> +
>  static unsigned int virtblk_queue_depth;
>  module_param_named(queue_depth, virtblk_queue_depth, uint, 0444);
>  
> @@ -1456,7 +1516,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  		goto out;
>  	index = err;
>  
> -	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
> +	vdev->priv = vblk = kzalloc(sizeof(*vblk), GFP_KERNEL);
>  	if (!vblk) {
>  		err = -ENOMEM;
>  		goto out_free_index;
> @@ -1544,6 +1604,10 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto out_cleanup_disk;
>  
> +	err = virtblk_cdev_add(vblk, &virtblk_chr_fops);
> +	if (err)
> +		goto out_cleanup_disk;

Missing remove the added disk before.

> +
>  	return 0;
>  
>  out_cleanup_disk:
> @@ -1568,6 +1632,8 @@ static void virtblk_remove(struct virtio_device *vdev)
>  	/* Make sure no work handler is accessing the device. */
>  	flush_work(&vblk->config_work);
>  
> +	virtblk_cdev_del(&vblk->cdev, &vblk->cdev_device);
> +
>  	del_gendisk(vblk->disk);
>  	blk_mq_free_tag_set(&vblk->tag_set);
>  
> @@ -1674,13 +1740,27 @@ static int __init virtio_blk_init(void)
>  		goto out_destroy_workqueue;
>  	}
>  
> +	error = alloc_chrdev_region(&vd_chr_devt, 0, VIRTBLK_MINORS,
> +				"vblk-generic");
> +	if (error < 0)
> +		goto unregister_chrdev;

Should unregister blkdev.

> +
> +	vd_chr_class = class_create("vblk-generic");
> +	if (IS_ERR(vd_chr_class)) {
> +		error = PTR_ERR(vd_chr_class);
> +		goto unregister_chrdev;
> +	}
> +
>  	error = register_virtio_driver(&virtio_blk);
>  	if (error)
>  		goto out_unregister_blkdev;

You've missed destroying vd_chr_class.

> +
>  	return 0;
>  
>  out_unregister_blkdev:
>  	unregister_blkdev(major, "virtblk");
> +unregister_chrdev:
> +	unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS);

The out labels should be re-ordered, e.g. move this up.

>  out_destroy_workqueue:
>  	destroy_workqueue(virtblk_wq);
>  	return error;
> @@ -1690,7 +1770,9 @@ static void __exit virtio_blk_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_blk);
>  	unregister_blkdev(major, "virtblk");

Also missed destroying vd_chr_class.

Thanks,
Joseph

> +	unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS);
>  	destroy_workqueue(virtblk_wq);
> +	ida_destroy(&vd_chr_minor_ida);
>  }
>  module_init(virtio_blk_init);
>  module_exit(virtio_blk_fini);


