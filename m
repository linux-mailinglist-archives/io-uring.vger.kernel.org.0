Return-Path: <io-uring+bounces-12240-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OM+TCpIDk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12240-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2511431C3
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1EB803017FB1
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09C02C21C1;
	Mon, 16 Feb 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsPriV0K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900143009DE
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242376; cv=none; b=C6KCnSdh2UacOhD6JtE7WSJIXFKPnLO69O2SAUYSLdP5IExp5pdc4dzx8VLEvekU1nOVF8wwG+xGfnr0CvESGvUZqJbGlV7BpkZawWWq+Hneyo4qSnWuDgZ8V4O5jIO6QGUYWbyNSoN0qpxDuBEsllL2Hf7m24+/A2OAmx1M59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242376; c=relaxed/simple;
	bh=Dkck9qIgOI/bQEWuXsHIUTlvUD0EWlC6UQ9/SnBlPYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmZRUwv9OgXwbiObuCB1oOx8K/hOvMhrMe1n4c8B7KP1Fc5Yv9ni1GPQtsDxDk7hWsBdxOQm7uZCB5juihPw++pTAtGssz+Z2ZLCpkdlNAZLR9fj2uliWHBzrKerOIKwYWd+KQeENFgOMNGhsRyL3mx+/7osNV6alvwoli9xAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GsPriV0K; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4359228b7c6so2291110f8f.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242372; x=1771847172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzVyXr7yFI6MFKXAZM6Z4ZQG18h3wTttjUaEIKBcUaw=;
        b=GsPriV0KK76wwnKqb1hqiuhgf3lXQSH2YJ2iTAOIYQsBYI2VCrNCX7+V9WajlKYXU4
         qwOLC4JYoBLvRxIzZixl+xto91TTMxVrTZMcz/HPQQOaECU823HfKKFxLed/+aiwxHSm
         nFnJmSGWkDG2nQFHuosLAQsyMgpUfS6uYrLZvqfIvTsqjvFKeFSi0zA/WiNCXphxiR4n
         oyRE1RNi7Zbmp/QZ/IH6CIQEuHe7OKL6CQzEyh9DPJV+Ohp1VDSSYR8KJvrSbcR3E8Ws
         ki5L56IKALeQeDx0IkDITX6+Pay/Xzw4O6hgtK97YcM/kYCGkfNvSBfJ9jto2QULF3t2
         axVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242372; x=1771847172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MzVyXr7yFI6MFKXAZM6Z4ZQG18h3wTttjUaEIKBcUaw=;
        b=syuZ5IQ4MW0a3TjPaHl5AerFTsw1Y4r/SSKrwSfbt6E11ZSMV+5T/siEGoFpBQvsqx
         4MJ9ZXLai4k4D6uIv6uTbRaMpFc6JWRIyNd1Y7KZ4s0sQxAFv5EPgm85UjKCMNiCz2h4
         5fLS9Hrc3hLliPsm0a6whDkQju/H+LgBu3ep7XzrtmQxEv6GsmKfbTl6x6BDVWdMdIdt
         p9+LfZew30gjWYwcEGMQJkivnBOkPx0fs80/mmzvXju/zHF/xX4X4Q8SVlqAtrO0sr1e
         R0JMEWN7aAKxUJ0LruV7hRLER5xh2dCTfX5XLomgCIdmxitD5PDBiEHjHZ7NC+WFWSLM
         /+aw==
X-Gm-Message-State: AOJu0YwwBpzsRtvyySEqsKdTVUxPXsMPijRYZBWWj8rqxEGkKhv+ElDX
	jpzeCEoo/sBUlv7XiDyzq60Z03yTwOqpXpongGvBBGR7jcLWOYDgNnpVtWPfdQ==
X-Gm-Gg: AZuq6aI5cZ3bui95KVvVUY0FaGzICsIJJiqGEpXKOiH9SJdFsXsz+hcgXzJrLNizabb
	+sm/tYQQnfHKKDu3F1vzx9XhPQcYoll5F64wa1k34fEM0tIv0zUYcNFGwHW8CkU5new02khwlyQ
	fpolhizZTAPFWqDZwtSPcpbB1RyccgRnkU4RIYPzGy7/wKpmJeUKx5xw/ZC5KBl6yzpc35QuFCj
	RcAhtarne6DS9TY6DvJI95W/QnzJQRKSsapmsyyiInOtJWifh1xgJ5Go6lzO5scoJrK3lBx/v2V
	sWe3LWA4HxYfwA7Bgm/GGz4QbzVaJfFBgRyGY8CKv5oa23eb33pIE20mzOXk6xPCM+ejKFKKM0O
	r93zBE4+vfGl21Ev46Ym+04Ba/lIENiLtv2WN9NVeSo5AraeYP3ClowGgtYmZh5fjT43K3iYjX6
	YslKfp1xqMegeB4uWkjjwd2L3YepuxY9do0rHUNaS8TMbPfTQ4AV6UCdCrldMZE0lc5gRUx4REJ
	Sfm/FyB
X-Received: by 2002:a05:6000:601:b0:435:ae97:b37 with SMTP id ffacd0b85a97d-4379dba75fbmr14994033f8f.52.1771242372281;
        Mon, 16 Feb 2026 03:46:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b4cdsm28991802f8f.8.2026.02.16.03.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:46:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 3/3] io_uring/zctx: unify zerocopy issue variants
Date: Mon, 16 Feb 2026 11:45:55 +0000
Message-ID: <3902d90bffaff8888da3d6ade5b8b9417f75be6a.1771240334.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771240334.git.asml.silence@gmail.com>
References: <cover.1771240334.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12240-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC2511431C3
X-Rspamd-Action: no action

io_send_zc and io_sendmsg_zc started different but now the only real
difference between them is how registered buffers are imported and
which net helper we use. Avoid duplication and combine them into a
single function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 86 ++++++++----------------------------------------
 io_uring/net.h   |  1 -
 io_uring/opdef.c |  2 +-
 3 files changed, 14 insertions(+), 75 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 88962b18965e..7ebfd51b84de 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1469,9 +1469,9 @@ static int io_send_zc_import(struct io_kiocb *req,
 	return 0;
 }
 
-int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
+int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned msg_flags;
@@ -1482,9 +1482,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
-
 	if (!(req->flags & REQ_F_POLLED) &&
-	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
@@ -1493,87 +1492,28 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			return ret;
 	}
 
-	msg_flags = zc->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		msg_flags |= MSG_DONTWAIT;
-	if (msg_flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
-	msg_flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
-
-	kmsg->msg.msg_flags = msg_flags;
-	kmsg->msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
-	ret = sock_sendmsg(sock, &kmsg->msg);
-
-	if (unlikely(ret < min_ret)) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return -EAGAIN;
-
-		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
-			zc->done_io += ret;
-			return -EAGAIN;
-		}
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-		req_set_fail(req);
-	}
-
-	if (ret >= 0)
-		ret += zc->done_io;
-	else if (zc->done_io)
-		ret = zc->done_io;
-
-	/*
-	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
-	 * flushing notif to io_send_zc_cleanup()
-	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_notif_flush(zc->notif);
-		zc->notif = NULL;
-		io_req_msg_cleanup(req, 0);
-	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-	return IOU_COMPLETE;
-}
-
-int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg = req->async_data;
-	struct socket *sock;
-	unsigned msg_flags;
-	int ret, min_ret = 0;
-
-	if (req->flags & REQ_F_IMPORT_BUFFER) {
-		ret = io_send_zc_import(req, kmsg, issue_flags);
-		if (unlikely(ret))
-			return ret;
-	}
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
-		return -EOPNOTSUPP;
-
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
-
 	msg_flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
 	if (msg_flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-	kmsg->msg.msg_control_user = sr->msg_control;
 	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
-	ret = __sys_sendmsg_sock(sock, &kmsg->msg, msg_flags);
+
+	if (req->opcode == IORING_OP_SEND_ZC) {
+		msg_flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
+		kmsg->msg.msg_flags = msg_flags;
+		ret = sock_sendmsg(sock, &kmsg->msg);
+	} else {
+		kmsg->msg.msg_control_user = sr->msg_control;
+		ret = __sys_sendmsg_sock(sock, &kmsg->msg, msg_flags);
+	}
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 
-		if (ret > 0 && io_net_retry(sock, msg_flags)) {
+		if (ret > 0 && io_net_retry(sock, sr->msg_flags)) {
 			sr->done_io += ret;
 			return -EAGAIN;
 		}
diff --git a/io_uring/net.h b/io_uring/net.h
index a862960a3bb9..d4d1ddce50e3 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -50,7 +50,6 @@ void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 91a23baf415e..645980fa4651 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -437,7 +437,7 @@ const struct io_issue_def io_issue_defs[] = {
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
-		.issue			= io_send_zc,
+		.issue			= io_sendmsg_zc,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.52.0


