Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AA2F814D
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAOQzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 11:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbhAOQzw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 11:55:52 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A246BC0613C1
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:55:11 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id v126so12243876qkd.11
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OaaS5T1O14aKTkeXu45xGwsiTvPMovYdhHXlgYjVikI=;
        b=Tt/ofVaCD4BhIHsqrVXgZxRqFCVTd5DLZvkqTB6KTZS1HGxWeJjeQGLDrLtHEIsBnu
         +/Tl2u5TbM+IPOxYtldlhym3/GRhXVLuztKXr12kyt9MWLAVzyZ8f+po8COferMm6lfd
         VD4YW4mBefl+g1kJ6L2NdadFngLLE0Jzzt97xOiL3QH+e8cU5LpjR00qS3DANRUN63xd
         /5HRQftypx8EYzBXZq7ijCnhDgKKI4IKShiSIFrET2TPRKfViieIwf6/xOsqcitRE5op
         JPc2s+Xq3H0y4u20lsr4aVWtSMgRjt3ch1xqO5NfOyBxgCwV3GzNtdCenz0dk3HI0+YL
         /GXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaaS5T1O14aKTkeXu45xGwsiTvPMovYdhHXlgYjVikI=;
        b=hF+cfCFu3JNMrnDHtexCXu2gonXaDnz2BzmO8rhl2NEJ161txc56/AxbJXODuIkX1F
         bkGqGYwFdsCSv/j0Ale1Il9OV8W9vpWh0Q+4O+KCmWmRMAIFT8X7d/9234PmZtl4CGgU
         +Xk3zgbrtSTFh1tL6/Pyu7zHIVbQsTlTMQF49C3+PiEO3SJqzmrvU/GcAtF03h3uOA8/
         uBPQE9h3KuKHXCRGulCQBRmOEIzWoNr2Tkzk8XOzIpQheuREqPhkMt8uEurEK+sqb6Zb
         jvSPxJLHLRkq8kl47o/hGXxlceabwskfRXpWzYln6BS30fJGSQx/l33S0q06A5mhiI2p
         xQ/g==
X-Gm-Message-State: AOAM531vot6C+jbp8jwcF2IvX66I/LB5xDNZsqNOo9tZ8i789eUvplDW
        A16Ais7k+5QMTIM+9gpbWp0=
X-Google-Smtp-Source: ABdhPJwLveL2cI02BsYeLk4FM8sG49u1XYG1KgcktI7ueepdcwZDYmfBhrtRUHAL88YLZZu/CON0bw==
X-Received: by 2002:a37:b87:: with SMTP id 129mr13255566qkl.2.1610729710964;
        Fri, 15 Jan 2021 08:55:10 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id n7sm5276366qkg.19.2021.01.15.08.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:55:10 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v4 1/1] io_uring: flush timeouts that should already have expired
Date:   Fri, 15 Jan 2021 11:54:40 -0500
Message-Id: <20210115165440.12170-2-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115165440.12170-1-marcelo827@gmail.com>
References: <20210115165440.12170-1-marcelo827@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Right now io_flush_timeouts() checks if the current number of events
is equal to ->timeout.target_seq, but this will miss some timeouts if
there have been more than 1 event added since the last time they were
flushed (possible in io_submit_flush_completions(), for example). Fix
it by recording the last sequence at which timeouts were flushed so
that the number of events seen can be compared to the number of events
needed without overflow.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 372be9caf340..06cc79d39586 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -354,6 +354,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
+		unsigned		cq_last_tm_flush;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -1639,19 +1640,38 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	while (!list_empty(&ctx->timeout_list)) {
+	u32 seq;
+
+	if (list_empty(&ctx->timeout_list))
+		return;
+
+	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
+	do {
+		u32 events_needed, events_got;
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
+
+		/*
+		 * Since seq can easily wrap around over time, subtract
+		 * the last seq at which timeouts were flushed before comparing.
+		 * Assuming not more than 2^31-1 events have happened since,
+		 * these subtractions won't have wrapped, so we can check if
+		 * target is in [last_seq, current_seq] by comparing the two.
+		 */
+		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
+		events_got = seq - ctx->cq_last_tm_flush;
+		if (events_got < events_needed)
 			break;
 
 		list_del_init(&req->timeout.list);
 		io_kill_timeout(req);
-	}
+	} while (!list_empty(&ctx->timeout_list));
+
+	ctx->cq_last_tm_flush = seq;
 }
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
@@ -5837,6 +5857,12 @@ static int io_timeout(struct io_kiocb *req)
 	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
+	/* Update the last seq here in case io_flush_timeouts() hasn't.
+	 * This is safe because ->completion_lock is held, and submissions
+	 * and completions are never mixed in the same ->completion_lock section.
+	 */
+	ctx->cq_last_tm_flush = tail;
+
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
-- 
2.20.1

