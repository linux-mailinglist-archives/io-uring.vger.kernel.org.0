Return-Path: <io-uring+bounces-11375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 388E2CF59B4
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 22:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD84E30B3A73
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 21:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229B12DE6FC;
	Mon,  5 Jan 2026 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Nq9kFQ5+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f99.google.com (mail-ej1-f99.google.com [209.85.218.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA242BEC5F
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 21:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647154; cv=none; b=mMmlMXjrFWQ/JtLvMnNJtxZC64L775ZEWBD74iS9ny/iLvQrqY6OX1KR/+80vdpamBTnq+lawf8N2/eECSIaTjYynl6WvUHhQXAM+p+FuFjT9rkAuVCYgXVEa4SOfXtUXa8cLmr0RzG9NQ+4HNCmmeuuvEiCQNDAr91YlxzRVbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647154; c=relaxed/simple;
	bh=nmBi4ylBnlgJaFlrj3RVOotCsUXiNn/BE5TBm+oiiek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJwB8xS5+Fypl/zCzjUMYdu+Dc6oHoJ8FH5iIVDmztjGtSU+TfzF7hgRmDwhjrCLTTU69MuPIb36Zzkg0j1xy/ImMQz0gOXqb+Cp8m7pUysiVrWS+/uLnJo/U71Z98AK4SYEZDBz6idtqDxc9NgHZGaYugaYulyM1BkRXfqtAGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Nq9kFQ5+; arc=none smtp.client-ip=209.85.218.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f99.google.com with SMTP id a640c23a62f3a-b7639da2362so6897266b.1
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 13:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767647150; x=1768251950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyfDolQw3Z8ZI7bCxJjqh+dHMcXjL+jvfGwEoLEbA+w=;
        b=Nq9kFQ5+AN+Kr2SSBDet0wSupF0Wf+mntZS+CIHNd9Oi99NhdE9l87rSfMriFIpCLN
         VYP7irPOPQqtHyMSPQGAKcJAL6kLUx3HZoRV8gX4MBhM7p5dacuIrlQu+Rlz1HuMEgXg
         SaunMrwTQbitElmfzv/bqO+QVUksTB3cT3i14ixVoE7Vl3XmMFb33y+kPWnSZfZHqt3k
         1eejXHHuapOP1SHcuc+y+zG3pizG10ZDzrvdWS3mRQQtHaU57G+83g2Y06ip3/Ob+aik
         n7c2EQUTC3s1acvTIxX8/c5mZPk1xpnT7hIzauWEEJ/sWVlVACJiarp/shaNkMh9axHp
         egQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647150; x=1768251950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyfDolQw3Z8ZI7bCxJjqh+dHMcXjL+jvfGwEoLEbA+w=;
        b=QEmnGtn24wv6v6kffVEelZ2C2f3WpgL9MdBzJ880L/T1KKYaKfV5hkWNKidd3FqdFT
         yb/tFDoCQtsn94Ct3XWTt+bMZrik8c8lL/IrCqKdh9PsLNrIcysB3gQ4br+jcxlSoy+n
         HOSyqxry0Ey2ZNddMwGgNhRd2U1Ae7beMfjieTJP+JSyUgpvz/e3bGJRzkvt/JZq6eiW
         GKmwGSwyzk6DlLe6LA2w+cmqMSMErxvaNZ2AA0Y4PxOoxndC/amLtwmpz1yokekecdQd
         3+X2z/ZuoGwtTS75TvD8faXrAeAhoSAk21HWHfSi3h1iDtrTwZ5YYmuucOHd4Bc3Mqq5
         nFiA==
X-Forwarded-Encrypted: i=1; AJvYcCWU98MkLWX7F/MJ63M+2SZThY0TlLfsvs8emcdpixFSgsLJN7AOOk92a36cCLbYjVgq9G6ojekYtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbS8S06hwoqiEgYxF7UyVw98+vWkIKg+Kbg4myI4hSszp1PE5s
	nFB7ttc15BfYhxs10WQFnqrKT4Cq6NQUVAqlyaW5CDIySoyJbeuTz3ze9RoJONLwZR7b4in2jlz
	YEWpUg3rLlYkggWwgBLT7O1/ytFuhTu2RFb3p
X-Gm-Gg: AY/fxX6PgXCCShVv1Hdd8Cc4/0ZoOL8M09KSdoqamGLAtwg53/ccT6hoH7mSsk2AWzx
	80SB26UF5VPHLnniI6epsAbgOkSgaF6zFYox8+ylaX7kwMj/TKb9KeuYn68+a61CS6cq1e7vuKU
	i2MU4q5Tqxv+P3LDw8ZLnlgQopCOPol2rg+gj1gWZKPJn4rrsbgBYRjSSvd2OKD5tk5+J4/OLiO
	6lVK/IgQ4ZbTrjwWWf/UqFUtYo2FO8PdlORRt6mttFV+8uemtgl02JRmYqv14yWY7Vv4QRjBSiS
	goAUYD4VkAdNPlWr/Bds96KUSMl67J1kCUrLH2dj8XsCInhUF721kUyBTjR/bqZIgHOJux0Zg+d
	+Lvg8dmMKqpba/UDd/hJMENykrgKIw8mVMT2jsaZljA==
X-Google-Smtp-Source: AGHT+IGc1AymejhJS1np5fvi3CQGGvWfBlkLpPX2lfbta2+WC+h4KeaHA/L36auASuU9h9NFThmUSXgJoIFh
X-Received: by 2002:a17:907:1b0f:b0:b7a:2ba7:18bf with SMTP id a640c23a62f3a-b842703f9aamr58945266b.5.1767647150443;
        Mon, 05 Jan 2026 13:05:50 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id a640c23a62f3a-b842a2102acsm1270766b.1.2026.01.05.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:05:50 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.49.34.222])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2B16634173B;
	Mon,  5 Jan 2026 14:05:49 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 27FADE41BCB; Mon,  5 Jan 2026 14:05:49 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v7 1/3] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Mon,  5 Jan 2026 14:05:40 -0700
Message-ID: <20260105210543.3471082-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com>
References: <20260105210543.3471082-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
This means they may race with the assignment to ctx->submitter_task and
the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
io_register_enable_rings(). Ensure the correct ordering of the
ctx->flags and ctx->submitter_task memory accesses by storing to
ctx->flags using release ordering and loading it using acquire ordering.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 4add705e4eeb ("io_uring: remove io_register_submitter")
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/io_uring.c |  6 +++++-
 io_uring/msg_ring.c | 12 ++++++++++--
 io_uring/register.c |  3 ++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87a87396e940..ec27fafcb213 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3254,11 +3254,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 
 	ctx = file->private_data;
 	ret = -EBADFD;
-	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_uring_add_tctx_node() -> __io_uring_add_tctx_node_from_submit()
+	 */
+	if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED))
 		goto out;
 
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7063ea7964e7..87b4d306cf1b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -123,11 +123,15 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
 	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_msg_data_remote() -> io_msg_remote_post()
+	 */
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_data_remote(target_ctx, msg);
 
@@ -243,11 +247,15 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (msg->len)
 		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	/*
+	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
+	 * in io_msg_fd_remote()
+	 */
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 	if (!msg->src_file) {
 		int ret = io_msg_grab_file(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/register.c b/io_uring/register.c
index 3d3822ff3fd9..12318c276068 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -191,11 +191,12 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	}
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	/* Keep submitter_task store before clearing IORING_SETUP_R_DISABLED */
+	smp_store_release(&ctx->flags, ctx->flags & ~IORING_SETUP_R_DISABLED);
 	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	return 0;
 }
 
-- 
2.45.2


