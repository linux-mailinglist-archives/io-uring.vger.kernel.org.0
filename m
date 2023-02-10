Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580F769224D
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 16:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjBJPeD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 10:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjBJPd5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 10:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693ED5BA5F
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676043185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCWDoQu05GM/FfiJ8Y58UcEN/SbMA9nhBOhrfHvxOXw=;
        b=f3fhuaK/uGAIFlMibtPBG10Is/lRT1SiEl6w6WxLBn+Nh6m130nqRSTtI6R/GPPBOM2gaA
        zWc60hrMbdJAjxbeIjtgZSZIJ1UERCDxT9+J1nLjxN8oSbp5x/pIZjbwE42/0bJsidN9M0
        e+4PjjPC3fjRZNjxvc647BDJVxeQ/Ok=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-kTcJ1TSmNEaEyceEKSLqGQ-1; Fri, 10 Feb 2023 10:33:04 -0500
X-MC-Unique: kTcJ1TSmNEaEyceEKSLqGQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E781B858F09;
        Fri, 10 Feb 2023 15:33:03 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADD9A492B00;
        Fri, 10 Feb 2023 15:33:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/4] ublk_drv: support splice based read/write zero copy
Date:   Fri, 10 Feb 2023 23:32:12 +0800
Message-Id: <20230210153212.733006-5-ming.lei@redhat.com>
In-Reply-To: <20230210153212.733006-1-ming.lei@redhat.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The initial idea of using splice for zero copy is from Miklos and Stefan.

Now io_uring supports IORING_OP_READ[WRITE]_SPLICE_BUF, and ublk can
pass request pages via direct/kernel private pipe to backend io_uring
read/write handling code.

This zero copy implementation improves sequential IO performance
obviously.

ublksrv code:

https://github.com/ming1/ubdsrv/commits/io_uring_splice_buf

So far, only loop/null target supports zero copy:

	ublk add -t loop -f $file -z
	ublk add -t none -z

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 169 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/ublk_cmd.h |  31 ++++++-
 2 files changed, 193 insertions(+), 7 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e6eceee44366..5ef5f2ccb0d5 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -43,6 +43,8 @@
 #include <asm/page.h>
 #include <linux/task_work.h>
 #include <linux/namei.h>
+#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <uapi/linux/ublk_cmd.h>
 
 #define UBLK_MINORS		(1U << MINORBITS)
@@ -154,6 +156,8 @@ struct ublk_device {
 	unsigned long		state;
 	int			ub_number;
 
+	struct srcu_struct	srcu;
+
 	struct mutex		mutex;
 
 	spinlock_t		mm_lock;
@@ -537,6 +541,9 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
 		return rq_bytes;
 
+	if (ubq->flags & UBLK_F_SUPPORT_ZERO_COPY)
+		return rq_bytes;
+
 	if (ublk_rq_has_data(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
@@ -558,6 +565,9 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
+	if (ubq->flags & UBLK_F_SUPPORT_ZERO_COPY)
+		return rq_bytes;
+
 	if (req_op(req) == REQ_OP_READ && ublk_rq_has_data(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
@@ -1221,6 +1231,7 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	del_gendisk(ub->ub_disk);
 	ub->dev_info.state = UBLK_S_DEV_DEAD;
 	ub->dev_info.ublksrv_pid = -1;
+	synchronize_srcu(&ub->srcu);
 	put_disk(ub->ub_disk);
 	ub->ub_disk = NULL;
  unlock:
@@ -1355,13 +1366,155 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 }
 
+static void ublk_pipe_buf_release(struct pipe_inode_info *pipe,
+			      struct pipe_buffer *buf)
+{
+}
+
+static const struct pipe_buf_operations ublk_pipe_buf_ops = {
+        .release        = ublk_pipe_buf_release,
+};
+
+static inline bool ublk_check_splice_rw(const struct request *req,
+		unsigned int flags)
+{
+	flags &= (SPLICE_F_KERN_FOR_READ | SPLICE_F_KERN_FOR_WRITE);
+
+	if (req_op(req) == REQ_OP_READ && flags == SPLICE_F_KERN_FOR_READ)
+		return true;
+
+	if (req_op(req) == REQ_OP_WRITE && flags == SPLICE_F_KERN_FOR_WRITE)
+		return true;
+
+	return false;
+}
+
+static ssize_t ublk_splice_read(struct file *in, loff_t *ppos,
+		struct pipe_inode_info *pipe,
+		size_t len, unsigned int flags)
+{
+	struct ublk_device *ub = in->private_data;
+	struct req_iterator rq_iter;
+	struct bio_vec bv;
+	struct request *req;
+	struct ublk_queue *ubq;
+	u16 tag, q_id;
+	unsigned int done;
+	int ret, buf_offset, srcu_idx;
+
+	if (!ub)
+		return -EPERM;
+
+	/* only support direct pipe and we do need confirm */
+	if (pipe != current->splice_pipe || !(flags &
+				SPLICE_F_KERN_NEED_CONFIRM))
+		return -EACCES;
+
+	ret = -EINVAL;
+
+	/* protect request queue & disk removed */
+	srcu_idx = srcu_read_lock(&ub->srcu);
+
+	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
+		goto exit;
+
+	tag = ublk_pos_to_tag(*ppos);
+	q_id = ublk_pos_to_hwq(*ppos);
+	buf_offset = ublk_pos_to_buf_offset(*ppos);
+
+	if (q_id >= ub->dev_info.nr_hw_queues)
+		goto exit;
+
+	ubq = ublk_get_queue(ub, q_id);
+	if (!ubq)
+		goto exit;
+
+	if (!(ubq->flags & UBLK_F_SUPPORT_ZERO_COPY))
+		goto exit;
+
+	/*
+	 * So far just support splice read buffer from ubq daemon context
+	 * because request may be gone in ->splice_read() if the splice
+	 * is called from other context.
+	 *
+	 * TODO: add request protection and relax the following limit.
+	 */
+	if (ubq->ubq_daemon != current)
+		goto exit;
+
+	if (tag >= ubq->q_depth)
+		goto exit;
+
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
+	if (!req || !blk_mq_request_started(req))
+		goto exit;
+
+	pr_devel("%s: qid %d tag %u offset %x, request bytes %u, len %llu flags %x\n",
+			__func__, tag, q_id, buf_offset, blk_rq_bytes(req),
+			(unsigned long long)len, flags);
+
+	if (!ublk_check_splice_rw(req, flags))
+		goto exit;
+
+	if (!ublk_rq_has_data(req) || !len)
+		goto exit;
+
+	if (buf_offset + len > blk_rq_bytes(req))
+		goto exit;
+
+	done = ret = 0;
+	rq_for_each_bvec(bv, req, rq_iter) {
+		struct pipe_buffer buf = {
+			.ops = &ublk_pipe_buf_ops,
+			.flags = 0,
+			.page = bv.bv_page,
+			.offset = bv.bv_offset,
+			.len = bv.bv_len,
+		};
+
+		if (buf_offset > 0) {
+			if (buf_offset >= bv.bv_len) {
+				buf_offset -= bv.bv_len;
+				continue;
+			} else {
+				buf.offset += buf_offset;
+				buf.len -= buf_offset;
+				buf_offset = 0;
+			}
+		}
+
+		if (done + buf.len > len)
+			buf.len = len - done;
+		done += buf.len;
+
+		ret = add_to_pipe(pipe, &buf);
+		if (unlikely(ret < 0)) {
+			done -= buf.len;
+			break;
+		}
+		if (done >= len)
+			break;
+	}
+
+	if (done) {
+		*ppos += done;
+		ret = done;
+
+		pipe_ack_page_consume(pipe);
+	}
+exit:
+	srcu_read_unlock(&ub->srcu, srcu_idx);
+	return ret;
+}
+
 static const struct file_operations ublk_ch_fops = {
 	.owner = THIS_MODULE,
 	.open = ublk_ch_open,
 	.release = ublk_ch_release,
-	.llseek = no_llseek,
+	.llseek = noop_llseek,
 	.uring_cmd = ublk_ch_uring_cmd,
 	.mmap = ublk_ch_mmap,
+	.splice_read = ublk_splice_read,
 };
 
 static void ublk_deinit_queue(struct ublk_device *ub, int q_id)
@@ -1472,6 +1625,7 @@ static void ublk_cdev_rel(struct device *dev)
 	ublk_deinit_queues(ub);
 	ublk_free_dev_number(ub);
 	mutex_destroy(&ub->mutex);
+	cleanup_srcu_struct(&ub->srcu);
 	kfree(ub);
 }
 
@@ -1600,17 +1754,18 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	get_device(&ub->cdev_dev);
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	ret = add_disk(disk);
 	if (ret) {
 		/*
 		 * Has to drop the reference since ->free_disk won't be
 		 * called in case of add_disk failure.
 		 */
+		ub->dev_info.state = UBLK_S_DEV_DEAD;
 		ublk_put_device(ub);
 		goto out_put_disk;
 	}
 	set_bit(UB_STATE_USED, &ub->state);
-	ub->dev_info.state = UBLK_S_DEV_LIVE;
 out_put_disk:
 	if (ret)
 		put_disk(disk);
@@ -1718,6 +1873,9 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	ub = kzalloc(sizeof(*ub), GFP_KERNEL);
 	if (!ub)
 		goto out_unlock;
+	ret = init_srcu_struct(&ub->srcu);
+	if (ret)
+		goto out_free_ub;
 	mutex_init(&ub->mutex);
 	spin_lock_init(&ub->mm_lock);
 	INIT_WORK(&ub->quiesce_work, ublk_quiesce_work_fn);
@@ -1726,7 +1884,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 
 	ret = ublk_alloc_dev_number(ub, header->dev_id);
 	if (ret < 0)
-		goto out_free_ub;
+		goto out_clean_srcu;
 
 	memcpy(&ub->dev_info, &info, sizeof(info));
 
@@ -1744,9 +1902,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (!IS_BUILTIN(CONFIG_BLK_DEV_UBLK))
 		ub->dev_info.flags |= UBLK_F_URING_CMD_COMP_IN_TASK;
 
-	/* We are not ready to support zero copy */
-	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
-
 	ub->dev_info.nr_hw_queues = min_t(unsigned int,
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
 	ublk_align_max_io_size(ub);
@@ -1776,6 +1931,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	ublk_deinit_queues(ub);
 out_free_dev_number:
 	ublk_free_dev_number(ub);
+out_clean_srcu:
+	cleanup_srcu_struct(&ub->srcu);
 out_free_ub:
 	mutex_destroy(&ub->mutex);
 	kfree(ub);
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index f6238ccc7800..a2f6748ee4ca 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -54,7 +54,36 @@
 #define UBLKSRV_IO_BUF_OFFSET	0x80000000
 
 /* tag bit is 12bit, so at most 4096 IOs for each queue */
-#define UBLK_MAX_QUEUE_DEPTH	4096
+#define UBLK_TAG_BITS		12
+#define UBLK_MAX_QUEUE_DEPTH	(1U << UBLK_TAG_BITS)
+
+/* used in ->splice_read for supporting zero-copy */
+#define UBLK_BUFS_SIZE_BITS	42
+#define UBLK_BUFS_SIZE_MASK    ((1ULL << UBLK_BUFS_SIZE_BITS) - 1)
+#define UBLK_BUF_SIZE_BITS     (UBLK_BUFS_SIZE_BITS - UBLK_TAG_BITS)
+#define UBLK_BUF_MAX_SIZE      (1ULL << UBLK_BUF_SIZE_BITS)
+
+static inline __u16 ublk_pos_to_hwq(__u64 pos)
+{
+	return pos >> UBLK_BUFS_SIZE_BITS;
+}
+
+static inline __u32 ublk_pos_to_buf_offset(__u64 pos)
+{
+	return (pos & UBLK_BUFS_SIZE_MASK) & (UBLK_BUF_MAX_SIZE - 1);
+}
+
+static inline __u16 ublk_pos_to_tag(__u64 pos)
+{
+	return (pos & UBLK_BUFS_SIZE_MASK) >> UBLK_BUF_SIZE_BITS;
+}
+
+/* offset of single buffer, which has to be < UBLK_BUX_MAX_SIZE */
+static inline __u64 ublk_pos(__u16 q_id, __u16 tag, __u32 offset)
+{
+	return (((__u64)q_id) << UBLK_BUFS_SIZE_BITS) |
+		((((__u64)tag) << UBLK_BUF_SIZE_BITS) + offset);
+}
 
 /*
  * zero copy requires 4k block size, and can remap ublk driver's io
-- 
2.31.1

