Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81311F8F7C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgFOHZp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgFOHZm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:25:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10057C05BD1E;
        Mon, 15 Jun 2020 00:25:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t18so15927266wru.6;
        Mon, 15 Jun 2020 00:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nb16NTER+xpaHsVhWoWJPF4ib0zB+sCmpD4uKPsQK90=;
        b=bmmzQQ/GjlL2wJU6lF6sbg5E28rEUR1tyA0WHuN5wVeFKIeEl6N/tltEu8U8uORn2r
         TBgQdbVhPpknpuUOER9QYdPJtaH8QxFlt7qh9CCdVo9DejN9s0bv8MQAdXntK0XYbxvP
         0oDCbBGWp9pxOawH0oSCOqiHGA+oGwcrHNg3ekpvGSO2SnqB7lVKG2uP39qKB3fdo3jS
         CaP/58DkjQzLdLzVKtydVWsceDQr5FWMmXO4HLC1M/q9htw7zMnz6GvPJesYGZVin690
         N2rIJ0JlAK6xlrLwkcdaVyw2UxMAJ0lVWlIWjF0564BLMiS21gwUW45BvgJHrF3TNZ+i
         x6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nb16NTER+xpaHsVhWoWJPF4ib0zB+sCmpD4uKPsQK90=;
        b=cVgLF98NOxw1eVrVci9oHNq+XxMYUo9BDPOc9CUGUETaBDaiCQnL48Yc4QWUrFkuSs
         S3R0yIrAnQjj1FBRJ7r+Hdcfr2x0uMg3pAMxr/v4+zvzGjg4GISTtaXIji+6mk9nLDwa
         etogHsmDXp+lz3tEpAbqufE0OJrM9iwThuloohL8V0I3MlIK8CeUFTZywD06WaIA0j95
         +I3MSWePSQrmEXMSNjjl45KGVHoLzTB9wQsjv6WxF1iUu1a71LuBe0Y7o8c7EThZjUvP
         2UMyyOz0+lObeZSYlzPyjKRAJj0wjorZ5zzV7w/oZ/tBLYOCydAmj+gDi9abPoeFw80E
         kECQ==
X-Gm-Message-State: AOAM531evOLHBVN9kn3TRyYoRSLI0Bv2xR+hCsxiGaRSZ4+4D1Xe0cCZ
        5gLDaMk36EarDs/5xjrQvRXxRvNH
X-Google-Smtp-Source: ABdhPJye24RWgWJOgiZeU4B2GS5O9/UD8w/lbkYYMMsJKl9O2KsFaKRS02bo9zC1imfhULIKKambsw==
X-Received: by 2002:a5d:6550:: with SMTP id z16mr29326696wrv.392.1592205939801;
        Mon, 15 Jun 2020 00:25:39 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b187sm21897402wmd.26.2020.06.15.00.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:25:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] io_uring: cancel all task's requests on exit
Date:   Mon, 15 Jun 2020 10:24:04 +0300
Message-Id: <c587cf1bfa2e842a207efd50abdbc7d81e033463.1592205754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592205754.git.asml.silence@gmail.com>
References: <cover.1592205754.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a process is going away, io_uring_flush() will cancel only 1
request with a matching pid. Cancel all of them

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 14 --------------
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 14 ++++++++++++--
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3b0bd956e539..a44ad3b98886 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1023,20 +1023,6 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
 }
 
-static bool io_wq_pid_match(struct io_wq_work *work, void *data)
-{
-	pid_t pid = (pid_t) (unsigned long) data;
-
-	return work->task_pid == pid;
-}
-
-enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
-{
-	void *data = (void *) (unsigned long) pid;
-
-	return io_wq_cancel_cb(wq, io_wq_pid_match, data, false);
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 7d5bd431c5e3..b72538fe5afd 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -125,7 +125,6 @@ static inline bool io_wq_is_hashed(struct io_wq_work *work)
 
 void io_wq_cancel_all(struct io_wq *wq);
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
-enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f18c29388d6..8bde42775693 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7428,6 +7428,13 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static bool io_cancel_pid_cb(struct io_wq_work *work, void *data)
+{
+	pid_t pid = (pid_t) (unsigned long) data;
+
+	return work->task_pid == pid;
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -7437,8 +7444,11 @@ static int io_uring_flush(struct file *file, void *data)
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
+		void *data = (void *) (unsigned long)task_pid_vnr(current);
+
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_pid_cb, data, true);
+	}
 
 	return 0;
 }
-- 
2.24.0

