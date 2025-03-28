Return-Path: <io-uring+bounces-7293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F5CA752CF
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1526189020C
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69C01F4CA0;
	Fri, 28 Mar 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWqo43mA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA81F4C8B
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203432; cv=none; b=LhJKk10NLNoh8oO3FPkrImwSWP5H07W5ckCVzPdbx8oh4XnPTcDtoym/mA9qbV2BY+6REEHCTbpm6fOBssZAoqjBGinoyheIufsDsirtfnOVueAguRvrsg7WwuY0HUt01hKi57BI4oZ58SS16J4KWcSQ5UYVPAdgl8D4zXF1rYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203432; c=relaxed/simple;
	bh=iIvhi2AVRhhXlh7mBMZZJms52m2vl3jzgThUmvX4jNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNMa+GsoKWSkrDdvYePnhx+DWCo7yYahXdMP0eynmoe/Yx4x0wxH+yli4gpfvk3oDvaeGPVsvCxw0ToU/6K2kECSH6QjSkveULLcl5iuIP4EBwxT7svJ8Cm1q7A69bEqKK9h+/Z9/6/lggvJd6SOEvuIayLZk+PH6iNCfb86qdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWqo43mA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e66407963fso5109153a12.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203429; x=1743808229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cy7Sop//9jk/fDE3IuJ+GB3m0VFXoWlKNpr+QpyH+4=;
        b=AWqo43mAhk/tfHTglMH2Mf2i7XmJnopdySZr+bgcgI0X98+2X7ZxVsLhDtGrSr6j7S
         /qkQIYYrEVOvwgJWaIUCpLE7ak9CRrcb1ubgwZVh66O+bNZeWWIQX03rH3rDBWq7G/Qf
         ortglQSPBHyhb36P2/61j0OCmrY91mU8/Ros06z1iIiQNOTUShM/XU7w8Bf9MavNs1lG
         c81vLwGdL+cWU9VzXYLINyF8BGMPqZmQuEOeO7XQllMkuVepOO0KNqU48nUJ+GlQ+GmR
         FKSQ5a6828xCV8l6TRF3Wu8iXh05cgqweM4u5DCCsKazEewTUHIlqOiYC61eM1Ofx8W3
         XtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203429; x=1743808229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/cy7Sop//9jk/fDE3IuJ+GB3m0VFXoWlKNpr+QpyH+4=;
        b=Ap62Xe7kq9EWt3sB/hAvxkX+hD2xsV/7++2LBH5R8Odaqhlh/vQZKpGVre0gZy0UQY
         wJ4gmoKkz75+zz7CQ+TZjI+Um30wZttnOFMTbjtDXMjwRiEac0I9pmqojUov5jKJal9T
         nbTFvXZv/AjAu3/5rjcG2CqQCGCJYV4rfJEIb2or04DbzmsYMOEdBok0n2jcqQjQ9Ks6
         IjKIByGnhkfycf5NyJlV22owqU/sIeNr7uOPufb9BMdEYwPvXnUtH8HBO0VUyGA/5HbK
         Y63qHjJY7d7z3uiC49NHV+YFVQM9IoJjKGgW7M2Uku421DVHSNj7OnSvaIZkcLe73/T0
         JkVQ==
X-Gm-Message-State: AOJu0Yz9aHzw2hLJpZkRiDmN1uFVoESfoDmheHGEaf4r9l5pG1wn0UHm
	WIwU80Kj8Uy/yyj9BDneljHin7AdYppXH9hsTsoISQ5D5OIjrT94DpYDag==
X-Gm-Gg: ASbGncvE/jj1XD8YwGtXqT3GMMXaEZAlIZj0JXZooikWaLMAvvH3o7pHZ7TNskU4/WH
	Z+azM5Zzl0UAE5keZHbfdwh0PqX3mmfKdFzgexmHp7l4cSoXF14vpYHsjNi+fR74yrqUt0yJSNL
	CmolSWLmIHIL9LWcrBR0prLdm7xP1MnYLMTQrrI2K2COhJo0ALc1yBKu6pEnVD9a6gMU8+Uf9Br
	uMToF+702X8Mpbr0QOBAGhyUHGqlrOyoUqwP6B3vgTGoawa2g96rre3CG2VStNrXddKHl6kSZrg
	tY7bEewtDNKO+f+qzfa+u/AOlqF5w/mBSIqHUkovpqGFAmFz/nB6yHPbteo=
X-Google-Smtp-Source: AGHT+IH35on6M8Eb3A9vdOlK7HMDaI0fT9f6pSQGkjgkhpS9eYgJGIjKZ0TWDnNYs8mOOb71zLKABQ==
X-Received: by 2002:a17:906:6a10:b0:ac2:6bb5:413c with SMTP id a640c23a62f3a-ac738a9700amr101345166b.31.1743203428563;
        Fri, 28 Mar 2025 16:10:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring/net: set sg_from_iter in advance
Date: Fri, 28 Mar 2025 23:10:59 +0000
Message-ID: <5fe2972701df3bacdb3d760bce195fa640bee201.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to the next patch, set ->sg_from_iter callback at request
prep time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9162dc6ac5e9..f3eaa35d9de3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -97,6 +97,11 @@ struct io_recvzc {
 	struct io_zcrx_ifq		*ifq;
 };
 
+static int io_sg_from_iter_iovec(struct sk_buff *skb,
+				 struct iov_iter *from, size_t length);
+static int io_sg_from_iter(struct sk_buff *skb,
+			   struct iov_iter *from, size_t length);
+
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -1267,6 +1272,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_async_msghdr *iomsg;
 	struct io_kiocb *notif;
 	int ret;
 
@@ -1309,8 +1315,15 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (io_is_compat(req->ctx))
 		zc->msg_flags |= MSG_CMSG_COMPAT;
 
-	if (unlikely(!io_msg_alloc_async(req)))
+	iomsg = io_msg_alloc_async(req);
+	if (unlikely(!iomsg))
 		return -ENOMEM;
+
+	if (zc->flags & IORING_RECVSEND_FIXED_BUF)
+		iomsg->msg.sg_from_iter = io_sg_from_iter;
+	else
+		iomsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+
 	if (req->opcode == IORING_OP_SEND_ZC) {
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return io_send_setup(req, sqe);
@@ -1321,11 +1334,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
-	if (!(zc->flags & IORING_RECVSEND_FIXED_BUF)) {
-		struct io_async_msghdr *iomsg = req->async_data;
-
+	if (!(zc->flags & IORING_RECVSEND_FIXED_BUF))
 		return io_notif_account_mem(zc->notif, iomsg->msg.msg_iter.count);
-	}
 	return 0;
 }
 
@@ -1392,7 +1402,6 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 					ITER_SOURCE, issue_flags);
 		if (unlikely(ret))
 			return ret;
-		kmsg->msg.sg_from_iter = io_sg_from_iter;
 	} else {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 		if (unlikely(ret))
@@ -1400,7 +1409,6 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_notif_account_mem(sr->notif, sr->len);
 		if (unlikely(ret))
 			return ret;
-		kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
 	}
 
 	return ret;
@@ -1483,8 +1491,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned flags;
 	int ret, min_ret = 0;
 
-	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
-
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
 		int ret;
@@ -1493,7 +1499,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 					&kmsg->vec, uvec_segs, issue_flags);
 		if (unlikely(ret))
 			return ret;
-		kmsg->msg.sg_from_iter = io_sg_from_iter;
 		req->flags &= ~REQ_F_IMPORT_BUFFER;
 	}
 
-- 
2.48.1


