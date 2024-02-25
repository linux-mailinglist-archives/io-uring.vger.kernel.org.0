Return-Path: <io-uring+bounces-705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3BF2862898
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01B9B1C2100C
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A016EECF;
	Sun, 25 Feb 2024 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NGHUNsSy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39011C06
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821594; cv=none; b=Ltt8E7QUQKpxvnjzstT2yAH9HOsvDdYm2KrxHl6PFpAH4/QrNSJ31VUA3wyQ6mWI68CZf2neXfcDbr6FaVRXl82uGmDOosrMHpIK5Huwb/BQ+5v0EaDZ7vBfBoRXi9umSuzopDwOSSNDmv/tZCnffRXTdO3fcapbDDlRMn2GfoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821594; c=relaxed/simple;
	bh=taZLZYe9/lGhZlFpg6RgyuB6JMR1eg7+Ku/sLaHYol0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGPDMJiAp9P4Kk8rivkNyf85BZ58dKHDML8ZH/iW3svJPB3Nu4Vc9ahIq6Fip8/9ERIRXyG3VVK1kCkyLwa8HqAS3QOvnRbNEG5r+Ga51D+MlWYr5pyFiqwy6cw3OudGxBd6Q/iJiGn1ykrrqlkIDARwQZTdPG8Afj/IfrjPADQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NGHUNsSy; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso863980a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821592; x=1709426392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQJvsw/J6sK+/X03ucFK8E4fqOrLrmHIUymPpkqPOW8=;
        b=NGHUNsSypXujgus++eHegLs4nUakh4DOn0bw2mTTTLgDyAWrLPC+0n0KKgG2W/jZwN
         qvXalRE0XMN3N10h3ZFVLzKz3LntBr4SvTnmnoDOOim9cq0nt0ty5uiJxnn/vQ/x0yVt
         47DPY/d3J+rJ3r7WiH6UigRWXt57Hxgvr4xqMFli4VWQrBzXrmX3BubjJkUsFWCc/5/B
         eHD5bBOlsDjDxq9UuHtayrZbgDp8FHrL9OYgdHPYVL6xXO33TmibqKoVtHLRigrvBY4f
         MW4gZgVGS7XOH+t3VKpoQpzQESHPgA8i4pkea4f3KcjjOgskZSMuOhx/xDPTGXchGYw7
         LkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821592; x=1709426392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQJvsw/J6sK+/X03ucFK8E4fqOrLrmHIUymPpkqPOW8=;
        b=BQw1rZMp7PmRufQPQuQPHzacS6ffQUbdAN2r5+Z+Knl2MSjygBUhecBgemUSUXROlz
         C04Eo3kD/CMdbFsQZtVU8iAwzzsLwbv/zSuImugeS/M2yWyaofVqt3VHtm+T9iTUNj6x
         LPF7S2OSYLhT1+kguSC8GkwS8LhbiZUmNYjL/AGON2n64CoXZZ9/+hkAzNQF3PBdHBMc
         PhpXMfttRurqFO9SMPbSLAxHrCUCgsaXdGaVrIxNK6sdwWu3TktGXIYSd6wf2W33rhYs
         LC2YPZvBz7R0XGDGi1y+YH7sxvy/8Cu0+8yevCVmTjjMb3O1RUFZgU4f5vNhzrS3Xtss
         t3QA==
X-Gm-Message-State: AOJu0Yy4osMcfWb/M08pTqtY6ZuKfcIHXu/ZME3vzvKQ3UBS5UGTc7jk
	qP1SIVgYK22DEU/ckijUbp0pw6lDA980gcJV566eH6oLALZXMbOIsPJo16R+/pJpvPDNyP4re51
	2
X-Google-Smtp-Source: AGHT+IE64TcOG5PUyWvD7CcpbPJ/6kW4ZzMogc2I1KCjkG9uigooJ7l8ukPjAX+5V5UCZSSi0hGN+w==
X-Received: by 2002:a05:6a20:9186:b0:1a0:dcfd:feda with SMTP id v6-20020a056a20918600b001a0dcfdfedamr5168120pzd.5.1708821591851;
        Sat, 24 Feb 2024 16:39:51 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:50 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring/net: add provided buffer support for IORING_OP_SENDMSG
Date: Sat, 24 Feb 2024 17:35:50 -0700
Message-ID: <20240225003941.129030-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
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
index 10b6d8caf4da..30afb394efd7 100644
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
@@ -458,6 +459,17 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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


