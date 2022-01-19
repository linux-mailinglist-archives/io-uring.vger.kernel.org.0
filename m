Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38D6493313
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351046AbiASCmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351040AbiASCmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:49 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB02C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:49 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id e8so925940ilm.13
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IFyirZnLCthMo4svojlXOKbCwV/+Jr8P1f0i0akXm+o=;
        b=Rz8V3DQtrIgd89CNzSgp0vmepiel8QXoq68qo+8NcwGfXmNUR4XkhkTaGhyryR779a
         MwePeacqs0oQbI1lPYJesDMUgj6Ror2Ns56UFrKC/uKJGPaVASyrRlkHrjAXo9xjp5GA
         WAMza7N7tyK/f8qUJdCfmWe6amY2ZJxPIBVntow6QmjXt7CLCCNVq7bK0La14w1dpKW6
         jl2AxYLJALGSIECssBqkN1rMFnkTLd83ba+Z6klaLeLDtqtpkK/S7tH80El9dnz7w5RO
         CboUo5DQIg8xZWFhKszIB0fxCOKCxWRJBeCanB/LUKs28tCtV6EwLhpHLCSMPbtU+4kg
         9izQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IFyirZnLCthMo4svojlXOKbCwV/+Jr8P1f0i0akXm+o=;
        b=cGxTdGopzRj25F3yXSv98CeAA7LHPr3boyuU9Mzk38V9pQuXhf5bJnufb0MI2iZrn+
         qMcd5iQZgia+jX2SjHpGRL8Ha/tuODI29xlANE6afxZv79BL2zsVEd/lVMzjfdd5TE3i
         y/BP1ZKX1Q5vxNgLa7lIubflsr/kVE0ooICu2VIXc/vfa69+LnuQouoCvwZyJTFBztUg
         pdAH5NI59bhm7otZsgSjC6d8KoXaszTXguugfViPt22gudYoSdJdOOj+VSPYhh0/5bUJ
         S6c2Mj5qIX1To7BKO6AHNvmjdlayopRGechKZBlHNc2XogdF3X6TRwMTzah4Hchp0YkW
         e/Hg==
X-Gm-Message-State: AOAM533rBMgq6UYD9R2zDNkGnC33MUWUv6aCUF3rMAnhO4bTZ5X1zJXH
        +rr7pg+ORtVWtdWw0uUGveWZIf82B1Xvcw==
X-Google-Smtp-Source: ABdhPJwK5JsE0eY60//4Mucqjx/VdCVnkGO9HgEOjlIFRIfgFxEP0WC9W7OmOjpaiCXJR3uTaGeRGw==
X-Received: by 2002:a92:ca4b:: with SMTP id q11mr15122589ilo.147.1642560168389;
        Tue, 18 Jan 2022 18:42:48 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Florian Fischer <florian.fl.fischer@fau.de>
Subject: [PATCH 5/6] io-wq: add intermediate work step between pending list and active work
Date:   Tue, 18 Jan 2022 19:42:40 -0700
Message-Id: <20220119024241.609233-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have a gap where a worker removes an item from the work list and to
when it gets added as the workers active work. In this state, the work
item cannot be found by cancelations. This is a small window, but it does
exist.

Add a temporary pointer to a work item that isn't on the pending work
list anymore, but also not the active work. This is needed as we need
to drop the wqe lock in between grabbing the work item and marking it
as active, to ensure that signal based cancelations are properly
ordered.

Reported-by: Florian Fischer <florian.fl.fischer@fau.de>
Link: https://lore.kernel.org/io-uring/20220118151337.fac6cthvbnu7icoc@pasture/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index db150186ce94..1efb134c98b7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -48,6 +48,7 @@ struct io_worker {
 	struct io_wqe *wqe;
 
 	struct io_wq_work *cur_work;
+	struct io_wq_work *next_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -530,6 +531,7 @@ static void io_assign_current_work(struct io_worker *worker,
 
 	raw_spin_lock(&worker->lock);
 	worker->cur_work = work;
+	worker->next_work = NULL;
 	raw_spin_unlock(&worker->lock);
 }
 
@@ -554,9 +556,20 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
-		if (work)
+		if (work) {
 			__io_worker_busy(wqe, worker);
 
+			/*
+			 * Make sure cancelation can find this, even before
+			 * it becomes the active work. That avoids a window
+			 * where the work has been removed from our general
+			 * work list, but isn't yet discoverable as the
+			 * current work item for this worker.
+			 */
+			raw_spin_lock(&worker->lock);
+			worker->next_work = work;
+			raw_spin_unlock(&worker->lock);
+		}
 		raw_spin_unlock(&wqe->lock);
 		if (!work)
 			break;
@@ -972,6 +985,19 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
 }
 
+static bool __io_wq_worker_cancel(struct io_worker *worker,
+				  struct io_cb_cancel_data *match,
+				  struct io_wq_work *work)
+{
+	if (work && match->fn(work, match->data)) {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		set_notify_signal(worker->task);
+		return true;
+	}
+
+	return false;
+}
+
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
@@ -981,11 +1007,9 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	 * may dereference the passed in work.
 	 */
 	raw_spin_lock(&worker->lock);
-	if (worker->cur_work &&
-	    match->fn(worker->cur_work, match->data)) {
-		set_notify_signal(worker->task);
+	if (__io_wq_worker_cancel(worker, match, worker->cur_work) ||
+	    __io_wq_worker_cancel(worker, match, worker->next_work))
 		match->nr_running++;
-	}
 	raw_spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;
-- 
2.34.1

