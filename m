Return-Path: <io-uring+bounces-758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2F18680ED
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBF1B1F2C054
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CA812FF6A;
	Mon, 26 Feb 2024 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aR3etyve"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20E812F361
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975512; cv=none; b=eetdpDCnJ8yFW0KBAkha/7il26RBMSHAHcX1V4mrfmoMK7stkJt7qFnUpYbO8fo8YXDvx+xYTWyOOxA29UwYicAzZwFm0P1ZHqrVGsamPdt93Fhf+ua1YayteyDexFGBtbKXOE4BjPUnOmf+lFVJY70Ktvp9xbqlxO9E5X+x2hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975512; c=relaxed/simple;
	bh=bkMmyZKh51k8y2VEtqkwLoik1cfgZqlRd2aMwSyglPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW+ukIdQuzy5LmHFxA+UBH5P5boi0/wMRjrkJDa3luElGQfc4AGGPLOOJLe1+9XpZo6qyOe/lswoxB03kdkTDnZf9dizEluUakmVNEyhJkS/q/262v4Bmc7oAA4igaTuTE9pBH3itxrX1ANexOh95lSJ7EU0Y5w7CmmIuj7uT7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aR3etyve; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7c7b076562cso26095039f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975509; x=1709580309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5S26c1cI50UkIDvPXxOEeXnJ8Zl5Pckl0/AFyGZTKQ=;
        b=aR3etyveoxSzr/7+BwrZAsPbyz+TMNnAv4s8Kx7pJ1pAd+YJZ+HgQbY10XPzigG96X
         5Y7dY4SYCXhBtJ7Zs9hGZqJex3t5PUgLmHKPBMzk7vXLloA4bukOGecVdFu+rC4Y98V7
         2Uysv9qd9iuUc3t5Bus+zfJvUj487TJv6UsUWDZr+Bgt7vW9vtYbLSpdIZWVIcS3EypH
         r466wG+4OUvs2crJI2RTBf4ILk/EYgAejUwjTXjCfsHe3NQW7Vw14AHQDaLqaiqr2PvS
         Yszz1DLwEJpoaTIe2COyc5Y1z7ZpYdALoRtR6cr1mWEVSnl2YlU0wRHyBHhZicjjrYOa
         8kMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975509; x=1709580309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5S26c1cI50UkIDvPXxOEeXnJ8Zl5Pckl0/AFyGZTKQ=;
        b=I4jZLIto+95O7yd+9cdEdu/1xIol/aydQfemD9sEcNtY4ZSAjm/MQ9cqGvgtVHw8zy
         z/c2+bO4SCi5RJwKKl0InTAEZYg92QjA4lvBUHKE5WJOsWkbE34xX+0BTRdKENRskr3e
         a0xsBNgpJqEcSdot+nHebuJtSaCA6YCMCnC9EjIownyWiPIvFVSTASA/Cggp+9HbZn8s
         TAS5tIgbw0YVP9PVvMzlIlOPRcOj9UhT09Y1mo7rxA9QrK7F2vP8XyZI30cTgEfwtdzl
         KGgIEC7S3WcfgnpQwoM9onEMNgS/i5rhiSScNJxVp0NgHuU9RY4tIyel3ALWrU88XoS3
         /+GQ==
X-Gm-Message-State: AOJu0YwqbVK3tCV8jKMfIWf8e/Ia/fbKDVpYiXhf98fskjzcsq7Qt/PA
	0RONvEkZ7nfKOTvu2CfpmI5n5eJqB1O55QCuWJwW+dHeaYbwh/71k9h6WvabeNx/g+yhtf9QYof
	h
X-Google-Smtp-Source: AGHT+IGxvMeVlV2CmRnHXyz8nPjhmH4mwdCD52CeyRjtcF8B48MqWKbJo3InLMQovC2ml4/0mkqwAQ==
X-Received: by 2002:a6b:6d08:0:b0:7c7:ba40:4ba8 with SMTP id a8-20020a6b6d08000000b007c7ba404ba8mr4323277iod.1.1708975508353;
        Mon, 26 Feb 2024 11:25:08 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring/net: add provided buffer support for IORING_OP_SEND
Date: Mon, 26 Feb 2024 12:21:14 -0700
Message-ID: <20240226192458.396832-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
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

Adds IORING_FEAT_SEND_BUF_SELECT as a feature flag.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           |  3 ++-
 io_uring/net.c                | 19 ++++++++++++++++---
 io_uring/opdef.c              |  1 +
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..061147cdfbb0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -522,6 +522,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_SEND_BUF_SELECT	(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..edd7cded1a80 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3962,7 +3962,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_SEND_BUF_SELECT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/net.c b/io_uring/net.c
index fcbaeb7cc045..c6a24973352e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -436,6 +436,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
+	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -489,7 +490,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
@@ -497,8 +499,9 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	size_t len = sr->len;
 	struct socket *sock;
+	struct msghdr msg;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -531,7 +534,17 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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


