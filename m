Return-Path: <io-uring+bounces-1866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDB28C2DDF
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 02:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 506BA1C20D4E
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 00:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BA6367;
	Sat, 11 May 2024 00:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMOGejTe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C1366
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 00:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715386394; cv=none; b=uBBokMnELlJiQk3jkdV6HmuI+MhzcJA1awiulMPW/8W6r8eHYLm2oW+cw2j6kk6KYzVaE2inzuFJ9QhdPFTPdvtV7NIVqecjrK8Q2Q0iPWJKvrVI0VShPeKVR88ddMwZCjzjxwZqZOEtvsSR3bIGaQKSG+WO0KHyXnR7n7PUjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715386394; c=relaxed/simple;
	bh=s8U+yf+BrfTbleUh5n5HzkHjKduRQQkFBU8WkgGouz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+ur/YzFNgI0GzzSM7qhjF7yC/1imbLWKvlyiZjyE3TjB0Dhc35uXWbC1a4fzasTbTHmX/k7oVJTR6d/Hc3xpUHuWB897mhYYdYp43v6r095DW96C8oodgGBcNUlNMrGbthUeHDN+D3L8M0hkSbMoskAkxaIdbUvnZhM/Wu9M7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMOGejTe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715386392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUb0l7ZG67OYxY2MUi0zuXbWMq/cfeErDSu3x2clJVY=;
	b=GMOGejTeIEPzTDEIbeOniamIv9MlDXSNNCOv3kzkU2SfabRbaMDxI0Brw1VAiyzOuuVL2s
	6873gWCLW5wBgAuHONJrp1IQkEq8rglFV0FK2msZffJ0YhtLg+AJgOmQzuG952MdKoBfaU
	GJdEQPm9tBv1FWsJbSujgC3CvgDDiHA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-lgqvKpZ1N563c0PtFHeVew-1; Fri,
 10 May 2024 20:12:53 -0400
X-MC-Unique: lgqvKpZ1N563c0PtFHeVew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FB9E1C0171D;
	Sat, 11 May 2024 00:12:53 +0000 (UTC)
Received: from localhost (unknown [10.72.116.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB78710B305F;
	Sat, 11 May 2024 00:12:51 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 9/9] ublk: support provide io buffer
Date: Sat, 11 May 2024 08:12:12 +0800
Message-ID: <20240511001214.173711-10-ming.lei@redhat.com>
In-Reply-To: <20240511001214.173711-1-ming.lei@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Implement uring command's IORING_PROVIDE_GROUP_KBUF, and provide
io buffer for userpace to run io_uring operations(FS, network IO),
then ublk zero copy can be supported.

userspace code:

	https://github.com/ublk-org/ublksrv/tree/group-provide-buf.v2
	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf.v2

And both loop and nbd zero copy(io_uring send and send zc) are covered.

Performance improvement is quite obvious in big block size test, such as
'loop --buffered_io' perf is doubled in 64KB block test("loop/007 vs
loop/009").

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 158 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/ublk_cmd.h |   7 +-
 2 files changed, 154 insertions(+), 11 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bea3d5cf8a83..ef07b907437d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -71,6 +71,8 @@ struct ublk_rq_data {
 	__u64 sector;
 	__u32 operation;
 	__u32 nr_zones;
+	bool allocated_bvec;
+	struct io_uring_kernel_buf buf[0];
 };
 
 struct ublk_uring_cmd_pdu {
@@ -189,11 +191,15 @@ struct ublk_params_header {
 	__u32	types;
 };
 
+static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
+		struct ublk_queue *ubq, int tag, size_t offset);
 static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq);
 
 static inline unsigned int ublk_req_build_flags(struct request *req);
 static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
 						   int tag);
+static void ublk_io_buf_giveback_cb(const struct io_uring_kernel_buf *buf);
+
 static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
 {
 	return ub->dev_info.flags & UBLK_F_USER_COPY;
@@ -566,6 +572,11 @@ static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
 	return ublk_support_user_copy(ubq);
 }
 
+static inline bool ublk_support_zc(const struct ublk_queue *ubq)
+{
+	return ubq->flags & UBLK_F_SUPPORT_ZERO_COPY;
+}
+
 static inline void ublk_init_req_ref(const struct ublk_queue *ubq,
 		struct request *req)
 {
@@ -829,6 +840,71 @@ static size_t ublk_copy_user_pages(const struct request *req,
 	return done;
 }
 
+/*
+ * The built command buffer is immutable, so it is fine to feed it to
+ * concurrent io_uring provide buf commands
+ */
+static int ublk_init_zero_copy_buffer(struct request *req)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+	struct io_uring_kernel_buf *imu = data->buf;
+	struct req_iterator rq_iter;
+	unsigned int nr_bvecs = 0;
+	struct bio_vec *bvec;
+	unsigned int offset;
+	struct bio_vec bv;
+
+	if (!ublk_rq_has_data(req))
+		goto exit;
+
+	rq_for_each_bvec(bv, req, rq_iter)
+		nr_bvecs++;
+
+	if (!nr_bvecs)
+		goto exit;
+
+	if (req->bio != req->biotail) {
+		int idx = 0;
+
+		bvec = kvmalloc_array(nr_bvecs, sizeof(struct bio_vec),
+				GFP_NOIO);
+		if (!bvec)
+			return -ENOMEM;
+
+		offset = 0;
+		rq_for_each_bvec(bv, req, rq_iter)
+			bvec[idx++] = bv;
+		data->allocated_bvec = true;
+	} else {
+		struct bio *bio = req->bio;
+
+		offset = bio->bi_iter.bi_bvec_done;
+		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	}
+	imu->bvec = bvec;
+	imu->nr_bvecs = nr_bvecs;
+	imu->offset = offset;
+	imu->len = blk_rq_bytes(req);
+	imu->dir = req_op(req) == REQ_OP_READ ? ITER_DEST : ITER_SOURCE;
+	imu->grp_kbuf_ack = ublk_io_buf_giveback_cb;
+
+	return 0;
+exit:
+	imu->bvec = NULL;
+	return 0;
+}
+
+static void ublk_deinit_zero_copy_buffer(struct request *req)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+	struct io_uring_kernel_buf *imu = data->buf;
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
@@ -840,13 +916,25 @@ static inline bool ublk_need_unmap_req(const struct request *req)
 	       (req_op(req) == REQ_OP_READ || req_op(req) == REQ_OP_DRV_IN);
 }
 
-static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
+static int ublk_map_io(const struct ublk_queue *ubq, struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
-	if (ublk_support_user_copy(ubq))
+	if (ublk_support_user_copy(ubq)) {
+		if (ublk_support_zc(ubq)) {
+			int ret = ublk_init_zero_copy_buffer(req);
+
+			/*
+			 * The only failure is -ENOMEM for allocating providing
+			 * buffer command, return zero so that we can requeue
+			 * this req.
+			 */
+			if (unlikely(ret))
+				return 0;
+		}
 		return rq_bytes;
+	}
 
 	/*
 	 * no zero copy, we delay copy WRITE request data into ublksrv
@@ -864,13 +952,16 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 }
 
 static int ublk_unmap_io(const struct ublk_queue *ubq,
-		const struct request *req,
+		struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
-	if (ublk_support_user_copy(ubq))
+	if (ublk_support_user_copy(ubq)) {
+		if (ublk_support_zc(ubq))
+			ublk_deinit_zero_copy_buffer(req);
 		return rq_bytes;
+	}
 
 	if (ublk_need_unmap_req(req)) {
 		struct iov_iter iter;
@@ -1016,6 +1107,7 @@ static inline void __ublk_complete_rq(struct request *req)
 
 	return;
 exit:
+	ublk_deinit_zero_copy_buffer(req);
 	blk_mq_end_request(req, res);
 }
 
@@ -1658,6 +1750,45 @@ static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 	io_uring_cmd_mark_cancelable(cmd, issue_flags);
 }
 
+static void ublk_io_buf_giveback_cb(const struct io_uring_kernel_buf *buf)
+{
+	struct ublk_rq_data *data = container_of(buf, struct ublk_rq_data, buf[0]);
+	struct request *req = blk_mq_rq_from_pdu(data);
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+
+	ublk_put_req_ref(ubq, req);
+}
+
+static int ublk_provide_io_buf(struct io_uring_cmd *cmd,
+		struct ublk_queue *ubq, int tag)
+{
+	struct ublk_device *ub = cmd->file->private_data;
+	struct ublk_rq_data *data;
+	struct request *req;
+
+	if (!ub)
+		return -EPERM;
+
+	req = __ublk_check_and_get_req(ub, ubq, tag, 0);
+	if (!req)
+		return -EINVAL;
+
+	pr_devel("%s: qid %d tag %u request bytes %u\n",
+			__func__, tag, ubq->q_id, blk_rq_bytes(req));
+
+	data = blk_mq_rq_to_pdu(req);
+
+	/*
+	 * io_uring guarantees that the callback will be called after
+	 * the provided buffer is consumed, and it is automatic removal
+	 * before this uring command is freed.
+	 *
+	 * This request won't be completed unless the callback is called,
+	 * so ublk module won't be unloaded too.
+	 */
+	return io_uring_cmd_provide_kbuf(cmd, data->buf);
+}
+
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags,
 			       const struct ublksrv_io_cmd *ub_cmd)
@@ -1674,6 +1805,10 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
 			ub_cmd->result);
 
+	if ((cmd->flags & IORING_PROVIDE_GROUP_KBUF) &&
+			cmd_op != UBLK_U_IO_PROVIDE_IO_BUF)
+		return -EOPNOTSUPP;
+
 	if (ub_cmd->q_id >= ub->dev_info.nr_hw_queues)
 		goto out;
 
@@ -1709,6 +1844,8 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 
 	ret = -EINVAL;
 	switch (_IOC_NR(cmd_op)) {
+	case _IOC_NR(UBLK_U_IO_PROVIDE_IO_BUF):
+		return ublk_provide_io_buf(cmd, ubq, tag);
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
 		if (ublk_queue_ready(ubq)) {
@@ -2128,11 +2265,14 @@ static void ublk_align_max_io_size(struct ublk_device *ub)
 
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
@@ -2417,8 +2557,12 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 		goto out_free_dev_number;
 	}
 
-	/* We are not ready to support zero copy */
-	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
+	/* zero copy depends on user copy */
+	if ((ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY) &&
+			!ublk_dev_is_user_copy(ub)) {
+		ret = -EINVAL;
+		goto out_free_dev_number;
+	}
 
 	ub->dev_info.nr_hw_queues = min_t(unsigned int,
 			ub->dev_info.nr_hw_queues, nr_cpu_ids);
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index c8dc5f8ea699..897ace0794c2 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -94,6 +94,8 @@
 	_IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
 #define	UBLK_U_IO_NEED_GET_DATA		\
 	_IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
+#define	UBLK_U_IO_PROVIDE_IO_BUF	\
+	_IOWR('u', 0x23, struct ublksrv_io_cmd)
 
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
@@ -126,10 +128,7 @@
 #define UBLKSRV_IO_BUF_TOTAL_BITS	(UBLK_QID_OFF + UBLK_QID_BITS)
 #define UBLKSRV_IO_BUF_TOTAL_SIZE	(1ULL << UBLKSRV_IO_BUF_TOTAL_BITS)
 
-/*
- * zero copy requires 4k block size, and can remap ublk driver's io
- * request into ublksrv's vm space
- */
+/* io_uring provide kbuf command based zero copy */
 #define UBLK_F_SUPPORT_ZERO_COPY	(1ULL << 0)
 
 /*
-- 
2.42.0


