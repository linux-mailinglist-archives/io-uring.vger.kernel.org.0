Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64566A6DF3
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCAOJW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCAOJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:09:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408E41F4A4
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJE4DhlpagUTIuGDdUJ2rg+ixtBuoV0cAAwn6SVonDk=;
        b=NDRKclKsHLLzkyvLiw0/E0MlMHisA/Wq7uSG40hPEmFUBVv5se7jfzycWmxZd4X3hQp3Xo
        xV4ULChfPF4KESkEzk2I3piEzsUbWsesUQdKIMzSiVX3faZPbKNkEIGFgojSom6nQVaSHM
        BbqNm5NFU51oRQdkCijQjLIS4tqjuxw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-18hTaVV_OgmPyEYUZY9P1g-1; Wed, 01 Mar 2023 09:08:03 -0500
X-MC-Unique: 18hTaVV_OgmPyEYUZY9P1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BC7E891F41;
        Wed,  1 Mar 2023 14:07:10 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4C122166B26;
        Wed,  1 Mar 2023 14:07:09 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 12/12] block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
Date:   Wed,  1 Mar 2023 22:06:11 +0800
Message-Id: <20230301140611.163055-13-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

Todo: don't complete ublk block request until all in-flight fused
commands aiming this request are completed; this change requires
to clean up current ublk driver a bit, so delay this work in future
post, and it won't affect reviewing on this whole approach.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 167 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/ublk_cmd.h |   1 +
 2 files changed, 160 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b9e38ebabca7..56a362798aa7 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -62,6 +62,8 @@
 struct ublk_rq_data {
 	struct llist_node node;
 	struct callback_head work;
+	bool allocated_bvec;
+	struct io_mapped_buf buf[0];
 };
 
 struct ublk_uring_cmd_pdu {
@@ -525,10 +527,87 @@ static inline int ublk_copy_user_pages(struct ublk_map_data *data,
 	return done;
 }
 
-static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
+/*
+ * The built command buffer is immutable, so it is fine to feed it to
+ * concurrent io_uring fused commands
+ */
+static int ublk_init_zero_copy_buffer(struct request *rq)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+	struct io_mapped_buf *imu = data->buf;
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
+	imu->buf = 0;
+	imu->buf_end = blk_rq_bytes(rq);
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
+	struct io_mapped_buf *imu = data->buf;
+
+	if (data->allocated_bvec) {
+		kvfree(imu->bvec);
+		data->allocated_bvec = false;
+	}
+}
+
+static int ublk_map_io(const struct ublk_queue *ubq, struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
+
+	if (ubq->flags & UBLK_F_SUPPORT_ZERO_COPY) {
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
@@ -553,11 +632,17 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 }
 
 static int ublk_unmap_io(const struct ublk_queue *ubq,
-		const struct request *req,
+		struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
+	if (ubq->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		ublk_deinit_zero_copy_buffer(req);
+
+		return rq_bytes;
+	}
+
 	if (req_op(req) == REQ_OP_READ && ublk_rq_has_data(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
@@ -693,6 +778,7 @@ static void ublk_complete_rq(struct request *req)
 
 	return;
 exit:
+	ublk_deinit_zero_copy_buffer(req);
 	blk_mq_end_request(req, res);
 }
 
@@ -1259,6 +1345,66 @@ static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
 	ublk_queue_cmd(ubq, req);
 }
 
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
+static void ublk_fused_cmd_done_cb(struct io_uring_cmd *cmd)
+{
+	io_uring_cmd_done(cmd, cmd->fused.data.slave_res, 0);
+}
+
+static int ublk_handle_fused_cmd(struct io_uring_cmd *cmd,
+		struct ublk_queue *ubq, int tag, unsigned int issue_flags)
+{
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
+	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
+		goto exit;
+
+	if (!(ubq->flags & UBLK_F_SUPPORT_ZERO_COPY))
+		goto exit;
+
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
+	if (!req || !blk_mq_request_started(req))
+		goto exit;
+
+	pr_devel("%s: qid %d tag %u request bytes %u, issue flags %x\n",
+			__func__, tag, ubq->q_id, blk_rq_bytes(req),
+			issue_flags);
+
+	if (!ublk_check_fused_buf_dir(req, issue_flags))
+		goto exit;
+
+	if (!ublk_rq_has_data(req))
+		goto exit;
+
+	data = blk_mq_rq_to_pdu(req);
+	io_fused_cmd_provide_kbuf(cmd, !(issue_flags & IO_URING_F_UNLOCKED),
+			data->buf, ublk_fused_cmd_done_cb);
+	return -EIOCBQUEUED;
+exit:
+	return -EINVAL;
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
@@ -1277,7 +1423,8 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!(issue_flags & IO_URING_F_SQE128))
 		goto out;
 
-	if (issue_flags & IO_URING_F_FUSED)
+	if ((issue_flags & IO_URING_F_FUSED) &&
+			cmd_op != UBLK_IO_FUSED_SUBMIT_IO)
 		return -EOPNOTSUPP;
 
 	if (ub_cmd->q_id >= ub->dev_info.nr_hw_queues)
@@ -1287,7 +1434,8 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!ubq || ub_cmd->q_id != ubq->q_id)
 		goto out;
 
-	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
+	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
+			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
 		goto out;
 
 	if (tag >= ubq->q_depth)
@@ -1310,6 +1458,9 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		goto out;
 
 	switch (cmd_op) {
+	case UBLK_IO_FUSED_SUBMIT_IO:
+		return ublk_handle_fused_cmd(cmd, ubq, tag, issue_flags);
+
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
 		if (ublk_queue_ready(ubq)) {
@@ -1533,11 +1684,14 @@ static void ublk_align_max_io_size(struct ublk_device *ub)
 
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
@@ -1756,9 +1910,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (!IS_BUILTIN(CONFIG_BLK_DEV_UBLK))
 		ub->dev_info.flags |= UBLK_F_URING_CMD_COMP_IN_TASK;
 
-	/* We are not ready to support zero copy */
-	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
-
 	ub->dev_info.nr_hw_queues = min_t(unsigned int,
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
 	ublk_align_max_io_size(ub);
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index f6238ccc7800..027e60e49cc8 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -44,6 +44,7 @@
 #define	UBLK_IO_FETCH_REQ		0x20
 #define	UBLK_IO_COMMIT_AND_FETCH_REQ	0x21
 #define	UBLK_IO_NEED_GET_DATA	0x22
+#define	UBLK_IO_FUSED_SUBMIT_IO	0x23
 
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
-- 
2.31.1

