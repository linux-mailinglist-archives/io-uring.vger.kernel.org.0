Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5659B3FF41E
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbhIBT00 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbhIBT0Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:25 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C981CC061757
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:26 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y18so3960124ioc.1
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnwLvrQjGybnp4kxZBfXxkU5T+J0SsOub95EsEA6yTY=;
        b=TAAEkHgtcg8me1Htvrv5Wg5NYQLKuyfxz7/qk9Ll4KZxkfVWf9m+sZbbO1CiYNsYvm
         Vd1PdzNsNjfZz07kFjbyD/ZByahrEdSk2Ft4127vZDZ3gdVKA8KMvikFNXPAaz+a9xln
         Ep1Ca4u9rOu3nCEj+e6oYkApZXpyIII0XiGgOcLshv+ezFGTwFvCPxvRpR+ydJK328o0
         hG25bqRMy5OAOoiWaSSwd0zsyh5jOcOaIypn23DRJQZPuLYIFu0O/guZjaVc4GrBilY+
         Na7MvKYB/DzBrJpgo1KX9XPGvfM6QTiCYA3wlbiubOTVtr59rby1LDbiXQ2n4jyaHQPH
         ggcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnwLvrQjGybnp4kxZBfXxkU5T+J0SsOub95EsEA6yTY=;
        b=Nm1QyPFzv2j7h9V21U3qEOxR+adczjypiyt8Y3jZe+aF0r9PfO0g8fXcZNsk52PpI1
         7bhP5oZza17sddj3axCAjr3QX4BJ3/UtzDavHeMI4kct8J6AqReXapj+bmVrjj6jqPdZ
         y2SndH9CizJNgnvTak4MRQqlH8z8RBNcLJ7EjlB982QKahSeAh73qsYOfkJDzS49fcjI
         zpoXhjoq2IsbdnYePtJrkP5UQeqlRH7B5oSXF9ezhZyiJWzT1lpvQm/5pN2D0hMCIytM
         YD6OKbdZJsX801He5b9N0Fd83kMa1yWKTq1zAW7FWsTwbjil++iwbIeFqldrhE+eYf4I
         KCYQ==
X-Gm-Message-State: AOAM532glSLuAQVFUddeVVg2vISOtRsWQ6NSTGuqP7coEQQ0/Kv1DxZy
        /HtcX0hIESHEo/JTTOLaupqGpMW2EgEEDw==
X-Google-Smtp-Source: ABdhPJybLvF+kIHnhQTkjAcnuXCUlspoD66bRMgbLuwlj4sSKDcQn+87Zbud9YPsRyfxaQQiMe88Yg==
X-Received: by 2002:a02:cc59:: with SMTP id i25mr4257164jaq.125.1630610724997;
        Thu, 02 Sep 2021 12:25:24 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io-wq: fix queue stalling race
Date:   Thu,  2 Sep 2021 13:25:16 -0600
Message-Id: <20210902192520.326283-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210902192520.326283-1-axboe@kernel.dk>
References: <20210902192520.326283-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to set the stalled bit early, before we drop the lock for adding
us to the stall hash queue. If not, then we can race with new work being
queued between adding us to the stall hash and io_worker_handle_work()
marking us stalled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a94060b72f84..aa9656eb832e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -436,8 +436,7 @@ static bool io_worker_can_run_work(struct io_worker *worker,
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
-					   struct io_worker *worker,
-					   bool *stalled)
+					   struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -475,10 +474,14 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 	}
 
 	if (stall_hash != -1U) {
+		/*
+		 * Set this before dropping the lock to avoid racing with new
+		 * work being added and clearing the stalled bit.
+		 */
+		wqe->flags |= IO_WQE_FLAG_STALLED;
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
-		*stalled = true;
 	}
 
 	return NULL;
@@ -518,7 +521,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
-		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -527,12 +529,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		stalled = false;
-		work = io_get_next_work(wqe, worker, &stalled);
+		work = io_get_next_work(wqe, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (stalled)
-			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock(&wqe->lock);
 		if (!work)
-- 
2.33.0

