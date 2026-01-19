Return-Path: <io-uring+bounces-11824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D571D3BC27
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9BEC305936B
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E073D2DA779;
	Mon, 19 Jan 2026 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mhy6hlra"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9D029BDBC
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866906; cv=none; b=hxi1t9wf8KVoy1g6w0XqtMmaRYAoWI15CNuLhIY9/q53EXgeOc+6/SWlN5jSqkbLXZib1oWkkoZbYPOi9dZdGpEPFfnnw3scPlV7Yg8uBCWkHxE3xTeNcuhH2PDxPjSFqHH+p4/QPq7eTmlCbD9ZZs7TaDDLoEl9ZcEalK7zEHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866906; c=relaxed/simple;
	bh=C9C+IU1pA+5Fb3cPH0ew3W1/JrGbtTU07hYMcQtLXSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9CEOxjK9GgO5A30QssJWsen+E0/3h+EQWhGvIj2myJBvFWUQoMAJ2Q0b/B4BrL3f91mpE8ZPdY51AgPoW//Ymn0mXC1jHw7msi1mCEfCMrHYek41G9tIutIQRPkWyHbHDS07lvPUtRH8mUw8Tw3a5hCs9D+ym+iLr7HU1Tukjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mhy6hlra; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7cfd95f77a3so3133746a34.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866901; x=1769471701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gUWeWDz/48yCjzxnphLYuWL+CABKXH9qFjCUViavDY=;
        b=Mhy6hlraW9cYJnejpzsav4WDFjcUEv1CnUh4lLcor94hJRiZBvuJjcOMUuGtDKwAa9
         fJBjsF+6LafLwer8zY+vvi1wpKgieoFbNYB8ivx+XNVpzLKA/UqofnjvxMN/9x6wKW55
         3zWcMNTF4vUZHrihyWs1eHgvvYq50UqalGSHYkYuGUFGEqk+HIvs2A1I7T1p/RpUwoi6
         79KtZpLBDU0Gjv2rLJcraVO6BBkTLm9GJtkTfaptTVAsbIi+xkPvNqlFUcHlEN2pTqZM
         g/4bL1zpk/46NNGjdRnWGxnpFIn2VWnlhosXsW6CBXy/el0elKJjZ22wk2pP9eXZhuTM
         lG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866901; x=1769471701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gUWeWDz/48yCjzxnphLYuWL+CABKXH9qFjCUViavDY=;
        b=qNr9XyxSFEGw/7O3lsmT8d4AjwerQEJ5qbJCobAhqed5XrFnZodBPHTDiz69ULsdk0
         DORXv0hwMFnUY22BRSJQv+Km5eR9duwo9up8nLRkmXsBeeLrPuUB5h9b9cH6Jb4qmj2y
         Eue/7a+X5bdHha6aAVpBZ2m+L2q8Lxs2pkei2eNeueGr+GRvkAryn6gfoBSprLYZncuu
         EZ8SE7+uCF6WwCpIEkYhgf7z89ec3Nidqw7se1rl9BN0zVkoeXKJtxVArUvDojkDGC+1
         awN2OTPzHjllb379SxK++Y7XxG2SPRRkp0zY9XF8ta1v+RGxyzgmzr5XE1PGrxMwRbP8
         YNJg==
X-Gm-Message-State: AOJu0YwSNIDeEcNXgYWe3dqPpfoD84yEgH2TINy5AXJ8VhaN4+1I+/9v
	8kterZ4OnUkC85lT9y7fL1V7tOM2SDLLCDC+HzD3qsALgi+JYgaQa3B3x/BR5Eewj3jB4ohZi1a
	5dSyr
X-Gm-Gg: AY/fxX4UiIZ9jCwq+aZS63xWo+8Zy/Yb4/SO3HLt3r24ikZL6DYToFgCEuPQ9dLKcYG
	aIbNvaSbsvgtmDNjAGtb9sp28B6spHZSjs5a6nMk5lIEAUExt2/zGi+gwgjQOaaDlp8k9AclP0T
	u0nLXAXFSUM4kXfOqsKtteWTeY2pmpM3mlBkW+nxozvy64rjOttnQAw6/TFGDhjiwZnXFyrIRjr
	bl4pJjmU/pcYKCNo1gDBZ5vryXC+cO2bjM7RwIrjqZpcpo3ufucahYP53ZulG8HBzREWtDixMup
	G0LOYFzVtRvv3xwl2y1Q8ULPNNinsNAQ+RnjEv4SF4uen1mfqhT3sI69jNCEhDS8JKXdjWJOQX1
	JiKArnMjxjbDsgtvh72oqQuiSOD/g011Lfa9OKvjutRUnwccHqjzmuUk9+2+CpucF4o/VH85hHf
	ItstC4Y6LjNHNWA+TduBEYmE5n6uWwUdF3gjv7HC8Mm3NEE8OKnBm3+0E4
X-Received: by 2002:a05:6830:2409:b0:7ca:f5d9:f767 with SMTP id 46e09a7af769-7cfe01ceb64mr6657513a34.34.1768866901627;
        Mon, 19 Jan 2026 15:55:01 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring/net: allow filtering on IORING_OP_SOCKET data
Date: Mon, 19 Jan 2026 16:54:25 -0700
Message-ID: <20260119235456.1722452-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Example population method for the BPF based opcode filtering. This
exposes the socket family, type, and protocol to a registered BPF
filter. This in turn enables the filter to make decisions based on
what was passed in to the IORING_OP_SOCKET request type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring/bpf_filter.h |  9 ++++++++-
 io_uring/bpf_filter.c                    | 10 ++++++++++
 io_uring/net.c                           |  9 +++++++++
 io_uring/net.h                           |  6 ++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index 8334a40e0f06..ad6961be5efa 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -15,7 +15,14 @@ struct io_uring_bpf_ctx {
 	__u8	opcode;
 	__u8	sqe_flags;
 	__u8	pad[6];
-	__u64	resv[6];
+	union {
+		__u64	resv[6];
+		struct {
+			__u32	family;
+			__u32	type;
+			__u32	protocol;
+		} socket;
+	};
 };
 
 enum {
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 08ca30545228..8934c0586842 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -29,6 +29,16 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 	bctx->user_data = req->cqe.user_data;
 	/* clear residual */
 	memset(bctx->pad, 0, sizeof(bctx->pad) + sizeof(bctx->resv));
+
+	/*
+	 * Opcodes can provide a handler fo populating more data into bctx,
+	 * for filters to use.
+	 */
+	switch (req->opcode) {
+	case IORING_OP_SOCKET:
+		io_socket_bpf_populate(bctx, req);
+		break;
+	}
 }
 
 /*
diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b761..4fcba36bd0bb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1699,6 +1699,15 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
+
+	bctx->socket.family = sock->domain;
+	bctx->socket.type = sock->type;
+	bctx->socket.protocol = sock->protocol;
+}
+
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
diff --git a/io_uring/net.h b/io_uring/net.h
index 43e5ce5416b7..a862960a3bb9 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -3,6 +3,7 @@
 #include <linux/net.h>
 #include <linux/uio.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/io_uring/bpf_filter.h>
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
@@ -44,6 +45,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
@@ -64,4 +66,8 @@ void io_netmsg_cache_free(const void *entry);
 static inline void io_netmsg_cache_free(const void *entry)
 {
 }
+static inline void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx,
+					  struct io_kiocb *req)
+{
+}
 #endif
-- 
2.51.0


