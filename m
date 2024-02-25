Return-Path: <io-uring+bounces-707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8102D862899
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 421E7281D63
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81F77FD;
	Sun, 25 Feb 2024 00:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JTVekTyI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35BE1113
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821598; cv=none; b=A3AR8vnGYs5Dd5oSPfECUbN+tuUC1h1qc1jPb0c5zoN81sLex7uzEV8LB4BXvgD6N2NdLfisq1AZIlmouXdd8U1OTXDN5U56soXuDwUxwXKrUN3RBlIuF0oYmJg7WYd8XcM08MSHtlaXUueXuP1AhTsG9KZvNySCNYMST8j3cMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821598; c=relaxed/simple;
	bh=Bf1KrOzbD/EJPal5T4Nb2NAmhQ56nL/WYBD96g0Ps5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz2mPxx/kcuN2Hqr96J2s/AN2goFyDLaon3lIrh8xKtrQ6IMQItbMSE3DGG5TWYbhRNEeisvpiOyquUNsovM3lrgjyGuvVr9Kr10pLgeyhO6Y0YGmj9T0wNhN7BrS78+czainNMuh1bqa6WwjTXJ4/scmBzgDmyZKVfIAskb4zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JTVekTyI; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e50c36a08cso544b3a.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821595; x=1709426395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lwWlvBNSsBfW5G92Au6ltP4hlZyM4QgGqnUIJdx9PlE=;
        b=JTVekTyIbvGnTOjLBBVV02Uru3f5cs/levZrKiL6CRaI4Am46G4PphWPKs5EBPmoc0
         p902H8d4GiTo1v0eWUTump5ctiVWIQfDDSHAZu0e8R9UlWnZrGArvuczMo4YCjeU99kI
         Vi/nbsf9bcAriHLvQIPgxo9c1m5LdiEgUNyGFSu3gRlBM9rwIQwHH8R557ceYbK83BCZ
         4xPlzoYVegdqyVeJQM8oqgc6OKxFlk/EJhgt0W5s8g1X648PzMRa8bdEl2Gq05fH2lI2
         mVUwnmB3VWauwd4B83EkB/yqiFBkpNctTL3d0MSeoUjtlnlZUKZq4hQc5wpjQem89Fac
         MJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821595; x=1709426395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lwWlvBNSsBfW5G92Au6ltP4hlZyM4QgGqnUIJdx9PlE=;
        b=S5CJeW+J7v1IC3vi0w9zkgwYUlon058UZoZSzUiTsNsgX2Mz40erXOUb3jvCiIU78n
         r7KICZg2EaMBfu/5yPqj5N/uj7MrVQBu18c49f1WoGsX626zH1lhN4ILV9qsoWrshjEh
         wEFyMPJxVMii1WR0a5M8ONYK9pQb++v5GQKP716rXjoKZH2fuRJyRZ882BHht51PpUBy
         vEM5OjO5yKkI7wrHnhgJmpoXaD1fyrQDepF1ZgZTCp31TG0j9bLX4aOSOWoCj54NtCDY
         chtNcZkL/NAZcfJqgeKhPgHNRyZ/nuf6DWuPhNJutNy40tUvln88DC29Bo7xPUgK3tEg
         YRWQ==
X-Gm-Message-State: AOJu0YyTKT8UEAzjhegjpZc4Vc9BCJt0ih8+9orQWutFnKjNIAAJi7OJ
	TFkPZ0mTbGA7oqFA9NSXKpAYqyXwQzWRqj9twaUZjzAL/P2LdBYOIW55Gb4HC2W2q1jfDwav30Q
	u
X-Google-Smtp-Source: AGHT+IFe6nlEjzl1y0QKd2HNRWG38DPLqQ1t5GGloOpxTUGeZrF1itOcNd8ousLvn7xwSMl/+fz4Rw==
X-Received: by 2002:aa7:850b:0:b0:6e5:3e:9eb8 with SMTP id v11-20020aa7850b000000b006e5003e9eb8mr1871797pfn.2.1708821595541;
        Sat, 24 Feb 2024 16:39:55 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring/net: support multishot for send
Date: Sat, 24 Feb 2024 17:35:52 -0700
Message-ID: <20240225003941.129030-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This works very much like the receive side, except for sends. The idea
is that an application can fill outgoing buffers in a provided buffer
group, and then arm a single send that will service them all. For now
this variant just terminates when we are out of buffers to send, and
hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
set, as per usual for multishot requests.

This only enables it for IORING_OP_SEND, IORING_OP_SENDMSG is coming
in a separate patch. However, this patch does do a lot of the prep
work that makes wiring up the sendmsg variant pretty trivial. They
share the prep side.

Enabling multishot for sends is, again, identical to the receive side.
The app sets IORING_SEND_MULTISHOT in sqe->ioprio. This flag is also
the same as IORING_RECV_MULTISHOT.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  8 +++
 io_uring/net.c                | 98 +++++++++++++++++++++++++++++------
 2 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 74c3afac9c63..6766e78ee03b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -351,9 +351,17 @@ enum io_uring_op {
  *				0 is reported if zerocopy was actually possible.
  *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
  *				(at least partially).
+ *
+ * IORING_SEND_MULTISHOT	Multishot send. Like the recv equivalent, must
+ *				be used with provided buffers. Keeps sending
+ *				from the given buffer group ID until it is
+ *				empty. Sets IORING_CQE_F_MORE if more
+ *				completions should be expected on behalf of
+ *				the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
+#define IORING_SEND_MULTISHOT		IORING_RECV_MULTISHOT
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 30afb394efd7..8237ac5c957f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,6 +204,16 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
+static inline void io_mshot_prep_retry(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	req->flags &= ~REQ_F_BL_EMPTY;
+	sr->done_io = 0;
+	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
+}
+
 static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
 {
 	int hdr;
@@ -401,6 +411,8 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 	kfree(io->free_iov);
 }
 
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_SEND_MULTISHOT)
+
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -417,11 +429,19 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
-	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+	if (sr->flags & IORING_SEND_MULTISHOT) {
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		if (sr->msg_flags & MSG_WAITALL)
+			return -EINVAL;
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+		sr->buf_group = req->buf_index;
+	}
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -431,6 +451,44 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static inline bool io_send_finish(struct io_kiocb *req, int *ret,
+				  struct msghdr *msg, unsigned issue_flags)
+{
+	bool mshot_finished = *ret <= 0;
+	unsigned int cflags;
+
+	cflags = io_put_kbuf(req, issue_flags);
+
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		io_req_set_res(req, *ret, cflags);
+		*ret = IOU_OK;
+		return true;
+	}
+
+	if (mshot_finished || req->flags & REQ_F_BL_EMPTY)
+		goto finish;
+
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_mshot_prep_retry(req);
+		*ret = IOU_ISSUE_SKIP_COMPLETE;
+		return false;
+	}
+
+	/* Otherwise stop multishot but use the current result. */
+finish:
+	io_req_set_res(req, *ret, cflags);
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		*ret = IOU_STOP_MULTISHOT;
+	else
+		*ret = IOU_OK;
+	return true;
+}
+
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -511,7 +569,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	size_t len = sr->len;
-	unsigned int cflags;
 	struct socket *sock;
 	struct msghdr msg;
 	unsigned flags;
@@ -542,10 +599,14 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_addr(req, &__address, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
@@ -570,8 +631,16 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (ret < min_ret) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_addr(req, &__address, issue_flags);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK)) {
+			ret = io_setup_async_addr(req, &__address, issue_flags);
+			if (ret != -EAGAIN)
+				return ret;
+			if (issue_flags & IO_URING_F_MULTISHOT) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return -EAGAIN;
+		}
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
@@ -588,9 +657,13 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
+	if (!io_send_finish(req, &ret, &msg, issue_flags))
+		goto retry_multishot;
+
+	return ret;
 }
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
@@ -654,15 +727,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-
-	sr->done_io = 0;
-	sr->len = 0; /* get from the provided buffer */
-	req->buf_index = sr->buf_group;
-}
-
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -697,7 +761,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req);
+		io_mshot_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
-- 
2.43.0


