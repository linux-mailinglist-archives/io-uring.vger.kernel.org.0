Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B312861792A
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 09:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKCIwF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 04:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiKCIvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 04:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC37271E
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 01:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667465452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s24KGcV2Z54EoXUCNfpVmCq/LLHmEm9f0arH5p9T5iM=;
        b=LWMbnlNsdzDmHxxAqZ9DMp7LffyVbSONd6lTpRRxKW1HqZikIREgYs4AClUWOP/QaWmSyp
        OmRPcV6elhzoJYFLCu2ZQLeMD+EBXYqYmWcRakgR8GQgK+J2FkcUPZ1wM1AwejFipgGazG
        bAe5JRS/UV2p2jjA0a92dyB6HOFMeoM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-P1tEpVr6PqigEItNTJ3Wjw-1; Thu, 03 Nov 2022 04:50:48 -0400
X-MC-Unique: P1tEpVr6PqigEItNTJ3Wjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4270858F13;
        Thu,  3 Nov 2022 08:50:47 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B901840C2140;
        Thu,  3 Nov 2022 08:50:46 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 4/4] ublk_drv: support splice based read/write zero copy
Date:   Thu,  3 Nov 2022 16:50:04 +0800
Message-Id: <20221103085004.1029763-5-ming.lei@redhat.com>
In-Reply-To: <20221103085004.1029763-1-ming.lei@redhat.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass ublk block IO request pages to kernel backend IO handling code via
pipe, and request page copy can be avoided. So far, the existed
pipe/splice mechanism works for handling write request only.

The initial idea of using splice for zero copy is from Miklos and Stefan.

Read request's zero copy requires pipe's change to allow one read end to
produce buffers for another read end to consume. The added SPLICE_F_READ_TO_READ
flag is for supporting this feature.

READ is handled by sending IORING_OP_SPLICE with SPLICE_F_DIRECT |
SPLICE_F_READ_TO_READ. WRITE is handled by sending IORING_OP_SPLICE with
SPLICE_F_DIRECT. Kernel internal pipe is used for simplifying userspace,
meantime potential info leak could be avoided.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 151 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/ublk_cmd.h |  34 +++++++-
 2 files changed, 182 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f96cb01e9604..c9d061547877 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -42,6 +42,8 @@
 #include <linux/mm.h>
 #include <asm/page.h>
 #include <linux/task_work.h>
+#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <uapi/linux/ublk_cmd.h>
 
 #define UBLK_MINORS		(1U << MINORBITS)
@@ -51,7 +53,8 @@
 		| UBLK_F_URING_CMD_COMP_IN_TASK \
 		| UBLK_F_NEED_GET_DATA \
 		| UBLK_F_USER_RECOVERY \
-		| UBLK_F_USER_RECOVERY_REISSUE)
+		| UBLK_F_USER_RECOVERY_REISSUE \
+		| UBLK_F_SPLICE_ZC)
 
 /* All UBLK_PARAM_TYPE_* should be included here */
 #define UBLK_PARAM_TYPE_ALL (UBLK_PARAM_TYPE_BASIC | UBLK_PARAM_TYPE_DISCARD)
@@ -61,6 +64,7 @@ struct ublk_rq_data {
 		struct callback_head work;
 		struct llist_node node;
 	};
+	atomic_t	handled;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -480,6 +484,9 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
 		return rq_bytes;
 
+	if (ubq->flags & UBLK_F_SPLICE_ZC)
+		return rq_bytes;
+
 	if (ublk_rq_has_data(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
@@ -501,6 +508,9 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
+	if (ubq->flags & UBLK_F_SPLICE_ZC)
+		return rq_bytes;
+
 	if (req_op(req) == REQ_OP_READ && ublk_rq_has_data(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
@@ -858,6 +868,19 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ublk_queue_can_use_recovery(ubq) && unlikely(ubq->force_abort))
 		return BLK_STS_IOERR;
 
+	if (ubq->flags & UBLK_F_SPLICE_ZC) {
+		struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+
+		atomic_set(&data->handled, 0);
+
+		/*
+		 * Order write ->handled and write rq->state in
+		 * blk_mq_start_request, the pair barrier is the one
+		 * implied in atomic_inc_return() in ublk_splice_read
+		 */
+		smp_wmb();
+	}
+
 	blk_mq_start_request(bd->rq);
 
 	if (unlikely(ubq_daemon_is_dying(ubq))) {
@@ -1299,13 +1322,137 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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
+/*
+ * Pass request page reference to kernel backend IO handler via pipe
+ *
+ * ublk server has to handle backend IO via splice()
+ */
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
+	int ret, buf_offset;
+	struct ublk_rq_data *data;
+
+	if (!(flags & SPLICE_F_DIRECT))
+		return -EPERM;
+
+	/* No, we have to be the in side */
+	if (pipe->consumed_by_read)
+		return -EINVAL;
+
+	if (!ub)
+		return -EPERM;
+
+	tag = ublk_pos_to_tag(*ppos);
+	q_id = ublk_pos_to_hwq(*ppos);
+	buf_offset = ublk_pos_to_buf_offset(*ppos);
+
+	if (q_id >= ub->dev_info.nr_hw_queues)
+		return -EINVAL;
+
+	ubq = ublk_get_queue(ub, q_id);
+	if (!ubq)
+		return -EINVAL;
+
+	if (!(ubq->flags & UBLK_F_SPLICE_ZC))
+		return -EINVAL;
+
+	if (tag >= ubq->q_depth)
+		return -EINVAL;
+
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
+	if (!req || !blk_mq_request_started(req))
+		return -EINVAL;
+
+	data = blk_mq_rq_to_pdu(req);
+	if (atomic_add_return(len, &data->handled) > blk_rq_bytes(req) || !len)
+		return -EACCES;
+
+	ret = -EINVAL;
+	if (!ublk_rq_has_data(req))
+		goto exit;
+
+	pr_devel("%s: qid %d tag %u offset %x, request bytes %u, len %llu\n",
+			__func__, tag, q_id, buf_offset, blk_rq_bytes(req),
+			(unsigned long long)len);
+
+	if (buf_offset + len > blk_rq_bytes(req))
+		goto exit;
+
+	if ((req_op(req) == REQ_OP_READ) &&
+			!(flags & SPLICE_F_READ_TO_READ))
+		goto exit;
+
+	if ((req_op(req) != REQ_OP_READ) &&
+			(flags & SPLICE_F_READ_TO_READ))
+		goto exit;
+
+	done = ret = 0;
+	/* todo: is iov_iter ready for handling multipage bvec? */
+	rq_for_each_segment(bv, req, rq_iter) {
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
+		ret = add_to_pipe(pipe, &buf);
+		if (unlikely(ret < 0))
+			break;
+		done += ret;
+	}
+
+	if (flags & SPLICE_F_READ_TO_READ)
+		pipe->consumed_by_read = true;
+
+	WARN_ON_ONCE(done > len);
+
+	if (done) {
+		*ppos += done;
+		ret = done;
+	}
+exit:
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
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index 8f88e3a29998..93d9ca7650ce 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -52,7 +52,36 @@
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
@@ -79,6 +108,9 @@
 
 #define UBLK_F_USER_RECOVERY_REISSUE	(1UL << 4)
 
+/* slice based write zero copy */
+#define UBLK_F_SPLICE_ZC	(1UL << 5)
+
 /* device state */
 #define UBLK_S_DEV_DEAD	0
 #define UBLK_S_DEV_LIVE	1
-- 
2.31.1

