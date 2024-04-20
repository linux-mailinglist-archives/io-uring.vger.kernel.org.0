Return-Path: <io-uring+bounces-1601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A088ABBBD
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47A041C20987
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0971D680;
	Sat, 20 Apr 2024 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eOBXJQK/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A12F168DC
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619980; cv=none; b=Xsk8madW2iZlenqj1B045kqDUaUt//NgjvMa2FBwQkEPQ4lqTKHzNX5DWQySgsZ9C0CGubXGlogwgY2kmJMq/EXQrf1aKFYfTkKkuXbhXvXoDpBHV2pSXsxhc6WSjQKdR5Z9YevOllHH9eqeKAgnccOZU37Uf9+ni98VefzEk5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619980; c=relaxed/simple;
	bh=cYya2fnpl8JJZQozQ8SNJnqY12zRBXux2HWOKUgYteA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o31C2Uboxk1UdFCmWG6DTi9lr6TFAxfIWs0w8CYmf9Z22JxETaS3yV077J41v9qsWXrfb7xuOmtvGKIliBdjjpjEo6Frk0yZ+AOMlmdinxV6+l+JV8NiE1c1+La2pESsM5oGMB4xsV5gm0H4KYBAYrH8zLCSje6rRIYRq9tD+bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eOBXJQK/; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-36b2e3b1f34so226615ab.3
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619977; x=1714224777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aPxa/LSmY4yNZ59jGCA1Lruzf3dDnvJMOq+tmBjLZU=;
        b=eOBXJQK/wlRWRtcyPyvuhuZ1qLKQUN6cKf9B+Je3mK9B75dNwYiIVhUj68W5TsFO44
         lPkOwH+Q+ESD25j4ASBJNnRs49ZAjrBKD5qFkva7gZkuMgpD4QN6nMUplsV3QBzHfBNK
         6Co1p5IGF+LmbWuLhPYBo7hX899PM1+xBnyKMIkVZpRvMciTpdz5LI1GJ3p5HeWbJVks
         QTH7hLer5IasbRIXZN/PRdeD0Evb0nIE2wLbDr+5WskEpzqLLuTYFVZOpHwGF0wcBMsl
         wraPwD/tVjcEZSHRVl44fdxAkwJRfp+8sVa6pqZA1moYcnM4v+gSUHKIcOEUmjOcaaeV
         ICkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619977; x=1714224777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aPxa/LSmY4yNZ59jGCA1Lruzf3dDnvJMOq+tmBjLZU=;
        b=bCfGxYrMgvabjm3hO9ODn/WiZ+5OLpOrGPa6ZNQgRvlV3tIdjUbOmy4mkgAGN3l4wU
         LToKHJTl6bqgArhluuYeXDV+zqw2QAhiLEeRIOlSEZZBoiNDvVWDM4lEHY6vg81aTtR+
         09g71ScUSHD3W6Wj57e3nWH+UzotdSqzcxHG6BAXzZsJg/8AS+d5qyUHobheo2t+JMDH
         w8/iA1J9+bQWV6DhkjcoEGv30FeX35EUEEV5hnHwEmIALOpUiOUrlcxs3RPuX+tB2Hli
         vx4YI/myI4G0HAprXj6sRVyo3HUpuEDsTIij4NEvqB1bjqv4KAjmbo37AmV5rux0nQ0j
         M4uw==
X-Gm-Message-State: AOJu0YxAZ8vq25MXzgAWC56qaNtV+NzOSoaKtFm8UTM7AT5rVw8F0s8G
	dS+/jlGogo3fmB8OY0bcXBk25eO1olE0K6UVje/vJ8NnSrMZJnXzOE6g8mcBkqUjdlCqSwIssps
	x
X-Google-Smtp-Source: AGHT+IFdHgvO5sTfWScobAo2iiKU4eVtXXsJHY4u8/kleAykkjxtzYd+qYSY5JXS3JLjCNIzcgSzHg==
X-Received: by 2002:a92:c241:0:b0:36b:2a68:d7ee with SMTP id k1-20020a92c241000000b0036b2a68d7eemr6158301ilo.1.1713619976912;
        Sat, 20 Apr 2024 06:32:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/net: support bundles for send
Date: Sat, 20 Apr 2024 07:29:46 -0600
Message-ID: <20240420133233.500590-6-axboe@kernel.dk>
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

If IORING_OP_SEND is used with provided buffers, the caller may also
set IORING_RECVSEND_BUNDLE to turn it into a multi-buffer send. The idea
is that an application can fill outgoing buffers in a provided buffer
group, and then arm a single send that will service them all. Once
there are no more buffers to send, or if the requested length has
been sent, the request posts a single completion for all the buffers.

This only enables it for IORING_OP_SEND, IORING_OP_SENDMSG is coming
in a separate patch. However, this patch does do a lot of the prep
work that makes wiring up the sendmsg variant pretty trivial. They
share the prep side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   9 +++
 io_uring/net.c                | 145 ++++++++++++++++++++++++++++++----
 2 files changed, 137 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a7f847543a7f..7f583927c908 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -351,11 +351,20 @@ enum io_uring_op {
  *				0 is reported if zerocopy was actually possible.
  *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
  *				(at least partially).
+ *
+ * IORING_RECVSEND_BUNDLE	Used with IOSQE_BUFFER_SELECT. If set, send will
+ *				grab as many buffers from the buffer group ID
+ *				given and send them all. The completion result
+ *				will be the number of buffers send, with the
+ *				starting buffer ID in cqe->flags as per usual
+ *				for provided buffer usage. The buffers will be
+ *				contigious from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
+#define IORING_RECVSEND_BUNDLE		(1U << 4)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index 13685d133582..3e326576254b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -57,7 +57,7 @@ struct io_sr_msg {
 		struct user_msghdr __user	*umsg;
 		void __user			*buf;
 	};
-	unsigned			len;
+	int				len;
 	unsigned			done_io;
 	unsigned			msg_flags;
 	unsigned			nr_multishot_loops;
@@ -389,6 +389,8 @@ static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
 	return ret;
 }
 
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
+
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -407,11 +409,20 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
-	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+	if (sr->flags & IORING_RECVSEND_BUNDLE) {
+		if (req->opcode == IORING_OP_SENDMSG)
+			return -EINVAL;
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		sr->msg_flags |= MSG_WAITALL;
+		sr->buf_group = req->buf_index;
+		req->buf_list = NULL;
+	}
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -427,6 +438,79 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 	io_netmsg_recycle(req, issue_flags);
 }
 
+/*
+ * For bundle completions, we need to figure out how many segments we consumed.
+ * A bundle could be using a single ITER_UBUF if that's all we mapped, or it
+ * could be using an ITER_IOVEC. If the latter, then if we consumed all of
+ * the segments, then it's a trivial questiont o answer. If we have residual
+ * data in the iter, then loop the segments to figure out how much we
+ * transferred.
+ */
+static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
+{
+	struct iovec *iov;
+	int nbufs;
+
+	/* no data is always zero segments, and a ubuf is always 1 segment */
+	if (ret <= 0)
+		return 0;
+	if (iter_is_ubuf(&kmsg->msg.msg_iter))
+		return 1;
+
+	iov = kmsg->free_iov;
+	if (!iov)
+		iov = &kmsg->fast_iov;
+
+	/* if all data was transferred, it's basic pointer math */
+	if (!iov_iter_count(&kmsg->msg.msg_iter))
+		return iter_iov(&kmsg->msg.msg_iter) - iov;
+
+	/* short transfer, count segments */
+	nbufs = 0;
+	do {
+		int this_len = min_t(int, iov[nbufs].iov_len, ret);
+
+		nbufs++;
+		ret -= this_len;
+	} while (ret);
+
+	return nbufs;
+}
+
+static inline bool io_send_finish(struct io_kiocb *req, int *ret,
+				  struct io_async_msghdr *kmsg,
+				  unsigned issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	bool bundle_finished = *ret <= 0;
+	unsigned int cflags;
+
+	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
+		cflags = io_put_kbuf(req, issue_flags);
+		goto finish;
+	}
+
+	cflags = io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret), issue_flags);
+
+	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
+		goto finish;
+
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
+		io_mshot_prep_retry(req, kmsg);
+		return false;
+	}
+
+	/* Otherwise stop bundle and use the current result. */
+finish:
+	io_req_set_res(req, *ret, cflags);
+	*ret = IOU_OK;
+	return true;
+}
+
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -482,7 +566,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -495,21 +578,47 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
+retry_bundle:
 	if (io_do_buffer_select(req)) {
-		size_t len = sr->len;
-		void __user *buf;
+		struct buf_sel_arg arg = {
+			.iovs = &kmsg->fast_iov,
+			.max_len = min_not_zero(sr->len, INT_MAX),
+			.nr_iovs = 1,
+			.mode = KBUF_MODE_EXPAND,
+		};
+
+		if (kmsg->free_iov) {
+			arg.nr_iovs = kmsg->free_iov_nr;
+			arg.iovs = kmsg->free_iov;
+			arg.mode |= KBUF_MODE_FREE;
+		}
 
-		buf = io_buffer_select(req, &len, issue_flags);
-		if (unlikely(!buf))
-			return -ENOBUFS;
-		sr->buf = buf;
-		sr->len = len;
+		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
+			arg.nr_iovs = 1;
+
+		ret = io_buffers_select(req, &arg, issue_flags);
+		if (unlikely(ret < 0))
+			return ret;
+
+		sr->len = arg.out_len;
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE, arg.iovs, ret,
+				arg.out_len);
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+			kmsg->free_iov_nr = ret;
+			kmsg->free_iov = arg.iovs;
+		}
 	}
 
-	flags = sr->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+	/*
+	 * If MSG_WAITALL is set, or this is a bundle send, then we need
+	 * the full amount. If just bundle is set, if we do a short send
+	 * then we complete the bundle sequence rather than continue on.
+	 */
+	if (flags & MSG_WAITALL || sr->flags & IORING_RECVSEND_BUNDLE)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
@@ -534,10 +643,12 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
+
+	if (!io_send_finish(req, &ret, kmsg, issue_flags))
+		goto retry_bundle;
+
 	io_req_msg_cleanup(req, issue_flags);
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	return ret;
 }
 
 static int io_recvmsg_mshot_prep(struct io_kiocb *req,
-- 
2.43.0


