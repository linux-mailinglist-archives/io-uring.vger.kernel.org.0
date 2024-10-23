Return-Path: <io-uring+bounces-3956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E579ACFEA
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03DE3282B2A
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1895113B792;
	Wed, 23 Oct 2024 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0S/Xifnu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594971CBE8F
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700137; cv=none; b=eHxilNSiWue8qCIJr4ZkaIDoUwSvgVPL9Q2BCamNOsQFgSEU8NnCHcap+wlz6Q3d7qBkzpg/TJIVtsv+loPdAzJNQX+mBp/F6HM80Mm4oep7i3IG0SZWucQS4XVbre3S7lZWLagLQuMfPdd99DidcIzwpWiKN5eMc8aYGxnFypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700137; c=relaxed/simple;
	bh=Uqwki1LuUEifgHw2K0BHZmq0KvpknnbwvrTuucKTFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aohG4iItAmVPia+vVVoW5ue/fzvNPeFTLmBw5WtfULlkMNJorQPfhfLxIpWkvcTQ68Ow+xJMAvIFM2jGJz7HltrEHlOyTTy7oV97B/YmnHLgGq3fdmkA0TS2Tto6PD7IOiAyothAX9oo3a0PWWYT2WbDphkTC3LOEeAEEXKamY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0S/Xifnu; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83ac817aac3so171897839f.0
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700134; x=1730304934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXtdybHKthx98tLnmZIwgxVHacDnHFHxsladV/YkWd8=;
        b=0S/XifnuEU2Q8H/wEp4nq5/G5VztuzzmReqJFK9Hpc5glWvJNCQNg5IySQxbcO0XI6
         EP9IgbVKcGDxM+3CrlDgD0kyhY4vTL6plIDQXHxMtPuFjONcZ1LX9Ue6QIbyZ3AySlLi
         UtHCQHuq8kGNM0IGCUPfotoRyM3wmA1BqnW4a7WbnH0A78Ff6AsSULYchXYUkVf4zyt2
         98Pb6lBsL0C81Uyhl9pHSJ/IlhT4bxbRj1IkGlzQALdh62lz+WQpSM25sRIu7A6Q8fqj
         5Dd3x7AarRXbsH/rYVttYF6UhtL4WcqSsaNBp9TN6ngYWjdHPPm69bNctd753ty8ESdk
         2Bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700134; x=1730304934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CXtdybHKthx98tLnmZIwgxVHacDnHFHxsladV/YkWd8=;
        b=xG/S/ouytTp2nlk3TEZck9TewGMy9Nf/7c6cmBAfvzFXSGARCcVNZd05xrqRPKPARG
         UCz114okOzVvBwNmEwuGUyipWfIdCmob1suKTvApNPOPsKUqnKEIEnGjM8GkLZNCAMXq
         tq2OBa1qORXKSv2vHiOPZVjX3vWoZ/IoZNnBtI+uyQqhKm9e6uiYsquuUGAon23mXlCE
         6cNuyBufI5fMkb39CjfUynpWjmyZfBzDP9nK1yVjzqMlzMoTFRJqZz3W3zxDQ+PfMoCg
         MnsgFTfDabe72RgWPfwwtD0eGQ+/hcJe6qxmIHend3p1hruld7nkDo5hYXBhQjktgC+s
         XBqg==
X-Gm-Message-State: AOJu0Yzt/QDaQNhjgqF0rMWe9eDa4jGZjt9NUFZjPSK1NnTxAX0VUQev
	h3h02iqxQH0LTcJu9JktzEEU/R2ueIOy6OZNjxGYz68ndVIMgVZUd/eShECcm7C2KqBP3capPZv
	9
X-Google-Smtp-Source: AGHT+IEKCM/588BO9fNZE0ipi0WMXOQlC9giondG4Enc3gQp6KnI8hjxhZE668FiCFEtJANLnABguQ==
X-Received: by 2002:a05:6602:1603:b0:83a:a25a:cfaf with SMTP id ca18e2360f4ac-83af6155756mr303252739f.3.1729700133630;
        Wed, 23 Oct 2024 09:15:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring/net: add provided buffer and bundle support to send zc
Date: Wed, 23 Oct 2024 10:07:40 -0600
Message-ID: <20241023161522.1126423-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provided buffers inform the kernel which buffer group ID to pick a
buffer from for transfer. Normally that buffer contains the usual
addr + length information, as well as a buffer ID that is passed back
at completion time to inform the application of which buffer was used
for the transfer.

However, if registered and provided buffers are combined, then the
provided buffer must instead tell the kernel which registered buffer
index should be used, and the length/offset within that buffer. Rather
than store the addr + length, the application must instead store this
information instead.

If provided buffers are used with send zc, then those buffers must be
an index into a registered buffer. Change the mapping type to use
KBUF_MODE_BVEC, which tells the kbuf handlers to turn the mappings
into bio_vecs rather than iovecs. Then all that is needed is to
setup our iov_iterator to use iov_iter_bvec().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 64 +++++++++++++++++++++++++++++++++---------------
 io_uring/net.h   | 10 ++++++--
 io_uring/opdef.c |  1 +
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 154756762a46..c062b1c685bd 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -83,6 +83,8 @@ struct io_sr_msg {
 
 static int io_sg_from_iter(struct sk_buff *skb, struct iov_iter *from,
 			   size_t length);
+static int io_sg_from_iter_iovec(struct sk_buff *skb, struct iov_iter *from,
+				 size_t length);
 
 /*
  * Number of times we'll try and do receives if there's more data. If we
@@ -581,33 +583,34 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-static int io_send_zc_import_single(struct io_kiocb *req,
-				    unsigned int issue_flags)
+static int __io_send_zc_import(struct io_kiocb *req,
+			       struct io_async_msghdr *kmsg, int nsegs)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_mapped_ubuf *imu;
 	int ret;
 	u16 idx;
 
-	ret = -EFAULT;
-	io_ring_submit_lock(ctx, issue_flags);
-	if (sr->buf_index < ctx->nr_user_bufs) {
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		struct bio_vec *bv = kmsg->free_bvec ?: &kmsg->fast_bvec;
+
+		WARN_ON_ONCE(bv == &kmsg->fast_bvec && nsegs > 1);
+		iov_iter_bvec(&kmsg->msg.msg_iter, ITER_SOURCE, bv, nsegs, sr->len);
+	} else {
+		if (WARN_ON_ONCE(nsegs != 1))
+			return -EFAULT;
+		if (unlikely(sr->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
 		idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
 		imu = READ_ONCE(ctx->user_bufs[idx]);
-		io_req_set_rsrc_node(sr->notif, ctx);
-		ret = 0;
-	}
-	io_ring_submit_unlock(ctx, issue_flags);
 
-	if (unlikely(ret))
-		return ret;
+		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
+					(u64)(uintptr_t)sr->buf, sr->len);
+		if (unlikely(ret))
+			return ret;
+	}
 
-	ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
-				(u64)(uintptr_t)sr->buf, sr->len);
-	if (unlikely(ret))
-		return ret;
 	kmsg->msg.sg_from_iter = io_sg_from_iter;
 	return 0;
 }
@@ -619,6 +622,16 @@ static int __io_send_import(struct io_kiocb *req, struct buf_sel_arg *arg,
 	struct io_async_msghdr *kmsg = req->async_data;
 	int ret = nsegs;
 
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		io_ring_submit_lock(req->ctx, issue_flags);
+		io_req_set_rsrc_node(sr->notif, req->ctx);
+		ret = __io_send_zc_import(req, kmsg, nsegs);
+		io_ring_submit_unlock(req->ctx, issue_flags);
+		if (unlikely(ret < 0))
+			return ret;
+		return nsegs;
+	}
+
 	if (nsegs == 1) {
 		sr->buf = arg->iovs[0].iov_base;
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
@@ -646,10 +659,13 @@ static int io_send_import(struct io_kiocb *req, unsigned int issue_flags)
 			.nr_vecs = 1,
 		};
 
+		if (sr->flags & IORING_RECVSEND_FIXED_BUF)
+			arg.mode |= KBUF_MODE_BVEC;
+
 		if (kmsg->free_iov) {
 			arg.nr_vecs = kmsg->free_iov_nr;
 			arg.iovs = kmsg->free_iov;
-			arg.mode = KBUF_MODE_FREE;
+			arg.mode |= KBUF_MODE_FREE;
 		}
 
 		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
@@ -1280,7 +1296,8 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 	}
 }
 
-#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
+#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | \
+			    IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_BUNDLE)
 #define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
 
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1399,8 +1416,13 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
+	ret = io_send_import(req, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return 0;
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF)
-		return io_send_zc_import_single(req, issue_flags);
+		return __io_send_zc_import(req, kmsg, 1);
 
 	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 	if (unlikely(ret))
@@ -1416,6 +1438,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	unsigned int cflags;
 	struct socket *sock;
 	unsigned msg_flags;
 	int ret, min_ret = 0;
@@ -1476,7 +1499,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		io_notif_flush(zc->notif);
 		io_req_msg_cleanup(req, 0);
 	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
+	cflags = io_put_kbuf(req, ret, issue_flags);
+	io_req_set_res(req, ret, cflags | IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 52bfee05f06a..e052762cf85d 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,9 +5,15 @@
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
-	struct iovec			fast_iov;
+	union {
+		struct iovec		fast_iov;
+		struct bio_vec		fast_bvec;
+	};
 	/* points to an allocated iov, if NULL we use fast_iov instead */
-	struct iovec			*free_iov;
+	union {
+		struct iovec		*free_iov;
+		struct bio_vec		*free_bvec;
+	};
 	int				free_iov_nr;
 	int				namelen;
 	__kernel_size_t			controllen;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ff..6203a7dd5052 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -422,6 +422,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 #if defined(CONFIG_NET)
-- 
2.45.2


