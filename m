Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D88C156BBA
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgBIRMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:12:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36065 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbgBIRMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:12:33 -0500
Received: by mail-pj1-f67.google.com with SMTP id gv17so3146696pjb.1
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmCgVtnI7tJ5yScIKrnRflrJ1Auj9+ahfJ7QOk2HlCg=;
        b=Ok+0pnt8VWMq0RuW7MoT2nkg4TgwvwHwfhs+QnGdotZdwup8ao1vUQCgcZr3LlqM4N
         W4kuRVw8RPaxU4CrC8qErkxSfhiVvA5RYihH72B9QVYKGekNNmeIKV0QVsAFJmWbeBba
         o+honY0IOxpq1OU1QNwmIciAampH+43Gw0UvBVeZm3Pu8zartTP/IrUqvaw44Icd+M7z
         WUAOsInTicbcVzPpxlk/7UYCopAsbl7GQ2S2koz5hfZu13FTVhwDNZWViYPmkWwnKCOe
         8YCsUAYU9b3ahXWPbipLuqgPpRqq89HnheI+DZwMkaY+6txDVGwr5wk9vZwqSLdGZQv+
         k5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmCgVtnI7tJ5yScIKrnRflrJ1Auj9+ahfJ7QOk2HlCg=;
        b=UUkxQuueVloQiGtKIVHrlOqTVse55WygLH9OTroqz3ebezHDxyfYHyw3DO0tWb3a5o
         zeFjixkdvvOjn8VSzT91kxIn7gcCFy3x2DTv8kTrPFEltDi4RQ+dBWQlCuiHSMontJNt
         Ie0LUae31ejH/v92yvGe3jtQncfglVSGQdnUIFD+gfxkA0uLDfECFnTAiTLfAHECb/iq
         vHDyRtT4ic+1/wpFS78V/51tNB+K1EkH1BflhotJ4egPR8K9hEWQ3yZpSvzin6Nz6h94
         3nFvNqqtJOarjiwNkf4DwiDVP2eOcryeYE3Ku2vxHFO4uzO7XncQmTVuKsTXMVEDj1VQ
         +jDA==
X-Gm-Message-State: APjAAAVPE3ErAQKNtX21IHH4ssb3/aS17SnYPnPGLyOvDsbtoL1FtRfO
        L2xYGsRSX28QQbMvQsGOmp5w4IarGhk=
X-Google-Smtp-Source: APXvYqzp6CsmYfn0/bIVcMU1nL/c3OSIxZiZ3ISMGQHOXCuYRDqwcI4MbZU0mElo0njpbqAjr0cKDQ==
X-Received: by 2002:a17:90a:f84:: with SMTP id 4mr16294426pjz.74.1581268351607;
        Sun, 09 Feb 2020 09:12:31 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z29sm9869695pgc.21.2020.02.09.09.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:12:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io-wq: make io_wqe_cancel_work() take a match handler
Date:   Sun,  9 Feb 2020 10:12:21 -0700
Message-Id: <20200209171223.14422-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171223.14422-1-axboe@kernel.dk>
References: <20200209171223.14422-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to use the cancel functionality for canceling based on not
just the work itself. Instead of matching on the work address
manually, allow a match handler to tell us if we found the right work
item or not.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 58b1891bcfe5..4889b42308ac 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -940,17 +940,19 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	return ret;
 }
 
+struct work_match {
+	bool (*fn)(struct io_wq_work *, void *data);
+	void *data;
+};
+
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
-	struct io_wq_work *work = data;
+	struct work_match *match = data;
 	unsigned long flags;
 	bool ret = false;
 
-	if (worker->cur_work != work)
-		return false;
-
 	spin_lock_irqsave(&worker->lock, flags);
-	if (worker->cur_work == work &&
+	if (match->fn(worker->cur_work, match->data) &&
 	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL)) {
 		send_sig(SIGINT, worker->task, 1);
 		ret = true;
@@ -961,15 +963,13 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 }
 
 static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
-					    struct io_wq_work *cwork)
+					    struct work_match *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
 	bool found = false;
 
-	cwork->flags |= IO_WQ_WORK_CANCEL;
-
 	/*
 	 * First check pending list, if we're lucky we can just remove it
 	 * from there. CANCEL_OK means that the work is returned as-new,
@@ -979,7 +979,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 
-		if (work == cwork) {
+		if (match->fn(work, match->data)) {
 			wq_node_del(&wqe->work_list, node, prev);
 			found = true;
 			break;
@@ -1000,20 +1000,31 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	 * completion will run normally in this case.
 	 */
 	rcu_read_lock();
-	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, cwork);
+	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
 	rcu_read_unlock();
 	return found ? IO_WQ_CANCEL_RUNNING : IO_WQ_CANCEL_NOTFOUND;
 }
 
+static bool io_wq_work_match(struct io_wq_work *work, void *data)
+{
+	return work == data;
+}
+
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 {
+	struct work_match match = {
+		.fn	= io_wq_work_match,
+		.data	= cwork
+	};
 	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
 	int node;
 
+	cwork->flags |= IO_WQ_WORK_CANCEL;
+
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		ret = io_wqe_cancel_work(wqe, cwork);
+		ret = io_wqe_cancel_work(wqe, &match);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
 	}
-- 
2.25.0

