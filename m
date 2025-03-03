Return-Path: <io-uring+bounces-6913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F885A4C5AF
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002A23A874F
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE6B2147FD;
	Mon,  3 Mar 2025 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTVkC/uw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8981D214A68
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017015; cv=none; b=gEvqW32Uy5by8wxTTNyG6c0eefkx5yMN0fAh6s8LUlnhr2gQt0P40iXoa/pAkGX8em5pG6gTaaZb1Z//by+MPoRf9bVeoWc8d0KaZIvXjdkyihdbNYapim+w++BRvI38wIpKXZSJkgCcSsoOv/NH8kRfbOULusc7WQjdF6PdgRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017015; c=relaxed/simple;
	bh=+ko6qVLwFbY8p2fCkuMHNRIwwTZQjN0AL9uVp4qcr08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGXHDdk7GNeUKOylL1G0+QNjOIPG8UvDq67bkn6UJjA73S2Wxuw93rpJDXmq6Zk5L3z4ieieTpzXoHyDEwu/KEi6yWvkqkmD04+q3qKJPNrIs7LavPyEB+Q+7mvG4Or3aIwZTmN2VJvNTH7SqpaMokH0D4TpzMF66daefgyrcJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTVkC/uw; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abf42913e95so415519866b.2
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017011; x=1741621811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=FTVkC/uw+lzubZgQ6Ti/aOUB0dfHCYveL0kZ9e/DS9N1MHjwCaLdx/WE2qkQj/Szjr
         75r7UE10AFwm2VJJ9FUk5YM1yHC6eCcvl7mDkV+NFRw2peZNNO/UWz9bxISl6SjqaSJZ
         3BmQN2eCG1MIRdwTgsBVsTR9z93c+Vz7e3GFGEHG/qXaW2g9tMCfjf/T+Jkko/AQgxM0
         Ks57UOxdxiwrLO2EwheycyDW+n0+j1C6QMsWDNE+oFhjB0ZsT5xAJ5hIYPzSQ7KEefEd
         EPwixWuDXPcDAAwerzW38tyIG149QfwikKJJypv4o0n874g1nV/KzPBn8iIzmhrMqnvk
         VzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017011; x=1741621811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=bM0+D6T6YsD67zFCil4YGSY9k7D9Zc8gLPwci7PGcCg3HUu0WpViMUa9bD/2F41mjd
         nowenqQ7DWk/5RI0Zrn8vQdlXxIlP145hlqC8vYEKbXdG2ezQUAy8sFObDhI4eb8li0N
         rnWdd3tzYFjWWRL+vZcetUZmHuZsr99/oDUyHcRrIMS2ZRZohyYyjJ8Gij4sO2plDup/
         /n1+y+xW63jyN8GvVisMqkXjILifUm+PkhNVDrDEQ355emuJ3sML6jCdxeJ5SCluZ0Rc
         jAkGsYe0RqiCZUtnIdD4xI1zzxVXJmCi9Z3ReiYq3hnS5muWZtvUZvwqG9guToohGEu0
         3mSw==
X-Gm-Message-State: AOJu0YxJZJ8C5lGIkhVljPJiw6sVUWsqooJvoK3TMKGkCqbj5R6A5+Fd
	2Jxm5LzGRtCZryIW2xTNFfj5ko7o4GtHYRDx3sljcFBz828cbjYwjw0wcA==
X-Gm-Gg: ASbGncvgCkx0wj73qRujRYy+l0I8k/63Pv9N09pzWMMnEGSnXVJ5APvDqFSdI3oM7g+
	Xj+R/c2/XI5CNAzoytLiBzqGyxuXSzyLqOOio2MLfSlXgS4sMGkhp7A0NzJ8xgCCTB5Z3CdaY6T
	95sQS4pn4r722XXOGWtTsyBtAF/YxB7USg6ft9Ko31oaCo+VI831o6v3nH74MKN4Yf8C2K1GLgB
	1Him7dhp0w18LBeKvRTokL1DzpXmXIEv69RTo3mclJ+FRmvxJDv/gmoot8XxwV9b9uxeOvBRRoT
	7Xj4Czu4ukwaMcvdOKHGeJE9dtQD
X-Google-Smtp-Source: AGHT+IHcUsv5eBQVod+isN0ix1b/5ICTR+hGIlxbIcGYZhT61r9aA/Cvxef6pGkt4U6fK+rTb2OiGg==
X-Received: by 2002:a17:907:97cd:b0:abb:33ff:c5f5 with SMTP id a640c23a62f3a-abf269b4357mr1584049666b.48.1741017011188;
        Mon, 03 Mar 2025 07:50:11 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 8/8] io_uring/net: implement vectored reg bufs for zctx
Date: Mon,  3 Mar 2025 15:51:03 +0000
Message-ID: <0b47cabcec226a2630fabf0491856ec78748ef04.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for vectored registered buffers for send zc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a4b39343f345..5e27c22e1d58 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -395,6 +395,44 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return io_sendmsg_copy_hdr(req, kmsg);
 }
 
+static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
+	struct user_msghdr msg;
+	int ret, iovec_off;
+	struct iovec *iov;
+	void *res;
+
+	if (!(sr->flags & IORING_RECVSEND_FIXED_BUF))
+		return io_sendmsg_setup(req, sqe);
+
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	ret = io_msg_copy_hdr(req, kmsg, &msg, ITER_SOURCE, NULL);
+	if (unlikely(ret))
+		return ret;
+	sr->msg_control = kmsg->msg.msg_control_user;
+
+	if (msg.msg_iovlen > kmsg->vec.nr || WARN_ON_ONCE(!kmsg->vec.iovec)) {
+		ret = io_vec_realloc(&kmsg->vec, msg.msg_iovlen);
+		if (ret)
+			return ret;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	iovec_off = kmsg->vec.nr - msg.msg_iovlen;
+	iov = kmsg->vec.iovec + iovec_off;
+
+	res = iovec_from_user(msg.msg_iov, msg.msg_iovlen, kmsg->vec.nr, iov,
+			      io_is_compat(req->ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	kmsg->msg.msg_iter.nr_segs = msg.msg_iovlen;
+	req->flags |= REQ_F_IMPORT_BUFFER;
+	return ret;
+}
+
 #define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1333,8 +1371,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->opcode != IORING_OP_SEND_ZC) {
 		if (unlikely(sqe->addr2 || sqe->file_index))
 			return -EINVAL;
-		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
-			return -EINVAL;
 	}
 
 	zc->len = READ_ONCE(sqe->len);
@@ -1350,7 +1386,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG_ZC)
 		return io_send_setup(req, sqe);
-	return io_sendmsg_setup(req, sqe);
+	return io_sendmsg_zc_setup(req, sqe);
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
@@ -1506,6 +1542,22 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned flags;
 	int ret, min_ret = 0;
 
+	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
+		unsigned iovec_off = kmsg->vec.nr - uvec_segs;
+		int ret;
+
+		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter, req,
+					&kmsg->vec, uvec_segs, iovec_off,
+					issue_flags);
+		if (unlikely(ret))
+			return ret;
+		kmsg->msg.sg_from_iter = io_sg_from_iter;
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
+	}
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1524,7 +1576,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	kmsg->msg.msg_control_user = sr->msg_control;
 	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
-	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (unlikely(ret < min_ret)) {
-- 
2.48.1


