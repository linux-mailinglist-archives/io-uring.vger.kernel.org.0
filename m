Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E0F5A7016
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiH3Vxp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiH3Vwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:52:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517295E4B
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x27-20020a25ac9b000000b0069140cfbbd9so714276ybi.8
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=QqkrsGdR9RIQpztjH+HKE2iaQK76d4alLlYGvP5mtuk=;
        b=EmELHff//JPLhVllZqIpmS0Yi/n4CYn1PpFo5D7aAgY/mGxsMtS6XD/+ioRS2qZY8C
         no10ngIVmFAT46GJYUJjGDNqdY92DoHLQ9QbhAJVsBRmHbrR9QbwqsDn7oDd7mF57S+J
         MK/ad/Fah7kdPasA545qk8VUbJu+zxO3x46X50P0T+NbpE7jyYjWPsZQ5vgUXGysvUe/
         W1W5uPUmm7KhCwcWdijNNG0C+OJlqBBAZwgyEyHf6FDcQet7W8l2Nexpz36zNi+sAkKv
         CMElZPZokU2RO03oq7FRoEcd/C8olIjRx4EsriXjGCc7C59ySMMLL8R3CCw5o8VWV3mF
         SxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=QqkrsGdR9RIQpztjH+HKE2iaQK76d4alLlYGvP5mtuk=;
        b=12lBXjolFivAGO0mdePaWgxLk1SSrfkbaFzFOjOU6qj+sqHtwx7gtrbXd9KJF565kg
         MOsBGDLj9Y4zZZBuzkaN2bO8v7cANWI2qC2d3HxiU+s1oHKujxgTZxfrtou1/OG1tZru
         ekzXC0R7YA1n20QVkcb1E2z81xHSDd6hxmPHPEOQM0PMx+uaftPZXQQf0UBsIdVBxhlo
         Pxn2c4tgKJH04tiSOtwnBheTxn15wtN9E1lQ0MEXPzg5OWon/rcfLSCL83fekHkSvw7G
         oKLCtbb5I+LRZebSYGJ8FdH/VSlvUBr4KTWEBNfTkrjBlanFk1yLKB8RGzz5Xec8SsPA
         703Q==
X-Gm-Message-State: ACgBeo3QYK9fN8O/82WPIq0GLPvQG1b8N56itFKsUGQ+2PWvp0WRfZfY
        Q7tr+tpnsmxQ1PzM50TfvQ9xlnbMzy4=
X-Google-Smtp-Source: AA6agR5ND+Bk6d/UBSONHhQ297Nqdm//CwhSmMh2PEZtOl62aMkc4xfTQyNu/uBDVWhdtd26Z8NBy2Q9NdY=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:4246:0:b0:699:186f:76ca with SMTP id
 p67-20020a254246000000b00699186f76camr13282039yba.272.1661896229901; Tue, 30
 Aug 2022 14:50:29 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:14 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-26-surenb@google.com>
Subject: [RFC PATCH 25/30] lib/time_stats: New library for statistics on events
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

This adds a small new library for tracking statistics on events that
have a duration, i.e. a start and end time.

 - number of events
 - rate/frequency
 - average duration
 - max duration
 - duration quantiles

This code comes from bcachefs, and originally bcache: the next patch
will be converting bcache to use this version, and a subsequent patch
will be using code_tagging to instrument all wait_event() calls in the
kernel.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/time_stats.h |  44 +++++++
 lib/Kconfig                |   3 +
 lib/Makefile               |   1 +
 lib/time_stats.c           | 236 +++++++++++++++++++++++++++++++++++++
 4 files changed, 284 insertions(+)
 create mode 100644 include/linux/time_stats.h
 create mode 100644 lib/time_stats.c

diff --git a/include/linux/time_stats.h b/include/linux/time_stats.h
new file mode 100644
index 000000000000..7ae929e6f836
--- /dev/null
+++ b/include/linux/time_stats.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_TIMESTATS_H
+#define _LINUX_TIMESTATS_H
+
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+
+#define NR_QUANTILES	15
+
+struct quantiles {
+	struct quantile_entry {
+		u64	m;
+		u64	step;
+	}		entries[NR_QUANTILES];
+};
+
+struct time_stat_buffer {
+	unsigned int	nr;
+	struct time_stat_buffer_entry {
+		u64	start;
+		u64	end;
+	}		entries[32];
+};
+
+struct time_stats {
+	spinlock_t	lock;
+	u64		count;
+	/* all fields are in nanoseconds */
+	u64		average_duration;
+	u64		average_frequency;
+	u64		max_duration;
+	u64		last_event;
+	struct quantiles quantiles;
+
+	struct time_stat_buffer __percpu *buffer;
+};
+
+struct seq_buf;
+void time_stats_update(struct time_stats *stats, u64 start);
+void time_stats_to_text(struct seq_buf *out, struct time_stats *stats);
+void time_stats_exit(struct time_stats *stats);
+
+#endif /* _LINUX_TIMESTATS_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index fc6dbc425728..884fd9f2f06d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -744,3 +744,6 @@ config ASN1_ENCODER
 
 config POLYNOMIAL
        tristate
+
+config TIME_STATS
+	bool
diff --git a/lib/Makefile b/lib/Makefile
index 489ea000c528..e54392011f5e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -232,6 +232,7 @@ obj-$(CONFIG_ALLOC_TAGGING) += alloc_tag.o
 obj-$(CONFIG_PAGE_ALLOC_TAGGING) += pgalloc_tag.o
 
 obj-$(CONFIG_CODETAG_FAULT_INJECTION) += dynamic_fault.o
+obj-$(CONFIG_TIME_STATS) += time_stats.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/time_stats.c b/lib/time_stats.c
new file mode 100644
index 000000000000..30362364fdd2
--- /dev/null
+++ b/lib/time_stats.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/percpu.h>
+#include <linux/seq_buf.h>
+#include <linux/spinlock.h>
+#include <linux/time_stats.h>
+#include <linux/timekeeping.h>
+
+static inline unsigned int eytzinger1_child(unsigned int i, unsigned int child)
+{
+	return (i << 1) + child;
+}
+
+static inline unsigned int eytzinger1_right_child(unsigned int i)
+{
+	return eytzinger1_child(i, 1);
+}
+
+static inline unsigned int eytzinger1_next(unsigned int i, unsigned int size)
+{
+	if (eytzinger1_right_child(i) <= size) {
+		i = eytzinger1_right_child(i);
+
+		i <<= __fls(size + 1) - __fls(i);
+		i >>= i > size;
+	} else {
+		i >>= ffz(i) + 1;
+	}
+
+	return i;
+}
+
+static inline unsigned int eytzinger0_child(unsigned int i, unsigned int child)
+{
+	return (i << 1) + 1 + child;
+}
+
+static inline unsigned int eytzinger0_first(unsigned int size)
+{
+	return rounddown_pow_of_two(size) - 1;
+}
+
+static inline unsigned int eytzinger0_next(unsigned int i, unsigned int size)
+{
+	return eytzinger1_next(i + 1, size) - 1;
+}
+
+#define eytzinger0_for_each(_i, _size)			\
+	for ((_i) = eytzinger0_first((_size));		\
+	     (_i) != -1;				\
+	     (_i) = eytzinger0_next((_i), (_size)))
+
+#define ewma_add(ewma, val, weight)					\
+({									\
+	typeof(ewma) _ewma = (ewma);					\
+	typeof(weight) _weight = (weight);				\
+									\
+	(((_ewma << _weight) - _ewma) + (val)) >> _weight;		\
+})
+
+static void quantiles_update(struct quantiles *q, u64 v)
+{
+	unsigned int i = 0;
+
+	while (i < ARRAY_SIZE(q->entries)) {
+		struct quantile_entry *e = q->entries + i;
+
+		if (unlikely(!e->step)) {
+			e->m = v;
+			e->step = max_t(unsigned int, v / 2, 1024);
+		} else if (e->m > v) {
+			e->m = e->m >= e->step
+				? e->m - e->step
+				: 0;
+		} else if (e->m < v) {
+			e->m = e->m + e->step > e->m
+				? e->m + e->step
+				: U32_MAX;
+		}
+
+		if ((e->m > v ? e->m - v : v - e->m) < e->step)
+			e->step = max_t(unsigned int, e->step / 2, 1);
+
+		if (v >= e->m)
+			break;
+
+		i = eytzinger0_child(i, v > e->m);
+	}
+}
+
+static void time_stats_update_one(struct time_stats *stats,
+				  u64 start, u64 end)
+{
+	u64 duration, freq;
+
+	duration	= time_after64(end, start)
+		? end - start : 0;
+	freq		= time_after64(end, stats->last_event)
+		? end - stats->last_event : 0;
+
+	stats->count++;
+
+	stats->average_duration = stats->average_duration
+		? ewma_add(stats->average_duration, duration, 6)
+		: duration;
+
+	stats->average_frequency = stats->average_frequency
+		? ewma_add(stats->average_frequency, freq, 6)
+		: freq;
+
+	stats->max_duration = max(stats->max_duration, duration);
+
+	stats->last_event = end;
+
+	quantiles_update(&stats->quantiles, duration);
+}
+
+void time_stats_update(struct time_stats *stats, u64 start)
+{
+	u64 end = ktime_get_ns();
+	unsigned long flags;
+
+	if (!stats->buffer) {
+		spin_lock_irqsave(&stats->lock, flags);
+		time_stats_update_one(stats, start, end);
+
+		if (stats->average_frequency < 32 &&
+		    stats->count > 1024)
+			stats->buffer =
+				alloc_percpu_gfp(struct time_stat_buffer,
+						 GFP_ATOMIC);
+		spin_unlock_irqrestore(&stats->lock, flags);
+	} else {
+		struct time_stat_buffer_entry *i;
+		struct time_stat_buffer *b;
+
+		preempt_disable();
+		b = this_cpu_ptr(stats->buffer);
+
+		BUG_ON(b->nr >= ARRAY_SIZE(b->entries));
+		b->entries[b->nr++] = (struct time_stat_buffer_entry) {
+			.start = start,
+			.end = end
+		};
+
+		if (b->nr == ARRAY_SIZE(b->entries)) {
+			spin_lock_irqsave(&stats->lock, flags);
+			for (i = b->entries;
+			     i < b->entries + ARRAY_SIZE(b->entries);
+			     i++)
+				time_stats_update_one(stats, i->start, i->end);
+			spin_unlock_irqrestore(&stats->lock, flags);
+
+			b->nr = 0;
+		}
+
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(time_stats_update);
+
+static const struct time_unit {
+	const char	*name;
+	u32		nsecs;
+} time_units[] = {
+	{ "ns",		1		},
+	{ "us",		NSEC_PER_USEC	},
+	{ "ms",		NSEC_PER_MSEC	},
+	{ "sec",	NSEC_PER_SEC	},
+};
+
+static const struct time_unit *pick_time_units(u64 ns)
+{
+	const struct time_unit *u;
+
+	for (u = time_units;
+	     u + 1 < time_units + ARRAY_SIZE(time_units) &&
+	     ns >= u[1].nsecs << 1;
+	     u++)
+		;
+
+	return u;
+}
+
+static void pr_time_units(struct seq_buf *out, u64 ns)
+{
+	const struct time_unit *u = pick_time_units(ns);
+
+	seq_buf_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+}
+
+void time_stats_to_text(struct seq_buf *out, struct time_stats *stats)
+{
+	const struct time_unit *u;
+	u64 freq = READ_ONCE(stats->average_frequency);
+	u64 q, last_q = 0;
+	int i;
+
+	seq_buf_printf(out, "count:          %llu\n", stats->count);
+	seq_buf_printf(out, "rate:           %llu/sec\n",
+		       freq ? div64_u64(NSEC_PER_SEC, freq) : 0);
+	seq_buf_printf(out, "frequency:      ");
+	pr_time_units(out, freq);
+	seq_buf_putc(out, '\n');
+
+	seq_buf_printf(out, "avg duration:   ");
+	pr_time_units(out, stats->average_duration);
+	seq_buf_putc(out, '\n');
+
+	seq_buf_printf(out, "max duration:   ");
+	pr_time_units(out, stats->max_duration);
+	seq_buf_putc(out, '\n');
+
+	i = eytzinger0_first(NR_QUANTILES);
+	u = pick_time_units(stats->quantiles.entries[i].m);
+	seq_buf_printf(out, "quantiles (%s): ", u->name);
+	eytzinger0_for_each(i, NR_QUANTILES) {
+		q = max(stats->quantiles.entries[i].m, last_q);
+		seq_buf_printf(out, "%llu ", div_u64(q, u->nsecs));
+		last_q = q;
+	}
+
+	seq_buf_putc(out, '\n');
+}
+EXPORT_SYMBOL_GPL(time_stats_to_text);
+
+void time_stats_exit(struct time_stats *stats)
+{
+	free_percpu(stats->buffer);
+	stats->buffer = NULL;
+}
+EXPORT_SYMBOL_GPL(time_stats_exit);
-- 
2.37.2.672.g94769d06f0-goog

