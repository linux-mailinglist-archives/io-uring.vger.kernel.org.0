Return-Path: <io-uring+bounces-8617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD860AFCDF8
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 16:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD481188739C
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 14:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F306F2E041C;
	Tue,  8 Jul 2025 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JMYlcHjD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011C22DF3F9
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985556; cv=none; b=fFgnS/0e3zAFblYsmdEU7hYzmh5boTCVhOfmeCge6VP+VHPMrYBsL0m7oHTOQgu6bv9HFYpfhMot3TjUu07FTKajPGenryNZjWjkecMoJnKdthB5n2r3QSWeRIfgeOmaWQsyiaBHTtqBAn7MTtPZpe9MrsJwZ0VbR3lL0ycon1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985556; c=relaxed/simple;
	bh=2j1zLmEy/NnkXPYEWIHNmK3kGhmgef9bfK5ol/Zxijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z76QMMzCjmXID1ZG+SNCxi4ZjSJtGZXiF8avSlJZ7xau1eBYnUlkEJrwMZib15Hjj5wVi6GhmgMOp4PQCSEltgpsU4rRRoMFatmAUHUpz3BpJqhqtgaL9ZuTVw0oDZfA4mAM7Hv1o+WGjzt3kMeeP0OOAdD2sUwgfWAMK8GNuac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JMYlcHjD; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3e058e82584so40213965ab.2
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 07:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751985552; x=1752590352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EfX3T1uAHIwWZdbRKKci3AdqUBDNUEKUZwTSx/RaX0=;
        b=JMYlcHjDTtLsZ0Kay9X/FrqVXywc8TG1D0WtSjGi6n0f/bGJM5jt7r91OMyZPE40Qz
         aXNQlW8361lqMv0XSv9fUo7U9JSCLB1tNF7Lps+v7fkenfp9owvEGVaSQyRvYIWAl0ow
         OAjO57eRFSM9h0ONNoMmDRrSAaaZI1LPdhgYpCXHt2q6avMOBx3hnyjwEC4l7ooA9dmP
         TnMsdJ/90IArbf3b1fbdBODfUPaR0tkUpVpg2XcmMZnI/PvpN12Zngr4Srmtc56QzuQn
         nEwWSck1zf7FPlMwZwbPcruxNpTQBDLg4gGZgJZjWwa94FzJFQ5i4BgjCrwH/LZe10su
         Fy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985552; x=1752590352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EfX3T1uAHIwWZdbRKKci3AdqUBDNUEKUZwTSx/RaX0=;
        b=GM04QEF6W2f51PZZlFDXk4j1jEn1cf3OrvkPfSZip0X6tcwAU/oCPiLTrl4KloX+nj
         PbaxQ/rcmNNb3sMbzDrLiKjFaRm7CaX4AkKC65TQ1ODnR0bTGFj724TsCJrkd/AKmJCG
         4jBjZS4B51MbKxFiFg3p6oTFB/GxbbiRgPcZFQ65AdnMpeTK62UV94MJ1PqwM07W/gyv
         //ETaNdxr2ANAGEJVteZNrcB7AhbPjglaiIhVJbukjlKqBFDF5dPQC/CAysjM9ebKQD1
         MkwGZqcu/r45aTp7VBeNs4W3SWosgpXybZc80p+UdBS3fc1P3/WyXitKCTYKrWrJfsyj
         WLQQ==
X-Gm-Message-State: AOJu0YyFawF0ECgbk6N735g9k82E5ZaZWuYDOwEdiepFdCG2skArEb5R
	HC2w2rImH9ZMJYIbrgQSz6c4Z1eT6m3zz07CdRS+pJI08izy6ZDIj3WjAVY+FBmAKzdes+QFeT7
	JsopV
X-Gm-Gg: ASbGncsoqwHBiYrN9TrB2rRpcVDuEvpGbZze+/UgyN4uLdVSKCWkzhStVZ2VcmP0n4V
	BnhUQJBvAkDn98QMxFyblZRASHvqD27Mdm2VUBgs3d23RpvPvtK7mcNhTrdedwcHaO3xNLr2HzJ
	UL1+fS+3ZZpEbfDZEfFiAa19Zrxh0iDTJzyHQCRr9g3LdcjaHIigu3PWzg4OzPk2S7inL2ywnBm
	t4OowcH1wbwvFuto8YmGCWbwIbiX6sw/u/oCVd2t2hZ+tbLuzGp0rgT9ylAOkfKrSDQKtcx9+AB
	nhIJrxlZBlU5vcvs1g5Mq7moKrYH69fJ4xDAkJO/QgXiJA==
X-Google-Smtp-Source: AGHT+IETcLiGQk69kapDFoz5GxfupK4EueOEgU92wkwEVuVtpWdhc7n0O+o8iFUB/SeE+ucrZfkNIg==
X-Received: by 2002:a05:6e02:228f:b0:3dc:79e5:e696 with SMTP id e9e14a558f8ab-3e154e4bdd8mr27663595ab.11.1751985552386;
        Tue, 08 Jul 2025 07:39:12 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5053aa4e546sm166739173.134.2025.07.08.07.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:39:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: allow multishot receive per-invocation cap
Date: Tue,  8 Jul 2025 08:26:55 -0600
Message-ID: <20250708143905.1114743-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708143905.1114743-1-axboe@kernel.dk>
References: <20250708143905.1114743-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an application is handling multiple receive streams using recv
multishot, then the amount of retries and buffer peeking for multishot
and bundles can process too much per socket before moving on. This isn't
directly controllable by the application. By default, io_uring will
retry a recv MULTISHOT_MAX_RETRY (32) times, if the socket keeps having
data to receive. And if using bundles, then each bundle peek will
potentially map up to PEEK_MAX_IMPORT (256) iovecs of data. Once these
limits are hit, then a requeue operation will be done, where the request
will get retried after other pending requests have had a time to get
executed.

Add support for capping the per-invocation receive length, before a
requeue condition is considered for each receive. This is done by setting
sqe->mshot_len to the byte value. For example, if this is set to 1024,
then each receive will be requeued by 1024 bytes received.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 72276339e9e6..c96043c4e8ab 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,6 +75,7 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
+	unsigned			mshot_len;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -87,9 +88,11 @@ struct io_sr_msg {
 enum sr_retry_flags {
 	IORING_RECV_RETRY	= (1U << 15),
 	IORING_RECV_PARTIAL_MAP	= (1U << 14),
+	IORING_RECV_MSHOT_CAP	= (1U << 13),
 
 	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
-	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
+	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP |
+				  IORING_RECV_MSHOT_CAP,
 };
 
 /*
@@ -202,7 +205,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->flags &= ~IORING_RECV_RETRY_CLEAR;
-	sr->len = 0; /* get from the provided buffer */
+	sr->len = sr->mshot_len;
 }
 
 static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg,
@@ -790,13 +793,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
+	sr->mshot_len = 0;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
 			return -EINVAL;
-		if (req->opcode == IORING_OP_RECV && sr->len)
-			return -EINVAL;
+		if (req->opcode == IORING_OP_RECV)
+			sr->mshot_len = sr->len;
 		req->flags |= REQ_F_APOLL_MULTISHOT;
 	}
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
@@ -837,6 +841,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				      issue_flags);
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
+		if (sr->mshot_len && *ret >= sr->mshot_len)
+			sr->flags |= IORING_RECV_MSHOT_CAP;
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
@@ -867,10 +873,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
-			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
+			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY &&
+			    !(sr->flags & IORING_RECV_MSHOT_CAP)) {
 				return false;
+			}
 			/* mshot retries exceeded, force a requeue */
 			sr->nr_multishot_loops = 0;
+			sr->flags &= ~IORING_RECV_MSHOT_CAP;
 			if (issue_flags & IO_URING_F_MULTISHOT)
 				*ret = IOU_REQUEUE;
 		}
@@ -1083,7 +1092,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 1)
+		if (*len)
+			arg.max_len = *len;
+		else if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(*len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);
-- 
2.50.0


