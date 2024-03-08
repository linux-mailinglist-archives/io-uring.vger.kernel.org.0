Return-Path: <io-uring+bounces-875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DEF876DFD
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 748BC1F22FA6
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981073D549;
	Fri,  8 Mar 2024 23:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HEByMjGT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA933BBEA
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941856; cv=none; b=D4fZwO2GOt3+eYCWxoYv7KI6XKOUBweKt2288CA4byFmbw0wBa5ah3zMCAIDexUIqqF4acBT14A+IDoQqQQYwXRv6pCj+S81Ty44EIbINizAf8MwyFivaJRRBmAm77pLbNPfIcO2gskRB+IahEtnahMpTpmi/1v1TEp10rYaT7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941856; c=relaxed/simple;
	bh=P6tB4BpZMnRH2BNRNjYHfAMIIVoEhlX+j04L/NSp/EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVOrrfY35B2a6jXkbTReaAEzsjc6voT3lGmq3IyS80RLfPoh5SUPHLJOeuIMJkywYX2G8iAchWyyv06ssx6xxW/HYd8pxtkDC3prgPvJ6QBL3wzNB2BfcxCoVIbC4rINyIrDsnMmFz29M4ElIXHBRJXIAXSYqS+pOWXWSBrznZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HEByMjGT; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c495be1924so38307039f.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941854; x=1710546654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7uQeSmZMXhZmFPy2FSkfjCUr3fhQmdKGcc5TYTa3LI=;
        b=HEByMjGTFnKLUKXyD5KbKuBLF/1//m5lr3qEIpMBOl+vjNpEqIjVMHiywWioL2hgs6
         ggynR/vjxWWfNH7KPZgSWgfXh99wLjBsH/bWrX5DT+5jlsaQeITACPbT9i2WdiBQm1zL
         mFWnkpFunu6XG9vDrpi2FhtAMB6rOfO0xZa9ovorb27g2uhsATTATTAYR9WhWlewzxLZ
         q1MUu7E/vOtjgPC9anCRrm1Q7n6FFpjOi6ReTq5NuSlJEqsnOjrJ6SBEyzx3xh2iVzEp
         GkYme96cY8kHdPiPXggtdpfuoproKTwOAaYsO0mxnBuAZHokrH6JnBFb2tfSvue5FIJx
         OV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941854; x=1710546654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7uQeSmZMXhZmFPy2FSkfjCUr3fhQmdKGcc5TYTa3LI=;
        b=sRHemn2y0k+v3C/E4czrrdjDRGOZI3fFXcHrFfnBM7xQ1lSwJJhV5hJ2PJ1jU6hLfw
         KURNWqu8SaNk1IOEm/W8VdExT3XlbqvsFXxpQvrEY0L2+hG05Fdw0TLImaWMYWZOZzHz
         SAnsUoiB+IV4P4MTi0af8tgiG7ZxNunPjeWfmZ4lqtEt2eDiwUUzEDLOGdeuS6BRIabS
         ltFx5cKjezNAYOLtlaip9bGMevTVO55keLuCsODH6pDGhhP8Uqu9iSQ0XIf9AxwVwdb9
         AEiMD+UWHILi7e8tsJ0eyUId7eGdaZbkGaQaMJVIQbdAn9aMDeJmVClv2a6ZImMSnbiQ
         768A==
X-Gm-Message-State: AOJu0Yx03a+rAhKU9vSZ3e8YHQKRmsuJKGhiFo6JT+WxfhviANDunuQI
	e0hAXyx6wPkg7DpQR9x0MuG5eJie8q2rAV74btxyAPtVDe2RRTruHV2D9F0ZrMpdlQ4IGxKYodF
	g
X-Google-Smtp-Source: AGHT+IELH97Li3ONvrls7gFdsW9Aupxr09QXNVPRNpVuYR42ZoxttoxHMmJXMKCbxDk4WwE62rqASw==
X-Received: by 2002:a05:6602:122f:b0:7c8:8a21:7156 with SMTP id z15-20020a056602122f00b007c88a217156mr419126iot.2.1709941853760;
        Fri, 08 Mar 2024 15:50:53 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring/net: add provided buffer support for IORING_OP_SEND
Date: Fri,  8 Mar 2024 16:34:07 -0700
Message-ID: <20240308235045.1014125-3-axboe@kernel.dk>
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
 io_uring/net.c   | 19 ++++++++++++++++---
 io_uring/opdef.c |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 97559cdec98e..566ef401f976 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -484,8 +484,10 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	size_t len = sr->len;
 	struct socket *sock;
+	unsigned int cflags;
+	struct msghdr msg;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -518,7 +520,17 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
 
@@ -550,7 +562,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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


