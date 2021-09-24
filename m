Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF8417CA8
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346529AbhIXVC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1B0C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dm26so6656036edb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VJuwULom7yaqoXLBtPlUq1eEkkqMZMkNc3h98TZx1+M=;
        b=OTFtf+IEC73cSQCR0Hqle1FX4nsmndX23rA6yiULlsQ2Qyuljc9yes8Dkx0hdob1/W
         Z4iXOWJsm4ZYu0xiNQR3hnffmMGthjGQ0YQGwomlD5gRezfbHsgssfCJRufzcF6zkjv3
         imUniDJuWP6lrivAgHlQom61TLJkHlpWDPrUJX8vSIOPUjtl/bhtxE7cAESb2W8H8Xyo
         BaI2kbbhec14ZocYrEOh3RSOP2lmLAKoW/Z7l1qDkdC0HVwLvrLCYMVKabys/fJaMrXQ
         QPFG0W9UTJvagxln1uLRepHWqTq6zt5I4cjTqAWQuA0qxh8x15VDdfiUorFUL4A6I9Xu
         /M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VJuwULom7yaqoXLBtPlUq1eEkkqMZMkNc3h98TZx1+M=;
        b=fXrEwKzxHqI4GDVJhbKJuRwjd8OSBTmHps6t4OHcSqi+Cj7ZhL9wuVtMiWQom736cJ
         z/NQPT54WNtK43Of9KFnIo0ZbTYvXVGmBF2qBqcglS9p5ZkRMjIPz1xFoggLc0gr6Kk6
         qBfBpawHwsS4SpDLvT3FWPI/2gc+7OwfRux0L8Ip8gtxnpTSegSgZv44/azrSsp0J3iJ
         S9Mtaw4P9UElcx/e+DovwE4b7z1NLLqi/efMaM9+VnrEX8PLznYcwjHxpSId/2ijAGJL
         TYYXO9Gc8SRalQlvlf0R0FkeN+cigbE7theCbJ2eFm8bRNh1UJy2a9vJITFpErNfd0lb
         nNkg==
X-Gm-Message-State: AOAM531+yhtgNtDTNQx1DAO9Ez30bc/MI5AfWGjwzearpdddYrOGEZ30
        MG7RNYlcJoWfCxT+HynmUltJ1AehPZ8=
X-Google-Smtp-Source: ABdhPJydsg1j8zWLPhGRCDC8/v/OnSK2YjAXPZHNt+tGbpcNr+m62p/BbJt0eIb7lJiij+UZk4dq5A==
X-Received: by 2002:a17:907:2064:: with SMTP id qp4mr14048306ejb.317.1632517250643;
        Fri, 24 Sep 2021 14:00:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 02/24] io_uring: force_nonspin
Date:   Fri, 24 Sep 2021 21:59:42 +0100
Message-Id: <782b39d1d8ec584eae15bca0a1feb6f0571fe5b8.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't really need to pass the number of requests to complete into
io_do_iopoll(), a flag whether to enforce non-spin mode is enough.

Should be straightforward, maybe except io_iopoll_check(). We pass !min
there, because we do never enter with the number of already reaped
requests is larger than the specified @min, apart from the first
iteration, where nr_events is 0 and so the final check should be
identical.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e269fff3bbe..b615fa7963ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2458,7 +2458,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
+			bool force_nonspin)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2466,9 +2466,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
-	 * off our complete list, and we're under the requested amount.
+	 * off our complete list.
 	 */
-	spin = !ctx->poll_multi_queue && *nr_events < min;
+	spin = !ctx->poll_multi_queue && !force_nonspin;
 
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
@@ -2516,7 +2516,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0);
+		io_do_iopoll(ctx, &nr_events, true);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2578,7 +2578,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
+		ret = io_do_iopoll(ctx, &nr_events, !min);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -7354,7 +7354,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
+			io_do_iopoll(ctx, &nr_events, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.33.0

