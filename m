Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD9123A4B
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfLQWyu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44086 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfLQWyt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:49 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so103108pgl.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=DiQGiOTXibRxabConsocE52E2Qbe8oNJ/FpFm4J0j/qI/ffPNp8u6UAi+UCpmnlEcp
         d1iSBmVePe27UySNOPgNnhD1StC7ts6v9ZXqLfVioA3a1sV+PeEPw10G71ztsP7l0XVS
         Rmb/2PECu7ii3dtGOpzHXsgtPIr/+xu0jZVK0tCAX/a890COvYc2KsW+l4wfQxro0hku
         JFUa1o48mF6hwsH//tTjHdGDa9h0ENBacLpbm167LnGNCMLmg51uzsFiQrdvJFBUeUb/
         NQYva8lp3INQiJ1Gzu2v03oGTd/UW7qitBq59t9EAE6je20LPom8S2O5zVQ+2gFQFy3/
         12VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=XqXQILAEggxisS1+103qXGYImFEadJpDr3YD3zMsHFVWpmuBfANUvdUarfImk5XsgY
         nMVeIrrSNNheNAiLuwIoEgqaL4aG40hA17hZpHVgDBwGU+WuHeM6g9AqgHDUhv3Y4Ss6
         P1ypmgyb5iEIXTgGa6EvmJcTYpHpK3gt/K5KiGZdayVoelPBcBxnZ6tYZz1gsHWNtvfy
         6gJucWipVncsz8/CrnPaEbHF/u6iUYALmMw04woefh/uvn+KgAoMHkVueSVg/L7nMSWq
         RoFxlb6wMZRSfRpZ549TyrKg+hGTleubWiWT2PGfrngKS3g8mznzKWIgQmZ7MlodPlua
         VFOw==
X-Gm-Message-State: APjAAAUiN4pfTaCUMq300JhAworHWTSvM3KrFDc/DAbj8jReNpoMEjXR
        hpfPvrv/wOGHzT6nSGP6mz04fgFK3ccL1A==
X-Google-Smtp-Source: APXvYqwXGdqvPELHHmsTlL1CBoMSb3x5bJeZaY0ngb/MZzLEvqFhC5gV3WuF2XvvNd/Q2ugxQRFPiA==
X-Received: by 2002:a63:5062:: with SMTP id q34mr28056468pgl.378.1576623288924;
        Tue, 17 Dec 2019 14:54:48 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Brian Gianforcaro <b.gianfo@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring: fix stale comment and a few typos
Date:   Tue, 17 Dec 2019 15:54:39 -0700
Message-Id: <20191217225445.10739-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Brian Gianforcaro <b.gianfo@gmail.com>

- Fix a few typos found while reading the code.

- Fix stale io_get_sqring comment referencing s->sqe, the 's' parameter
  was renamed to 'req', but the comment still holds.

Signed-off-by: Brian Gianforcaro <b.gianfo@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 2 +-
 fs/io_uring.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 90c4978781fb..11e80b7252a8 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -948,7 +948,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	/*
 	 * Now check if a free (going busy) or busy worker has the work
 	 * currently running. If we find it there, we'll return CANCEL_RUNNING
-	 * as an indication that we attempte to signal cancellation. The
+	 * as an indication that we attempt to signal cancellation. The
 	 * completion will run normally in this case.
 	 */
 	rcu_read_lock();
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b1833fedc5c..04cff3870b3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1178,7 +1178,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 /*
- * Poll for a mininum of 'min' events. Note that if min == 0 we consider that a
+ * Poll for a minimum of 'min' events. Note that if min == 0 we consider that a
  * non-spinning poll check - we'll still enter the driver poll loop, but only
  * as a non-spinning completion check.
  */
@@ -2573,7 +2573,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 		/*
 		 * Adjust the reqs sequence before the current one because it
-		 * will consume a slot in the cq_ring and the the cq_tail
+		 * will consume a slot in the cq_ring and the cq_tail
 		 * pointer will be increased, otherwise other timeout reqs may
 		 * return in advance without waiting for enough wait_nr.
 		 */
@@ -3430,7 +3430,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 }
 
 /*
- * Fetch an sqe, if one is available. Note that s->sqe will point to memory
+ * Fetch an sqe, if one is available. Note that req->sqe will point to memory
  * that is mapped by userspace. This means that care needs to be taken to
  * ensure that reads are stable, as we cannot rely on userspace always
  * being a good citizen. If members of the sqe are validated and then later
@@ -3694,7 +3694,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	struct io_ring_ctx *ctx = iowq->ctx;
 
 	/*
-	 * Wake up if we have enough events, or if a timeout occured since we
+	 * Wake up if we have enough events, or if a timeout occurred since we
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-- 
2.24.1

