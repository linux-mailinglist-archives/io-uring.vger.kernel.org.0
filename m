Return-Path: <io-uring+bounces-5177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4ECD9E1BDD
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:17:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C082A1628BB
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700701E6DEE;
	Tue,  3 Dec 2024 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZkKX3WEc"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAF1E6325;
	Tue,  3 Dec 2024 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228080; cv=none; b=ZL1T5dytaebZobnCUdJDOe1ehVACEECKnM8Ljo1ayQ5CszqA/rdipW8uCLGPlPUbCRQ2kFRYOGSb+doGLeXHXO5npqx1KRt3OtLAVeDcnbJOlj4z1P7fQdH1fnhk1dDeWG2d3FFJSh3gRZcwqp75bPniKvjV7P7OwYwtdbJuH1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228080; c=relaxed/simple;
	bh=hGdR+7+Md1hmgaPVKCHnoTzGHFccIfoNdWaDzOx/5Ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gkp1O78po7xqwFKmApXT/bhp9BaxMIBByt1h9eAFDkWea9Op8SfvFJKBFFV2pzvZCgK0m+wxp3YArLv9UqBgLCdvlCaG3NkgvfqkkRAJlh3Th+uF6Exr42V6zrrvFpkR9hT4Oeu0YQiterTc/OYZYTbdsM9aefbS7BPXT3S/2Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZkKX3WEc; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733228075; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=szT6nb75DkFbJ7msQyZCLd0xLU9oLmiJXokCkA3KK/c=;
	b=ZkKX3WEcJ1L70PNfQI7sFcqkrEBFkd1fRnRGVZQDzPKUP6PI1eo9xrvi1VrUX0xwbSar4dvDX8cSbIjSZkpALhfIhQu+f9mMnvAQpu7OxXvx+awFPgYoG9+J10B24V4dgWANaaPQ/WtJLkGb4vVB21e7GouqZZcwTasEDOZPu3U=
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WKmboUl_1733228074 cluster:ay36)
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
Subject: [PATCH 2/3] virtio-blk: add uring_cmd support for I/O passthru on chardev.
Date: Tue,  3 Dec 2024 20:14:23 +0800
Message-Id: <20241203121424.19887-3-mengferry@linux.alibaba.com>
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

Add ->uring_cmd() support for virtio-blk chardev (/dev/vdXc0).
According to virtio spec, in addition to passing 'hdr' info into kernel,
we also need to pass vaddr & data length of the 'iov' requeired for the
writev/readv op.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 drivers/block/virtio_blk.c      | 228 +++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_blk.h |  16 +++
 2 files changed, 240 insertions(+), 4 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 3487aaa67514..1a4bac3dc044 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -18,6 +18,9 @@
 #include <linux/vmalloc.h>
 #include <uapi/linux/virtio_ring.h>
 #include <linux/cdev.h>
+#include <linux/io_uring/cmd.h>
+#include <linux/types.h>
+#include <linux/uio.h>
 
 #define PART_BITS 4
 #define VQ_NAME_LEN 16
@@ -54,6 +57,20 @@ static struct class *vd_chr_class;
 
 static struct workqueue_struct *virtblk_wq;
 
+struct virtblk_uring_cmd_pdu {
+	struct request *req;
+	struct bio *bio;
+	int status;
+};
+
+struct virtblk_command {
+	struct virtio_blk_outhdr out_hdr;
+
+	__u64	data;
+	__u32	data_len;
+	__u32	flag;
+};
+
 struct virtio_blk_vq {
 	struct virtqueue *vq;
 	spinlock_t lock;
@@ -122,6 +139,16 @@ struct virtblk_req {
 	struct scatterlist sg[];
 };
 
+static bool virtblk_is_write(struct virtblk_command *cmd)
+{
+	return cmd->out_hdr.type & VIRTIO_BLK_T_OUT;
+}
+
+static void __user *virtblk_to_user_ptr(uintptr_t ptrval)
+{
+	return (void __user *)ptrval;
+}
+
 static inline blk_status_t virtblk_result(u8 status)
 {
 	switch (status) {
@@ -259,9 +286,6 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 	if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) && op_is_zone_mgmt(req_op(req)))
 		return BLK_STS_NOTSUPP;
 
-	/* Set fields for all request types */
-	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
-
 	switch (req_op(req)) {
 	case REQ_OP_READ:
 		type = VIRTIO_BLK_T_IN;
@@ -309,9 +333,11 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 		type = VIRTIO_BLK_T_ZONE_RESET_ALL;
 		break;
 	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
 		/*
 		 * Out header has already been prepared by the caller (virtblk_get_id()
-		 * or virtblk_submit_zone_report()), nothing to do here.
+		 * virtblk_submit_zone_report() or io_uring passthrough cmd), nothing
+		 * to do here.
 		 */
 		return 0;
 	default:
@@ -323,6 +349,7 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 	vbr->in_hdr_len = in_hdr_len;
 	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
 	vbr->out_hdr.sector = cpu_to_virtio64(vdev, sector);
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
 
 	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES ||
 	    type == VIRTIO_BLK_T_SECURE_ERASE) {
@@ -832,6 +859,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	vbr = blk_mq_rq_to_pdu(req);
 	vbr->in_hdr_len = sizeof(vbr->in_hdr.status);
 	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
 	vbr->out_hdr.sector = 0;
 
 	err = blk_rq_map_kern(q, req, id_str, VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
@@ -1250,6 +1278,197 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.poll		= virtblk_poll,
 };
 
+static inline struct virtblk_uring_cmd_pdu *virtblk_get_uring_cmd_pdu(
+		struct io_uring_cmd *ioucmd)
+{
+	return (struct virtblk_uring_cmd_pdu *)&ioucmd->pdu;
+}
+
+static void virtblk_uring_task_cb(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct virtblk_uring_cmd_pdu *pdu = virtblk_get_uring_cmd_pdu(ioucmd);
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(pdu->req);
+	u64 result = 0;
+
+	if (pdu->bio)
+		blk_rq_unmap_user(pdu->bio);
+
+	/* currently result has no use, it should be zero as cqe->res */
+	io_uring_cmd_done(ioucmd, vbr->in_hdr.status, result, issue_flags);
+}
+
+static enum rq_end_io_ret virtblk_uring_cmd_end_io(struct request *req,
+						   blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct virtblk_uring_cmd_pdu *pdu = virtblk_get_uring_cmd_pdu(ioucmd);
+
+	/*
+	 * For iopoll, complete it directly. Note that using the uring_cmd
+	 * helper for this is safe only because we check blk_rq_is_poll().
+	 * As that returns false if we're NOT on a polled queue, then it's
+	 * safe to use the polled completion helper.
+	 *
+	 * Otherwise, move the completion to task work.
+	 */
+	if (blk_rq_is_poll(req)) {
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_iopoll_done(ioucmd, 0, pdu->status);
+	} else {
+		io_uring_cmd_do_in_task_lazy(ioucmd, virtblk_uring_task_cb);
+	}
+
+	return RQ_END_IO_FREE;
+}
+
+static struct virtblk_req *virtblk_req(struct request *req)
+{
+	return blk_mq_rq_to_pdu(req);
+}
+
+static enum req_op virtblk_req_op(struct virtblk_command *cmd)
+{
+	return virtblk_is_write(cmd) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
+}
+
+static struct request *virtblk_alloc_user_request(
+		struct request_queue *q, struct virtblk_command *cmd,
+		unsigned int rq_flags, blk_mq_req_flags_t blk_flags)
+{
+	struct request *req;
+
+	req = blk_mq_alloc_request(q, virtblk_req_op(cmd) | rq_flags, blk_flags);
+	if (IS_ERR(req))
+		return req;
+
+	req->rq_flags |= RQF_DONTPREP;
+	memcpy(&virtblk_req(req)->out_hdr, &cmd->out_hdr, sizeof(struct virtio_blk_outhdr));
+	return req;
+}
+
+static int virtblk_map_user_request(struct request *req, u64 ubuffer,
+		unsigned int bufflen, struct io_uring_cmd *ioucmd,
+		bool vec)
+{
+	struct request_queue *q = req->q;
+	struct virtio_blk *vblk = q->queuedata;
+	struct block_device *bdev = vblk ? vblk->disk->part0 : NULL;
+	struct bio *bio = NULL;
+	int ret;
+
+	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
+		struct iov_iter iter;
+
+		/* fixedbufs is only for non-vectored io */
+		if (WARN_ON_ONCE(vec))
+			return -EINVAL;
+		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+				rq_data_dir(req), &iter, ioucmd);
+		if (ret < 0)
+			goto out;
+		ret = blk_rq_map_user_iov(q, req, NULL,
+			&iter, GFP_KERNEL);
+	} else {
+		ret = blk_rq_map_user_io(req, NULL,
+				virtblk_to_user_ptr(ubuffer),
+				bufflen, GFP_KERNEL, vec, 0,
+				0, rq_data_dir(req));
+	}
+	if (ret)
+		goto out;
+
+	bio = req->bio;
+	if (bdev)
+		bio_set_dev(bio, bdev);
+	return 0;
+
+out:
+	blk_mq_free_request(req);
+	return ret;
+}
+
+static int virtblk_uring_cmd_io(struct virtio_blk *vblk,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
+{
+	struct virtblk_uring_cmd_pdu *pdu = virtblk_get_uring_cmd_pdu(ioucmd);
+	const struct virtblk_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	struct request_queue *q = vblk->disk->queue;
+	struct virtblk_req *vbr;
+	struct virtblk_command d;
+	struct request *req;
+	unsigned int rq_flags = 0;
+	blk_mq_req_flags_t blk_flags = 0;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	d.out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, READ_ONCE(cmd->ioprio));
+	d.out_hdr.type = cpu_to_virtio32(vblk->vdev, READ_ONCE(cmd->type));
+	d.out_hdr.sector = cpu_to_virtio32(vblk->vdev, READ_ONCE(cmd->sector));
+	d.data = READ_ONCE(cmd->data);
+	d.data_len = READ_ONCE(cmd->data_len);
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		rq_flags = REQ_NOWAIT;
+		blk_flags = BLK_MQ_REQ_NOWAIT;
+	}
+	if (issue_flags & IO_URING_F_IOPOLL)
+		rq_flags |= REQ_POLLED;
+
+	req = virtblk_alloc_user_request(q, &d, rq_flags, blk_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	vbr = virtblk_req(req);
+	vbr->in_hdr_len = sizeof(vbr->in_hdr.status);
+	if (d.data && d.data_len) {
+		ret = virtblk_map_user_request(req, d.data, d.data_len, ioucmd, vec);
+		if (ret)
+			return ret;
+	}
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	pdu->bio = req->bio;
+	pdu->req = req;
+	req->end_io_data = ioucmd;
+	req->end_io = virtblk_uring_cmd_end_io;
+	blk_execute_rq_nowait(req, false);
+	return -EIOCBQUEUED;
+}
+
+
+static int virtblk_uring_cmd(struct virtio_blk *vblk, struct io_uring_cmd *ioucmd,
+			     unsigned int issue_flags)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct virtblk_uring_cmd_pdu) > sizeof(ioucmd->pdu));
+
+	switch (ioucmd->cmd_op) {
+	case VIRTBLK_URING_CMD_IO:
+		ret = virtblk_uring_cmd_io(vblk, ioucmd, issue_flags, false);
+		break;
+	case VIRTBLK_URING_CMD_IO_VEC:
+		ret = virtblk_uring_cmd_io(vblk, ioucmd, issue_flags, true);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	return ret;
+}
+
+static int virtblk_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct virtio_blk *vblk = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct virtio_blk, cdev);
+
+	return virtblk_uring_cmd(vblk, ioucmd, issue_flags);
+}
+
 static void virtblk_cdev_rel(struct device *dev)
 {
 	ida_free(&vd_chr_minor_ida, MINOR(dev->devt));
@@ -1297,6 +1516,7 @@ static int virtblk_cdev_add(struct virtio_blk *vblk,
 
 static const struct file_operations virtblk_chr_fops = {
 	.owner		= THIS_MODULE,
+	.uring_cmd	= virtblk_chr_uring_cmd,
 };
 
 static unsigned int virtblk_queue_depth;
diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 3744e4da1b2a..93b6e1b5b9a4 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -313,6 +313,22 @@ struct virtio_scsi_inhdr {
 };
 #endif /* !VIRTIO_BLK_NO_LEGACY */
 
+struct virtblk_uring_cmd {
+	/* VIRTIO_BLK_T* */
+	__u32 type;
+	/* io priority. */
+	__u32 ioprio;
+	/* Sector (ie. 512 byte offset) */
+	__u64 sector;
+
+	__u64 data;
+	__u32 data_len;
+	__u32 flag;
+};
+
+#define VIRTBLK_URING_CMD_IO		1
+#define VIRTBLK_URING_CMD_IO_VEC	2
+
 /* And this is the final byte of the write scatter-gather list. */
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1
-- 
2.43.5


