Return-Path: <io-uring+bounces-878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD6C876E00
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EDE31C21156
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E163CF5E;
	Fri,  8 Mar 2024 23:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OADJMvA6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64E43BBCA
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941863; cv=none; b=LuCZQiLGM4cx9dVRPPMiW1RZDBjB2EQ534mQwn0dMA6LMck15nM7H5Rd+B/JX42hdrz202rwOYgKX2/+/+FimTJx9qmt5f7bPt6dmcCGfWCUXU6b5BtwDgP/fKYhxpPZ/Juy5dxX3Q7iFHL5FM+98PzF7hf+TeSQtYPGv8KA1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941863; c=relaxed/simple;
	bh=GxtwBTZAZ5a+LfAgK9eNb5MCUgijZ+0EL0RCSa0o5RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auBw1hBxHE/WyrLRUfvaQ4FI8ME3H6+77Ju4ct87MUUEjNiuuwxNA5V5NE0+cXjBcOHnmIDCl4N5RypBzu21Syc+/qan6Mi6AMO3m1X55vsTJfeosUGlZL+n+P83cEqB8/oJAM6/n8iqnzxxHFaVj82ORA1PsyI1ayY0AYfESxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OADJMvA6; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-365c0dfc769so2589465ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941860; x=1710546660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eTG0D6slRskWELPyZNsc8gGMPxr+dwKo25yPsX+MUXg=;
        b=OADJMvA6PJp95WifHw3joV2jNqM9E4NwATovRceBDla26jxp7d2RhKDDmIxZ/AYgzL
         V0Y9s6dA7BK34pyYbys/V0xT4BqJ1NBJ12WeJbMxNDCOkK/a5jqb/uNtOFnJC5beSdVS
         /LDYi3tkB03kvx2mPXakti6dYsT61BOs+FGq2fA3kbgDcGeVQ3ad2jWXRivhpzivBZzr
         UIsV45vDNcL4HLm7xZdh1VQSC/Izm0U75w1RIgMks+k9GtHk5TQGxVO4oscu0l9CZc6M
         Gvliobxa7h/uMeUCsFmEmH11TAW2QmA1EjjecoQrMKLk1q9gOdMf+syR871RnKhkJvms
         kHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941860; x=1710546660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTG0D6slRskWELPyZNsc8gGMPxr+dwKo25yPsX+MUXg=;
        b=qrouez/nkwwITWoMdQE88YL0TXfz6fGXfVmr53MOJr9GZk/ZadgOGR1G2t7HBDkELO
         sEgDM4vBRhsqnkZ11rqNfqnCw5eJ55ZBid4zJ5E/O7jgeziIq2avWGU55STC4yQ444EN
         qlYXPbSEcSlW0tKE0gS7yvD2fKftS0NA5oQnUIGECcw3xQgtFG5xg/O/Otdt92PfaF8T
         JugLvShcTxQYZ+Gw6x/wPR2GDrjdx9a4Nq26uvGhwclDYfgRevXmhUXQ5qqseu33UIaz
         714bxR8H2JEeR7HaQMbxGFS+wb9VMgIKcfmoe/Dg6N6U2wUHHvk56VBy3qoTyUEZLFaY
         9PDw==
X-Gm-Message-State: AOJu0YzDPqluH8JqorL8AIZKaQ1c7cEtqhKOM8w/0hMQ9jWGD+wKBoXQ
	XZorKXSxREkyy1BF/vxh21pYKWOH6oRKAJUL6y/AZiHNwOk3RskT/Niur/g9pZImtO5ka0iKefy
	0
X-Google-Smtp-Source: AGHT+IEofgkF0++ogPUmw+anTE/N5q9FhPp1KXbu5YU7yWPrQ/qIvtHvequRudWiU/7jmk5e0dA25Q==
X-Received: by 2002:a5d:9f1a:0:b0:7c8:7471:2f59 with SMTP id q26-20020a5d9f1a000000b007c874712f59mr477229iot.0.1709941860485;
        Fri, 08 Mar 2024 15:51:00 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring/net: support bundles for send
Date: Fri,  8 Mar 2024 16:34:10 -0700
Message-ID: <20240308235045.1014125-6-axboe@kernel.dk>
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
 io_uring/net.c                | 138 +++++++++++++++++++++++++++++-----
 2 files changed, 129 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..3a0ff6da35de 100644
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
index 66318fbba805..0c4273005a68 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -370,6 +370,8 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 	kfree(io->free_iov);
 }
 
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
+
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -388,11 +390,20 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -412,6 +423,84 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
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
+		iov = kmsg->fast_iov;
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
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_mshot_prep_retry(req);
+		if (kmsg->free_iov) {
+			kfree(kmsg->free_iov);
+			kmsg->free_iov = NULL;
+		}
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
@@ -521,9 +610,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
-	size_t len = sr->len;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -536,24 +623,37 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (IS_ERR(kmsg))
 		return PTR_ERR(kmsg);
 
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
+retry_bundle:
 	if (io_do_buffer_select(req)) {
-		void __user *buf;
+		size_t len = min_not_zero(sr->len, (unsigned) INT_MAX);
+		int max_segs = ARRAY_SIZE(kmsg->fast_iov);
 
-		buf = io_buffer_select(req, &len, issue_flags);
-		if (!buf)
-			return -ENOBUFS;
-		sr->buf = buf;
-		sr->len = len;
+		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
+			max_segs = 1;
 
-		ret = import_ubuf(ITER_SOURCE, sr->buf, len, &kmsg->msg.msg_iter);
-		if (unlikely(ret))
+		kmsg->free_iov = kmsg->fast_iov;
+		ret = io_buffers_select(req, &kmsg->free_iov, max_segs, &len,
+					issue_flags);
+		if (unlikely(ret < 0))
 			return ret;
+
+		sr->len = len;
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE, kmsg->free_iov,
+			      ret, len);
+		if (kmsg->free_iov == kmsg->fast_iov)
+			kmsg->free_iov = NULL;
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
@@ -576,10 +676,12 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
+
+	if (!io_send_finish(req, &ret, kmsg, issue_flags))
+		goto retry_bundle;
+
 	io_req_msg_cleanup(req, kmsg, issue_flags);
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	return ret;
 }
 
 static int io_recvmsg_mshot_prep(struct io_kiocb *req,
-- 
2.43.0


