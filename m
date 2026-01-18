Return-Path: <io-uring+bounces-11799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5813D3986B
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94DC63009558
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F2723EAB2;
	Sun, 18 Jan 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jPSBnfjR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D877816A395
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757016; cv=none; b=hU3B0LaoK9qujZbkb+QdGcEdpK7YTChyGpVJoVF5cVw/F0nXIb5hMz8fkJUv5XANFFvZ6y64JmI4R+juTiEAsqZeC7vM1IfTb70hqTBoIDLApHbi6v+AzfM+H5tie6cUInYrqNiMaD7QQn91wpgH0kLWz0ftD6x90mAYKkNz/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757016; c=relaxed/simple;
	bh=hyOkguUOUGpKIHx7+bZtr3JwR71ERBEljHoy7VM9b+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byKr5K8g4Or24y8xzSK4HRYiDeZYZMTaW8vPIQKFvbqqCpgEP2/YzQKL/cnjN0HYFtjSBmPju8j7MF37oZdg2Pr7Wubfky0FRt3VPoBxwYOeUJavabZ+KX1dCJe9x5Hfp9CtiC2UP3qeUZjtbzJ7L6YLGCzL8H39nSQ8I33cgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jPSBnfjR; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cfd819ae5eso1861903a34.1
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757013; x=1769361813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8FbSLtA/iUXtV+q5VcrKKdn+M8LqnzepKXFIccyjIA=;
        b=jPSBnfjR1r3Vc3Yr7SVKIAP3eJrZr16SnkpGvQjyd4iqFCDMzZOK5MOTbu8hzpWPq2
         oN9fVRPHo7rjBk9wuREyLIMhUUjXlJ9cJ5dneqIH5zvMA8zECeTnByIIj6eMmB2M7XqA
         33OuP/RBxmtJlZKYpm35O8zVvsg+vP9n+dy5kPXvwfxd0swsypx0XRmHtY0AV7Ua3STL
         Sk2qLI81yaKNhL+tWqKRq0gWIDQC55XF08hqoRTzrlFFeFwwudeXz7g6oG4llQb04dKR
         DS6ZWn1oq1siw+WTo23FAIgZkotS9j6UwPq7e+myFQh1kXD5k3MXd6+Nnn9egENgnbkJ
         x+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757013; x=1769361813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E8FbSLtA/iUXtV+q5VcrKKdn+M8LqnzepKXFIccyjIA=;
        b=mcewO5/ib7xgtqsTv02nFFLbRw9FXzua3kktyKNdAWVNbGEaReqFxrsLGOucersQou
         xH+8PXGXNVpCZqZAPoUZJ5fgJEXiqdnT2OrXrBvOhWDH6AmPqNs6xQiF37xj8nt3P96a
         76wvN+dzBtyng9iD3xn+HJ7XrdPFIO5MCnfxCHQdvueg53Z8hO17gP6ONxr5pGRhgCZr
         P5ciX746SPq4M70N/cKsKrmNjyi/WIQ+kvTAaS9Q8telf2sHJifmnAOuHsIVmICQ7eF5
         xtRttAjTN6TlvhBnCZmB0nax7qCoKLh4QqGwrqMn7tN9g7zWn7voyAuTYhgxcNhoYL7g
         daNg==
X-Gm-Message-State: AOJu0YwMCsa1lbOSdQnU7I4QVq/hjddsXxVsA27wODVYHA1NtL2hUb0q
	+0Jps0UPLxdmNrSe8RnNV3O8F7fkE4KBDA8LTasNBMImgNacVZE1U5ljVCKDM2lVGy3q+fvsr9N
	FH98d
X-Gm-Gg: AY/fxX78jJYztPiRrqOuEoW+VGvAv4IYWNo3btNRhE1BX4A5X8yCt9MfLbfxKuUlPWd
	3OlIwl6HMS9X5bR1iPWGVAP7Ldmm7aCWRTpC0Jrv5rFm8CAI1LKgt9En/m53t0YH+7e7zA6pCy7
	H3OUH1EN47t9WFkIl2oPkLFdByJ4h05j0Z7QM+ljL9cGIbQnOcXKxnZ/D/2wKghzxh1E9FnHgPZ
	jjxeU72qRXIJv+ZP/O8F6T2qej631dEyiJzptieIeTCSUrjs4gLo8163uuug5CHJCKac/k4begD
	WqXPwPBVhGF8VC9zw+AUcyM7h6bHMKQDnNLaTzywlD4Xpzp8FUGSA7a/n6cMrDbwwKzOVsrCLIZ
	GuB9fiDPmMGwo/J3ijQVaT+WrljX48iHKa6UaIrkkBYqybLN4nbm7g+d4bSTqaPhNFHFyVMJar6
	SQitgogbFx7zkJxd/u7zhgU6NCc3JdZsa4Bf3uFTCLPZvtTnb15pqqg/+h
X-Received: by 2002:a05:6830:81cb:b0:7cf:d191:3a76 with SMTP id 46e09a7af769-7cfded32872mr5471195a34.2.1768757013588;
        Sun, 18 Jan 2026 09:23:33 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/net: allow filtering on IORING_OP_SOCKET data
Date: Sun, 18 Jan 2026 10:16:52 -0700
Message-ID: <20260118172328.1067592-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
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
index 14bd5b7468a7..e7565458d4d8 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -12,7 +12,14 @@ struct io_uring_bpf_ctx {
 	__u8	sqe_flags;
 	__u8	pad[6];
 	__u64	user_data;
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
index 48c7ea6f8d63..63996b350e60 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -28,6 +28,16 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 	bctx->opcode = req->opcode;
 	bctx->sqe_flags = (__force int) req->flags & SQE_VALID_FLAGS;
 	bctx->user_data = req->cqe.user_data;
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


