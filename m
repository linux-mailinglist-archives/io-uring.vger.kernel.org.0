Return-Path: <io-uring+bounces-3252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC5197DC11
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B85851F21E68
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816E014A0AB;
	Sat, 21 Sep 2024 08:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H2WctHGM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86B154425
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905811; cv=none; b=RIPRWgBsUEh1JXB2CX7oWKcYegzUykRrz5EaxqmDcoMkiywrdI4DuGeX2+NjOe8U53/JF/ZEJel8znsS56QNGecHCfMf0A5l+Fl5eLyad2rUxo392x37PNTNXM3OJmwRJNgd+dwjpdCFzl3umbOutHJW+rKESaaICmy8dK6R0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905811; c=relaxed/simple;
	bh=PzsrtkjKwRx2E7o4j65Cv9HylLcgvaVlipIRHbhoVSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYrdvOZxGb/BiBqTmPsnd0CTu6imFMGMJysZ5WLqAbr0odgd9zFWNnRZTImx4VwprvjBSnQWzz4g5Bt3LA4/NCjfJqy5FhPQKr8TF+OPW7ZoZi2rzlaPeAviWmxfHq4WPxC7QzKHff+UpWJ/by1QarPqOSiBqJ7aRclb0HAP8Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H2WctHGM; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d56155f51so311598366b.2
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905807; x=1727510607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7T+zO3yL3MLZif62myBqDQzv2a8wUfIb32Bu2v4rpE=;
        b=H2WctHGM0dTbPNaf9nPYEBzKCOlVtG5BQzpCu10cjJPYEXAHsuvCArqWa69Slhm+sX
         zoYLV9QZL/dyPVLJVtGNhCKMl0TIAtVAWxvfsQvmD4SMqHJqoeIqoqMXHoLewdo3zXtO
         pTlPuxJRS8p35RPfCxMzqEakLPAPB5iJTHAAIeMYPHiTKgeBeuKUMyHYLiXR761+KrP+
         md+aGeVMfmxXuIRBD5xcOlxvaYPwxpduhwRGr5xCj6UMwplQStqrIicoFohHEebOK3Kf
         FFYascO34W3YHPzBOBgc2LnEN82ntde6XIBuIGch235uVH3ktxlTHAsczZsCPn6vpSD+
         ZDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905807; x=1727510607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7T+zO3yL3MLZif62myBqDQzv2a8wUfIb32Bu2v4rpE=;
        b=j/9aJPlx4eOL4UODjb20pUg5tCrJf3KJKlH79cEnWKDQBa7keCdmFZr9iOXXF3ikfY
         QNDX5D4NIcrU6RUwapcpDVW3S36Gus/Yz43pqy58Fx5q1GUbuITLYBk4kphhnfG8AdvS
         qORkOElmOMErADRfXaWzW3dFv25waBUFv42Pdl+Csar1jKRL32QN00H2KdaSE0OJ0Kj9
         /o9h/wpP6x9TNnXSudRW7KGCn/ZwgAottmgtCJooJeFyhq6G9P1ZxW/I7U8xDQPbGzeX
         MadAJ+wSGfg3pvavU/1DuzjS48FF01WywlwThYstnueMUx+KMzfDtZb/dM728hgzbRsD
         hsnQ==
X-Gm-Message-State: AOJu0YxyvDIMEtOLmD1EfMI8I4hnWJ/np1zmAooQEPyRFRsMu94carsH
	91WjD/l0jVL4XTD5YngM6qIDbFL/KShjk6cseIodgXnLLg9nEHlRB9ua5aDB3maFyaZVxTWFnDC
	akIKbLc+n
X-Google-Smtp-Source: AGHT+IHGnrZtnO+Q04rpZhPT91GK+goAvLMF6dmLDZsv9o+0qR2/hfPnhc/vRccU/9v+M1eI6I/vkw==
X-Received: by 2002:a17:906:d259:b0:a7a:9ca6:528 with SMTP id a640c23a62f3a-a90d4fc8f40mr430336466b.11.1726905807076;
        Sat, 21 Sep 2024 01:03:27 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/eventfd: move ctx->evfd_last_cq_tail into io_ev_fd
Date: Sat, 21 Sep 2024 01:59:52 -0600
Message-ID: <20240921080307.185186-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything else about the io_uring eventfd support is nicely kept
private to that code, except the cached_cq_tail tracking. With
everything else in place, move io_eventfd_flush_signal() to using
the ev_fd grab+release helpers, which then enables the direct use of
io_ev_fd for this tracking too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 50 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index d1fdecd0c458..fab936d31ba8 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -13,10 +13,12 @@
 
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
-	unsigned int		eventfd_async: 1;
-	struct rcu_head		rcu;
+	unsigned int		eventfd_async;
+	/* protected by ->completion_lock */
+	unsigned		last_cq_tail;
 	refcount_t		refs;
 	atomic_t		ops;
+	struct rcu_head		rcu;
 };
 
 enum {
@@ -123,25 +125,31 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 {
-	bool skip;
-
-	spin_lock(&ctx->completion_lock);
-
-	/*
-	 * Eventfd should only get triggered when at least one event has been
-	 * posted. Some applications rely on the eventfd notification count
-	 * only changing IFF a new CQE has been added to the CQ ring. There's
-	 * no depedency on 1:1 relationship between how many times this
-	 * function is called (and hence the eventfd count) and number of CQEs
-	 * posted to the CQ ring.
-	 */
-	skip = ctx->cached_cq_tail == ctx->evfd_last_cq_tail;
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-	if (skip)
-		return;
+	struct io_ev_fd *ev_fd;
 
-	io_eventfd_signal(ctx);
+	ev_fd = io_eventfd_grab(ctx);
+	if (ev_fd) {
+		bool skip, put_ref = true;
+
+		/*
+		 * Eventfd should only get triggered when at least one event
+		 * has been posted. Some applications rely on the eventfd
+		 * notification count only changing IFF a new CQE has been
+		 * added to the CQ ring. There's no dependency on 1:1
+		 * relationship between how many times this function is called
+		 * (and hence the eventfd count) and number of CQEs posted to
+		 * the CQ ring.
+		 */
+		spin_lock(&ctx->completion_lock);
+		skip = ctx->cached_cq_tail == ev_fd->last_cq_tail;
+		ev_fd->last_cq_tail = ctx->cached_cq_tail;
+		spin_unlock(&ctx->completion_lock);
+
+		if (!skip)
+			put_ref = __io_eventfd_signal(ev_fd);
+
+		io_eventfd_release(ev_fd, put_ref);
+	}
 }
 
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -172,7 +180,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	spin_lock(&ctx->completion_lock);
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	ev_fd->last_cq_tail = ctx->cached_cq_tail;
 	spin_unlock(&ctx->completion_lock);
 
 	ev_fd->eventfd_async = eventfd_async;
-- 
2.45.2


