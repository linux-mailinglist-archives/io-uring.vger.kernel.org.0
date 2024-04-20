Return-Path: <io-uring+bounces-1599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 547DB8ABBBE
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F24CB20E5C
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7B020309;
	Sat, 20 Apr 2024 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SCsr2RA5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87F8C10
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619976; cv=none; b=FpQg3cDyr6oBSz1tz/s3c7oit2rIF8LuA6O9LPbZrQM5geZmz86Z3HEnh23GCFkneM1uM+SpQZjvv1FEIMTfJq7Cb91eYkHDw+swsZgqUFzWXPfHRweWg3jLVMYpaVCe7kmrpvxmxaOG2RcfDEBedrVVnJUOZpza0QoqB1Dq9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619976; c=relaxed/simple;
	bh=RkrIYwPaHE2BrPfHlakApbKIr+DWF9XVaWCh9GHmgWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG6jrLJbvLKvuvCn0YhLA9hYDJviHkPbie7P5yntts0K1M4zxBQt6tcnpIB/Wi43wmr9TSEvULnnO7nN0Y8kJkcZ6ANmVH2YsYtyFfS1GpE+zrQsdUZoL59qcjgrF/UD1ROPE7dJmDOu57B9QZqPARFZdDEE8rAb3+9ZQnNklbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SCsr2RA5; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36b2e3b0ef9so288025ab.3
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619973; x=1714224773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OgX+O3/zuVrt/DBcGcP+zeMYKjKi+PDHln5LiTngIg=;
        b=SCsr2RA5sQcNZTIPu+6msryOxvNbhNJH4CR5EcoqHlYVk08hDfn4sDTjJ9guEFzaHb
         EPvCsSMLfzJ+ecFX7+PNviRw5Hs3RWRJIDig9kr4w8q+X6GfzM36LNtyooolxzJDGlJE
         mWzjYbHRNNFqVLuT5hjfntDinQnmaqsfrwd48dR4J1yK/bk1PCYIB5Ha4zP5oCrQQinM
         h/Pa1sUAuNu637bO4yhaiyas9U8DinBk7xX4Bmg4irUAT6IQpipr788XVQT/6W43xXZJ
         7/pkFBhQa84C/1y5UDV9iq7t4CB7WQltEqsbbUGyt68gInlYi130q1eLsrsMtxWDN07S
         R3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619973; x=1714224773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9OgX+O3/zuVrt/DBcGcP+zeMYKjKi+PDHln5LiTngIg=;
        b=wfpzwOumsyHqo6rqMoTPqarYAdMixDhjV44mH9U9aaQXvnYF9ePSnEgDK0cwIl2vW7
         KN/BwSH8mUCvVynrVGO7jKBokXRmebUjttdvBxfO9+RcR9gxUpjJIqK8EkmyJ7ujiVaE
         oh4j6ePoNSbUxJ6Pftbp1Hz7aS+ldWKDF8V/AAkX6sRLUal1MYTqnJu75WGN87R4nGfk
         nIrQikWGdv6Pq5wOmOlJD/YAc/VHHqtBia7M8QHv/C5sf51e/aO5kcAL0DDZdi1kifDA
         GIMq6FbOEHTqmcP5sHezzeC5Y7R68YB8XQ2EDJPeigahGlvzscSVIMSBhGN66hpCrREb
         Yn5g==
X-Gm-Message-State: AOJu0YwuK44Og8nsX2am4PQzlprtb2OiCZeXoifU6XQetZf/K+CDIRVE
	iy7gLt7a8tOrN5H4k/MqLZz39Zll3bmBBHpdgAfEEpGdOd2dBisS66k7+qdFHNlOYzF/Fw+iflo
	n
X-Google-Smtp-Source: AGHT+IGMUb/G1F74JWskKoqSUJCwWqluK44hBnLc74Md/6Mk0oXki/jSF4POndlp4rGug88UUKHjzg==
X-Received: by 2002:a05:6e02:1d1a:b0:36a:3ee8:b9f0 with SMTP id i26-20020a056e021d1a00b0036a3ee8b9f0mr6705232ila.0.1713619972803;
        Sat, 20 Apr 2024 06:32:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/net: add provided buffer support for IORING_OP_SEND
Date: Sat, 20 Apr 2024 07:29:44 -0600
Message-ID: <20240420133233.500590-4-axboe@kernel.dk>
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

It's pretty trivial to wire up provided buffer support for the send
side, just like how it's done the receive side. This enables setting up
a buffer ring that an application can use to push pending sends to,
and then have a send pick a buffer from that ring.

One of the challenges with async IO and networking sends is that you
can get into reordering conditions if you have more than one inflight
at the same time. Consider the following scenario where everything is
fine:

1) App queues sendA for socket1
2) App queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, completes successfully, posts CQE
5) sendB is issued, completes successfully, posts CQE

All is fine. Requests are always issued in-order, and both complete
inline as most sends do.

However, if we're flooding socket1 with sends, the following could
also result from the same sequence:

1) App queues sendA for socket1
2) App queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, socket1 is full, poll is armed for retry
5) Space frees up in socket1, this triggers sendA retry via task_work
6) sendB is issued, completes successfully, posts CQE
7) sendA is retried, completes successfully, posts CQE

Now we've sent sendB before sendA, which can make things unhappy. If
both sendA and sendB had been using provided buffers, then it would look
as follows instead:

1) App queues dataA for sendA, queues sendA for socket1
2) App queues dataB for sendB queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, socket1 is full, poll is armed for retry
5) Space frees up in socket1, this triggers sendA retry via task_work
6) sendB is issued, picks first buffer (dataA), completes successfully,
   posts CQE (which says "I sent dataA")
7) sendA is retried, picks first buffer (dataB), completes successfully,
   posts CQE (which says "I sent dataB")

Now we've sent the data in order, and everybody is happy.

It's worth noting that this also opens the door for supporting multishot
sends, as provided buffers would be a prerequisite for that. Those can
trigger either when new buffers are added to the outgoing ring, or (if
stalled due to lack of space) when space frees up in the socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 25 ++++++++++++++++++++-----
 io_uring/opdef.c |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index dc310f0bfe4c..13685d133582 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -364,10 +364,12 @@ static int io_send_setup(struct io_kiocb *req)
 		kmsg->msg.msg_name = &kmsg->addr;
 		kmsg->msg.msg_namelen = sr->addr_len;
 	}
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
-	if (unlikely(ret < 0))
-		return ret;
-
+	if (!io_do_buffer_select(req)) {
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+				  &kmsg->msg.msg_iter);
+		if (unlikely(ret < 0))
+			return ret;
+	}
 	return 0;
 }
 
@@ -480,6 +482,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
+	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -492,6 +495,17 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	if (io_do_buffer_select(req)) {
+		size_t len = sr->len;
+		void __user *buf;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (unlikely(!buf))
+			return -ENOBUFS;
+		sr->buf = buf;
+		sr->len = len;
+	}
+
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -521,7 +535,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	io_req_msg_cleanup(req, issue_flags);
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a16f73938ebb..2de5cca9504e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -281,6 +281,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
-- 
2.43.0


