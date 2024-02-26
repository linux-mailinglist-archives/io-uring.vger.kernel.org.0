Return-Path: <io-uring+bounces-757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCCC8680EC
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B5B11F2BE17
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DEA12FF67;
	Mon, 26 Feb 2024 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oD+BZzYK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E212FF64
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975512; cv=none; b=MKWn/GVLlgNcuay4jELm6K2YgwNWJgplrjXJ377PE8JYXynAfyLVOf7is7Ib7CyVnRTqqgXpsG2pFcorddLlDco/X0m2ufLOmdb0o0eDeEejy7Hte/LG/4+dlYP2iVTZYutnv9U/d9GydDzLxU/KNOm8CNl4lem0b1olCuNIDrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975512; c=relaxed/simple;
	bh=lGoC2BMu61GnabMZrBdyCwtqhshjhK1Ekf9h9Qs2UU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6ZBubqSP2mKQsPNgGFQSy45vlfrDuBD27OnhpZKY5gndiSpiU2Ap8FMrl3djxyza1LofsLyxc/P/n6rwOXogfiO2e8/DxIK6pFk24qj4rfg4MmdptgCQS+7KyhioJmAk2Qa7iPJRmUC9k2V9J8VdwL0efHl5YHcSstg1J7zDD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oD+BZzYK; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c787eee137so39011839f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975509; x=1709580309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0ptQPO8d+OTLLsakqRHLt1Ahb+P2jcy8KvUJBo3TIw=;
        b=oD+BZzYKtxANNrC8YUvPJrxmjDMkhKecyo83t+7SQeQnYs0vwpfrrDjyuEjtGc6wuR
         KGJJeiu+onwcfpZxAtBbpSrTN/GP7+UOetz8L4AJJpruwf3hrCv64iafOxSFq2kPsX4y
         8jdVHAU2PZoLEqnhiRTm45yf60yz/VYa9K6Cj0iRs/b/GjKDY1nK3EX+XHWcwKRbfYmy
         iUGF6P4QSCqQpZsRYDWyYiAOfmrpjDO4xOycVHHic9G9z6iSUpoWFJcM+OHm/mIQ6XBJ
         +Pfn0h86ymGyYkKv/sUrXUUF1ZAzQ6rwk9xAWOoBB/5uSNZBBRv12KY7khyyLkxqFQYi
         +ZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975509; x=1709580309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I0ptQPO8d+OTLLsakqRHLt1Ahb+P2jcy8KvUJBo3TIw=;
        b=YqdZEBIUxaJBtGjYmIDdeevSQsDyeR/q2NMCMg6LY7DOokljFVV2mLQ3LifRvoMTra
         d5y3N222pwclcfnHgbT118jqboygt+484W1oIILi7BbNdm6Qg5wfD9/3SqwTtEcIY5Wu
         2JTsCYPknJ8zYTw/ZbRAcqAJ3NAaTBiePWPfuhSj3cl2ESKoibr2EXeYdHcQd7ltFUbu
         wd5Njv1mDzuczIM+yAU2fc5rDAPujqPCjjErvs5TRn87Q0XCJbeVDJPfYRAbEbT9ImDy
         2aoVNPAA1cPwC5zWHNYdSBUrl1N/qclXfDSWROcSvQdY7qa5j5rGGQONZF+5jneKBJpN
         2O4w==
X-Gm-Message-State: AOJu0YxM49b6QZ40prxgL/AP6Lg3hLeFt5FycgmUOoJmoaiQ4bCESTH0
	OGJbtHSZb5EZYsLT1XuP1DTqW8wcuUKImKNe4GLXJ9fcVMNrud/Og2Wt8mGJjYtFXxDuH1mbzql
	n
X-Google-Smtp-Source: AGHT+IGxlaAZ9ISe685f8FnDQWCVcngONtKINNK3PvcvH3bAVYi3X8+a3PP2ctV4skgTsPIHNIYj9g==
X-Received: by 2002:a6b:da17:0:b0:7c7:a02d:f102 with SMTP id x23-20020a6bda17000000b007c7a02df102mr7465761iob.0.1708975509227;
        Mon, 26 Feb 2024 11:25:09 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] io_uring/net: add provided buffer support for IORING_OP_SENDMSG
Date: Mon, 26 Feb 2024 12:21:15 -0700
Message-ID: <20240226192458.396832-4-axboe@kernel.dk>
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

Adds provided buffer support for sendmsg as well, see the previous commit
that added it to IORING_OP_SEND for a longer explanation of why this
makes sense.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 15 ++++++++++++++-
 io_uring/opdef.c |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c6a24973352e..679eefcd11c5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -459,6 +459,17 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+		size_t len = sr->len;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+
+		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
+	}
+
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -502,6 +513,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	size_t len = sr->len;
 	struct socket *sock;
 	struct msghdr msg;
+	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -576,7 +588,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 88fbe5cfd379..1f6b09e61ef8 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -139,6 +139,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_sendmsg,
-- 
2.43.0


