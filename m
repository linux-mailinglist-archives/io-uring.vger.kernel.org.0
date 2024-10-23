Return-Path: <io-uring+bounces-3952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F329ACFE4
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84D931C213DC
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D202B1CB31D;
	Wed, 23 Oct 2024 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R39TMA99"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B2D1CACDD
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700132; cv=none; b=D1sBxFWzfvgFX332Mb2l2wpnsPNgK3KcUxx7q7U0w+CZJGAroSBCvtny4yGH+n6OVw3uhDy/9YA1gYZwQXerPfpvUONZU1ESTMcIKJHM/mZdTUGIk60l/hYReeB+MsZNQlF5eT/Bueyti/N5aYo13H6VsxnUhvj0WxE8HyVq0HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700132; c=relaxed/simple;
	bh=dvGsUXnzAHkxsecjiCnLZAVaZ4J8zq/EiYVeNX/IvOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2SAl2uHDQb1JkC5IbwL2dU7iHfZ4z1TVoEti6Y9UUPo8jlhTQW3GXrRdxa67E2OQi4TT3t3Kmwd+aDJ1ogdF/S3WsXQH2TWV0ClFEImlJH6nVP4mINwyi7o7XHvRO4ckJS5MNqJoprsJd1P0yYve4zJpt5u4AHh04K4/zaU11Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R39TMA99; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ab3413493so240564139f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700129; x=1730304929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCP85O6Vn4J5WfFHGwdvkrQGlciOPw4+bilPFxYPNbI=;
        b=R39TMA99f5dVBMXqgCCk82n+vxwG1ii/GZ8tgLUot58qw1a1bTBgjzb7B/oaEk1I4c
         I1riQA9uJfvE8WMi1/CsXyYy9lUp2tUjtLbEZilgpP5k+ipbxBeAh4mB9/pqgJanSw5P
         wnNspOInPE8XUoyD5mL3oLZUhjgAqFbQWo+TjYQ+rS670oD7uh6xX+4p7NJ+Uwe7HPBm
         0oxBmcO8zEXarDCqmdJu1ZINiu2SexzoumPVIiWjcLFoL0Dm1QGARUJUni+muvKv/y/8
         7KMQEc4f1rJygXPRXQgfQIF6KRqDt/LkEPy7t1gfPMs12lDOeehT4dwywa+/NzKb/UHR
         ZDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700129; x=1730304929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCP85O6Vn4J5WfFHGwdvkrQGlciOPw4+bilPFxYPNbI=;
        b=lwJ4OjiAMt62eUTSMg2D2whbOpVPppWKoNzdu/wg8bsruOnlIp52pue2FPslr10kdE
         xv++TRjFj1hubo00cvJug/NQW8uWIA3xqAcdJ4VzySGlOghKnqLkU+kUGVbUEmnmHeb0
         C45U/TjvHA+JRFr4Yyn+k0SIgkyicGem0rEQ4N8PkUr6rWeWhOHDtCePaeZtT7yYDrUJ
         DCEx7UDlQ6qC0V7rG4IGXdaBXj8zombN9ITKowXO/2tUK0qYms+6XV6BgvzLm1it9rrA
         PaMjioOnLRwTb771kRTQUC5rio6T679rJwTyEK1EHb1dpjfzXJQjd+kLkH/6AA7kLs4T
         5/7A==
X-Gm-Message-State: AOJu0YxSRTZc865koJoExY/9JO3ld/LVfR6E48r2wQvyz1e72HMA5LW2
	a9hM9y6Q5Ezmifx/23uBaWLiPZ6IYxVi873o/xMPp6dUQYDbnWOZ6wrXqbRGuESBuvZ+/A7uDma
	M
X-Google-Smtp-Source: AGHT+IGMNQtlv3Cw6heF8vIB2CZGBGko3wUxeMqdvcdolJKbFZj9yhXtwYJEgi8zWsYWTPbZQffvYg==
X-Received: by 2002:a05:6602:493:b0:82d:129f:acb6 with SMTP id ca18e2360f4ac-83af63f517fmr434941939f.14.1729700128605;
        Wed, 23 Oct 2024 09:15:28 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring/net: abstract out io_send_import() helper
Date: Wed, 23 Oct 2024 10:07:36 -0600
Message-ID: <20241023161522.1126423-4-axboe@kernel.dk>
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

If provided buffers are used, this helper can be used to import the
necessary data from a provided buffer group. Only one user so far, but
add it in preparation of adding another one. While doing so, also split
the actual import into an iov_iter out into a separate helper.

In preparation for needing to know the number of mapped segments, return
that instead. It still returns < 0 on error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 75 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 25 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 2040195e33ab..13b807c729f9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -578,28 +578,33 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_send_import(struct io_kiocb *req, struct buf_sel_arg *arg,
+			    int nsegs, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
-	struct socket *sock;
-	unsigned flags;
-	int min_ret = 0;
-	int ret;
+	int ret = nsegs;
 
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
+	if (nsegs == 1) {
+		sr->buf = arg->iovs[0].iov_base;
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+				   &kmsg->msg.msg_iter);
+		if (unlikely(ret < 0))
+			return ret;
+	} else {
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE, arg->iovs,
+			      nsegs, arg->out_len);
+	}
 
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
+	return nsegs;
+}
 
-	flags = sr->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
+static int io_send_import(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
+	int ret = 1;
 
-retry_bundle:
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
@@ -629,18 +634,38 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		sr->len = arg.out_len;
 
-		if (ret == 1) {
-			sr->buf = arg.iovs[0].iov_base;
-			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
-						&kmsg->msg.msg_iter);
-			if (unlikely(ret))
-				return ret;
-		} else {
-			iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE,
-					arg.iovs, ret, arg.out_len);
-		}
+		return __io_send_import(req, &arg, ret, issue_flags);
 	}
 
+	return ret;
+}
+
+int io_send(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
+	struct socket *sock;
+	unsigned flags;
+	int min_ret = 0;
+	int ret;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
+retry_bundle:
+	ret = io_send_import(req, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+
 	/*
 	 * If MSG_WAITALL is set, or this is a bundle send, then we need
 	 * the full amount. If just bundle is set, if we do a short send
-- 
2.45.2


