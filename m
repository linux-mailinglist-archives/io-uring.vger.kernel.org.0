Return-Path: <io-uring+bounces-10883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 23612C9C40A
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 17:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DF3834E1DA2
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 16:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1647279792;
	Tue,  2 Dec 2025 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EFLGtCwO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f100.google.com (mail-ed1-f100.google.com [209.85.208.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D7D290DBB
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693693; cv=none; b=oY6HxhfPOslQ3qhgGQwW1GeuAQJOjTF7TSaUQz4WNaJHIvyMlVrTEiNDmIa5zFvxiedtLFppVrb+7OVMgi+NVLYc8vOPYuNIOcc6YN+Vvf8bBiw6B7LwHxiOcNZ4ebtqqO+xN8sFd2tJNZbohDyeXNNJyCefg/JV+4KR0BWUrC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693693; c=relaxed/simple;
	bh=rfcJtYpApZgZ3ggMk6Lu6xqNaGNNQRUrF0JUvpvg2v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vhli4OA4wgWuRFgeRfxgHd81tweWS+o69ZZJM825CDmD1boqUD2/gc5rjxCoqHmBi/7MxUOcF9AkHKysbsmiWCitULoaJ3nFRmxyoVRjkJPNp7HxQcr3L/YX0ZQea9itcm13e5ITYua+pqAlw4HfljzM35q5/x5KNmr+RCc8yak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EFLGtCwO; arc=none smtp.client-ip=209.85.208.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f100.google.com with SMTP id 4fb4d7f45d1cf-6478e8f6bc4so93524a12.2
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 08:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764693689; x=1765298489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Oc38qZVe+2zts7GwGqPTlWIWW8FzVfjm2VCTYXmKJg=;
        b=EFLGtCwOYlWTfpFoK25Ay8QGWLEqhxP3zi9u7GthSdMBGP0QspACfqOvhmmAvDnWGI
         /+FtRsr3KIRAvJH2liVVO2U7BpYAk2C9d4l/APzgzVAHEcvdYnOlPLcMVSIVM5w2wF9l
         uCge9Q6JVyFKErKpg/1dia4f10GMzuGuPlb/R40pNZQBYU+lzOkJvfLUeJmzmXQMTE8J
         BsCYfQxLMnWKa+KQBxriGGE6+GibAOh7MopAMG5WX3pmTf5TBPJdCkjTaG6zstJXaxTU
         Fxf0VHgaQZLOEyhF1pVVcDjjyJw/2JoxjijDpr569Bo6uvKLR4EJuo6IQXztJi4CIHX0
         vDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764693689; x=1765298489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Oc38qZVe+2zts7GwGqPTlWIWW8FzVfjm2VCTYXmKJg=;
        b=vHnxrhC5w9uxSpOvE6kQpDlJXR5uotcQcyhtWyEDE4VfCCMQJ5pbDOyPAoPSijgzy9
         Ue5Y+DzzfgXxj/qUU3AjAp1X1J4oe3ITLTdRwUdBuIj/YQt5osn5k/gYlPgKYG31GIA0
         UYRNgMWGIEdMBsYLjV6vZGYxavuk8UCzAffLot690Mm2+qJb7P8+7e6OSpUf0p1LuJvY
         iX94TsgL4WJh5kMtVYAZ6GsarlqFvGGoxsx1SCmpjeBSa8LF1kkabYB97uzzMAb5E2mz
         dS+FtF9bdP3YAyzRFRJa8zFK6jEhNGav3apMSlVSBYrxewwfHPAHXkLlRoGM50VfWeXG
         P8QQ==
X-Gm-Message-State: AOJu0Yw9C+Pby2l2oveaxpmZaB+QUVgliaEKDaPBm7JkaLcuD71ns1Vr
	fct2MBSGRxwlTk5sx7BYN3hjDVQCiYrDBBiFVgYlRkAUynzBHfMZjd15o2sGQobx61+ry2x9H2S
	LTAhl8ZcC32Fjpzqnt1/NrwF9mJvr+4aNLi/M
X-Gm-Gg: ASbGncsBQiyrik/tEoUTl4ZZmyOW0Bb1Bb+NgyOjnoaQII53zdqFq83yx3jJX8RsBae
	sKJE2L9PMAzVeiEXk0YK8TC2Xe7zayQ/02pz5uq4z4YwUa8wF3Tklbw1U9HDRmiGL+YiCQs/YLJ
	LP1zz+hT8XhjgeurmEaz3s/E/Oz6lJuLdcnHKiV+YKJFGBX1ootyXOmvMtGu+S6HzmXgCHkSq/M
	UTXYn9qi1xXDoyIiWA/IPCKAPxf8vYXARmFZmiIsT9AeF/ThkqoZedT3/LMIGlgE3qfj8Y10Nqf
	kwZhPFaVopqjQvJiwkUtqt/A0LhjfL3hmBpbhEaHkEwHekdIPb61Rka11y/MdvC1FCevvhk55Ny
	3V88+0SmLRwuGUfbXj6VBxJrXNan0Iqf5vXiLSxb5TA==
X-Google-Smtp-Source: AGHT+IGvPqXs6ksMogVRx2uhOVrpAHsXcVLaUdtkGKSKHzyRU55KnHDWuiHPOuOdg2Dlo4Qr1d/rdUj4hn7B
X-Received: by 2002:a05:6402:2112:b0:643:130c:eb1 with SMTP id 4fb4d7f45d1cf-64559f58067mr20447502a12.1.1764693689271;
        Tue, 02 Dec 2025 08:41:29 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id a640c23a62f3a-b76f51c8e1bsm235442366b.42.2025.12.02.08.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:41:29 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id EA5F03402AD;
	Tue,  2 Dec 2025 09:41:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E9C22E41DB4; Tue,  2 Dec 2025 09:41:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 1/5] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Tue,  2 Dec 2025 09:41:17 -0700
Message-ID: <20251202164121.3612929-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251202164121.3612929-1-csander@purestorage.com>
References: <20251202164121.3612929-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_enter() and io_msg_ring() read ctx->flags and
ctx->submitter_task without holding the ctx's uring_lock. This means
they may race with the assignment to ctx->submitter_task and the
clearing of IORING_SETUP_R_DISABLED from ctx->flags in
io_register_enable_rings(). Ensure the correct ordering of the
ctx->flags and ctx->submitter_task memory accesses by storing to
ctx->flags using release ordering and loading it using acquire ordering.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 7e84e1c7566a ("io_uring: allow disabling rings during the creation")
---
 io_uring/io_uring.c | 2 +-
 io_uring/msg_ring.c | 4 ++--
 io_uring/register.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e58fc1d5667..e32eb63e3cf2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3244,11 +3244,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 
 	ctx = file->private_data;
 	ret = -EBADFD;
-	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
+	if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED))
 		goto out;
 
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7063ea7964e7..c48588e06bfb 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -123,11 +123,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
 	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_data_remote(target_ctx, msg);
 
@@ -243,11 +243,11 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (msg->len)
 		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 	if (!msg->src_file) {
 		int ret = io_msg_grab_file(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..9e473c244041 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -191,11 +191,11 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	}
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	smp_store_release(&ctx->flags, ctx->flags & ~IORING_SETUP_R_DISABLED);
 	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	return 0;
 }
 
-- 
2.45.2


