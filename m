Return-Path: <io-uring+bounces-7748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06507A9ED1F
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D88A1629B0
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3942525DD1A;
	Mon, 28 Apr 2025 09:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnAxc210"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB031DE2CF
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833509; cv=none; b=JsJUe2xxo1KsRogvAD4fgibWV3DnxLk8s1pP1d5OeGs8dtNaGlaClz3Tl/tEM9/xbzKDqR0ZqUG8o19Kaieui0+lYUKbR6mskQsTVkC+fc6Eq3ZEMu4ZYFnK93wJ8vVm2tcNsKsAuHpVbhsk8YaJmvtaWPwPEgQ9Z3SwoQ4JGEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833509; c=relaxed/simple;
	bh=5uhiwmaxLOgiH+d8sZ/RF95Ard1whrgHfzg2IOHGXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4wYFfXdLAQ6NHXRwWfqi1USepBIb4GTA8MB4CnfDkpmCbQz5GbjC3mQFF7zVE6V4icQMJmIS8tEMakWLktZJIqgeOQNH/Ex5X5JbxGamQOUb4mXWsdDEcWaNBQS5qCcDsP6796S2OkdBvX8fV6q7fOnYYNzhm5asPaElkpv1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnAxc210; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PwfsdcmBrLSt5UA63GogTrnK+Vei3hZmdQP3DOa+zgU=;
	b=JnAxc210SlqrzzgzysswE6ZTA3m6sjJh1IMfEb90Kwm3eFetKDy6oVJrR+Ab2Ktp5d4Yhg
	WrFXULFIsKhoit3cqcBkmCfzNRtURNZRVJVh+6aGli7zWMDn8fh83PpMZw9S7scg5GG/b+
	qw/6KXdobj+0mc4MFWNJRJNJJHpGMts=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-zG74Cy3hNP-KgqgNGpdYHw-1; Mon,
 28 Apr 2025 05:45:00 -0400
X-MC-Unique: zG74Cy3hNP-KgqgNGpdYHw-1
X-Mimecast-MFC-AGG-ID: zG74Cy3hNP-KgqgNGpdYHw_1745833499
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A71BB19560AF;
	Mon, 28 Apr 2025 09:44:58 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8AC9E1800352;
	Mon, 28 Apr 2025 09:44:57 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 6/7] ublk: register buffer to specified io_uring & buf index via UBLK_F_AUTO_BUF_REG
Date: Mon, 28 Apr 2025 17:44:17 +0800
Message-ID: <20250428094420.1584420-7-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add UBLK_F_AUTO_BUF_REG for supporting to register buffer automatically
to specified io_uring context and buffer index.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 56 ++++++++++++++++++++++++++++-------
 include/uapi/linux/ublk_cmd.h | 38 ++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1fd20e481a60..e82618442749 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -66,7 +66,8 @@
 		| UBLK_F_USER_COPY \
 		| UBLK_F_ZONED \
 		| UBLK_F_USER_RECOVERY_FAIL_IO \
-		| UBLK_F_UPDATE_SIZE)
+		| UBLK_F_UPDATE_SIZE \
+		| UBLK_F_AUTO_BUF_REG)
 
 #define UBLK_F_ALL_RECOVERY_FLAGS (UBLK_F_USER_RECOVERY \
 		| UBLK_F_USER_RECOVERY_REISSUE \
@@ -146,7 +147,10 @@ struct ublk_uring_cmd_pdu {
 
 struct ublk_io {
 	/* userspace buffer address from io cmd */
-	__u64	addr;
+	union {
+		__u64	addr;
+		struct ublk_auto_buf_reg buf;
+	};
 	unsigned int flags;
 	int res;
 
@@ -626,7 +630,7 @@ static inline bool ublk_support_zero_copy(const struct ublk_queue *ubq)
 
 static inline bool ublk_support_auto_buf_reg(const struct ublk_queue *ubq)
 {
-	return false;
+	return ubq->flags & UBLK_F_AUTO_BUF_REG;
 }
 
 static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
@@ -1177,6 +1181,16 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_end_request(rq, BLK_STS_IOERR);
 }
 
+
+static inline void ublk_init_auto_buf_reg(const struct ublk_io *io,
+					  struct io_buf_data *data)
+{
+	data->index = io->buf.index;
+	data->ring_fd = io->buf.ring_fd;
+	data->has_fd = true;
+	data->registered_fd = io->buf.flags & UBLK_AUTO_BUF_REGISTERED_RING;
+}
+
 static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *req,
 			      struct ublk_io *io, unsigned int issue_flags)
 {
@@ -1187,6 +1201,9 @@ static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *req,
 	};
 	int ret;
 
+	if (ublk_support_auto_buf_reg(ubq))
+		ublk_init_auto_buf_reg(io, &data);
+
 	/* one extra reference is dropped by ublk_io_release */
 	ublk_init_req_ref(ubq, req, 2);
 	ret = io_buffer_register_bvec(io->cmd, &data, issue_flags);
@@ -2045,7 +2062,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
 		 */
 		if (!buf_addr && !ublk_need_get_data(ubq))
 			goto out;
-	} else if (buf_addr) {
+	} else if (buf_addr && !ublk_support_auto_buf_reg(ubq)) {
 		/* User copy requires addr to be unset */
 		ret = -EINVAL;
 		goto out;
@@ -2058,13 +2075,17 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
 	return ret;
 }
 
-static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_cmd *cmd,
+static void ublk_auto_buf_unreg(const struct ublk_queue *ubq,
+				struct ublk_io *io, struct io_uring_cmd *cmd,
 				struct request *req, unsigned int issue_flags)
 {
 	struct io_buf_data data = {
 		.index = req->tag,
 	};
 
+	if (ublk_support_auto_buf_reg(ubq))
+		ublk_init_auto_buf_reg(io, &data);
+
 	WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flags));
 	io->flags &= ~UBLK_IO_FLAG_AUTO_BUF_REG;
 }
@@ -2088,7 +2109,8 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
 		if (!ub_cmd->addr && (!ublk_need_get_data(ubq) ||
 					req_op(req) == REQ_OP_READ))
 			return -EINVAL;
-	} else if (req_op(req) != REQ_OP_ZONE_APPEND && ub_cmd->addr) {
+	} else if ((req_op(req) != REQ_OP_ZONE_APPEND &&
+				!ublk_support_auto_buf_reg(ubq)) && ub_cmd->addr) {
 		/*
 		 * User copy requires addr to be unset when command is
 		 * not zone append
@@ -2097,7 +2119,7 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
 	}
 
 	if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
-		ublk_auto_buf_unreg(io, cmd, req, issue_flags);
+		ublk_auto_buf_unreg(ubq, io, cmd, req, issue_flags);
 
 	ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
 
@@ -2788,6 +2810,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	else if (!(info.flags & UBLK_F_UNPRIVILEGED_DEV))
 		return -EPERM;
 
+	/* F_AUTO_BUF_REG and F_SUPPORT_ZERO_COPY can't co-exist */
+	if ((info.flags & UBLK_F_AUTO_BUF_REG) &&
+			(info.flags & UBLK_F_SUPPORT_ZERO_COPY))
+		return -EINVAL;
+
 	/* forbid nonsense combinations of recovery flags */
 	switch (info.flags & UBLK_F_ALL_RECOVERY_FLAGS) {
 	case 0:
@@ -2817,8 +2844,11 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 		 * For USER_COPY, we depends on userspace to fill request
 		 * buffer by pwrite() to ublk char device, which can't be
 		 * used for unprivileged device
+		 *
+		 * Same with zero copy or auto buffer register.
 		 */
-		if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY))
+		if (info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY |
+					UBLK_F_AUTO_BUF_REG))
 			return -EINVAL;
 	}
 
@@ -2876,17 +2906,22 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 		UBLK_F_URING_CMD_COMP_IN_TASK;
 
 	/* GET_DATA isn't needed any more with USER_COPY or ZERO COPY */
-	if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY))
+	if (ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY |
+				UBLK_F_AUTO_BUF_REG))
 		ub->dev_info.flags &= ~UBLK_F_NEED_GET_DATA;
 
 	/*
 	 * Zoned storage support requires reuse `ublksrv_io_cmd->addr` for
 	 * returning write_append_lba, which is only allowed in case of
 	 * user copy or zero copy
+	 *
+	 * UBLK_F_AUTO_BUF_REG can't be enabled for zoned because it need
+	 * the space for getting ring_fd and buffer index.
 	 */
 	if (ublk_dev_is_zoned(ub) &&
 	    (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) || !(ub->dev_info.flags &
-	     (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)))) {
+	     (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)) ||
+	     (ub->dev_info.flags & UBLK_F_AUTO_BUF_REG))) {
 		ret = -EINVAL;
 		goto out_free_dev_number;
 	}
@@ -3403,6 +3438,7 @@ static int __init ublk_init(void)
 
 	BUILD_BUG_ON((u64)UBLKSRV_IO_BUF_OFFSET +
 			UBLKSRV_IO_BUF_TOTAL_SIZE < UBLKSRV_IO_BUF_OFFSET);
+	BUILD_BUG_ON(sizeof(struct ublk_auto_buf_reg) != sizeof(__u64));
 
 	init_waitqueue_head(&ublk_idr_wq);
 
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index be5c6c6b16e0..3d7c8c69cf06 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -219,6 +219,30 @@
  */
 #define UBLK_F_UPDATE_SIZE		 (1ULL << 10)
 
+/*
+ * request buffer is registered automatically to ublk server specified
+ * io_uring context before delivering this io command to ublk server,
+ * meantime it is un-registered automatically when completing this io
+ * command.
+ *
+ * For using this feature:
+ *
+ * - ublk server has to create sparse buffer table
+ *
+ * - pass io_ring context FD from `ublksrv_io_cmd.buf.ring_fd`, and the FD
+ *   can be registered io_ring FD if `UBLK_AUTO_BUF_REGISTERED_RING` is set
+ *   in `ublksrv_io_cmd.flags`, or plain FD
+ *
+ * - pass buffer index from `ublksrv_io_cmd.buf.index`
+ *
+ * This way avoids extra cost from two uring_cmd, but also simplifies backend
+ * implementation, such as, the dependency on IO_REGISTER_IO_BUF and
+ * IO_UNREGISTER_IO_BUF becomes not necessary.
+ *
+ * This feature isn't available for UBLK_F_ZONED
+ */
+#define UBLK_F_AUTO_BUF_REG 	(1ULL << 11)
+
 /* device state */
 #define UBLK_S_DEV_DEAD	0
 #define UBLK_S_DEV_LIVE	1
@@ -339,6 +363,14 @@ static inline __u32 ublksrv_get_flags(const struct ublksrv_io_desc *iod)
 	return iod->op_flags >> 8;
 }
 
+struct ublk_auto_buf_reg {
+	__s32  ring_fd;
+	__u16  index;
+#define UBLK_AUTO_BUF_REGISTERED_RING            (1 << 0)
+	__u8   flags;
+	__u8   _pad;
+};
+
 /* issued to ublk driver via /dev/ublkcN */
 struct ublksrv_io_cmd {
 	__u16	q_id;
@@ -363,6 +395,12 @@ struct ublksrv_io_cmd {
 		 */
 		__u64	addr;
 		__u64	zone_append_lba;
+
+		/*
+		 * for AUTO_BUF_REG feature, F_ZONED can't be supported,
+		 * and ->addr isn't used for zero copy
+		 */
+		struct ublk_auto_buf_reg auto_buf;
 	};
 };
 
-- 
2.47.0


