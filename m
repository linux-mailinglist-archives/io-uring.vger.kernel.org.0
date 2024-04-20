Return-Path: <io-uring+bounces-1602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A65E08ABBBF
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6668A281535
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585612030A;
	Sat, 20 Apr 2024 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PUw6577t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD3D1CD25
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619982; cv=none; b=ldRvkdBzhp7nIXwqlrvtre4Jf7wcJGUYezEizp7CySp8uiN3dZeNgD0vDA3g7iGVX851Td4AM2cJY16Sd7a2wkDadwh525VjItII3l9ILpyhd3L8NwCaPE/M1NUBIN2aSTNXfCyJVbmCXWZsIMLCUXemBVU+LcKn0JPevoiqufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619982; c=relaxed/simple;
	bh=HLMf+Vdhgi6/7xZSVGvGZGs3mSAI0hgSOFDh6SRdq3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ6FnW/N/CI95NfneDfyRjjwo6HUlFzVO/oZDCfi4+/j+owW3Zw0e3DKxDBuu/d/34UHAdomBSXbqbyW1NTLqZ/PIOeGYM92zbcXmNEkGOTmCynuxVZVAuiZtha9WlibMT2BmDXN1XUkb2+Jcvy4F2HN8CTkbFScFQPquejZMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PUw6577t; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6eb50bbd8ceso467384a34.1
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619979; x=1714224779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YpMy9O3xOahtl9nLT0xVNhy9inQvhw9KWICHoewNQE=;
        b=PUw6577t1j8W6ErfaJpXz/N+z1fm/HcKAkkqJczsL8PHoMd4ehXT479Ucs6UwDicCi
         ZFeo627qntujqWu6m1Q9doUjPw3vTC65fwNISCYlzbC2LZtRilDsJVeql6y1DgtiltG1
         Ruy8Ga/GLCrH94sqpjouvy5qViG0Pm0GV8yrpbgC3EwJqwlAHNHVfYfZTsWBBmWOBvfo
         kXOYSYu3+6zrybVZGbceDgmTy8aoskjUfc6b/H/hZCL2y5XRlpBVLmNNwGJM3T+xqcn8
         waiLLk7V9WjnUeh0Yt9OCrgWF6XIExQwYN3IbJRohOSC8clOUAMuptcvJiDLveKFew31
         GV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619979; x=1714224779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YpMy9O3xOahtl9nLT0xVNhy9inQvhw9KWICHoewNQE=;
        b=QIRTAKeIbjws4wi0+Yo7QwUqCMjQQmNPEY0q02JYiK1VGI9oiUM0g0ol4w3kseuMQ3
         9Uaesaq/dzP6s06W6eZgMBynnbIPuCFbaEhR1BUh/t0jn6k5BGSsyXYyFpZ7W1Iy9+Xw
         vtBJTEYCkatFWOd3hz3Gb9DnJbR4sonMMz/kKMvOLITIW6Uh2fcpE4SmeRaUaWx9OOH0
         WH6+LTvpiU0eL3o2rCuOy9PeZ4I0XhiDR3y2+38ocn1KTvU5v/rC2UZimrnwHJhel70A
         IhgPxRzKa+ZdUBufv3MnTrfvun8yepbWQuJzexqjVOgMqYs5WKf0RAU4GikyO8Qy8Ozp
         tYOA==
X-Gm-Message-State: AOJu0YxcQVSXVTs0QHLjeUrDMh/h/SJzrzqEhubeNe1fq0IVk3+SlYx9
	7lnyMM9/hphgcNUm6ka2bXmM608Y1Q8JodtfqX58ifu6xB2tGDROAG6fb68Ii5kSrycZQqXkDqG
	a
X-Google-Smtp-Source: AGHT+IFoBeX7DOa4R0DyRcbCGbdwLTGT6dlUpL/10k9t1BQdLO1QdON1Wmm4MPV6iDqt+Ncq+uJq5Q==
X-Received: by 2002:a05:6870:d68c:b0:22e:77b6:4f9d with SMTP id z12-20020a056870d68c00b0022e77b64f9dmr5843506oap.3.1713619978956;
        Sat, 20 Apr 2024 06:32:58 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring/net: support bundles for recv
Date: Sat, 20 Apr 2024 07:29:47 -0600
Message-ID: <20240420133233.500590-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240420133233.500590-2-axboe@kernel.dk>
References: <20240420133233.500590-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_OP_RECV is used with provided buffers, the caller may also set
IORING_RECVSEND_BUNDLE to turn it into a multi-buffer recv. This grabs
buffers available and receives into them, posting a single completion for
all of it.

This can be used with multishot receive as well, or without it.

Now that both send and receive support bundles, add a feature flag for
it as well. If IORING_FEAT_RECVSEND_BUNDLE is set after registering the
ring, then the kernel supports bundles for recv and send.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  15 +++--
 io_uring/io_uring.c           |   3 +-
 io_uring/net.c                | 116 ++++++++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7f583927c908..f093cb2300d9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -352,13 +352,13 @@ enum io_uring_op {
  *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
  *				(at least partially).
  *
- * IORING_RECVSEND_BUNDLE	Used with IOSQE_BUFFER_SELECT. If set, send will
- *				grab as many buffers from the buffer group ID
- *				given and send them all. The completion result
- *				will be the number of buffers send, with the
- *				starting buffer ID in cqe->flags as per usual
- *				for provided buffer usage. The buffers will be
- *				contigious from the starting buffer ID.
+ * IORING_RECVSEND_BUNDLE	Used with IOSQE_BUFFER_SELECT. If set, send or
+ *				recv will grab as many buffers from the buffer
+ *				group ID given and send them all. The completion
+ *				result 	will be the number of buffers send, with
+ *				the starting buffer ID in cqe->flags as per
+ *				usual for provided buffer usage. The buffers
+ *				will be	contigious from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -529,6 +529,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3c9087f37c43..2675cffbd9a4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3570,7 +3570,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_RECVSEND_BUNDLE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/net.c b/io_uring/net.c
index 3e326576254b..51c41d771c50 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -747,7 +747,8 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 	return ret;
 }
 
-#define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT)
+#define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT | \
+			IORING_RECVSEND_BUNDLE)
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -761,21 +762,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
-	if (sr->flags & ~(RECVMSG_FLAGS))
+	if (sr->flags & ~RECVMSG_FLAGS)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |= REQ_F_CLEAR_POLLIN;
-	if (sr->flags & IORING_RECV_MULTISHOT) {
-		if (!(req->flags & REQ_F_BUFFER_SELECT))
-			return -EINVAL;
-		if (sr->msg_flags & MSG_WAITALL)
-			return -EINVAL;
-		if (req->opcode == IORING_OP_RECV && sr->len)
-			return -EINVAL;
-		req->flags |= REQ_F_APOLL_MULTISHOT;
+	if (req->flags & REQ_F_BUFFER_SELECT) {
 		/*
 		 * Store the buffer group for this multishot receive separately,
 		 * as if we end up doing an io-wq based issue that selects a
@@ -785,6 +779,20 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * restore it.
 		 */
 		sr->buf_group = req->buf_index;
+		req->buf_list = NULL;
+	}
+	if (sr->flags & IORING_RECV_MULTISHOT) {
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		if (sr->msg_flags & MSG_WAITALL)
+			return -EINVAL;
+		if (req->opcode == IORING_OP_RECV && sr->len)
+			return -EINVAL;
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+	}
+	if (sr->flags & IORING_RECVSEND_BUNDLE) {
+		if (req->opcode == IORING_OP_RECVMSG)
+			return -EINVAL;
 	}
 
 #ifdef CONFIG_COMPAT
@@ -805,19 +813,28 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
 				  bool mshot_finished, unsigned issue_flags)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags;
 
-	cflags = io_put_kbuf(req, issue_flags);
+	if (sr->flags & IORING_RECVSEND_BUNDLE)
+		cflags = io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret),
+				      issue_flags);
+	else
+		cflags = io_put_kbuf(req, issue_flags);
+
 	if (kmsg->msg.msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
+	/* bundle with no more immediate buffers, we're done */
+	if (sr->flags & IORING_RECVSEND_BUNDLE && req->flags & REQ_F_BL_EMPTY)
+		goto finish;
+
 	/*
 	 * Fill CQE for this receive and see if we should keep trying to
 	 * receive from this socket.
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
 	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
-		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
 		io_mshot_prep_retry(req, kmsg);
@@ -837,6 +854,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	/* Finish the request / stop multishot. */
+finish:
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)
@@ -1020,6 +1038,69 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
+			      size_t *len, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int ret;
+
+	/*
+	 * If the ring isn't locked, then don't use the peek interface
+	 * to grab multiple buffers as we will lock/unlock between
+	 * this selection and posting the buffers.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+	    sr->flags & IORING_RECVSEND_BUNDLE) {
+		struct buf_sel_arg arg = {
+			.iovs = &kmsg->fast_iov,
+			.nr_iovs = 1,
+			.mode = KBUF_MODE_EXPAND,
+		};
+
+		if (kmsg->free_iov) {
+			arg.nr_iovs = kmsg->free_iov_nr;
+			arg.iovs = kmsg->free_iov;
+			arg.mode |= KBUF_MODE_FREE;
+		}
+
+		if (kmsg->msg.msg_inq > 0)
+			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
+
+		ret = io_buffers_peek(req, &arg);
+		if (unlikely(ret < 0))
+			return ret;
+
+		/* special case 1 vec, can be a fast path */
+		if (ret == 1) {
+			sr->buf = arg.iovs[0].iov_base;
+			sr->len = arg.iovs[0].iov_len;
+			goto map_ubuf;
+		}
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
+				arg.out_len);
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+			kmsg->free_iov_nr = ret;
+			kmsg->free_iov = arg.iovs;
+		}
+	} else {
+		void __user *buf;
+
+		*len = sr->len;
+		buf = io_buffer_select(req, len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		sr->buf = buf;
+		sr->len = *len;
+map_ubuf:
+		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
+				  &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return 0;
+}
+
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -1044,17 +1125,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		void __user *buf;
-
-		buf = io_buffer_select(req, &len, issue_flags);
-		if (!buf)
-			return -ENOBUFS;
-		sr->buf = buf;
-		sr->len = len;
-		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
-				  &kmsg->msg.msg_iter);
+		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
 		if (unlikely(ret))
 			goto out_free;
+		sr->buf = NULL;
 	}
 
 	kmsg->msg.msg_inq = -1;
-- 
2.43.0


