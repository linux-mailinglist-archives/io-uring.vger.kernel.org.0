Return-Path: <io-uring+bounces-11763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A9BD38969
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6D3FF30186A6
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502DC31329B;
	Fri, 16 Jan 2026 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wQRosQZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06442F5485
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603443; cv=none; b=aSI/sF8kEM3G92WhHhSU4WT3msZhWRcGFMJSCVrPFNUoDomBBkkFdHjTcy2tlATtaNhluugygbBiSkh98IqBdkLiFAcq0rfSH/R43+FWvkrv5PFxEAdk8/THqHdWUXlQ1eRveUZkywItXk+RaoNKJwrFxsOmYx3PwTNuayQk7rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603443; c=relaxed/simple;
	bh=bFcgEEVsZwoudY/Kh8DFbbXRGk5pnxsuRqmQnV5MPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUwRnDmLOIlhBLkz+IDXfudHCM4zZ133HfuYPjYGEHgrIBS2kF9WdCqgNFXIpH6QUcBej/INmgXNtlMQme/LF7ibGLnbkZ8n0mbRPoLObfLvO7jNbFuEkq89leInQ8tPVc/P+XD1yuzrl0gj7mLp2xFxFjiTP+Bi5bwwnTp8PDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wQRosQZR; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45c93e60525so1145601b6e.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603440; x=1769208240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OADFySmG45s0JxoyyWOZQP8lh8YxNhFYWCn0xfR93hE=;
        b=wQRosQZRCBX6QLwNpHqrpJZRsEn3SjVena9PO9QPZwvu4h2FzVFFFkzq0Ry5thzge+
         gcrm7tn1Am4pT2htMQMEu8GSchLrbK0Y+UNL8GIFkC/8ENvIDinTNef1bvpMM0d4uoal
         uMKrambfPwxN75RUI/3DsoRwBXQ/V+2CTMV8E1jSCMOzEzOAtNsjfVTCEsKds7pMpXWx
         R7UOREqzxs39ftX9IX7+3JHdOyMhJh26oLxOh1Guein/aT67fMDjMl/X7s++ye1IAf++
         UjQWSTC4u0biTkxg8JEOdy2Q2lip+fLp1ML2YId7jU5WmMwYBtq7Bn7Gi24vSOXE+sRD
         D4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603440; x=1769208240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OADFySmG45s0JxoyyWOZQP8lh8YxNhFYWCn0xfR93hE=;
        b=wUgbcitmuPYq8PhlWUK3Sj3OmU6L2inY3H1XkGWbfp+GwaLMjaiJBi4cFIHJyV/WuJ
         8glUt3Ry4u4qSHUIgvr6nvjzfv+tkUiW9VHlvgZy5tYglx4m9KiTR8Ii5rybvW40HpzQ
         n7b5jySE+ZgvnA3BUBLJBHlbiQOnpLXmvMUAaAR35cSEqaSDhbh5+3F0n6M6+bA69g9K
         s9/ETCBQsgDMbmufrnFBGvRDUstNSAdxVYneOth4sOsm5dOVpDuEzk8vAVnyYX1neWJ+
         2A+8oSYEuksJn2DkexYKSfKdiywuZwyK6jYOVrKIpF92yDXN+daFlOpq0/LI8zfDvvYR
         Zq6g==
X-Gm-Message-State: AOJu0YyIl2oGXFRbRvKlcvBWLwFDZmsqZBk5aQEh2ugNu+VgY0TqYjOf
	Zd9qNOKDgpXhSj2QUA1RnWXmqbIPCMEjkUHdL4E2shtWLdgP9L4Pl65i1BB9nsqluUbfZW8BNpB
	Va4jH
X-Gm-Gg: AY/fxX5eFXWMeMwjtGSAAXM7C/7CZuzjcvATJEstDrSolpmPtfFwA2Ev/5scWnBWxgb
	z3TqoNfjtRrxVebs9hyaXfySS3PO4RIdy5s4+RjJotLieD0G2Wfa0tRLXFOfHNICZ6DOtpwaVzk
	YJYarQC1Q8rdeu5mjZ+1glcDXkFEYnDqM+4RvLE5XjH/qzgF5Jjh2youXm1GRAhr6fuV0VmScOG
	Q+bZFbKB9fCG2VIwivjpHcxbnepzTxHDu6FZuU2/reYFIbIZActypYwJsA7JSGLZNiziPQW1PEn
	ADf7geHq88CoUrHOR801qS3ZTkbOrqo9UyIockl8g3z7/raNbtIzMr1Q1U4VCqLzAzoM3H1Wpx2
	wdCvq/Py1CCdwt7ve4fnRFEVezKBNpEicwfM6+J/OdFuiQ242bVq0mluJ274KWGa7eZNno2M92s
	t5OhG1Eap4A4rD25LHgQbHSQF5Szgh1cRK+Of63uQM53iyib8ryLFEI5Dt
X-Received: by 2002:a05:6808:1802:b0:43f:7e97:3983 with SMTP id 5614622812f47-45c9c080e31mr1837448b6e.41.1768603440476;
        Fri, 16 Jan 2026 14:44:00 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:44:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/net: allow filtering on IORING_OP_SOCKET data
Date: Fri, 16 Jan 2026 15:38:39 -0700
Message-ID: <20260116224356.399361-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260116224356.399361-1-axboe@kernel.dk>
References: <20260116224356.399361-1-axboe@kernel.dk>
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
 include/uapi/linux/io_uring.h |  9 ++++++++-
 io_uring/bpf_filter.c         | 10 ++++++++++
 io_uring/net.c                |  9 +++++++++
 io_uring/net.h                |  5 +++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 768b0e7c0b57..27839318c43e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1121,7 +1121,14 @@ struct io_uring_bpf_ctx {
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
index f63a8e9e85db..74969e9bc3b4 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -78,6 +78,16 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
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
index 43e5ce5416b7..eef6b4272d01 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -44,6 +44,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
@@ -64,4 +65,8 @@ void io_netmsg_cache_free(const void *entry);
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


