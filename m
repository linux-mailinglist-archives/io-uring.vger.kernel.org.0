Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE760155B07
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 16:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgBGPuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 10:50:46 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44801 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgBGPuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 10:50:46 -0500
Received: by mail-il1-f194.google.com with SMTP id s85so2060674ill.11
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 07:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nx0zLuuSVjRcGRsww4pu5U9gDsXqI3Akdw0A9ohFK7Y=;
        b=U5jczplXQveO0KalMqRoJuda1kPErLvkWKMPCukcoNgLl8TDasvPSMqpEhW3K2A7QG
         xBMva5AlMnq6+pMcpi/zoDWIEZtR0IzxX6bj+DyY1GBiXj3KPvzjZEJ9AvfWseQzLaEz
         sSge08jGegx6tR9ttSjlzjWPbKfTZ6tKnbWgw/zxJ6WtA8iJ4bFfufaM4NJWwho13IGP
         G2oLDV/FW0AYTlJaiiblHhxk4xGCVZqEqZe7mZEDxei4uOmviqkfnbbYix0qwENgisEI
         DuFyIfC1xFaOYK5xxtRkSvDoGuN4iR+Kd+jp4hVUURNupG85xC+nuYZaIVVOXDCe3iHc
         tzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nx0zLuuSVjRcGRsww4pu5U9gDsXqI3Akdw0A9ohFK7Y=;
        b=mf8rtJzxkIjjSaUD3Z/cgulgCEGltBW6qVrIuZgrsvoRkKtBNzl25WEatmP3o9s8CD
         ixy1xB3OYwyjW5nvqNlZ+b90LVkw+e0NIWRg9E4WidSJuwFRYt3Fw/8OlPrhbW5oi9Oq
         mN9XlVJwfhLjU9xiDxBoRkSjGDu5a3PdZuHFIoo5ZGtowdVG9h8i1cpTEivrgNuPolgX
         2LexIqgRMDkJvwcqWcyNPomI5XK/fDJlYCFmng8Lfxg4lugwMfkFfUaGpb/3PcztXg+Y
         W//8Znrytb4gpIwGHdXemx6vGbqBdvUvFfrLCFAChNlB21VISaDM50QXAzUgbM2B3wb1
         BPGQ==
X-Gm-Message-State: APjAAAXvR0m9rKVVM1TQvUlPiDWcXYyLuFpLBVO86KkpXWRtyV+M84QW
        /Pyv1JQoBG3WprtT3a7xNFW0ttLQteA=
X-Google-Smtp-Source: APXvYqyoZ2iJ5KXnzvRrreffn5xVZZk3OWx68UF4f0y8JCz/viBDaBujmWn6vV5lvVN49Uk4S5y+hw==
X-Received: by 2002:a92:b648:: with SMTP id s69mr31214ili.184.1581090645143;
        Fri, 07 Feb 2020 07:50:45 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm978493iom.71.2020.02.07.07.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:50:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io-wq: add support for inheriting ->fs
Date:   Fri,  7 Feb 2020 08:50:37 -0700
Message-Id: <20200207155039.12819-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207155039.12819-1-axboe@kernel.dk>
References: <20200207155039.12819-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some work items need this for relative path lookup, make it available
like the other inherited credentials/mm/etc.

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

