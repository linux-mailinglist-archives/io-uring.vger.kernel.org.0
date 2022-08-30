Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11255A7015
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiH3Vxr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiH3Vwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:52:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A0B94139
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-340862314d9so173452597b3.3
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=PJDqdE16VQFkhBtAZQdE7ryguEFDkMx7mMptHwdJxIQ=;
        b=Ij75nFrUrPvJu2bumKHw5qB/wQ6gVxiA7JiR459fjyWwf8bAM7esU+z26b2Gs2wm+2
         GJco7Z59pIbk7lAYzIUjBLlbgij5WieJsWdNVz1juJkVh+sa9UWATRgrEBqBGRWkiIgS
         e9fE2xkYV7tYVniZBisXLNcLv1T2Qe2o0c8hnbKmgjEZ4CuxPiv3aHRBgJXL1TW2FAU/
         xTP0HeMc1J5XCTMzbl6MriSnvFIhWbWVUtAJ/9V96DnOp2vk9Hc7k6iFLgNru+svATI5
         qjP0FOpFl9sx7TmiI9c+PBZgc2FqjExNp+v4DIbowFGQu7f8+ZLj1VsmDoNwIg4tHpwc
         B9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=PJDqdE16VQFkhBtAZQdE7ryguEFDkMx7mMptHwdJxIQ=;
        b=k2GpLo77wOFAmx2GK+UTV47AZJ3SeSpJT7w40jU4mGQRZVPD+5UKHZFg5nfCAt1kys
         AcnYzFWC5qLzCxvVUpJkccgCA4ZxCRMRINwVOZGWnfKa5m28W3cbowiKj6SubCuTmSTZ
         VqjatD8ytUvEm4jBnivYByqJ2vIhtrpdXnbGLra8rG78IZT7EY4z8N5eC0JYNQGa43UI
         TTwrk1RAiT1q9+NVuUr3O9ZTIQiNlMqCjZlJloAcA1GMmT/cuMByRvR4xXKBaMvF1fzS
         hcet88mUTXO4WvMlSb6W6UzDDedBA4do/UXm3fpBpH7i5tkJO3pusnmLLz9IqwC8WAZx
         oRmg==
X-Gm-Message-State: ACgBeo20mnCo9F3xunlZNN80V9QQ7k/iDNv6lobMhwvkAwZoh5ftjrVR
        8ZUZFyfwa4ewUaOuGIUXGpvUK5fuZmc=
X-Google-Smtp-Source: AA6agR6avTM18XP2y4CdHSCV3FE6n/efM5TdzJAiOApCx+OJvVOl1HBVpl97MaszhlrgGlpdRen0jumUZ8U=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a81:54c4:0:b0:329:d0e1:cfcf with SMTP id
 i187-20020a8154c4000000b00329d0e1cfcfmr15741208ywb.451.1661896227243; Tue, 30
 Aug 2022 14:50:27 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:13 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-25-surenb@google.com>
Subject: [RFC PATCH 24/30] wait: Clean up waitqueue_entry initialization
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

Cleanup for code tagging latency tracking:

Add an initializer, WAIT_FUNC_INITIALIZER(), to be used by initializers
for structs that include wait_queue_entries.

Also, change init_wait(), init_wait_entry etc.  to be a wrapper around
the new __init_waitqueue_entry(); more de-duplication prep work.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sbitmap.h  |  6 +----
 include/linux/wait.h     | 52 +++++++++++++++++++---------------------
 include/linux/wait_bit.h |  7 +-----
 kernel/sched/wait.c      |  9 -------
 4 files changed, 27 insertions(+), 47 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 8f5a86e210b9..f696c29d9ab3 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -596,11 +596,7 @@ struct sbq_wait {
 #define DEFINE_SBQ_WAIT(name)							\
 	struct sbq_wait name = {						\
 		.sbq = NULL,							\
-		.wait = {							\
-			.private	= current,				\
-			.func		= autoremove_wake_function,		\
-			.entry		= LIST_HEAD_INIT((name).wait.entry),	\
-		}								\
+		.wait = WAIT_FUNC_INITIALIZER((name).wait, autoremove_wake_function),\
 	}
 
 /*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 58cfbf81447c..91ced6a118bc 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -79,21 +79,38 @@ extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *n
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
 #endif
 
-static inline void init_waitqueue_entry(struct wait_queue_entry *wq_entry, struct task_struct *p)
-{
-	wq_entry->flags		= 0;
-	wq_entry->private	= p;
-	wq_entry->func		= default_wake_function;
+#define WAIT_FUNC_INITIALIZER(name, function) {					\
+	.private	= current,						\
+	.func		= function,						\
+	.entry		= LIST_HEAD_INIT((name).entry),				\
 }
 
+#define DEFINE_WAIT_FUNC(name, function)					\
+	struct wait_queue_entry name = WAIT_FUNC_INITIALIZER(name, function)
+
+#define DEFINE_WAIT(name) DEFINE_WAIT_FUNC(name, autoremove_wake_function)
+
 static inline void
-init_waitqueue_func_entry(struct wait_queue_entry *wq_entry, wait_queue_func_t func)
+__init_waitqueue_entry(struct wait_queue_entry *wq_entry, unsigned int flags,
+		       void *private, wait_queue_func_t func)
 {
-	wq_entry->flags		= 0;
-	wq_entry->private	= NULL;
+	wq_entry->flags		= flags;
+	wq_entry->private	= private;
 	wq_entry->func		= func;
+	INIT_LIST_HEAD(&wq_entry->entry);
 }
 
+#define init_waitqueue_func_entry(_wq_entry, _func)			\
+	__init_waitqueue_entry(_wq_entry, 0, NULL, _func)
+
+#define init_waitqueue_entry(_wq_entry, _task)				\
+	__init_waitqueue_entry(_wq_entry, 0, _task, default_wake_function)
+
+#define init_wait_entry(_wq_entry, _flags)				\
+	__init_waitqueue_entry(_wq_entry, _flags, current, autoremove_wake_function)
+
+#define init_wait(wait)		init_wait_entry(wait, 0)
+
 /**
  * waitqueue_active -- locklessly test for waiters on the queue
  * @wq_head: the waitqueue to test for waiters
@@ -283,8 +300,6 @@ static inline void wake_up_pollfree(struct wait_queue_head *wq_head)
 	(!__builtin_constant_p(state) ||					\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)		\
 
-extern void init_wait_entry(struct wait_queue_entry *wq_entry, int flags);
-
 /*
  * The below macro ___wait_event() has an explicit shadow of the __ret
  * variable when used from the wait_event_*() macros.
@@ -1170,23 +1185,6 @@ long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
 int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
-#define DEFINE_WAIT_FUNC(name, function)					\
-	struct wait_queue_entry name = {					\
-		.private	= current,					\
-		.func		= function,					\
-		.entry		= LIST_HEAD_INIT((name).entry),			\
-	}
-
-#define DEFINE_WAIT(name) DEFINE_WAIT_FUNC(name, autoremove_wake_function)
-
-#define init_wait(wait)								\
-	do {									\
-		(wait)->private = current;					\
-		(wait)->func = autoremove_wake_function;			\
-		INIT_LIST_HEAD(&(wait)->entry);					\
-		(wait)->flags = 0;						\
-	} while (0)
-
 typedef int (*task_call_f)(struct task_struct *p, void *arg);
 extern int task_call_func(struct task_struct *p, task_call_f func, void *arg);
 
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 7725b7579b78..267ca0fe9fd9 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -38,12 +38,7 @@ int wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync
 #define DEFINE_WAIT_BIT(name, word, bit)					\
 	struct wait_bit_queue_entry name = {					\
 		.key = __WAIT_BIT_KEY_INITIALIZER(word, bit),			\
-		.wq_entry = {							\
-			.private	= current,				\
-			.func		= wake_bit_function,			\
-			.entry		=					\
-				LIST_HEAD_INIT((name).wq_entry.entry),		\
-		},								\
+		.wq_entry = WAIT_FUNC_INITIALIZER((name).wq_entry, wake_bit_function),\
 	}
 
 extern int bit_wait(struct wait_bit_key *key, int mode);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 9860bb9a847c..b9922346077d 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -289,15 +289,6 @@ prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_ent
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
-void init_wait_entry(struct wait_queue_entry *wq_entry, int flags)
-{
-	wq_entry->flags = flags;
-	wq_entry->private = current;
-	wq_entry->func = autoremove_wake_function;
-	INIT_LIST_HEAD(&wq_entry->entry);
-}
-EXPORT_SYMBOL(init_wait_entry);
-
 long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state)
 {
 	unsigned long flags;
-- 
2.37.2.672.g94769d06f0-goog

