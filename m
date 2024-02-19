Return-Path: <io-uring+bounces-643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 506CB85AC63
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 20:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06FD71F22E43
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEDB56475;
	Mon, 19 Feb 2024 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JzsJqVsv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9094056448
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708372113; cv=none; b=lxodFYuZbnBKXy5Ac5ahlYcecWGDSX0eMxMdvxrPmr4gJzDFhofHjBGM78102WM0AQiQYRsgDAlpsN9Hku9nXkuk9qRlOXH4X2hOfcQQzB94H6pwVTmRcmx+VITirh2Ets9bEV+Scjv1Gkytk05Psk0TdyAxX2SFjjh8cVfYTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708372113; c=relaxed/simple;
	bh=XX4H6dpV2e4C6DplzlgPVkmumTWhkbNU5FwqQ0x8tFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2db3NjzDK41mDWiUlYSkNzqfoi91nyBEynu0TvbkLFK3m1PTGn80zSCZHzkGT87Mm/ue0pMQHpcDXOKsdiatAMvq1QlV3TxiDEtrDjnZN2Ygi3tZALf5hYHdWzh083Ep/uz53gu3yrsW4Aey3OuEn0WZi31Vzitrf6mrWPv4Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JzsJqVsv; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7c45829f3b6so29512839f.1
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 11:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708372109; x=1708976909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bXLgbwyH0Awyxr1dZIwuUCQClb/EXdf+2p7mshNPF0=;
        b=JzsJqVsvcrqCw01BgiNFKuxZzf8Iza8RAawfo1fG+dwZH2VQrvZL64gGfVvbv+aZ0h
         pTtIMXTWQDRW8BqFYv7YB+4TaIGwFv8ld4QP3clnJT58Nmg6KGYY8MYvFLP+PeRWwVvc
         NXIiDriC1bHWOqVasSr8ap6C0/2ngQaDQGvjKWFKj3UNqRkUfqp1Tmwc3q4V934ssuyu
         j01ONJ/WHX5Lw4qpy4DIEVZy1/tR1p49m5I6asMXUpZiW+xXDH/ipJfFbBIhG4Vu0rGk
         ZegtFOpVhzfBQ193W3+OwRKK151njetHnoxuUgyte+Bw3QcGDUO/RGThRWaj5CBnjzgM
         r91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708372109; x=1708976909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bXLgbwyH0Awyxr1dZIwuUCQClb/EXdf+2p7mshNPF0=;
        b=Lc1HJccJbjfTzHfsFdOFrqYjsfpCr9hMDhVDfO+WnnQAslD0JgOtvr+tvKa0k3vhq1
         aqGvEW+j0FMTgyvi/iKn7udAw3kwzZp4LUodyjrx6aXnLEYq9UXkzI63ubD9aiDxDJNv
         UjC4r35ce1wKFrPRbFnhl6wPxWq8Z06recIjzAZKqw75+z/MgvGQVw6RUibGASNNOhwT
         WoPbWn+a7RV9wNvdPOlzHn+xOqXVuEgaitpNmgXUAfcZuP/MZ7g89PKpMPgQOjz/Sqvc
         yyh2JVbrsrMchAQqAeNildpncvLbyLc5KLSRZkrmR3Slj+4wZSICvkAJHbWzm8V8fnQt
         446g==
X-Gm-Message-State: AOJu0Yy37yjJp55J5fOx6vqCk4sA48Yk8Ei0U74kN2NWUCIgAIc20dlZ
	OErd/FTw9U9ULeTwXhfA356IK4doW5/speor93YU0PxNEjox+kuphkvmkvasnbcFlZtVBsQ84oV
	k
X-Google-Smtp-Source: AGHT+IHgydH70rQl+iqAT8rEQNXgsWnEi87Ux+1bziLyxSqN91lp2BtfgzgvYBsvUJ3eV4+ChgcFhg==
X-Received: by 2002:a05:6e02:198d:b0:363:b545:3a97 with SMTP id g13-20020a056e02198d00b00363b5453a97mr10233351ilf.0.1708372109200;
        Mon, 19 Feb 2024 11:48:29 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02220f00b003639d3e5afdsm620302ilf.10.2024.02.19.11.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 11:48:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/net: add provided buffer support for IORING_OP_SENDMSG
Date: Mon, 19 Feb 2024 12:42:47 -0700
Message-ID: <20240219194754.3779108-4-axboe@kernel.dk>
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

Adds provided buffer support for sendmsg as well, see the previous commit
that added it to IORING_OP_SEND for a longer explanation of why this
makes sense.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 15 ++++++++++++++-
 io_uring/opdef.c |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6c22091a0c77..fcc0ce5fecd6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -304,6 +304,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
+	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -326,6 +327,17 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+		size_t len = 0;
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
@@ -357,7 +369,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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


