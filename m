Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E3A123DE8
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRD2F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43357 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLRD2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id h14so392669pfe.10
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=vkTQHhIsTuy3SGEEO3tpezmMr6qlxP4SBfsQT/X3/dks3dBmeUjDsViulhlqwwP5A8
         ACaMEzRnyVjpYvXhbUWbSjuQHmv4GyblBjYowar50y4aLngv+/sFsJJJAFvARIxIQnCd
         77I+4pNkNuEjWxXB7zlkWulVMjXzyUwTXTJ//fMvnpLSI/BhYhpUmi2d5ijUtsS59W1r
         PfoyvjQ8eoVQwhgOUEBMxI+mL6jqYYAdpO9+hdcY8mIvPymWATryYxYGRXppZ+xAu4QF
         DNgxvSJg9h9BHqcOB8nttLRQCNht5sVXwvd09Sd72biFbz8T8cWNWWRvQeX6NO1CZ175
         FKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wj65Oqui1uUjj9BwV6Y5wibj83RCG46jQpgSN4/Fd1Q=;
        b=BrjdSMADpuT9yumkLWUs9MIDyO5zi/nYdijfyNzn8/h6k/zJCRyDSHv406Xu2nXsJb
         su6gaCM16QC+L48csHp/wCM9LLCeYI9VBvRC2R/IXPigfViNM1SE/75IxfM8Pf+ZQ7D1
         hvGaRhb4pC9nbIqHCgEhkBUnqDWIznsXeXzgEgkTPfwSGvdoujQ8xB0FGim+Ss+G4mN4
         2BE2/TNEvI+zA7WgU4wskV47mRtTjYkfBT7w93NM3FHQK6ULgxdICaIRV2slPNhnvp9D
         PGDqW2BrYPnITcUjWxI1XI2NnfOcUqTfnszJDJ7t7M4Fw7esL33Oe4y21qc+f6ELBuEn
         wzvg==
X-Gm-Message-State: APjAAAX4huq+huN7COeEOym2eLDAdwpPFyhc5sUyvhpU8DRUT9fZP3pE
        x2TzZ9fOW1FoqEcX6MC7xXz1ig5B6V55ug==
X-Google-Smtp-Source: APXvYqwy61sZC+2NCoNHDVuklcVZkAxz9QNiD/dfsXeIaym4wW4saq0SJmBA2quUVakHt/XGh6h40A==
X-Received: by 2002:a62:cec3:: with SMTP id y186mr483412pfg.129.1576639684066;
        Tue, 17 Dec 2019 19:28:04 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Brian Gianforcaro <b.gianfo@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] io_uring: fix stale comment and a few typos
Date:   Tue, 17 Dec 2019 20:27:49 -0700
Message-Id: <20191218032759.13587-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
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

