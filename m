Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5919FE69
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 21:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgDFTtA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 15:49:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45569 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 15:49:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id o26so488890pgc.12
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 12:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dBG5qEgkJuwOYLwi4cG0+3FMjVtBSj7Afv7kmp6OHDQ=;
        b=r+ZcuBYsfec1so7/S4eG+eRVBnmFLq6abY2S+4qBPa1yk5SE7gUY1es3++aENxgE+Z
         T0quZri8us2S570YHsRVWVn1WvsPQDJKMNM5v4pu9MLiPwC36oJ5sh5rToFPZ0pv0pmm
         I8EF+BkT1CR8MzSCyNPVNR7AAlp9dFJUwtI+dZbehJLqEGRCt+J3Bio/iio1s71FV41n
         N6COJ1i3US9shae/lXtmr19Ln7q+ph9x+wt4JCFM09SiTng9makHlGAt4zdeeHtXFx6t
         HU7KcPaID43LALl+RUkzmT/cWglsiBEdFB9X5sZBa1lk0yHRc0Vl2PmFyg4yCHAQ+SMw
         TIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dBG5qEgkJuwOYLwi4cG0+3FMjVtBSj7Afv7kmp6OHDQ=;
        b=AwG27nRoNt9yEu6J/tTHZvUCAXei+gEhqIt/qpRXlfjk7UZqu8x2uBzULrfDtsHHoD
         OCsSu2+FJRMV2r2UYBOepCJcbpK3+lmkQYif2OVWAgs3Fe6eCjFRNUYvjxryh6Yzielq
         em2/1G8tYUooERRtU9Lavzas5G7e82/WMucm3mTVpIROeF0xbzcrXRYEBsiQJjaYSTiY
         RvSjUBD8x3ho3O0wkylq6W9JuiZaCGJIG3x89iA6kvG01cDRiMKnkhbnimnP3Voz37l2
         4D/wJOIUyAdpikZGypNd6TvI/Oj3RlcNffaaRRV3khEept4+emVw4Hg0HQaH1oiqwRpr
         dS3g==
X-Gm-Message-State: AGi0PuYnvxf9rVe7sXSIQS5nJDKavnqFRYX6mfOoeOkapAfInporGxX2
        ABdaLd+GfrrybuK0h6PzsMZ6zQkCy7Io1Q==
X-Google-Smtp-Source: APiQypJhpSSLe+nkFKcr6i6WH+W8R7jpibi+iSxnXCSAtk8Xz2T1uWPTM7PGEzXbRayTHhIzh8u0bA==
X-Received: by 2002:a63:1118:: with SMTP id g24mr714465pgl.259.1586202538793;
        Mon, 06 Apr 2020 12:48:58 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id g11sm362620pjs.17.2020.04.06.12.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:48:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] task_work: don't run task_work if task_work_exited is queued
Date:   Mon,  6 Apr 2020 13:48:51 -0600
Message-Id: <20200406194853.9896-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200406194853.9896-1-axboe@kernel.dk>
References: <20200406194853.9896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If task_work has already been run on task exit, we don't always know
if it's safe to run again. Check for task_work_exited in the
task_work_pending() helper. This makes it less fragile in calling
from the exit files path, for example.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 4 +++-
 kernel/task_work.c        | 8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 54c911bbf754..24f977a8fc35 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -7,6 +7,8 @@
 
 typedef void (*task_work_func_t)(struct callback_head *);
 
+extern struct callback_head task_work_exited;
+
 static inline void
 init_task_work(struct callback_head *twork, task_work_func_t func)
 {
@@ -19,7 +21,7 @@ void __task_work_run(void);
 
 static inline bool task_work_pending(void)
 {
-	return current->task_works;
+	return current->task_works && current->task_works != &task_work_exited;
 }
 
 static inline void task_work_run(void)
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 9620333423a3..d6a8b4ab4858 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,7 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+struct callback_head task_work_exited = { };
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -31,7 +31,7 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 
 	do {
 		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
+		if (unlikely(head == &task_work_exited))
 			return -ESRCH;
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
@@ -95,14 +95,14 @@ void __task_work_run(void)
 	for (;;) {
 		/*
 		 * work->func() can do task_work_add(), do not set
-		 * work_exited unless the list is empty.
+		 * task_work_exited unless the list is empty.
 		 */
 		do {
 			head = NULL;
 			work = READ_ONCE(task->task_works);
 			if (!work) {
 				if (task->flags & PF_EXITING)
-					head = &work_exited;
+					head = &task_work_exited;
 				else
 					break;
 			}
-- 
2.26.0

