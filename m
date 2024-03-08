Return-Path: <io-uring+bounces-880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 408A2876E02
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB28E283A28
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65BD3BBDF;
	Fri,  8 Mar 2024 23:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NKQaJGor"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A223D0C6
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941867; cv=none; b=d6W1DTIApEx47T7FW9XMwYzXL2pF71Ysy6hxcYGoVQws8uofkwvdz1q4SBmNA7+yFmpe9RWx6/+5frXqyxlErU+otUyZPB57HcP161p9sNepIngZrWqea/SQK/QtmI6VO1U7CyfWEINa6u71cqu3FWDqJ851GGO0NU2N5rQxgIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941867; c=relaxed/simple;
	bh=h34qolhJ4ag202048Q5TTCRyB4jy431LjVCEGGbPAsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXvegJ1FZDNknXRwZBz+2bUvK1hZzjr/6zzcI95cZRsHSMfRQlZITt6i3jZvcHvlczfjEnLlRdTNskeSV931uXgnsDQXlj8wisnIAvoX6lD3hjunTq/lNwQ1Xps0sXRMNnCMWCZTczFTnnZL/4/abea8bRjiGYfXtx6Zg75IFUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NKQaJGor; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c495be1924so38308139f.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941864; x=1710546664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpdR4+HAExoO+9KRr8x0nArtDVP0MJit8Bxe9BBdbrY=;
        b=NKQaJGorB+ImO108bJHXsm8zege1rWra1ilF8XIzjdcEl9nGm9xJALlxfLceK8LmRA
         XJQKVbdJm04P11hVz7n3hLB+qXCEZL2RsTrkJ9u8vv0E+fTK/SqNTm+aT5vjgAVSAByP
         hAXilTwWDURA5xKyRvXdCmV5EUByulHXT/Up1NznxRxWovWEn6IiTZFGpjw7qiQZQ/fK
         QuY/ZJ4L6k9SZN/fmLWkBHtj8QTA3OEs5NHnTmbt+scrl2GG7J3vCc3sQYcfEU7TNRnp
         G5sMDlneM8l/79osvLweIIt+wFiNZ10Um70jTz5v7BlA5yfy72C3SW7CP7FNvlGLwtLj
         F0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941864; x=1710546664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpdR4+HAExoO+9KRr8x0nArtDVP0MJit8Bxe9BBdbrY=;
        b=E3O1a3YHhwlawv/k0JzANJQ/kxNiqALatwC7ZReRDy+lo934hh8bwtbCbvI6+wdNaf
         9P5/BEgrn6lIKgTtKT3LGLD8d3mxVMbubLN7MNIu/rsCSogIj/DlsBAkhliFhYmsxe+x
         CoUsB/qAPVNaRP8RbggbWLazRhCjJmWqy0RVpLxHccKkOhczQW+EGy3Cr3jmLas42UT9
         ywlQWvZ8nEi4ruaJ7oUKpeGUV3gwscHfnxnIEezii1C8PUHEE36Asxa0zyqhZKwQbIZb
         4vxhh1YCjxlJf9Xu4i78IyJrA/w8qNobxpPLZj7CTd1zfbTVB7UASj44396VJ4FQ5pvs
         /9Vw==
X-Gm-Message-State: AOJu0YwXSy6bxmLk/TaFVoWdtBn5vxXIcrvxusHTj3FhpvYMM1pX5SSx
	3lM54CEjYoakGJEVwtfMsZrKWgQvgbLkVdks0QqJFZ4e5LR41+HnIO6JxJuD/oTSS5hKxMkt63h
	N
X-Google-Smtp-Source: AGHT+IF//929OIuifoKtd8DGkPMLmIyS4eQzyLQa9+7ifOJ82aa8E9JAk5ZalQqiaa+9NK2LL+MkbA==
X-Received: by 2002:a5e:df01:0:b0:7c8:6f1f:d44 with SMTP id f1-20020a5edf01000000b007c86f1f0d44mr509633ioq.1.1709941864553;
        Fri, 08 Mar 2024 15:51:04 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:51:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring/net: support bundles for recv
Date: Fri,  8 Mar 2024 16:34:12 -0700
Message-ID: <20240308235045.1014125-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240308235045.1014125-1-axboe@kernel.dk>
References: <20240308235045.1014125-1-axboe@kernel.dk>
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
 io_uring/net.c                | 119 ++++++++++++++++++++++++++--------
 3 files changed, 101 insertions(+), 36 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3a0ff6da35de..9cf6c45149dd 100644
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
@@ -531,6 +531,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf348c33f485..112c21053e6f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3982,7 +3982,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_RECVSEND_BUNDLE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/net.c b/io_uring/net.c
index 07831e764068..c671ecb5b849 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -760,7 +760,8 @@ int io_recvmsg_prep_async(struct io_kiocb *req)
 	return ret;
 }
 
-#define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT)
+#define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT | \
+			IORING_RECVSEND_BUNDLE)
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -774,21 +775,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -798,6 +792,20 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -818,12 +826,22 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
@@ -831,14 +849,18 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
 	    io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
 				*ret, cflags | IORING_CQE_F_MORE)) {
-		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
 		io_mshot_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
-			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
+			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY) {
+				if (kmsg->free_iov) {
+					kfree(kmsg->free_iov);
+					kmsg->free_iov = NULL;
+				}
 				return false;
+			}
 			/* mshot retries exceeded, force a requeue */
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
@@ -851,6 +873,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	/* Finish the request / stop multishot. */
+finish:
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)
@@ -1048,6 +1071,58 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
+		struct iovec *iov = kmsg->fast_iov;
+
+		*len = 0;
+		if (kmsg->msg.msg_inq > 0) {
+			*len = kmsg->msg.msg_inq;
+			if (sr->len && *len > sr->len)
+				*len = sr->len;
+		}
+		ret = io_buffers_peek(req, &iov, ARRAY_SIZE(kmsg->fast_iov), len);
+		if (unlikely(ret < 0))
+			return ret;
+
+		if (ret == 1) {
+			sr->buf = iov->iov_base;
+			sr->len = iov->iov_len;
+			goto ubuf;
+		}
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, iov, ret, *len);
+		if (iov != kmsg->fast_iov)
+			kmsg->free_iov = iov;
+	} else {
+		void __user *buf;
+
+		*len = sr->len;
+		buf = io_buffer_select(req, len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		sr->buf = buf;
+		sr->len = *len;
+ubuf:
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
@@ -1093,17 +1168,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -1143,13 +1211,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags)) {
-		if (kmsg->free_iov) {
-			kfree(kmsg->free_iov);
-			kmsg->free_iov = NULL;
-		}
+	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
 		goto retry_multishot;
-	}
 
 	io_req_msg_cleanup(req, kmsg, issue_flags);
 	return ret;
-- 
2.43.0


