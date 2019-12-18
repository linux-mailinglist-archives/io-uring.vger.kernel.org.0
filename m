Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792A8124EE9
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLRRSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:45 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:47063 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:44 -0500
Received: by mail-io1-f68.google.com with SMTP id t26so2748729ioi.13
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=ILj7B6C71EkAWmidU/adezwuvFA3DyJOLuQCYXly7mzNqSGdANY0Tu3HI+LyDt+M48
         6A9ul31acSMCR9k1rY4Fa6rjbSyAPvGGRfrV5SdbY52FT2cdsI3Zh5P/ZW2pURufru0A
         BeevGbk5UK5J9nT34O+Br14k6C/JmsWuES4FBWi14YkGOAq5MNU2kxwa8rd0acWWx5yi
         m3Y9UvU2Z8E8N+zUx/kWsFrOFVnIhzl3m1ia/VMkS3tOQtV9ZQku5AWWldzB6or68VKK
         nN8gymtN5r5t/r9eHnRD44Cckcy3LQNFJsciuxb3XHpwNNKNficiyxOebJJviHSG2J+R
         88eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=iPXDeuLGjSXo3dMesBZ9zWR6Pftx1CoY/xaYUsSFZt842tZIL66QEMj9eEc7rUrv1B
         cS5AaGG87zlJGwM6weJeUGJltGHkZHe8Ak2ls9pBres0H2pVYMmSzrfvNSnS6T6Ckmxl
         AvYZIBKPQOKg6vMxjQVCvCZoXgF4WkxtvbDn9Dp5PoilLzRzOYu7pQJoixF8rUAA3GsB
         cxLGwrBcNPaH/ycrmHTzOrqZeGPaTPXpC3AV2ggWxktmwblS3/jN9s4DaBMg9/2YfWhX
         fxfHYHEAuIsK121ibZypOGQA79xpmZvne1bQZ0iOiK2aaSqIfuCSGjoeJa/7lArz1giW
         Lgow==
X-Gm-Message-State: APjAAAW28JAGCVS5GgbUSNCms1pp3dHGabILqJKjk++yDijU+0y1/Nz7
        VSLkm+ZgusGzS06U6iBaZgWaQqvXg3AlEA==
X-Google-Smtp-Source: APXvYqy8O9PI334296lldW/IfPjWyGmE0/EMlD33eQi3V2BC0XkDx3oTSxYk1iFvn9lGAO65jXwxoA==
X-Received: by 2002:a5d:884c:: with SMTP id t12mr2488082ios.171.1576689523987;
        Wed, 18 Dec 2019 09:18:43 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Brian Gianforcaro <b.gianfo@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/13] io_uring: fix stale comment and a few typos
Date:   Wed, 18 Dec 2019 10:18:23 -0700
Message-Id: <20191218171835.13315-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
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

