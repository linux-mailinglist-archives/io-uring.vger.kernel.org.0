Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF21F0C72
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgFGPeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgFGPeJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:09 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30AC08C5C3;
        Sun,  7 Jun 2020 08:34:08 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x6so14672883wrm.13;
        Sun, 07 Jun 2020 08:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=C3aCZY+VITj7C4JItC4Fgt+Bj4MVRdBKF8f/Zz68P+4=;
        b=clpcWgvEsZLyg5pL8qXsCoM5iQp/C/TsvDbvJEhaxmT0VYHmzdHx+H3f1BGFIcNOsX
         LjrDIw5vHzoJzzUTftsR7Cdv9NQlkbv6wrhrmpdrjtE2O2/brlI018/Pt4hVBn7h6HW3
         pBauvaC8WePu+ftpt5YjOXy05Kyn2OJX6gSh+yzKBCgOLKcoDgNo7SsQjzymSzrhTj1c
         c5PhbQoojzODRwuMx8KT0kvNqNxMJsw63XGzLNC+gpMBWbXqGQ7dfXfSjIppyV7VE3vs
         K73gZ0X4Z4lo3XNynYowMYdDtLsKDyfsj/Zgmd80lgGtJsROSfsOb0x+f8jskZ4s5A58
         HHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C3aCZY+VITj7C4JItC4Fgt+Bj4MVRdBKF8f/Zz68P+4=;
        b=fRSyum3c+YtlxsDeqvq6uF5KNRR3NjPRmnSCcjbO9Kh6d5H8rc9uWhajfREa8fgjjv
         guidk2716yX2Hu03bGst9LolnCcF+g1yiNQ13dHlM4l5BBW3Nl7lkw9UmxtuBkBF2X+4
         nOxnqjvYy3zj1Wv4uvvmCTPBTM/Wu5A4++PVAaDqzQrgCQKQRtfO/JSpCS9etujNXOe/
         VrOeokj7yzphCWIP+blP1UdvwdNIdzlPI3QSfgDSHQSXwM1PR/PwgFsX8XzN3hTnyNL5
         nivMKu+L/8bOKBerp7jq6UN+utSAZGb1QlnQFqwh7TpJHCy7Ng/FPwLW5IOdVyZNAx1o
         m5OQ==
X-Gm-Message-State: AOAM530cBgF6THyJk8QCKFvv/JOlKyWkvOwT+B9ye2IP/79X2100JOK0
        RApigZSTYS1zaNhAt56Wo9M=
X-Google-Smtp-Source: ABdhPJw1LdN+FBG+kt9GK5YA2HX3rrxobVovURYwMaN9JoKOKYaBsQiVzDIv5vUxkojvavNQ8ldRew==
X-Received: by 2002:a5d:4e87:: with SMTP id e7mr18323418wru.427.1591544046951;
        Sun, 07 Jun 2020 08:34:06 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io-wq: reorder cancellation pending -> running
Date:   Sun,  7 Jun 2020 18:32:22 +0300
Message-Id: <4d250faf3029d6bd31973276701d5971db696004.1591541128.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
References: <cover.1591541128.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Go all over all pending lists and cancel works there, and only then
try to match running requests. No functional changes here, just a
preparation for bulk cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 54 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4023c9846860..3283f8c5b5a1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -931,19 +931,14 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	return ret;
 }
 
-static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
-					    struct io_cb_cancel_data *match)
+static bool io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
 	bool found = false;
 
-	/*
-	 * First check pending list, if we're lucky we can just remove it
-	 * from there. CANCEL_OK means that the work is returned as-new,
-	 * no completion will be posted for it.
-	 */
 	spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
@@ -956,21 +951,20 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	}
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if (found) {
+	if (found)
 		io_run_cancel(work, wqe);
-		return IO_WQ_CANCEL_OK;
-	}
+	return found;
+}
+
+static bool io_wqe_cancel_running_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	bool found;
 
-	/*
-	 * Now check if a free (going busy) or busy worker has the work
-	 * currently running. If we find it there, we'll return CANCEL_RUNNING
-	 * as an indication that we attempt to signal cancellation. The
-	 * completion will run normally in this case.
-	 */
 	rcu_read_lock();
 	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
 	rcu_read_unlock();
-	return found ? IO_WQ_CANCEL_RUNNING : IO_WQ_CANCEL_NOTFOUND;
+	return found;
 }
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
@@ -980,18 +974,34 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 		.fn	= cancel,
 		.data	= data,
 	};
-	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
 	int node;
 
+	/*
+	 * First check pending list, if we're lucky we can just remove it
+	 * from there. CANCEL_OK means that the work is returned as-new,
+	 * no completion will be posted for it.
+	 */
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		ret = io_wqe_cancel_work(wqe, &match);
-		if (ret != IO_WQ_CANCEL_NOTFOUND)
-			break;
+		if (io_wqe_cancel_pending_work(wqe, &match))
+			return IO_WQ_CANCEL_OK;
 	}
 
-	return ret;
+	/*
+	 * Now check if a free (going busy) or busy worker has the work
+	 * currently running. If we find it there, we'll return CANCEL_RUNNING
+	 * as an indication that we attempt to signal cancellation. The
+	 * completion will run normally in this case.
+	 */
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		if (io_wqe_cancel_running_work(wqe, &match))
+			return IO_WQ_CANCEL_RUNNING;
+	}
+
+	return IO_WQ_CANCEL_NOTFOUND;
 }
 
 static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
-- 
2.24.0

