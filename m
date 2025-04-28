Return-Path: <io-uring+bounces-7746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A955A9ED40
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FB4D3A91F5
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55170267B14;
	Mon, 28 Apr 2025 09:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bj2icjfo"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A71E267AFC
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833504; cv=none; b=mESi1ET6VV2a2FKZ6UwNaUKw4jwHJkPJg6cJdvoWsm7TF1yXMW17dOQ+pMm4b3g1DZbgOtfL+8gCmLnNQ69NVzXrjCZulKUbvANonaNL3YaqNoebNJFmCxin4UGCrA4C8fc3bmitAaL5ApPpx7P2lGg3INdBQ+FmnwayuSkob3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833504; c=relaxed/simple;
	bh=0KxYV1Q2xfvDWmBu/UyjEWJVpRP6m/lCT2TuyEXNiUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnAd3FeMe+YjCQfKV2zfuBlX+xcKrFrIPgk3GpiTmXdgDWWizf++KZcNrqVmelxFgjSUKTSXOyaeswCyN/Qqs32KdRscrWnv8lrYchyLEabM8AFWGu4f5pfkPPCUYx2FekDd19uz6CwHiBFMbPVAhcj3zwh375J+/6H3Xkl9yR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bj2icjfo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvzG55eQCqAYFEI+SZkh9pz0HYSVHvuq8GsgaUkD7OE=;
	b=bj2icjfoNB7hfogXw/EeYqA/4tdCTke105MQ+IJUfReebzBq+hPoIVNUdbypsowmDIiGc/
	+QUuzwPNlH6rkjVHXXJudhE1B71LzmjI0GadR+Xk5RknnNIpkBMU8kdPR1kv4V1Uirk4NA
	4gVWbV1SV6GBSQ2B6UHu2PfNTYDc/94=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-wEsCUTGxOum33r7sB8GPxw-1; Mon,
 28 Apr 2025 05:44:55 -0400
X-MC-Unique: wEsCUTGxOum33r7sB8GPxw-1
X-Mimecast-MFC-AGG-ID: wEsCUTGxOum33r7sB8GPxw_1745833494
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CF0F195609F;
	Mon, 28 Apr 2025 09:44:54 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC70F19560A3;
	Mon, 28 Apr 2025 09:44:53 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 5/7] ublk: prepare for supporting to register request buffer automatically
Date: Mon, 28 Apr 2025 17:44:16 +0800
Message-ID: <20250428094420.1584420-6-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

UBLK_F_SUPPORT_ZERO_COPY requires ublk server to issue explicit buffer
register/unregister uring_cmd for each IO, this way is not only inefficient,
but also introduce dependency between buffer consumer and buffer register/
unregister uring_cmd, please see tools/testing/selftests/ublk/stripe.c
in which backing file IO has to be issued one by one by IOSQE_IO_LINK.

Prepare for adding feature UBLK_F_AUTO_BUF_REG for addressing the existing
zero copy limitation:

- register request buffer automatically to ublk uring_cmd's io_uring
  context before delivering io command to ublk server

- unregister request buffer automatically from the ublk uring_cmd's
  io_uring context when completing the request

- io_uring will unregister the buffer automatically when uring is
  exiting, so we needn't worry about accident exit

For using this feature, ublk server has to create one sparse buffer table

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 85 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 9 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 9cd331d12fa6..1fd20e481a60 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -133,6 +133,14 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
 
+/*
+ * request buffer is registered automatically, so we have to unregister it
+ * before completing this request.
+ *
+ * io_uring will unregister buffer automatically for us during exiting.
+ */
+#define UBLK_IO_FLAG_AUTO_BUF_REG 	0x10
+
 /* atomic RW with ubq->cancel_lock */
 #define UBLK_IO_FLAG_CANCELED	0x80000000
 
@@ -205,6 +213,7 @@ struct ublk_params_header {
 	__u32	types;
 };
 
+static void ublk_io_release(void *priv);
 static void ublk_stop_dev_unlocked(struct ublk_device *ub);
 static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq);
 static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
@@ -615,6 +624,11 @@ static inline bool ublk_support_zero_copy(const struct ublk_queue *ubq)
 	return ubq->flags & UBLK_F_SUPPORT_ZERO_COPY;
 }
 
+static inline bool ublk_support_auto_buf_reg(const struct ublk_queue *ubq)
+{
+	return false;
+}
+
 static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
 {
 	return ubq->flags & UBLK_F_USER_COPY;
@@ -622,7 +636,8 @@ static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
 
 static inline bool ublk_need_map_io(const struct ublk_queue *ubq)
 {
-	return !ublk_support_user_copy(ubq) && !ublk_support_zero_copy(ubq);
+	return !ublk_support_user_copy(ubq) && !ublk_support_zero_copy(ubq) &&
+		!ublk_support_auto_buf_reg(ubq);
 }
 
 static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
@@ -633,17 +648,22 @@ static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
 	 *
 	 * for zero copy, request buffer need to be registered to io_uring
 	 * buffer table, so reference is needed
+	 *
+	 * For auto buffer register, ublk server still may issue
+	 * UBLK_IO_COMMIT_AND_FETCH_REQ before one registered buffer is used up,
+	 * so reference is required too.
 	 */
-	return ublk_support_user_copy(ubq) || ublk_support_zero_copy(ubq);
+	return ublk_support_user_copy(ubq) || ublk_support_zero_copy(ubq) ||
+		ublk_support_auto_buf_reg(ubq);
 }
 
 static inline void ublk_init_req_ref(const struct ublk_queue *ubq,
-		struct request *req)
+		struct request *req, int init_ref)
 {
 	if (ublk_need_req_ref(ubq)) {
 		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 
-		refcount_set(&data->ref, 1);
+		refcount_set(&data->ref, init_ref);
 	}
 }
 
@@ -1157,6 +1177,37 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_end_request(rq, BLK_STS_IOERR);
 }
 
+static bool ublk_auto_buf_reg(struct ublk_queue *ubq, struct request *req,
+			      struct ublk_io *io, unsigned int issue_flags)
+{
+	struct io_buf_data data = {
+		.rq    = req,
+		.index = req->tag,
+		.release = ublk_io_release,
+	};
+	int ret;
+
+	/* one extra reference is dropped by ublk_io_release */
+	ublk_init_req_ref(ubq, req, 2);
+	ret = io_buffer_register_bvec(io->cmd, &data, issue_flags);
+	if (ret) {
+		blk_mq_end_request(req, BLK_STS_IOERR);
+		return false;
+	}
+	io->flags |= UBLK_IO_FLAG_AUTO_BUF_REG;
+	return true;
+}
+
+static bool ublk_prep_buf_reg(struct ublk_queue *ubq, struct request *req,
+			      struct ublk_io *io, unsigned int issue_flags)
+{
+	if (ublk_support_auto_buf_reg(ubq) && ublk_rq_has_data(req))
+		return ublk_auto_buf_reg(ubq, req, io, issue_flags);
+
+	ublk_init_req_ref(ubq, req, 1);
+	return true;
+}
+
 static void ublk_start_io(struct ublk_queue *ubq, struct request *req,
 			  struct ublk_io *io)
 {
@@ -1181,8 +1232,6 @@ static void ublk_start_io(struct ublk_queue *ubq, struct request *req,
 		ublk_get_iod(ubq, req->tag)->nr_sectors =
 			mapped_bytes >> 9;
 	}
-
-	ublk_init_req_ref(ubq, req);
 }
 
 static void ublk_dispatch_req(struct ublk_queue *ubq,
@@ -1225,7 +1274,9 @@ static void ublk_dispatch_req(struct ublk_queue *ubq,
 	}
 
 	ublk_start_io(ubq, req, io);
-	ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags);
+
+	if (ublk_prep_buf_reg(ubq, req, io, issue_flags))
+		ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags);
 }
 
 static void ublk_cmd_tw_cb(struct io_uring_cmd *cmd,
@@ -2007,9 +2058,21 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
 	return ret;
 }
 
+static void ublk_auto_buf_unreg(struct ublk_io *io, struct io_uring_cmd *cmd,
+				struct request *req, unsigned int issue_flags)
+{
+	struct io_buf_data data = {
+		.index = req->tag,
+	};
+
+	WARN_ON_ONCE(io_buffer_unregister_bvec(cmd, &data, issue_flags));
+	io->flags &= ~UBLK_IO_FLAG_AUTO_BUF_REG;
+}
+
 static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
 				 struct ublk_io *io, struct io_uring_cmd *cmd,
-				 const struct ublksrv_io_cmd *ub_cmd)
+				 const struct ublksrv_io_cmd *ub_cmd,
+				 unsigned int issue_flags)
 {
 	struct request *req;
 
@@ -2033,6 +2096,9 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
 		return -EINVAL;
 	}
 
+	if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG)
+		ublk_auto_buf_unreg(io, cmd, req, issue_flags);
+
 	ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
 
 	/* now this cmd slot is owned by ublk driver */
@@ -2065,6 +2131,7 @@ static void ublk_get_data(struct ublk_queue *ubq, struct ublk_io *io)
 			ublk_get_iod(ubq, req->tag)->addr);
 
 	ublk_start_io(ubq, req, io);
+	ublk_init_req_ref(ubq, req, 1);
 }
 
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
@@ -2124,7 +2191,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			goto out;
 		break;
 	case UBLK_IO_COMMIT_AND_FETCH_REQ:
-		ret = ublk_commit_and_fetch(ubq, io, cmd, ub_cmd);
+		ret = ublk_commit_and_fetch(ubq, io, cmd, ub_cmd, issue_flags);
 		if (ret)
 			goto out;
 		break;
-- 
2.47.0


