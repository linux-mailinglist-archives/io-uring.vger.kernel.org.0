Return-Path: <io-uring+bounces-642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6301C85AC62
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 20:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D11201F2240E
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7070255E75;
	Mon, 19 Feb 2024 19:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xKzmDRcg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC0A55E54
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 19:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708372111; cv=none; b=qG5P6tqJqRznd8kdP0hzQuyYOYlpijO4CLcLXKKIndPpWnULX0j+WOYulWXD+FwGqfjVtfefZeKGmYvqIwg5wKGG72GNqiNIBnr3p9M2G65x9WG9aFjN9ItiXYsGDpIR+bnUShvcbxcp18aSrTyU9eqSl2hMmcIaNQHGRhFsMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708372111; c=relaxed/simple;
	bh=35u5KCTVdHhIF/FLR/EuUDWkEmEE8YC3N44CjZBjS7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlGJ4iRBNcL72F583cVdl+5LVDdAYVzAfUUby1FZsWvz/x0K6mzTs1WpnR8Wc76AaqDA2i0qtKvvLENadboVQENv90uCBKAF938IJHMBtpW/t2rz8urWjVm85E5c5dMig5XCui6Fcnt9jvz9g+0WPRaKIxKK4/EzQ/1Z/DXODxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xKzmDRcg; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso49024039f.0
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 11:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708372107; x=1708976907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybut4aiQ8J8jpPksFRX+LHMx4T04G5ww8CWzh2zhu2Y=;
        b=xKzmDRcgTn1dUuI0GHKwEgnx9APP7GKA2hqGWRIKe2uoYsQ497g+O8fB950MqdtYhl
         YP+60ZqKR3aY6lPG/tnN21nqPShZJldeM3Qu6F2tIq73/gySDh7gPitA5Mix8RgsYJjl
         s/xb1GaS0PDUQ+IULaCDdO/TsWOQ63JxC6UpnSWXwP9X8J0zLWOiHgP7nDO+yxiK7kHY
         QOgVWLHqRVJ8P/ZXhnZQqWwbVpHjVIazU5BkiSr9hy+9GaN1YCSFHNlFPnYP/k+cPiO1
         BmioS8ZNJTfsM/guokgSwejYxu/5lIuyucOGQZDmftvdfnpHZDzyAjmt9bFINAsIeYA8
         PFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708372107; x=1708976907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybut4aiQ8J8jpPksFRX+LHMx4T04G5ww8CWzh2zhu2Y=;
        b=gHX7CYqLdTzDLZ1AD0FvHai+nmM2l9ppCG4OzKRp4yDC7FlVoRfZ38hiMZB03ji/ot
         BxROSUizXEroIKUc7BgjA1/GOnnt7tIwx8rk863oKU/vO630ZrzdCWNKfUW3XfZv7d/c
         otA2zXtyb8M/EJMDHl0HwCfFpjDD6aDIegSMUlI4xnkEy5wwNIef6PRZKfW8IbXim19/
         n0xhcEwsXKD+GTZOnx9V9teMMclO4j1dgNbQ6vJZy+4AZgkiZZmTGF+lHbwYAUC1cCpI
         VCsmlesdY/Wpu1N2I2lQ+W3DYqg3Cq6CBHj/t0Su8JT9ptEKl81/JjYsJWcRD1WvgqWS
         a/Fw==
X-Gm-Message-State: AOJu0YzXI+GF6KvINp2FUAoXtri1FRwqPZDYWytGvKg+euPOfkxk1jIn
	tEMqsyFrHS79zUvhGnsb6JFeB77jFy4sWhSsdBvzTKmqAiB71M5JZ4Jm+8zPM56r7aYv0Q9MHow
	6
X-Google-Smtp-Source: AGHT+IFKeHtQGHJBGfNwvrm0U3JiAEqbT2zKyYoegZRtwCXmeH/UDByoB0pS2EAcvJAl2UJl6bDgGg==
X-Received: by 2002:a05:6e02:2144:b0:365:2f19:e58e with SMTP id d4-20020a056e02214400b003652f19e58emr3098601ilv.3.1708372107087;
        Mon, 19 Feb 2024 11:48:27 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02220f00b003639d3e5afdsm620302ilf.10.2024.02.19.11.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 11:48:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/net: add provided buffer support for IORING_OP_SEND
Date: Mon, 19 Feb 2024 12:42:46 -0700
Message-ID: <20240219194754.3779108-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219194754.3779108-2-axboe@kernel.dk>
References: <20240219194754.3779108-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's pretty trivial to wire up provided buffer support for the send
side, just like we do on the receive side. This enables setting up
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
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           |  3 ++-
 io_uring/net.c                | 19 ++++++++++++++++---
 io_uring/opdef.c              |  1 +
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..74c3afac9c63 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -522,6 +522,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_SEND_BUFS		(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..f6332fc56bed 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3962,7 +3962,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_SEND_BUFS;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/net.c b/io_uring/net.c
index 161622029147..6c22091a0c77 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -365,8 +365,10 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	size_t len = sr->len;
+	unsigned int cflags;
 	struct socket *sock;
+	struct msghdr msg;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -399,7 +401,17 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		sr->buf = buf;
+		sr->len = len;
+	}
+
+	ret = import_ubuf(ITER_SOURCE, sr->buf, len, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
 
@@ -431,7 +443,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9c080aadc5a6..88fbe5cfd379 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -273,6 +273,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
-- 
2.43.0


