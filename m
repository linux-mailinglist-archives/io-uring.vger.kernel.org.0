Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E448F5A6F96
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiH3VuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiH3Vtg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:49:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A218FD6D
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p12-20020a259e8c000000b006958480b858so716736ybq.12
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=Ax7BfvJ0osMGjEtA73bq+7eMx40gLvPyn7aoZ5x/9O0=;
        b=hsapsq4Io1duD+oIcMKHPqjZY+p0l934IuKt6ADX53IxWDy+3W9yhUCc9UOoy72l+K
         yoi0pXSbPO5msleZdGZIvsV2cB7YSDfNeglHGW6FBm8CZZTN50YXVoQQqGyWu9X2u7pD
         k570L0pSRabwOW7Ke158CR88Up/9Z6lXEL30XT3S5u/I8ECd096CujeXPJFvz+9r3kgB
         qoVp6eGu0iY42VmNRszNeFxFF2vJTlL/2lnL0neCfdF+yMpw5RYl0YRjkEJWDOUcF8+F
         QxPQK5wJ7XQtmCBTueYp+wLoE89WGl4y+n7qUFebGmKhLaH9FtY63f9CwEVHHl+9VlmY
         tEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Ax7BfvJ0osMGjEtA73bq+7eMx40gLvPyn7aoZ5x/9O0=;
        b=pT/r9x1hnjD1muEU4MxU9fm92q91RxC5e7e3a4arc+NbMotRPl/MDL87Cfi6mpVniv
         703UQSIEGQN0PQ7UQUbtani4PIdCjrBQePg+9A+VJzhI1Q9IT5iMzRqNM8dUUNsoJF5O
         Wa9xt5osV3yqNNHoL/QUJHRAIDNyFviKJvBs66s3lQ6cc4YN8fyLeGo8GAucNA1SIo7I
         jDqLMGnPdXPx6XAvKVdZQzZ3/e7qRHrQCrORsE49LvmwHDrn1jGX8776dup9ltMG7Nxk
         o7XJTGqJxz11EZyBxbRPm6XyRS9HHjx+pm11CgysFFPRyBGhZRi9AGwXp/DkTHjQCdXe
         +vMQ==
X-Gm-Message-State: ACgBeo2BjQTtfBvj9u/J4c30vC1QN8m4R1ZAW7Xo6TkZUXnT7D8Np/Bv
        8Hgzmi0b+BU0UfIKiYJZiiV0jR0xvTQ=
X-Google-Smtp-Source: AA6agR7hndW0to/mdEbktFYjBoW+FsmL/An39pt9gov0fVTaelPsArzlVK5iYkOr3o+674D1aZ8YbEGFrHU=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:3406:0:b0:69c:857b:7fd3 with SMTP id
 b6-20020a253406000000b0069c857b7fd3mr3099193yba.404.1661896172108; Tue, 30
 Aug 2022 14:49:32 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:48:52 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-4-surenb@google.com>
Subject: [RFC PATCH 03/30] Lazy percpu counters
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

This patch adds lib/lazy-percpu-counter.c, which implements counters
that start out as atomics, but lazily switch to percpu mode if the
update rate crosses some threshold (arbitrarily set at 256 per second).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/lazy-percpu-counter.h |  67 +++++++++++++
 lib/Kconfig                         |   3 +
 lib/Makefile                        |   2 +
 lib/lazy-percpu-counter.c           | 141 ++++++++++++++++++++++++++++
 4 files changed, 213 insertions(+)
 create mode 100644 include/linux/lazy-percpu-counter.h
 create mode 100644 lib/lazy-percpu-counter.c

diff --git a/include/linux/lazy-percpu-counter.h b/include/linux/lazy-percpu-counter.h
new file mode 100644
index 000000000000..a22a2b9a9f32
--- /dev/null
+++ b/include/linux/lazy-percpu-counter.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Lazy percpu counters:
+ * (C) 2022 Kent Overstreet
+ *
+ * Lazy percpu counters start out in atomic mode, then switch to percpu mode if
+ * the update rate crosses some threshold.
+ *
+ * This means we don't have to decide between low memory overhead atomic
+ * counters and higher performance percpu counters - we can have our cake and
+ * eat it, too!
+ *
+ * Internally we use an atomic64_t, where the low bit indicates whether we're in
+ * percpu mode, and the high 8 bits are a secondary counter that's incremented
+ * when the counter is modified - meaning 55 bits of precision are available for
+ * the counter itself.
+ *
+ * lazy_percpu_counter is 16 bytes (on 64 bit machines), raw_lazy_percpu_counter
+ * is 8 bytes but requires a separate unsigned long to record when the counter
+ * wraps - because sometimes multiple counters are used together and can share
+ * the same timestamp.
+ */
+
+#ifndef _LINUX_LAZY_PERCPU_COUNTER_H
+#define _LINUX_LAZY_PERCPU_COUNTER_H
+
+struct raw_lazy_percpu_counter {
+	atomic64_t			v;
+};
+
+void __lazy_percpu_counter_exit(struct raw_lazy_percpu_counter *c);
+void __lazy_percpu_counter_add(struct raw_lazy_percpu_counter *c,
+			       unsigned long *last_wrap, s64 i);
+s64 __lazy_percpu_counter_read(struct raw_lazy_percpu_counter *c);
+
+static inline void __lazy_percpu_counter_sub(struct raw_lazy_percpu_counter *c,
+					     unsigned long *last_wrap, s64 i)
+{
+	__lazy_percpu_counter_add(c, last_wrap, -i);
+}
+
+struct lazy_percpu_counter {
+	struct raw_lazy_percpu_counter	v;
+	unsigned long			last_wrap;
+};
+
+static inline void lazy_percpu_counter_exit(struct lazy_percpu_counter *c)
+{
+	__lazy_percpu_counter_exit(&c->v);
+}
+
+static inline void lazy_percpu_counter_add(struct lazy_percpu_counter *c, s64 i)
+{
+	__lazy_percpu_counter_add(&c->v, &c->last_wrap, i);
+}
+
+static inline void lazy_percpu_counter_sub(struct lazy_percpu_counter *c, s64 i)
+{
+	__lazy_percpu_counter_sub(&c->v, &c->last_wrap, i);
+}
+
+static inline s64 lazy_percpu_counter_read(struct lazy_percpu_counter *c)
+{
+	return __lazy_percpu_counter_read(&c->v);
+}
+
+#endif /* _LINUX_LAZY_PERCPU_COUNTER_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index dc1ab2ed1dc6..fc6dbc425728 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -498,6 +498,9 @@ config ASSOCIATIVE_ARRAY
 
 	  for more information.
 
+config LAZY_PERCPU_COUNTER
+	bool
+
 config HAS_IOMEM
 	bool
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index ffabc30a27d4..cc7762748708 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -163,6 +163,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
+obj-$(CONFIG_LAZY_PERCPU_COUNTER) += lazy-percpu-counter.o
+
 obj-$(CONFIG_BITREVERSE) += bitrev.o
 obj-$(CONFIG_LINEAR_RANGES) += linear_ranges.o
 obj-$(CONFIG_PACKING)	+= packing.o
diff --git a/lib/lazy-percpu-counter.c b/lib/lazy-percpu-counter.c
new file mode 100644
index 000000000000..299ef36137ee
--- /dev/null
+++ b/lib/lazy-percpu-counter.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/atomic.h>
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/lazy-percpu-counter.h>
+#include <linux/percpu.h>
+
+/*
+ * We use the high bits of the atomic counter for a secondary counter, which is
+ * incremented every time the counter is touched. When the secondary counter
+ * wraps, we check the time the counter last wrapped, and if it was recent
+ * enough that means the update frequency has crossed our threshold and we
+ * switch to percpu mode:
+ */
+#define COUNTER_MOD_BITS		8
+#define COUNTER_MOD_MASK		~(~0ULL >> COUNTER_MOD_BITS)
+#define COUNTER_MOD_BITS_START		(64 - COUNTER_MOD_BITS)
+
+/*
+ * We use the low bit of the counter to indicate whether we're in atomic mode
+ * (low bit clear), or percpu mode (low bit set, counter is a pointer to actual
+ * percpu counters:
+ */
+#define COUNTER_IS_PCPU_BIT		1
+
+static inline u64 __percpu *lazy_percpu_counter_is_pcpu(u64 v)
+{
+	if (!(v & COUNTER_IS_PCPU_BIT))
+		return NULL;
+
+	v ^= COUNTER_IS_PCPU_BIT;
+	return (u64 __percpu *)(unsigned long)v;
+}
+
+static inline s64 lazy_percpu_counter_atomic_val(s64 v)
+{
+	/* Ensure output is sign extended properly: */
+	return (v << COUNTER_MOD_BITS) >>
+		(COUNTER_MOD_BITS + COUNTER_IS_PCPU_BIT);
+}
+
+static void lazy_percpu_counter_switch_to_pcpu(struct raw_lazy_percpu_counter *c)
+{
+	u64 __percpu *pcpu_v = alloc_percpu_gfp(u64, GFP_ATOMIC|__GFP_NOWARN);
+	u64 old, new, v;
+
+	if (!pcpu_v)
+		return;
+
+	preempt_disable();
+	v = atomic64_read(&c->v);
+	do {
+		if (lazy_percpu_counter_is_pcpu(v)) {
+			free_percpu(pcpu_v);
+			return;
+		}
+
+		old = v;
+		new = (unsigned long)pcpu_v | 1;
+
+		*this_cpu_ptr(pcpu_v) = lazy_percpu_counter_atomic_val(v);
+	} while ((v = atomic64_cmpxchg(&c->v, old, new)) != old);
+	preempt_enable();
+}
+
+/**
+ * __lazy_percpu_counter_exit: Free resources associated with a
+ * raw_lazy_percpu_counter
+ *
+ * @c: counter to exit
+ */
+void __lazy_percpu_counter_exit(struct raw_lazy_percpu_counter *c)
+{
+	free_percpu(lazy_percpu_counter_is_pcpu(atomic64_read(&c->v)));
+}
+EXPORT_SYMBOL_GPL(__lazy_percpu_counter_exit);
+
+/**
+ * __lazy_percpu_counter_read: Read current value of a raw_lazy_percpu_counter
+ *
+ * @c: counter to read
+ */
+s64 __lazy_percpu_counter_read(struct raw_lazy_percpu_counter *c)
+{
+	s64 v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v = lazy_percpu_counter_is_pcpu(v);
+
+	if (pcpu_v) {
+		int cpu;
+
+		v = 0;
+		for_each_possible_cpu(cpu)
+			v += *per_cpu_ptr(pcpu_v, cpu);
+	} else {
+		v = lazy_percpu_counter_atomic_val(v);
+	}
+
+	return v;
+}
+EXPORT_SYMBOL_GPL(__lazy_percpu_counter_read);
+
+/**
+ * __lazy_percpu_counter_add: Add a value to a lazy_percpu_counter
+ *
+ * @c: counter to modify
+ * @last_wrap: pointer to a timestamp, updated when mod counter wraps
+ * @i: value to add
+ */
+void __lazy_percpu_counter_add(struct raw_lazy_percpu_counter *c,
+			       unsigned long *last_wrap, s64 i)
+{
+	u64 atomic_i;
+	u64 old, v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v;
+
+	atomic_i  = i << COUNTER_IS_PCPU_BIT;
+	atomic_i &= ~COUNTER_MOD_MASK;
+	atomic_i |= 1ULL << COUNTER_MOD_BITS_START;
+
+	do {
+		pcpu_v = lazy_percpu_counter_is_pcpu(v);
+		if (pcpu_v) {
+			this_cpu_add(*pcpu_v, i);
+			return;
+		}
+
+		old = v;
+	} while ((v = atomic64_cmpxchg(&c->v, old, old + atomic_i)) != old);
+
+	if (unlikely(!(v & COUNTER_MOD_MASK))) {
+		unsigned long now = jiffies;
+
+		if (*last_wrap &&
+		    unlikely(time_after(*last_wrap + HZ, now)))
+			lazy_percpu_counter_switch_to_pcpu(c);
+		else
+			*last_wrap = now;
+	}
+}
+EXPORT_SYMBOL(__lazy_percpu_counter_add);
-- 
2.37.2.672.g94769d06f0-goog

