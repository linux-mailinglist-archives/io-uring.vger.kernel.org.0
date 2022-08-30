Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A254C5A701F
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiH3Vxu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiH3VxY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:53:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17C7910BF
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c18-20020a170902d49200b001750f4fb8beso2414439plg.15
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=kZY1PfnIfhpzKe2fg2QNhEi4K+n6/AZeM4PXPDl+jSs=;
        b=dJIIXMoaDfo4LS1xQQsLOYvOSR0hfxqszIVBrvS11cTWnTWgSYoHleGkgC0i1RcvEW
         g0FnB2GyEmZdNHr6qvVjCkD5o8oUCDsQN6hIW7/R52HXnnZeYixGTmPmUjkl/HVYK9gL
         Qo4/LFsvJ+0cR9rmUutD4WN2/z4CAitg0y36m7N9M2fZq2hfBbMNxbfvmd6aQgPqHqkG
         6a9S9xFeeaCoHjkHXbbF/J0YPQDSPpwSprLRWHG9c2lJ3QzYjp2lWoTEqHtd8FJ9BudO
         moRv5nbs15u8zEsMhSNn0aeOd2zru1Uacoknhz067J3h2b0D6a3WPhHKe4+8QHPv/dBd
         t9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=kZY1PfnIfhpzKe2fg2QNhEi4K+n6/AZeM4PXPDl+jSs=;
        b=7Ir2nvvho195PnJOCD3a9etNDgSyRilgeoK6mHNdH9S7rz1z8/FDnDtPx8EGi4KQlD
         tBVusV0cbITt6XXQy/1OGtNaDe7FZ06DAqU6ewsO4xs8Lp2PaVVDXUu2BZ3BIUP5Q8d4
         hpIqVu1KmaWJfD8iD4v+lXAUyCYK2nKiqn6EtIIQdFzUigGSQ0JqtwCGDB3/pDXei+So
         5RWLu3qLmCtV8PywQyk6F4TGO2AFjZMkwTi7PRvCyymvhevJaVcZvCaFoh2D6FLICgVH
         MO5IEZfMSpuEtr+wmysAIPE30X6DLCtU+aGiZEYGRAluFkw0gpS9EUlxD9BSYDY3j3gA
         tapg==
X-Gm-Message-State: ACgBeo3BOj2yw36w8UJc/sYC70yAFFHylc3dqbSdq1HrQefSjwTJ4efK
        AyVYPqARHocf/voyrNTHGRTzyjfZf/k=
X-Google-Smtp-Source: AA6agR6gjE9iFWchZ4YdJrumvkghNHAZU6MHZC3qdslJX2rUX6yUkswTTbpzQbuhO2vfdv4e8k6IHGZMB7I=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a63:5c4a:0:b0:41d:bd7d:6084 with SMTP id
 n10-20020a635c4a000000b0041dbd7d6084mr19548657pgm.411.1661896235530; Tue, 30
 Aug 2022 14:50:35 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:16 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-28-surenb@google.com>
Subject: [RFC PATCH 27/30] Code tagging based latency tracking
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
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
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

This adds the ability to easily instrument code for measuring latency.
To use, add the following to calls to your code, at the start and end of
the event you wish to measure:

  code_tag_time_stats_start(start_time);
  code_tag_time_stats_finish(start_time);

Stastistics will then show up in debugfs under
/sys/kernel/debug/time_stats, listed by file and line number.

Stastics measured include weighted averages of frequency, duration, max
duration, as well as quantiles.

This patch also instruments all calls to init_wait and finish_wait,
which includes all calls to wait_event. Example debugfs output:

fs/xfs/xfs_trans_ail.c:746 module:xfs func:xfs_ail_push_all_sync
count:          17
rate:           0/sec
frequency:      2 sec
avg duration:   10 us
max duration:   232 us
quantiles (ns): 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128

lib/sbitmap.c:813 module:sbitmap func:sbitmap_finish_wait
count:          3
rate:           0/sec
frequency:      4 sec
avg duration:   4 sec
max duration:   4 sec
quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048

net/core/datagram.c:122 module:datagram func:__skb_wait_for_more_packets
count:          10
rate:           1/sec
frequency:      859 ms
avg duration:   472 ms
max duration:   30 sec
quantiles (ns): 0 12279 12279 15669 15669 15669 15669 17217 17217 17217 17217 17217 17217 17217 17217

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/asm-generic/codetag.lds.h  |   3 +-
 include/linux/codetag_time_stats.h |  54 +++++++++++
 include/linux/io_uring_types.h     |   2 +-
 include/linux/wait.h               |  22 ++++-
 kernel/sched/wait.c                |   6 +-
 lib/Kconfig.debug                  |   8 ++
 lib/Makefile                       |   1 +
 lib/codetag_time_stats.c           | 143 +++++++++++++++++++++++++++++
 8 files changed, 233 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/codetag_time_stats.h
 create mode 100644 lib/codetag_time_stats.c

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
index 16fbf74edc3d..d799f4aced82 100644
--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -10,6 +10,7 @@
 
 #define CODETAG_SECTIONS()		\
 	SECTION_WITH_BOUNDARIES(alloc_tags)		\
-	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)
+	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)	\
+	SECTION_WITH_BOUNDARIES(time_stats_tags)
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/linux/codetag_time_stats.h b/include/linux/codetag_time_stats.h
new file mode 100644
index 000000000000..7e44c7ee9e9b
--- /dev/null
+++ b/include/linux/codetag_time_stats.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CODETAG_TIMESTATS_H
+#define _LINUX_CODETAG_TIMESTATS_H
+
+/*
+ * Code tagging based latency tracking:
+ * (C) 2022 Kent Overstreet
+ *
+ * This allows you to easily instrument code to track latency, and have the
+ * results show up in debugfs. To use, add the following two calls to your code
+ * at the beginning and end of the event you wish to instrument:
+ *
+ * code_tag_time_stats_start(start_time);
+ * code_tag_time_stats_finish(start_time);
+ *
+ * Statistics will then show up in debugfs under /sys/kernel/debug/time_stats,
+ * listed by file and line number.
+ */
+
+#ifdef CONFIG_CODETAG_TIME_STATS
+
+#include <linux/codetag.h>
+#include <linux/time_stats.h>
+#include <linux/timekeeping.h>
+
+struct codetag_time_stats {
+	struct codetag		tag;
+	struct time_stats	stats;
+};
+
+#define codetag_time_stats_start(_start_time)	u64 _start_time = ktime_get_ns()
+
+#define codetag_time_stats_finish(_start_time)			\
+do {								\
+	static struct codetag_time_stats			\
+	__used							\
+	__section("time_stats_tags")				\
+	__aligned(8) s = {					\
+		.tag	= CODE_TAG_INIT,			\
+		.stats.lock = __SPIN_LOCK_UNLOCKED(_lock)	\
+	};							\
+								\
+	WARN_ONCE(!(_start_time), "codetag_time_stats_start() not called");\
+	time_stats_update(&s.stats, _start_time);		\
+} while (0)
+
+#else
+
+#define codetag_time_stats_finish(_start_time)	do {} while (0)
+#define codetag_time_stats_start(_start_time)	do {} while (0)
+
+#endif /* CODETAG_CODETAG_TIME_STATS */
+
+#endif
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..3bcef85eacd8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -488,7 +488,7 @@ struct io_cqe {
 struct io_cmd_data {
 	struct file		*file;
 	/* each command gets 56 bytes of data */
-	__u8			data[56];
+	__u8			data[64];
 };
 
 static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 91ced6a118bc..bab11b7ef19a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -4,6 +4,7 @@
 /*
  * Linux wait queue related types and methods
  */
+#include <linux/codetag_time_stats.h>
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -32,6 +33,9 @@ struct wait_queue_entry {
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	entry;
+#ifdef CONFIG_CODETAG_TIME_STATS
+	u64			start_time;
+#endif
 };
 
 struct wait_queue_head {
@@ -79,10 +83,17 @@ extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *n
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
 #endif
 
+#ifdef CONFIG_CODETAG_TIME_STATS
+#define WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER	.start_time = ktime_get_ns(),
+#else
+#define WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER
+#endif
+
 #define WAIT_FUNC_INITIALIZER(name, function) {					\
 	.private	= current,						\
 	.func		= function,						\
 	.entry		= LIST_HEAD_INIT((name).entry),				\
+	WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER					\
 }
 
 #define DEFINE_WAIT_FUNC(name, function)					\
@@ -98,6 +109,9 @@ __init_waitqueue_entry(struct wait_queue_entry *wq_entry, unsigned int flags,
 	wq_entry->private	= private;
 	wq_entry->func		= func;
 	INIT_LIST_HEAD(&wq_entry->entry);
+#ifdef CONFIG_CODETAG_TIME_STATS
+	wq_entry->start_time	= ktime_get_ns();
+#endif
 }
 
 #define init_waitqueue_func_entry(_wq_entry, _func)			\
@@ -1180,11 +1194,17 @@ do {										\
 void prepare_to_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 bool prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
-void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
+void __finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
 int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
+#define finish_wait(_wq_head, _wq_entry)					\
+do {										\
+	codetag_time_stats_finish((_wq_entry)->start_time);			\
+	__finish_wait(_wq_head, _wq_entry);					\
+} while (0)
+
 typedef int (*task_call_f)(struct task_struct *p, void *arg);
 extern int task_call_func(struct task_struct *p, task_call_f func, void *arg);
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index b9922346077d..e88de3f0c3ad 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -367,7 +367,7 @@ int do_wait_intr_irq(wait_queue_head_t *wq, wait_queue_entry_t *wait)
 EXPORT_SYMBOL(do_wait_intr_irq);
 
 /**
- * finish_wait - clean up after waiting in a queue
+ * __finish_wait - clean up after waiting in a queue
  * @wq_head: waitqueue waited on
  * @wq_entry: wait descriptor
  *
@@ -375,7 +375,7 @@ EXPORT_SYMBOL(do_wait_intr_irq);
  * the wait descriptor from the given waitqueue if still
  * queued.
  */
-void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+void __finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
 
@@ -399,7 +399,7 @@ void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_en
 		spin_unlock_irqrestore(&wq_head->lock, flags);
 	}
 }
-EXPORT_SYMBOL(finish_wait);
+EXPORT_SYMBOL(__finish_wait);
 
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key)
 {
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b7d03afbc808..b0f86643b8f0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1728,6 +1728,14 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config CODETAG_TIME_STATS
+	bool "Code tagging based latency measuring"
+	depends on DEBUG_FS
+	select TIME_STATS
+	select CODE_TAGGING
+	help
+	  Enabling this option makes latency statistics available in debugfs
+
 source "kernel/trace/Kconfig"
 
 config PROVIDE_OHCI1394_DMA_INIT
diff --git a/lib/Makefile b/lib/Makefile
index e54392011f5e..d4067973805b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -233,6 +233,7 @@ obj-$(CONFIG_PAGE_ALLOC_TAGGING) += pgalloc_tag.o
 
 obj-$(CONFIG_CODETAG_FAULT_INJECTION) += dynamic_fault.o
 obj-$(CONFIG_TIME_STATS) += time_stats.o
+obj-$(CONFIG_CODETAG_TIME_STATS) += codetag_time_stats.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/codetag_time_stats.c b/lib/codetag_time_stats.c
new file mode 100644
index 000000000000..b0e9a08308a2
--- /dev/null
+++ b/lib/codetag_time_stats.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/codetag_time_stats.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/seq_buf.h>
+
+static struct codetag_type *cttype;
+
+struct user_buf {
+	char __user		*buf;	/* destination user buffer */
+	size_t			size;	/* size of requested read */
+	ssize_t			ret;	/* bytes read so far */
+};
+
+static int flush_ubuf(struct user_buf *dst, struct seq_buf *src)
+{
+	if (src->len) {
+		size_t bytes = min_t(size_t, src->len, dst->size);
+		int err = copy_to_user(dst->buf, src->buffer, bytes);
+
+		if (err)
+			return err;
+
+		dst->ret	+= bytes;
+		dst->buf	+= bytes;
+		dst->size	-= bytes;
+		src->len	-= bytes;
+		memmove(src->buffer, src->buffer + bytes, src->len);
+	}
+
+	return 0;
+}
+
+struct time_stats_iter {
+	struct codetag_iterator ct_iter;
+	struct seq_buf		buf;
+	char			rawbuf[4096];
+	bool			first;
+};
+
+static int time_stats_open(struct inode *inode, struct file *file)
+{
+	struct time_stats_iter *iter;
+
+	pr_debug("called");
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	codetag_lock_module_list(cttype, true);
+	codetag_init_iter(&iter->ct_iter, cttype);
+	codetag_lock_module_list(cttype, false);
+
+	file->private_data = iter;
+	seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
+	iter->first = true;
+	return 0;
+}
+
+static int time_stats_release(struct inode *inode, struct file *file)
+{
+	struct time_stats_iter *i = file->private_data;
+
+	kfree(i);
+	return 0;
+}
+
+static ssize_t time_stats_read(struct file *file, char __user *ubuf,
+			       size_t size, loff_t *ppos)
+{
+	struct time_stats_iter *iter = file->private_data;
+	struct user_buf	buf = { .buf = ubuf, .size = size };
+	struct codetag_time_stats *s;
+	struct codetag *ct;
+	int err;
+
+	codetag_lock_module_list(iter->ct_iter.cttype, true);
+	while (1) {
+		err = flush_ubuf(&buf, &iter->buf);
+		if (err || !buf.size)
+			break;
+
+		ct = codetag_next_ct(&iter->ct_iter);
+		if (!ct)
+			break;
+
+		s = container_of(ct, struct codetag_time_stats, tag);
+		if (s->stats.count) {
+			if (!iter->first) {
+				seq_buf_putc(&iter->buf, '\n');
+				iter->first = true;
+			}
+
+			codetag_to_text(&iter->buf, &s->tag);
+			seq_buf_putc(&iter->buf, '\n');
+			time_stats_to_text(&iter->buf, &s->stats);
+		}
+	}
+	codetag_lock_module_list(iter->ct_iter.cttype, false);
+
+	return err ?: buf.ret;
+}
+
+static const struct file_operations time_stats_ops = {
+	.owner	= THIS_MODULE,
+	.open	= time_stats_open,
+	.release = time_stats_release,
+	.read	= time_stats_read,
+};
+
+static void time_stats_module_unload(struct codetag_type *cttype, struct codetag_module *mod)
+{
+	struct codetag_time_stats *i, *start = (void *) mod->range.start;
+	struct codetag_time_stats *end = (void *) mod->range.stop;
+
+	for (i = start; i != end; i++)
+		time_stats_exit(&i->stats);
+}
+
+static int __init codetag_time_stats_init(void)
+{
+	const struct codetag_type_desc desc = {
+		.section	= "time_stats_tags",
+		.tag_size	= sizeof(struct codetag_time_stats),
+		.module_unload	= time_stats_module_unload,
+	};
+	struct dentry *debugfs_file;
+
+	cttype = codetag_register_type(&desc);
+	if (IS_ERR_OR_NULL(cttype))
+		return PTR_ERR(cttype);
+
+	debugfs_file = debugfs_create_file("time_stats", 0666, NULL, NULL, &time_stats_ops);
+	if (IS_ERR(debugfs_file))
+		return PTR_ERR(debugfs_file);
+
+	return 0;
+}
+module_init(codetag_time_stats_init);
-- 
2.37.2.672.g94769d06f0-goog

