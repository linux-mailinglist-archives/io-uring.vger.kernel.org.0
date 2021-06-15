Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0756C3A845A
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 17:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhFOPu2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhFOPu1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 11:50:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A1EC0617AF
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so2307640wms.3
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sO/yhwtxVzWXRvhePkBmZvoGZ7kv8aWTahRww/Scx8s=;
        b=lQ75Esv2ucg52E1oZAxjvyvrmdxd3foTARMzRUNW+qGZW+Ky8XCyxwxlziIwjTz3HU
         kcBkY6W3uFNfyUElhGTQ73QJ+b6A3QPBoZxOAwoGVrsh2oUjSGSqZRqIkVhDLAtJGj2G
         CXpN3CHQjPkTvWIma/grZ6haRkC5rNlo88JG2zdUXhuCxf3VREIK/q/bea0KFXk1tsCY
         JKEmy6HleV8fgi2h3dSlBy7CqHV0YLEtcv6drPucGTCipBRzMXxewQbfA4llnABANUbf
         Y1qcZjGs5y5/b9H8/UW55yIN6nuElNTSmDpxC4nr2PFasW9CiJiMJyEg1QpFT+kCXYuq
         lzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sO/yhwtxVzWXRvhePkBmZvoGZ7kv8aWTahRww/Scx8s=;
        b=Asybvf1TVVRTEFoMcQt1QWwUY2ebudqDJHDLgGkA+VeV9JtCJ9CeOhPgcZ5XVYm9JB
         ewufyZMI/oEexAaWZLZsDYQh9lidEs6qvWyESz8jrfJIAV8plgCdmrXNyiWs+UpIJLJU
         JFfqSbBsk2+ew5xRzwMEtkY12KJH5Kak71gXndnYttIR9qo0Vx2qwDn7U4D2tZNHh3pD
         vDNOctkusa61mcZZFFjSBIA8ZxkEr5zzopDTeP7jT3YC+StKrpDhJ82Vphp6gw8RnTcD
         EsptuSTBmQjwv6v2j1viQe9/C7JCl1go8jNz6QqcbRRvIK69Ac2+4o5BFlrDfN0wyLuO
         YneA==
X-Gm-Message-State: AOAM533pIQsGtNqgpE5U10bndvG/mjiCvMTRjBpTPty3MUBFnn8qGpGe
        FiHz/whqkaY9byWvzFsRyFc=
X-Google-Smtp-Source: ABdhPJwkeOrcjWdMTXvznjMX8uQZF4CHvaqwm3mEIrmOB68IPh6CuwjDE2YlzFn7mobxXBQvs7m6VA==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr6005965wml.178.1623772100205;
        Tue, 15 Jun 2021 08:48:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id o3sm20136378wrm.78.2021.06.15.08.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:48:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: optimise io_commit_cqring()
Date:   Tue, 15 Jun 2021 16:47:58 +0100
Message-Id: <7350f8b6b92caa50a48a80be39909f0d83eddd93.1623772051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623772051.git.asml.silence@gmail.com>
References: <cover.1623772051.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In most cases io_commit_cqring() is just an smp_store_release(), and
it's hot enough, especially for IRQ rw, to want it to save on a function
call. Mark it inline and extract a non-inlined slow path doing drain
and timeout flushing. The inlined part is pretty slim to not cause
binary bloating.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 947500af425c..d916eb2cef09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1344,14 +1344,18 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 	ctx->cq_last_tm_flush = seq;
 }
 
-static void io_commit_cqring(struct io_ring_ctx *ctx)
+static void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active)) {
-		if (ctx->off_timeout_used)
-			io_flush_timeouts(ctx);
-		if (ctx->drain_active)
-			io_queue_deferred(ctx);
-	}
+	if (ctx->off_timeout_used)
+		io_flush_timeouts(ctx);
+	if (ctx->drain_active)
+		io_queue_deferred(ctx);
+}
+
+static inline void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+		__io_commit_cqring_flush(ctx);
 	/* order cqe stores with ring update */
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
-- 
2.31.1

