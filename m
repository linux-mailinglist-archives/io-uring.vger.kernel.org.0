Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2146B9543
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 14:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjCNNEg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 09:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjCNNEO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 09:04:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF2ACBAB
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 05:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678798718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LoD9ITw5FtQjABBNvWWztKETsacvaj53kxHMngCT9yw=;
        b=Ea8qJ9/hdnGEbJlLPT+YvFNEELs73/C228m6VHYr73u3JRQ1VNNOFmNi/tewUxkQeloT4B
        TQkk6jdtUjLT/ZJe1OFtOJnhqoS7w5mgCKXouKASacJ/A1U6vn/S0MQeiLKlvuxsbYJy9z
        SteCIbVcJrrGBrZ0d3MkuFDrMJX5IdQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-FgDO8Q-OMBOk4bScF9VhxA-1; Tue, 14 Mar 2023 08:58:31 -0400
X-MC-Unique: FgDO8Q-OMBOk4bScF9VhxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B035E85A5A3;
        Tue, 14 Mar 2023 12:58:30 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDAB9140EBF4;
        Tue, 14 Mar 2023 12:58:29 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 16/16] block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
Date:   Tue, 14 Mar 2023 20:57:27 +0800
Message-Id: <20230314125727.1731233-17-ming.lei@redhat.com>
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply io_uring fused command for supporting zero copy:

1) init the fused cmd buffer(io_mapped_buf) in ublk_map_io(),
and deinit it in ublk_unmap_io(), and this buffer is immutable,
so it is just fine to retrieve it from concurrent fused command.

1) add sub-command opcode of UBLK_IO_FUSED_SUBMIT_IO for retrieving
this fused cmd(zero copy) buffer

2) call io_fused_cmd_provide_kbuf() to provide buffer to slave
request; meantime setup complete callback via this API, once
slave request is completed, the complete callback is called
for freeing the buffer and completing the uring fused command

Also request reference is held during fused command lifetime, and
this way guarantees that request buffer won't be freed until
fused commands are done.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 191 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/ublk_cmd.h |   6 +-
 2 files changed, 185 insertions(+), 12 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e77eca0a45bb..e0879db6220f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -74,10 +74,15 @@ struct ublk_rq_data {
 	 *   successfully
 	 */
 	struct kref ref;
+	bool allocated_bvec;
+	struct io_uring_bvec_buf buf[0];
 };
 
 struct ublk_uring_cmd_pdu {
-	struct ublk_queue *ubq;
+	union {
+		struct ublk_queue *ubq;
+		struct request *req;
+	};
 };
 
 /*
@@ -566,6 +571,69 @@ static size_t ublk_copy_user_pages(const struct request *req,
 	return done;
 }
 
+/*
+ * The built command buffer is immutable, so it is fine to feed it to
+ * concurrent io_uring fused commands
+ */
+static int ublk_init_zero_copy_buffer(struct request *rq)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+	struct io_uring_bvec_buf *imu = data->buf;
+	struct req_iterator rq_iter;
+	unsigned int nr_bvecs = 0;
+	struct bio_vec *bvec;
+	unsigned int offset;
+	struct bio_vec bv;
+
+	if (!ublk_rq_has_data(rq))
+		goto exit;
+
+	rq_for_each_bvec(bv, rq, rq_iter)
+		nr_bvecs++;
+
+	if (!nr_bvecs)
+		goto exit;
+
+	if (rq->bio != rq->biotail) {
+		int idx = 0;
+
+		bvec = kvmalloc_array(sizeof(struct bio_vec), nr_bvecs,
+				GFP_NOIO);
+		if (!bvec)
+			return -ENOMEM;
+
+		offset = 0;
+		rq_for_each_bvec(bv, rq, rq_iter)
+			bvec[idx++] = bv;
+		data->allocated_bvec = true;
+	} else {
+		struct bio *bio = rq->bio;
+
+		offset = bio->bi_iter.bi_bvec_done;
+		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	}
+	imu->bvec = bvec;
+	imu->nr_bvecs = nr_bvecs;
+	imu->offset = offset;
+	imu->len = blk_rq_bytes(rq);
+
+	return 0;
+exit:
+	imu->bvec = NULL;
+	return 0;
+}
+
+static void ublk_deinit_zero_copy_buffer(struct request *rq)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+	struct io_uring_bvec_buf *imu = data->buf;
+
+	if (data->allocated_bvec) {
+		kvfree(imu->bvec);
+		data->allocated_bvec = false;
+	}
+}
+
 static inline bool ublk_need_map_req(const struct request *req)
 {
 	return ublk_rq_has_data(req) && req_op(req) == REQ_OP_WRITE;
@@ -576,11 +644,23 @@ static inline bool ublk_need_unmap_req(const struct request *req)
 	return ublk_rq_has_data(req) && req_op(req) == REQ_OP_READ;
 }
 
-static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
+static int ublk_map_io(const struct ublk_queue *ubq, struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
+	if (ublk_support_zc(ubq)) {
+		int ret = ublk_init_zero_copy_buffer(req);
+
+		/*
+		 * The only failure is -ENOMEM for allocating fused cmd
+		 * buffer, return zero so that we can requeue this req.
+		 */
+		if (unlikely(ret))
+			return 0;
+		return rq_bytes;
+	}
+
 	/*
 	 * no zero copy, we delay copy WRITE request data into ublksrv
 	 * context and the big benefit is that pinning pages in current
@@ -600,11 +680,17 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 }
 
 static int ublk_unmap_io(const struct ublk_queue *ubq,
-		const struct request *req,
+		struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
+	if (ublk_support_zc(ubq)) {
+		ublk_deinit_zero_copy_buffer(req);
+
+		return rq_bytes;
+	}
+
 	if (ublk_need_unmap_req(req)) {
 		struct iov_iter iter;
 		struct iovec iov;
@@ -688,6 +774,12 @@ static inline struct ublk_uring_cmd_pdu *ublk_get_uring_cmd_pdu(
 	return (struct ublk_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
+static inline struct ublk_uring_cmd_pdu *ublk_get_uring_fused_cmd_pdu(
+		struct io_uring_cmd *ioucmd)
+{
+	return (struct ublk_uring_cmd_pdu *)&ioucmd->fused.pdu;
+}
+
 static inline bool ubq_daemon_is_dying(struct ublk_queue *ubq)
 {
 	return ubq->ubq_daemon->flags & PF_EXITING;
@@ -743,6 +835,7 @@ static inline void __ublk_complete_rq(struct request *req)
 
 	return;
 exit:
+	ublk_deinit_zero_copy_buffer(req);
 	blk_mq_end_request(req, res);
 }
 
@@ -1348,6 +1441,67 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 	return NULL;
 }
 
+static void ublk_fused_cmd_done_cb(struct io_uring_cmd *cmd)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_fused_cmd_pdu(cmd);
+	struct request *req = pdu->req;
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+
+	ublk_put_req_ref(ubq, req);
+	io_uring_cmd_done(cmd, cmd->fused.data.slave_res, 0);
+}
+
+static inline bool ublk_check_fused_buf_dir(const struct request *req,
+		unsigned int flags)
+{
+	flags &= IO_URING_F_FUSED;
+
+	if (req_op(req) == REQ_OP_READ && flags == IO_URING_F_FUSED_WRITE)
+		return true;
+
+	if (req_op(req) == REQ_OP_WRITE && flags == IO_URING_F_FUSED_READ)
+		return true;
+
+	return false;
+}
+
+static int ublk_handle_fused_cmd(struct io_uring_cmd *cmd,
+		struct ublk_queue *ubq, int tag, unsigned int issue_flags)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_fused_cmd_pdu(cmd);
+	struct ublk_device *ub = cmd->file->private_data;
+	struct ublk_rq_data *data;
+	struct request *req;
+
+	if (!ub)
+		return -EPERM;
+
+	if (!(issue_flags & IO_URING_F_FUSED))
+		goto exit;
+
+	req = __ublk_check_and_get_req(ub, ubq, tag, 0);
+	if (!req)
+		goto exit;
+
+	pr_devel("%s: qid %d tag %u request bytes %u, issue flags %x\n",
+			__func__, tag, ubq->q_id, blk_rq_bytes(req),
+			issue_flags);
+
+	if (!ublk_check_fused_buf_dir(req, issue_flags))
+		goto exit_put_ref;
+
+	pdu->req = req;
+	data = blk_mq_rq_to_pdu(req);
+	io_fused_cmd_provide_kbuf(cmd, !(issue_flags & IO_URING_F_UNLOCKED),
+			data->buf, ublk_fused_cmd_done_cb);
+	return -EIOCBQUEUED;
+
+exit_put_ref:
+	ublk_put_req_ref(ubq, req);
+exit:
+	return -EINVAL;
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
@@ -1363,6 +1517,10 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
 			ub_cmd->result);
 
+	if ((issue_flags & IO_URING_F_FUSED) &&
+			cmd_op != UBLK_IO_FUSED_SUBMIT_IO)
+		return -EOPNOTSUPP;
+
 	if (ub_cmd->q_id >= ub->dev_info.nr_hw_queues)
 		goto out;
 
@@ -1370,7 +1528,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!ubq || ub_cmd->q_id != ubq->q_id)
 		goto out;
 
-	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
+	/*
+	 * The fused command reads the io buffer data structure only, so it
+	 * is fine to be issued from other context.
+	 */
+	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
+			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
 		goto out;
 
 	if (tag >= ubq->q_depth)
@@ -1393,6 +1556,9 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		goto out;
 
 	switch (cmd_op) {
+	case UBLK_IO_FUSED_SUBMIT_IO:
+		return ublk_handle_fused_cmd(cmd, ubq, tag, issue_flags);
+
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
 		if (ublk_queue_ready(ubq)) {
@@ -1722,11 +1888,14 @@ static void ublk_align_max_io_size(struct ublk_device *ub)
 
 static int ublk_add_tag_set(struct ublk_device *ub)
 {
+	int zc = !!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY);
+	struct ublk_rq_data *data;
+
 	ub->tag_set.ops = &ublk_mq_ops;
 	ub->tag_set.nr_hw_queues = ub->dev_info.nr_hw_queues;
 	ub->tag_set.queue_depth = ub->dev_info.queue_depth;
 	ub->tag_set.numa_node = NUMA_NO_NODE;
-	ub->tag_set.cmd_size = sizeof(struct ublk_rq_data);
+	ub->tag_set.cmd_size = struct_size(data, buf, zc);
 	ub->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	ub->tag_set.driver_data = ub;
 	return blk_mq_alloc_tag_set(&ub->tag_set);
@@ -1942,12 +2111,18 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	 */
 	ub->dev_info.flags &= UBLK_F_ALL;
 
+	/*
+	 * NEED_GET_DATA doesn't make sense any more in case that
+	 * ZERO_COPY is requested. Another reason is that userspace
+	 * can read/write io request buffer by pread()/pwrite() with
+	 * each io buffer's position.
+	 */
+	if (ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY)
+		ub->dev_info.flags &= ~UBLK_F_NEED_GET_DATA;
+
 	if (!IS_BUILTIN(CONFIG_BLK_DEV_UBLK))
 		ub->dev_info.flags |= UBLK_F_URING_CMD_COMP_IN_TASK;
 
-	/* We are not ready to support zero copy */
-	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
-
 	ub->dev_info.nr_hw_queues = min_t(unsigned int,
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
 	ublk_align_max_io_size(ub);
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index d1a6b3dc0327..c4f3465399cf 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -44,6 +44,7 @@
 #define	UBLK_IO_FETCH_REQ		0x20
 #define	UBLK_IO_COMMIT_AND_FETCH_REQ	0x21
 #define	UBLK_IO_NEED_GET_DATA	0x22
+#define	UBLK_IO_FUSED_SUBMIT_IO	0x23
 
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
@@ -85,10 +86,7 @@ static inline __u64 ublk_pos(__u16 q_id, __u16 tag, __u32 offset)
 		((((__u64)tag) << UBLK_BUF_SIZE_BITS) + offset);
 }
 
-/*
- * zero copy requires 4k block size, and can remap ublk driver's io
- * request into ublksrv's vm space
- */
+/* io_uring fused command based zero copy */
 #define UBLK_F_SUPPORT_ZERO_COPY	(1ULL << 0)
 
 /*
-- 
2.39.2

