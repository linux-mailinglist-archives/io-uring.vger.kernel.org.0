Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15F156BB3
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBIRLV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:11:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45090 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgBIRLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:11:20 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so2559022pgk.12
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6e+uo3ACeZgZd+51AcSYalJRF8CRxNO3ZDnpAk/rqw=;
        b=G+sXD4VPjr1vJd7iedX3vFRboOBzdEcoFJAGqgegulzaHc/odO5hG0kpmBXKLITInn
         LGiLBuRYe8Wn2TN0ViXc1r83AesvGBYDOOf7LI5BQXu3S2zZb+u2kqj4wmOJB4tz8M4R
         zKvQ/5fGhZxYBAGreRk5vYZDZezzrzOqpVmeF9PNFgprA1ydMxkEzgMSdjmOAXe3UfnW
         +UFrSrF3Y8VKhiWppBaAI39+9l6BJ5vHShEUrJdJqblUFvEK1VM7dOSJmXObAsLoTjsX
         Nv78eBHJb9pUXNxVACDjLNgX/W4iy//A3yGGXS98Z0mBu95GjA3/EoOdnCiphyVSiPQ1
         mESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6e+uo3ACeZgZd+51AcSYalJRF8CRxNO3ZDnpAk/rqw=;
        b=jDgiOBbq3HGcsTdDthPOpZ7ibVHeMBsgmBqFDPfXEZJseKvdZ8ZIA6dOl6jVjjnE9B
         0eMp0YeaDw7bwh1+RXWfJfiY/dOSgeCdNphagcVn64C9iwjDO7a1uVPQN64dhTIJS3oP
         zG8mPuB+Me1/Qkho+UAYe5YUEDcL46Whdnx25mRoCuO/C/j3YwLTk9L00ieykJj703uS
         CyjPgOnpDPnlKbBJLSQKEl4uxQomSJvECAtS5yBpYsw92fGu1A+hFJFK5DiHFlhGbUlJ
         EtUfbx5fSzZ36C6ofMIyjA3XkTEh9BDSUw8EPDQimzWYHZFg2lPemjYGyFz2Tpj6/z8L
         +qRQ==
X-Gm-Message-State: APjAAAVGhh2/t6C+XXqCdiEOqfR0LMo3oODmDwPH+sGjQuhhZqYiMe+5
        vbRn/Ki6SfSOfvE5C82ZFcOGy23TXTg=
X-Google-Smtp-Source: APXvYqxRPIgDsLsrs1Cy2bqL1g658UW/fROT4Uytt50DlnKMscX8G18Llo7gcOO5AXcfR8REOiZ4eA==
X-Received: by 2002:a62:6409:: with SMTP id y9mr9236624pfb.30.1581268278539;
        Sun, 09 Feb 2020 09:11:18 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o9sm9703271pfg.130.2020.02.09.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:11:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/3] io-wq: add support for inheriting ->fs
Date:   Sun,  9 Feb 2020 10:11:11 -0700
Message-Id: <20200209171113.14270-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171113.14270-1-axboe@kernel.dk>
References: <20200209171113.14270-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some work items need this for relative path lookup, make it available
like the other inherited credentials/mm/etc.

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 19 +++++++++++++++----
 fs/io-wq.h |  4 +++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cb60a42b9fdf..58b1891bcfe5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
+#include <linux/fs_struct.h>
 
 #include "io-wq.h"
 
@@ -59,6 +60,7 @@ struct io_worker {
 	const struct cred *cur_creds;
 	const struct cred *saved_creds;
 	struct files_struct *restore_files;
+	struct fs_struct *restore_fs;
 };
 
 #if BITS_PER_LONG == 64
@@ -141,13 +143,17 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		worker->cur_creds = worker->saved_creds = NULL;
 	}
 
-	if (current->files != worker->restore_files) {
+	if ((current->files != worker->restore_files) ||
+	    (current->fs != worker->restore_fs)) {
 		__acquire(&wqe->lock);
 		spin_unlock_irq(&wqe->lock);
 		dropped_lock = true;
 
 		task_lock(current);
-		current->files = worker->restore_files;
+		if (current->files != worker->restore_files)
+			current->files = worker->restore_files;
+		if (current->fs != worker->restore_fs)
+			current->fs = worker->restore_fs;
 		task_unlock(current);
 	}
 
@@ -311,6 +317,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_files = current->files;
+	worker->restore_fs = current->fs;
 	io_wqe_inc_running(wqe, worker);
 }
 
@@ -476,9 +483,13 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (work->flags & IO_WQ_WORK_CB)
 			work->func(&work);
 
-		if (work->files && current->files != work->files) {
+		if ((work->files && current->files != work->files) ||
+		    (work->fs && current->fs != work->fs)) {
 			task_lock(current);
-			current->files = work->files;
+			if (work->files && current->files != work->files)
+				current->files = work->files;
+			if (work->fs && current->fs != work->fs)
+				current->fs = work->fs;
 			task_unlock(current);
 		}
 		if (work->mm != worker->mm)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 50b3378febf2..f152ba677d8f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -74,6 +74,7 @@ struct io_wq_work {
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
+	struct fs_struct *fs;
 	unsigned flags;
 };
 
@@ -81,10 +82,11 @@ struct io_wq_work {
 	do {						\
 		(work)->list.next = NULL;		\
 		(work)->func = _func;			\
-		(work)->flags = 0;			\
 		(work)->files = NULL;			\
 		(work)->mm = NULL;			\
 		(work)->creds = NULL;			\
+		(work)->fs = NULL;			\
+		(work)->flags = 0;			\
 	} while (0)					\
 
 typedef void (get_work_fn)(struct io_wq_work *);
-- 
2.25.0

