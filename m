Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5C6D037F
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjC3LkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjC3Lj2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816E9AD39
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtjM1t9/RuOhhaT+16ff71HK3aa9BZZtmJUc3ROLd1I=;
        b=P6w2W9OCzo4J8AQA0kr8BBttVIwvMcJ/faXY32NzsVhsojcUoyqsSldt6CTzmHZu1qugxt
        nEj+QHFW2pvVLqVC8FKCYSWY3PTNXFdvpdaWn6sJkg9CwR+VMQuaerJvBn7R9HrJeTaaHF
        BQZAgseoF+UlrwZQZu+ZH6jXPNY2/JA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-TcZCe1acP9Gg6AwhEHB69w-1; Thu, 30 Mar 2023 07:37:54 -0400
X-MC-Unique: TcZCe1acP9Gg6AwhEHB69w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED04888B7A1;
        Thu, 30 Mar 2023 11:37:53 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74FC9C15BA0;
        Thu, 30 Mar 2023 11:37:52 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 17/17] block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
Date:   Thu, 30 Mar 2023 19:36:30 +0800
Message-Id: <20230330113630.1388860-18-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply io_uring fused command for supporting zero copy:

1) init the fused cmd buffer(io_mapped_buf) in ublk_map_io(), and deinit it
in ublk_unmap_io(), and this buffer is immutable, so it is just fine to
retrieve it from concurrent fused command.

1) add sub-command opcode of UBLK_IO_FUSED_SUBMIT_IO for retrieving this
fused cmd(zero copy) buffer

2) call io_fused_cmd_start_secondary_req() to provide buffer to secondary
request and submit secondary request; meantime setup complete callback via
this API, once secondary request is completed, the complete callback is
called for freeing the buffer and completing the fused command

Also request reference is held during fused command lifetime, and this way
guarantees that request buffer won't be freed until all inflight fused
commands are completed.

userspace(only implement sqe128 fused command):

	https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-for-v6

liburing test(only implement normal sqe fused command: two 64byte SQEs)

	https://github.com/ming1/liburing/tree/fused_cmd_miniublk_for_v6

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 Documentation/block/ublk.rst  | 126 ++++++++++++++++++++--
 drivers/block/ublk_drv.c      | 192 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/ublk_cmd.h |   6 +-
 3 files changed, 303 insertions(+), 21 deletions(-)

diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
index 1713b2890abb..7b7aa24e9729 100644
--- a/Documentation/block/ublk.rst
+++ b/Documentation/block/ublk.rst
@@ -297,18 +297,126 @@ with specified IO tag in the command data:
   ``UBLK_IO_COMMIT_AND_FETCH_REQ`` to the server, ublkdrv needs to copy
   the server buffer (pages) read to the IO request pages.
 
-Future development
-==================
+- ``UBLK_IO_FUSED_SUBMIT_IO``
+
+  Used for implementing zero copy feature.
+
+  It has to been the primary command of io_uring fused command. This command
+  submits the generic secondary IO request with io buffer provided by our primary
+  command, and won't be completed until the secondary request is done.
+
+  The provided buffer is represented as ``io_uring_bvec_buf``, which is
+  actually ublk request buffer's reference, and the reference is shared &
+  read-only, so the generic secondary request can retrieve any part of the buffer
+  by passing buffer offset & length.
 
 Zero copy
----------
+=========
+
+What is zero copy?
+------------------
+
+When application submits IO to ``/dev/ublkb*``, userspace buffer(direct io)
+or page cache buffer(buffered io) or kernel buffer(meta io often) is used
+for submitting data to ublk driver, and all kinds of these buffers are
+represented by bio/bvecs(ublk request buffer) finally. Before supporting
+zero copy, data in these buffers has to be copied to ublk server userspace
+buffer before handling WRITE IO, or after handing READ IO, so that ublk
+server can handle IO for ``/dev/ublkb*`` with the copied data.
+
+The extra copy between ublk request buffer and ublk server userspace buffer
+not only increases CPU utilization(such as pinning pages, copy data), but
+also consumes memory bandwidth, and the cost could be very big when IO size
+is big. It is observed that ublk-null IOPS may be increased to ~5X if the
+extra copy can be avoided.
+
+So zero copy is very important for supporting high performance block device
+in userspace.
+
+Technical requirements
+----------------------
+
+- ublk request buffer use
+
+ublk request buffer is represented by bio/bvec, which is immutable, so do
+not try to change bvec via buffer reference; data can be read from or
+written to the buffer according to buffer direction, but bvec can't be
+changed
+
+- buffer lifetime
+
+Ublk server borrows ublk request buffer for handling ublk IO, ublk request
+buffer reference is used. Reference can't outlive the referent buffer. That
+means all request buffer references have to be released by ublk server
+before ublk driver completes this request, when request buffer ownership
+is transferred to upper layer(FS, application, ...).
+
+Also after ublk request is completed, any page belonging to this ublk
+request can not be written or read any more from ublk server since it is
+one block device from kernel viewpoint.
+
+- buffer direction
+
+For ublk WRITE request, ublk request buffer should only be accessed as data
+source, and the buffer can't be written by ublk server
+
+For ublk READ request, ublk request buffer should only be accessed as data
+destination, and the buffer can't be read by ublk server, otherwise kernel
+data is leaked to ublk server, which can be unprivileged application.
+
+- arbitrary size sub-buffer needs to be retrieved from ublk server
+
+ublk is one generic framework for implementing block device in userspace,
+and typical requirements include logical volume manager(mirror, stripped, ...),
+distributed network storage, compressed target, ...
+
+ublk server needs to retrieve arbitrary size sub-buffer of ublk request, and
+ublk server needs to submit IOs with these sub-buffer(s). That also means
+arbitrary size sub-buffer(s) can be used to submit IO multiple times.
+
+Any sub-buffer is actually one reference of ublk request buffer, which
+ownership can't be transferred to upper layer if any reference is held
+by ublk server.
+
+Why slice isn't good for ublk zero copy
+---------------------------------------
+
+- spliced page from ->splice_read() can't be written
+
+ublk READ request can't be handled because spliced page can't be written to, and
+extending splice for ublk zero copy isn't one good solution [#splice_extend]_
+
+- it is very hard to meet above requirements  wrt. request buffer lifetime
+
+splice/pipe focuses on page reference lifetime, but ublk zero copy pays more
+attention to ublk request buffer lifetime. If is very inefficient to respect
+request buffer lifetime by using all pipe buffer's ->release() which requires
+all pipe buffers and pipe to be kept when ublk server handles IO. That means
+one single dedicated ``pipe_inode_info`` has to be allocated runtime for each
+provided buffer, and the pipe needs to be populated with pages in ublk request
+buffer.
+
+
+io_uring fused command based zero copy
+--------------------------------------
+
+io_uring fused command includes one primary command(uring command) and one
+generic secondary request. The primary command is responsible for submitting
+secondary request with provided buffer from ublk request, and primary command
+won't be completed until the secondary request is completed.
+
+Typical ublk IO handling includes network and FS IO, so it is usual enough
+for io_uring net & fs to support IO with provided buffer from primary command.
 
-Zero copy is a generic requirement for nbd, fuse or similar drivers. A
-problem [#xiaoguang]_ Xiaoguang mentioned is that pages mapped to userspace
-can't be remapped any more in kernel with existing mm interfaces. This can
-occurs when destining direct IO to ``/dev/ublkb*``. Also, he reported that
-big requests (IO size >= 256 KB) may benefit a lot from zero copy.
+Once primary command is submitted successfully, ublk driver guarantees that
+the ublk request buffer won't be gone away since secondary request actually
+grabs the buffer's reference. This way also guarantees that multiple
+concurrent fused commands associated with same request buffer works fine,
+as the provided buffer reference is shared & read-only.
 
+Also buffer usage direction flag is passed to primary command from userspace,
+so ublk driver can validate if it is legal to use buffer with requested
+direction.
 
 References
 ==========
@@ -323,4 +431,4 @@ References
 
 .. [#stefan] https://lore.kernel.org/linux-block/YoOr6jBfgVm8GvWg@stefanha-x1.localdomain/
 
-.. [#xiaoguang] https://lore.kernel.org/linux-block/YoOr6jBfgVm8GvWg@stefanha-x1.localdomain/
+.. [#splice_extend] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index a744d3b5da91..64b0408873f6 100644
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
@@ -565,6 +570,69 @@ static size_t ublk_copy_user_pages(const struct request *req,
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
+		bvec = kvmalloc_array(nr_bvecs, sizeof(struct bio_vec),
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
@@ -575,11 +643,23 @@ static inline bool ublk_need_unmap_req(const struct request *req)
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
@@ -599,11 +679,17 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
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
@@ -687,6 +773,12 @@ static inline struct ublk_uring_cmd_pdu *ublk_get_uring_cmd_pdu(
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
@@ -742,6 +834,7 @@ static inline void __ublk_complete_rq(struct request *req)
 
 	return;
 exit:
+	ublk_deinit_zero_copy_buffer(req);
 	blk_mq_end_request(req, res);
 }
 
@@ -1352,6 +1445,68 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 	return NULL;
 }
 
+static void ublk_fused_cmd_done_cb(struct io_uring_cmd *cmd,
+		unsigned issue_flags)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_fused_cmd_pdu(cmd);
+	struct request *req = pdu->req;
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+
+	ublk_put_req_ref(ubq, req);
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
+static inline bool ublk_check_fused_buf_dir(const struct request *req,
+		unsigned int flags)
+{
+	flags &= IO_URING_F_FUSED_BUF;
+
+	if (req_op(req) == REQ_OP_READ && flags == IO_URING_F_FUSED_BUF_DEST)
+		return true;
+
+	if (req_op(req) == REQ_OP_WRITE && flags == IO_URING_F_FUSED_BUF_SRC)
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
+	if (!(issue_flags & IO_URING_F_FUSED_BUF))
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
+	io_fused_provide_buf_and_start(cmd, issue_flags, data->buf,
+			ublk_fused_cmd_done_cb);
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
@@ -1367,6 +1522,10 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
 			ub_cmd->result);
 
+	if ((issue_flags & IO_URING_F_FUSED_BUF) &&
+			cmd_op != UBLK_IO_FUSED_SUBMIT_IO)
+		return -EOPNOTSUPP;
+
 	if (ub_cmd->q_id >= ub->dev_info.nr_hw_queues)
 		goto out;
 
@@ -1374,7 +1533,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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
@@ -1397,6 +1561,9 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		goto out;
 
 	switch (cmd_op) {
+	case UBLK_IO_FUSED_SUBMIT_IO:
+		return ublk_handle_fused_cmd(cmd, ubq, tag, issue_flags);
+
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
 		if (ublk_queue_ready(ubq)) {
@@ -1726,11 +1893,14 @@ static void ublk_align_max_io_size(struct ublk_device *ub)
 
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
@@ -1946,12 +2116,18 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
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

