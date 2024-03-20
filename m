Return-Path: <io-uring+bounces-1169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE0B8819B0
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B45C282921
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C6D8593C;
	Wed, 20 Mar 2024 22:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RfSwDzoW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B485C7F
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975490; cv=none; b=cO3nnxKuz7ijMtNUozAjmVXeEh7+pTpzDg9KmMLurmCqZa6JooZrmpRtJDxRH+fliuOMOzGHBUjqFZU3xPD+mBb/GFwao0dQe7MDzsnSkJJjhqcxkzLczN92cPPh8TFTVBYV+lc9hPUr7xgsusqb1Aj4UeO1o9oQn14aOH2QVBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975490; c=relaxed/simple;
	bh=Ve6uHhsYaizqlgH/NaC3fWbKK6mM5yEmkwoIG+qdOcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmmiJ70CbMKcn1YFP29m9E/mzYaRlE1C+1tjj8l8GQxHvlUuzcaK0bra9IhvacJs5fbgqdDcbTDcg7xMTgDLtBUPHmUsaCfi7bwLlgjcC+TcVLvsclIrquFC+DIsXb2mXaml6Y2sJIzBDGwImjog/ca6CdlBZTBig5GmbfEvNvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RfSwDzoW; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so6266439f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975488; x=1711580288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2UrDyqNAoZmjKjSbgMjdB+JTKkJl5VhiIsoG9G4uPM=;
        b=RfSwDzoWws/aZa5vm00zf93OLMJVW2NibjiyQCNWFWvMDgXGHV6tj0yG2YEugcYMvc
         2jWX3fqkhmwAI/pqLy/5jxa6C3UfqWzt03rSlKfsJBctGJfpAUlTRi4II3qcEbHt17Hv
         isNCa5z98nOZ2ulHV2i8cmqxv3pMQxhU7alvMbndmpRJJOENHwBxyvXdV1m4yPd1beyC
         O0EtGub9VPWeH/93CvVuFqtx2fv+/OfENkMcj2RqK+QinLm0HJDSTXLc6DodpVulMIuP
         L5Y9gMHyYfSMsuatkzYT09w1UdVBVHnH/9AP6gSjb9hQg2bB8nG1WyEV3smbmo1YS1GN
         05RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975488; x=1711580288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2UrDyqNAoZmjKjSbgMjdB+JTKkJl5VhiIsoG9G4uPM=;
        b=jdwOx4rad/7y2fcF2swYt5Nr+AwTK+6wDsJ0ZzJHmoHkHz5BmcEI+y+MkoHHCySZFg
         DW2CVkUW7E1nnVCejeibiNBHrQfrnG+eDjEODMNOoYSwGZUPrqULCpSqHtMVD2Kz1RWP
         jhkq4KRgz26nLNcbPW6cxwmFJtkVO3a4AM27rc8aqsPTUxXP+KLmt4u3C1D376D5sY13
         d3Y7cPhCPXTdwrdL6Yd6eAIT/eZXyo69nNo55Gauol7M39AXs5eNzknVa8wnzWDUJ1Na
         L5u/U9n0dJXXjy+GKBVFnqGQaaPthqxmtCJFl+kPziUX6wuL5OLCcqT+WdF8PzUEL21f
         LnNA==
X-Gm-Message-State: AOJu0YxUeZYFh3GQSNFms0VGF/zrRuhu735awZrhjNzpa35m4u6h/qB9
	G4n68EsFKV2pSkx1tMB64UK2Wq16dl3pm5Ojue7Q4hgKf3xtRQ6qTu0dEdgjDSyAGWNpKGZ5rsK
	l
X-Google-Smtp-Source: AGHT+IHuA/aCDq3yA3LeB0Fsdl4KErlzaTfwK1tsKB6FtOvHvGnjbGPNUfO+4+l8bPuKO2s6wVXRzQ==
X-Received: by 2002:a6b:6303:0:b0:7c8:d514:9555 with SMTP id p3-20020a6b6303000000b007c8d5149555mr16278103iog.1.1710975487975;
        Wed, 20 Mar 2024 15:58:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/17] io_uring: kill io_msg_alloc_async_prep()
Date: Wed, 20 Mar 2024 16:55:22 -0600
Message-ID: <20240320225750.1769647-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
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
index dc6cda076a93..6b45311dcc08 100644
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
@@ -331,8 +322,7 @@ static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
 	struct io_async_msghdr *kmsg;
 	int ret;
 
-	/* always locked for prep */
-	kmsg = io_msg_alloc_async(req, 0);
+	kmsg = io_msg_alloc_async(req);
 	if (unlikely(!kmsg))
 		return -ENOMEM;
 	if (!is_msg)
@@ -551,8 +541,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 	struct io_async_msghdr *kmsg;
 	int ret;
 
-	/* always locked for prep */
-	kmsg = io_msg_alloc_async(req, 0);
+	kmsg = io_msg_alloc_async(req);
 	if (unlikely(!kmsg))
 		return -ENOMEM;
 
-- 
2.43.0


