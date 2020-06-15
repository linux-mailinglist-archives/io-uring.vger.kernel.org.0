Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38E1F8F7B
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgFOHZm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgFOHZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:25:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0157C05BD43;
        Mon, 15 Jun 2020 00:25:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l11so15932088wru.0;
        Mon, 15 Jun 2020 00:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PLjL6HSHY4IJ365TM4h+lxLSvM2NbFHY6SA4XyxEBB4=;
        b=tLrDJLkZDRVnjFxFLmgsQ3ULT2ojxnNmYewJdXdS24AvQama1uwWVUVMV/HYsMZM4m
         VqT51cc4fFsFh8BFwfxjM8YwX1jMmflJeAyCVVae7kDXxH/6aHPeHPavG84pB2mMrhlE
         mEz2M5Eldfhe7VOKp5OhOCM8TcHOxss8d3TbFTdrk4oT+C6RZIlJkhh3MF7hd2WcfHJ5
         QvzvGN5J5z2Am5Ug9H6/ZA+oEFTorU5LOANQeI17QDUpnZPU7+uSMxKyxKDd7fu27/Cr
         zgeqBaemS9SEa/A2JUNau6lb4DH6Uv9i5QYoAxEYVx4jtfHnbLXi+BABU5zIEHl7xsRt
         JC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLjL6HSHY4IJ365TM4h+lxLSvM2NbFHY6SA4XyxEBB4=;
        b=C/YMIihNYi/bqKdLU8zn+hGyoRnYSCpH3BNQ92bTYuIKz4eRcBi8QZhZa/BdCU030q
         zpQTsSB5UD+9AVjqQA5C/Hxx6jsSBENu4fYJg8prHfTwCcKHERtEWj1uS5mibRWLvjx3
         qnIHQn4LraVRkhU3OJh3s/3LBnf1iFTgwHC/3Pf5hLVFY5aOSu1s+dkMp3fLnMdNA0c/
         3/8OA06qU5wHNiMrn8XryAGykA4BTATWw+f/4cIFa17QXw2DVLSh23BDAuohQT+RCtpi
         0W9IVO1bxcLXJCP2BH+RWOTNxhhv+rt6OQqR44f9X+tbo+auI6dMTOVFHrr04WjHqQHh
         lu1g==
X-Gm-Message-State: AOAM5314FjRY4ggFw4iGVlTSlu7Opw0CL/OZBcMDMFSZpAC4+638F+Qf
        2H3Fj9zRQ4PIw5wUFnJSJDk=
X-Google-Smtp-Source: ABdhPJwBM+6QlpShroHFAuWaKW8NClQbcN/fCHd+9QF3ysgA3y/xoXRO/Ji52WmKkqjUiEXe2CHp/g==
X-Received: by 2002:a5d:61d0:: with SMTP id q16mr28828521wrv.182.1592205937383;
        Mon, 15 Jun 2020 00:25:37 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b187sm21897402wmd.26.2020.06.15.00.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:25:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] io-wq: reorder cancellation pending -> running
Date:   Mon, 15 Jun 2020 10:24:02 +0300
Message-Id: <56dea8bebbbc4d960519dacb07ad5062f5d14906.1592205754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592205754.git.asml.silence@gmail.com>
References: <cover.1592205754.git.asml.silence@gmail.com>
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
index d7dc638f4b8e..9e7d277de248 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -932,19 +932,14 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
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
@@ -957,21 +952,20 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
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
@@ -981,18 +975,34 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
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

