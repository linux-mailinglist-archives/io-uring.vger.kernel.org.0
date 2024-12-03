Return-Path: <io-uring+bounces-5178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE859E1BDF
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40FB316176D
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166B61EE02A;
	Tue,  3 Dec 2024 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HLr11tAw"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3F11E5005;
	Tue,  3 Dec 2024 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228081; cv=none; b=cGpDptA4Zt9vc8FZqdCKEj7BlTVpHg4geNKDl8bqRGFO26Q5buaR8XG2yOJLuzkEgUSF/MsHIA7vte9yfUutuComxoi+Y9os1Pd9YH0rwnXM/jsoA6TURAsB06fJPWlwGluE9Yb0rilFgXRz0XkQKXYtLy4BlQHg3JyoWDWMg+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228081; c=relaxed/simple;
	bh=suVFN18f6l88ll5bXCZiLUvgX6JmXNTjyUNOVTCHtl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SxUqUDEL80S9+Jr9SQO+9PnQypJ39Nywgbu1IhKe+1tB+ykb3CuyGNqYmOTZoVBXQ5EyXXsoChscHwtEh6+3RuRbnh+PBIDv+5iliY1Sw978XYjsOn9OjYJOYBxWWDdjkV9F7wjWhN3KejEbF9ELEJaPiPGicIIf1+ugMERXRKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HLr11tAw; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733228074; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hM3NMjNyhiKp7OTl4GYAGnFmUrECoxmiKjcfQlgfIyg=;
	b=HLr11tAwKXIWlPOIlUM5m8OCYcgca8hF1UT9h3Ppo0srhfE6a2bO73TzX3O91D0JjcPxvn+bU+q+j7UippDvGVImlRpGTvgapUd5M0a9pCZlEdUGEi9GR4uy7RvNxZKS+z1j3fxyIwfSGDOryyaoiRldWlBtJOD4+cPwkLraRNg=
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WKmboUc_1733228073 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Dec 2024 20:14:34 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 1/3] virtio-blk: add virtio-blk chardev support.
Date: Tue,  3 Dec 2024 20:14:22 +0800
Message-Id: <20241203121424.19887-2-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20241203121424.19887-1-mengferry@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce character interfaces for block device (per-device), facilitating
access to block devices through io_uring I/O passsthrough.

Besides, vblk initialize only use kmalloc with GFP_KERNEL flag, but for
char device support, we should ensure cdev kobj must be zero before
initialize. So better initial this struct with __GFP_ZERO flag.

Now the character devices only named as

	- /dev/vdXc0

Currently, only one character interface is created for one actual
virtblk device, although it has been partitioned.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 drivers/block/virtio_blk.c | 84 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 194417abc105..3487aaa67514 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -17,6 +17,7 @@
 #include <linux/numa.h>
 #include <linux/vmalloc.h>
 #include <uapi/linux/virtio_ring.h>
+#include <linux/cdev.h>
 
 #define PART_BITS 4
 #define VQ_NAME_LEN 16
@@ -25,6 +26,8 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+#define VIRTBLK_MINORS		(1U << MINORBITS)
+
 #ifdef CONFIG_ARCH_NO_SG_CHAIN
 #define VIRTIO_BLK_INLINE_SG_CNT	0
 #else
@@ -45,6 +48,10 @@ MODULE_PARM_DESC(poll_queues, "The number of dedicated virtqueues for polling I/
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
+static DEFINE_IDA(vd_chr_minor_ida);
+static dev_t vd_chr_devt;
+static struct class *vd_chr_class;
+
 static struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk_vq {
@@ -84,6 +91,10 @@ struct virtio_blk {
 
 	/* For zoned device */
 	unsigned int zone_sectors;
+
+	/* For passthrough cmd */
+	struct cdev cdev;
+	struct device cdev_device;
 };
 
 struct virtblk_req {
@@ -1239,6 +1250,55 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.poll		= virtblk_poll,
 };
 
+static void virtblk_cdev_rel(struct device *dev)
+{
+	ida_free(&vd_chr_minor_ida, MINOR(dev->devt));
+}
+
+static void virtblk_cdev_del(struct cdev *cdev, struct device *cdev_device)
+{
+	cdev_device_del(cdev, cdev_device);
+	put_device(cdev_device);
+}
+
+static int virtblk_cdev_add(struct virtio_blk *vblk,
+		const struct file_operations *fops)
+{
+	struct cdev *cdev = &vblk->cdev;
+	struct device *cdev_device = &vblk->cdev_device;
+	int minor, ret;
+
+	minor = ida_alloc(&vd_chr_minor_ida, GFP_KERNEL);
+	if (minor < 0)
+		return minor;
+
+	cdev_device->parent = &vblk->vdev->dev;
+	cdev_device->devt = MKDEV(MAJOR(vd_chr_devt), minor);
+	cdev_device->class = vd_chr_class;
+	cdev_device->release = virtblk_cdev_rel;
+	device_initialize(cdev_device);
+
+	ret = dev_set_name(cdev_device, "%sc0", vblk->disk->disk_name);
+	if (ret)
+		goto err;
+
+	cdev_init(cdev, fops);
+	ret = cdev_device_add(cdev, cdev_device);
+	if (ret) {
+		put_device(cdev_device);
+		goto err;
+	}
+	return ret;
+
+err:
+	ida_free(&vd_chr_minor_ida, minor);
+	return ret;
+}
+
+static const struct file_operations virtblk_chr_fops = {
+	.owner		= THIS_MODULE,
+};
+
 static unsigned int virtblk_queue_depth;
 module_param_named(queue_depth, virtblk_queue_depth, uint, 0444);
 
@@ -1456,7 +1516,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out;
 	index = err;
 
-	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
+	vdev->priv = vblk = kzalloc(sizeof(*vblk), GFP_KERNEL);
 	if (!vblk) {
 		err = -ENOMEM;
 		goto out_free_index;
@@ -1544,6 +1604,10 @@ static int virtblk_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_cleanup_disk;
 
+	err = virtblk_cdev_add(vblk, &virtblk_chr_fops);
+	if (err)
+		goto out_cleanup_disk;
+
 	return 0;
 
 out_cleanup_disk:
@@ -1568,6 +1632,8 @@ static void virtblk_remove(struct virtio_device *vdev)
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vblk->config_work);
 
+	virtblk_cdev_del(&vblk->cdev, &vblk->cdev_device);
+
 	del_gendisk(vblk->disk);
 	blk_mq_free_tag_set(&vblk->tag_set);
 
@@ -1674,13 +1740,27 @@ static int __init virtio_blk_init(void)
 		goto out_destroy_workqueue;
 	}
 
+	error = alloc_chrdev_region(&vd_chr_devt, 0, VIRTBLK_MINORS,
+				"vblk-generic");
+	if (error < 0)
+		goto unregister_chrdev;
+
+	vd_chr_class = class_create("vblk-generic");
+	if (IS_ERR(vd_chr_class)) {
+		error = PTR_ERR(vd_chr_class);
+		goto unregister_chrdev;
+	}
+
 	error = register_virtio_driver(&virtio_blk);
 	if (error)
 		goto out_unregister_blkdev;
+
 	return 0;
 
 out_unregister_blkdev:
 	unregister_blkdev(major, "virtblk");
+unregister_chrdev:
+	unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS);
 out_destroy_workqueue:
 	destroy_workqueue(virtblk_wq);
 	return error;
@@ -1690,7 +1770,9 @@ static void __exit virtio_blk_fini(void)
 {
 	unregister_virtio_driver(&virtio_blk);
 	unregister_blkdev(major, "virtblk");
+	unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS);
 	destroy_workqueue(virtblk_wq);
+	ida_destroy(&vd_chr_minor_ida);
 }
 module_init(virtio_blk_init);
 module_exit(virtio_blk_fini);
-- 
2.43.5


