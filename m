Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D556F2DF144
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbgLSTQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 14:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgLSTQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 14:16:34 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C380C061257
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:41 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id g24so3856122qtq.12
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pqu5QCNzl6YIsLPOFU12NOO1EQ9/G0hw/eavrFeoMJo=;
        b=qYYSU4lgkqOJ897stn0IELNwRor9QmuAuhGK5oeEaiJv0qoA42z/9hk1Jo0WwTD1/k
         HurDwBmtU3f/PiSW0KatpnLJCZgzlhw8Xb2JFEF4oWmkb7qM7Wy3/zqrw+ICko+raC2K
         8DFRJxQvsDDLUfe4oh/VwFDzUv6odvAQMI4W2rGCWeFw5yWZ5vlalf+GW2H63tS9IPfb
         xa5u+vF22rsVprkO3R8WyoLJ12ld04q3CBOmuR57i+bPhU/GeVEgfsX7tj/IUD9c+XxR
         oLpeSovud/SYOhEO6CAOTd+z6rmOyopjWNuTM7MO3zi5NQvYk6UF5kNRH4u8kgP+lMYS
         8LQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pqu5QCNzl6YIsLPOFU12NOO1EQ9/G0hw/eavrFeoMJo=;
        b=LmkkdZqDL5VfBTJhJp/XlzZ/FGuAZ36UMInroln1I+uDlzGe62XlpbbdrCpxptkCzp
         Ji/uc1/PVmeGZ/hnMgnxJenfm4tD91OmFVaekY4wKDB8156dqf973AFd6p65NM9+PUKW
         PGh8s1LJDHiTTIthLqJuwm8JkULBKGxhfNNS2fCrX9T6jVnO+ivKr/tsp/qrO4qvIrV8
         GBUdI7opOtjWEjPNNYM0LIQSXpj5+aB5JAK+Xde0xDQA2E3VKnhLi3cqwyGFxwXxsFlU
         jXyynTOHM509H1Mm69e41Uwm3flmw5VPkON+6jV1Xu80h6+jLWuRgS6ZYQO4I2jGjkv5
         RVnQ==
X-Gm-Message-State: AOAM531YYezGyufaFOfqCpzCNV+7R0Q53rNMzWyBJFsSc/mx6UI04osg
        4LraqH3TpipMAmz4UELcJRo=
X-Google-Smtp-Source: ABdhPJzCC5AEoF4AeAXrwJZUeCR7O1QW5YEpQQQu77iG3NAySeaX8Brrto1LN6Cl/eR/oZNCs0mFzg==
X-Received: by 2002:aed:3668:: with SMTP id e95mr10163126qtb.69.1608405340469;
        Sat, 19 Dec 2020 11:15:40 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id 17sm7335488qtb.17.2020.12.19.11.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 11:15:39 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v2 2/2] io_uring: flush timeouts that should already have expired
Date:   Sat, 19 Dec 2020 14:15:21 -0500
Message-Id: <20201219191521.82029-3-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201219191521.82029-1-marcelo827@gmail.com>
References: <20201219191521.82029-1-marcelo827@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Right now io_flush_timeouts() checks if the current number of events
is equal to ->timeout.target_seq, but this will miss some timeouts if
there have been more than 1 event added since the last time they were
flushed (possible in io_submit_flush_completions(), for example). Fix
it by recording the starting value of ->cached_cq_overflow -
->cq_timeouts instead of the target value, so that we can safely
(without overflow problems) compare the number of events that have
happened with the number of events needed to trigger the timeout.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f394bf358022..f62de0cb5fc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -444,7 +444,7 @@ struct io_cancel {
 struct io_timeout {
 	struct file			*file;
 	u32				off;
-	u32				target_seq;
+	u32				start_seq;
 	struct list_head		list;
 	/* head of the link, used by linked timeouts only */
 	struct io_kiocb			*head;
@@ -1629,6 +1629,24 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 	} while (!list_empty(&ctx->defer_list));
 }
 
+static inline u32 io_timeout_events_left(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	u32 events;
+
+	/*
+	 * events -= req->timeout.start_seq and the comparison between
+	 * ->timeout.off and events will not overflow because each time
+	 * ->cq_timeouts is incremented, ->cached_cq_tail is incremented too.
+	 */
+
+	events = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	events -= req->timeout.start_seq;
+	if (req->timeout.off > events)
+		return req->timeout.off - events;
+	return 0;
+}
+
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->timeout_list)) {
@@ -1637,8 +1655,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 		if (io_is_timeout_noseq(req))
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
+		if (io_timeout_events_left(req) > 0)
 			break;
 
 		list_del_init(&req->timeout.list);
@@ -5785,7 +5802,6 @@ static int io_timeout(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = req->async_data;
 	struct list_head *entry;
-	u32 tail, off = req->timeout.off;
 
 	spin_lock_irq(&ctx->completion_lock);
 
@@ -5799,8 +5815,8 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
-	req->timeout.target_seq = tail + off;
+	req->timeout.start_seq = ctx->cached_cq_tail -
+		atomic_read(&ctx->cq_timeouts);
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -5813,7 +5829,7 @@ static int io_timeout(struct io_kiocb *req)
 		if (io_is_timeout_noseq(nxt))
 			continue;
 		/* nxt.seq is behind @tail, otherwise would've been completed */
-		if (off >= nxt->timeout.target_seq - tail)
+		if (req->timeout.off >= io_timeout_events_left(nxt))
 			break;
 	}
 add:
-- 
2.20.1

