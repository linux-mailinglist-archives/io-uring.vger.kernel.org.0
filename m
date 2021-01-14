Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F71F2F652F
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 16:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbhANPu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 10:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbhANPu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 10:50:56 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73061C061757
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 07:50:16 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id g24so3783895qtq.12
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 07:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CT4NyhPj0XtVe5ac9mzTPZbcfYojRLTJT1y6ugl/BDA=;
        b=rMGver4s7N8aYcdQ+DHO6SxsH0oVjw+ZadEcAnFNBtxbbrBodzg31Ap2xi8WxKt2CY
         ZJfIroNhYR5swzDTzP9qNScwA/DWQpt0tkZfZMzxdrgbgbUnMa+lJMBUdwSxmQmm+ZBW
         Xk0sgEvBLuhJUa+S0dXk7hADrhgRFwv6va2H9Q55CzHVkxKQ5i21qfGIZONb9VuLJHBe
         qyZcAcP5v9uyff2BF8sTxzGtuOAVqpDzQSzudOVnnmAmUh4U7fK0c2DB2PolgQhMnC7t
         dWHclRQMCSdNpBSnXYQ2uclc8sRN51oOfJI/GBF6QOPZ1IH31gysTPZXk4N7fSHv+7BA
         s53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CT4NyhPj0XtVe5ac9mzTPZbcfYojRLTJT1y6ugl/BDA=;
        b=igTnKFL+vwq2THEnbCfBSNbqyzozbdW/eMZ4OQAA4++0iNc6MLonSr2knHk5RW6dD9
         qdM1wIqaHT3Ey2uxwXQ5K1XpnyppRezbdb9JGYCfAprkvjWN/dsKa2N4bAcfWuRvr3MS
         UWwoFE3Yeqk884zIH1LO+X4h4tp4uxgPmxZxsYbA5e3uqrnfnn7qQWJmMlTz9bCnwAoL
         iWc7nN8YykBZuEi4mDBVf7c3NEZx+y582UYFanFGXlxPSWsAu9014z8mME9OIktXsbQd
         81gC8oup1L00l6DF+FoAhADhoLZ1Mc76/QrykqGEWuie9XTY9JQQvVUuQZGfXJaP4Mb6
         6SoA==
X-Gm-Message-State: AOAM533PMooUWWvBpbzv75/0NxeEmqKGYrNx7UbQo3W706XGPsz3EI2J
        5LAQ4CvzTrhvgy4asjdXSfT///z7sN81ZA==
X-Google-Smtp-Source: ABdhPJyRorFHqHpZwyA9iBXrZhu5Sheitp/6qzvqg2l8908CM7WNaq1pGdvWhIwEvOwnZFt0jyliAA==
X-Received: by 2002:ac8:7949:: with SMTP id r9mr7533489qtt.112.1610639415776;
        Thu, 14 Jan 2021 07:50:15 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id a194sm3149029qkc.70.2021.01.14.07.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 07:50:15 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v3 1/1] io_uring: flush timeouts that should already have expired
Date:   Thu, 14 Jan 2021 10:50:07 -0500
Message-Id: <20210114155007.13330-2-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210114155007.13330-1-marcelo827@gmail.com>
References: <20210114155007.13330-1-marcelo827@gmail.com>
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
---
 fs/io_uring.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 372be9caf340..71d8fa0733ad 100644
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
@@ -1639,19 +1640,36 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	while (!list_empty(&ctx->timeout_list)) {
+	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
+	if (list_empty(&ctx->timeout_list))
+		return;
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
@@ -5837,6 +5855,9 @@ static int io_timeout(struct io_kiocb *req)
 	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
+	/* Update the last seq here in case io_flush_timeouts() hasn't */
+	ctx->cq_last_tm_flush = tail;
+
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
-- 
2.20.1

