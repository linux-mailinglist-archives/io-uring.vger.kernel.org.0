Return-Path: <io-uring+bounces-1151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFD4880907
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00E9F1F2444D
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B336F7464;
	Wed, 20 Mar 2024 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S/NLWO5E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010F56AB9
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897792; cv=none; b=feMnV44JoB3l6mkBQm5wuTxqQflLQwawpRqnUEq0EeHFvYI3WP6ZUFM+Qz9FtfdahI8RgdD4R6WqmLCCa3hFM5x6tFMnZ/PcHpjYokabhYxOF4XsicMALOQ9oot4++i0TMG78HMmj1qqEZkvHc1ihoqpZej3Y8RYByWgRPlrK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897792; c=relaxed/simple;
	bh=GUq1YL1l99R26cr3XZNdacxQpTiKR95eVXArPQDbP6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrnKEvM6VNWyyPUR9xwu158EWYM/Ugp786f/ARmZYsuG7skFsQVE4CsdC5gMs8QmAVJUuac2Ixo1XXyUylfbv2wy4zjFPzVNVtvc5cRtLaYEdzC7WkdiiE/5wOY8jBTnZIxejDG2tMl7EsCdkT4mFqmo0P4Gi6G1b+mM7v4lcto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S/NLWO5E; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a47680a806so1368978eaf.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897789; x=1711502589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mwf5gpehLqrQJLmo4KvjUucibL5k2W580oU2DJPGaqY=;
        b=S/NLWO5Eob/dYga3fr2xesImJN57rJulWsnjjuWVFBIfZ+Y78k2YGChat7Eh9Y2U9s
         TXUr+d80iEryuxGK16ZeWd9xVVrMj/tULOnWuUzemxalcMy10Nv6KbOHvcq2u7MJIutS
         ggfUMgcZ5cyQ5smu67WioUd/vSgfrcg/gok+z1pVlWqdfPkik2D1uHPC0QAuxl9RAQDm
         4LC0TCOfPpG1yhdcgZhbhcurzRJrS1x97xl/fKCpn4yYWIswcRUJf7HI/giiYBrrtxH7
         j3IV3OJ65R8y78XKmRT8xRL+gN7PnMjp0+kgo6hwrTBN/bPpewM8TfHR2pFaYp26rvU1
         ZAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897789; x=1711502589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mwf5gpehLqrQJLmo4KvjUucibL5k2W580oU2DJPGaqY=;
        b=f9aFFAHk/t9VSqvICAyICh5u5Gbc/91844bmXq5WGMMoyTGG1viIS1hM7uA3do9LXR
         68sK8j8arHB0duVkQ+hexevcyygm7a1D7qdKQkGrHf8Q7RWB3SoFBmy7xLD4ifZma+fv
         dy58pVbGHdRepbjS/sKOqYmZri7C61XBWZQkvcEGQ3U/2+UIIEAuAHJIE4Nxda8DcLot
         G3e0vEmqUv8KCFP6/4aHReVW8rs10GlMGLEBs9ukAEVgI5oTtJ54O1+YV0KcqC0m+wrc
         KTh8z9wWCQel6ql+aBgZC/KF55w3qm/0AXOMtd0ZNMj/4w6e2VfMfOhggj9s/XIglBQD
         98yQ==
X-Gm-Message-State: AOJu0YzEqBfuB4Js/0Gk1bOAuilXNVeezE7i+Asltb6xJ+Gdp0l4oP2R
	bAFk+LRpK3trxY2dT7AZYFXdFRnnkDsWd2BDS75VMphZyaTryEDuo+ZwBiMHvhHwXJm56BRNx/+
	K
X-Google-Smtp-Source: AGHT+IEncGfT0ro7fYY5iT2MZ6KOIWIb2GF7T+XWE9du76kVfDBcsS9v+/0NnYvRMR8xwwFPwWuFZQ==
X-Received: by 2002:a05:6358:291d:b0:17e:b8b5:d6a7 with SMTP id y29-20020a056358291d00b0017eb8b5d6a7mr4258129rwb.1.1710897789590;
        Tue, 19 Mar 2024 18:23:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/15] io_uring: kill io_msg_alloc_async_prep()
Date: Tue, 19 Mar 2024 19:17:35 -0600
Message-ID: <20240320012251.1120361-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We now ONLY call io_msg_alloc_async() from inside prep handling, which
is always locked. No need for this helper anymore, or the check in
io_msg_alloc_async() on whether the ring is locked or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 94767d6c1946..21624b7ead8a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -129,22 +129,19 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
-						  unsigned int issue_flags)
+static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		entry = io_alloc_cache_get(&ctx->netmsg_cache);
-		if (entry) {
-			hdr = container_of(entry, struct io_async_msghdr, cache);
-			hdr->free_iov = NULL;
-			req->flags |= REQ_F_ASYNC_DATA;
-			req->async_data = hdr;
-			return hdr;
-		}
+	entry = io_alloc_cache_get(&ctx->netmsg_cache);
+	if (entry) {
+		hdr = container_of(entry, struct io_async_msghdr, cache);
+		hdr->free_iov = NULL;
+		req->flags |= REQ_F_ASYNC_DATA;
+		req->async_data = hdr;
+		return hdr;
 	}
 
 	if (!io_alloc_async_data(req)) {
@@ -155,12 +152,6 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 	return NULL;
 }
 
-static inline struct io_async_msghdr *io_msg_alloc_async_prep(struct io_kiocb *req)
-{
-	/* ->prep_async is always called from the submission context */
-	return io_msg_alloc_async(req, 0);
-}
-
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -334,8 +325,7 @@ static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
 	struct io_async_msghdr *kmsg;
 	int ret;
 
-	/* always locked for prep */
-	kmsg = io_msg_alloc_async(req, 0);
+	kmsg = io_msg_alloc_async(req);
 	if (unlikely(!kmsg))
 		return -ENOMEM;
 
@@ -554,8 +544,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 	struct io_async_msghdr *kmsg;
 	int ret;
 
-	/* always locked for prep */
-	kmsg = io_msg_alloc_async(req, 0);
+	kmsg = io_msg_alloc_async(req);
 	if (unlikely(!kmsg))
 		return -ENOMEM;
 
-- 
2.43.0


