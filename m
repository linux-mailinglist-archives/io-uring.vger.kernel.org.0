Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1C25A6FF5
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiH3Vwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiH3Vvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:51:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064477D7BA
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n18-20020a25d612000000b0069661a1dc48so726107ybg.20
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=vjjGk6pymrjMSyrfbdxQ3/p6O8Kus1ISFMk96O5o39I=;
        b=OXRgptnZ7i+ICNigJkBWT2cSYFZtaNbBth28h0zoZMO0yy1KlhLJWbOL/agYd17Ge+
         H8eygOzvmZZ/skvQrD81gmRZiypc2lcG0QHZKUmUE/ni+JmGucTrUU1yExVGKLt9MJij
         ftmKNsJcjdyi4dhaD13stFQzNJ1xbGRin4GkFtVHsn7nMBn5wS02jls3bfzzV07WlYsq
         mi9CGSRXCSnkh+sEnyExpA/okvKqytcPBHSo0PnRH7aCU5Q1xfzVqiAqvHEkIxcqVnHs
         2oBNbQXE+ro549f5zm45uHNrO1sona3NzY/FqJ45DQDnvKS22ifnzF7B5XwlNd/5xlfX
         M9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=vjjGk6pymrjMSyrfbdxQ3/p6O8Kus1ISFMk96O5o39I=;
        b=NUfUcLBfFPwpR1LMM4TzOwlKPFTaSwMYtisDNa7y9OkHchXRRdZGpwQLxr6FJT5CIb
         kMdK1keMl+dtWRcIhdWi1JxFsS34xpEQh9g0BRRgtfaVBrKODu5HSrLEN6mi2VZQOwMp
         veK5uzq7hcx/XaR2jQ7Cd7Tp0uop9E63jvcif3TbuBzvBQ+b8PFgoycK3VvG7hwcT8gP
         /lirJd6+neR4U74IAlI+utXVtPVyNH3wPxj76d2ZMuS7ls6GHDi/eEj/1zBZqMcFcFQm
         EbFTib+0YRz/yvyfdiMqehAz+QmnJTc8G/eiUm+SNogXSFyAOIUmig6mktAeAlH30Ewn
         USCQ==
X-Gm-Message-State: ACgBeo1Gjp/qQyyWfpRKEvaiUXAGabUYIDTObZ2Cv4mZ+a8j5L2TndC+
        pAqDZrkC13dFuXq4DpUD8yTTNf3wulU=
X-Google-Smtp-Source: AA6agR4vIoEARtwRV51vchZbtFRCbo5XPnJmQ5jWl1WbEyyresfSAVBl15tPztqHAfgzavikcDXhMgmO3BY=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a81:f47:0:b0:31f:434b:5ee with SMTP id
 68-20020a810f47000000b0031f434b05eemr15734874ywp.383.1661896214287; Tue, 30
 Aug 2022 14:50:14 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:08 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-20-surenb@google.com>
Subject: [RFC PATCH 19/30] move stack capture functionality into a separate
 function for reuse
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

Make save_stack() function part of stackdepot API to be used outside of
page_owner. Also rename task_struct's in_page_owner to in_capture_stack
flag to better convey the wider use of this flag.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/sched.h      |  6 ++--
 include/linux/stackdepot.h |  3 ++
 lib/stackdepot.c           | 68 ++++++++++++++++++++++++++++++++++++++
 mm/page_owner.c            | 52 ++---------------------------
 4 files changed, 77 insertions(+), 52 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e7b2f8a5c711..d06cad6c14bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -930,9 +930,9 @@ struct task_struct {
 	/* Stalled due to lack of memory */
 	unsigned			in_memstall:1;
 #endif
-#ifdef CONFIG_PAGE_OWNER
-	/* Used by page_owner=on to detect recursion in page tracking. */
-	unsigned			in_page_owner:1;
+#ifdef CONFIG_STACKDEPOT
+	/* Used by stack_depot_capture_stack to detect recursion. */
+	unsigned			in_capture_stack:1;
 #endif
 #ifdef CONFIG_EVENTFD
 	/* Recursion prevention for eventfd_signal() */
diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index bc2797955de9..8dc9fdb2c4dd 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -64,4 +64,7 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 
 void stack_depot_print(depot_stack_handle_t stack);
 
+bool stack_depot_capture_init(void);
+depot_stack_handle_t stack_depot_capture_stack(gfp_t flags);
+
 #endif
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index e73fda23388d..c8615bd6dc25 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -514,3 +514,71 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 	return __stack_depot_save(entries, nr_entries, alloc_flags, true);
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
+
+static depot_stack_handle_t recursion_handle;
+static depot_stack_handle_t failure_handle;
+
+static __always_inline depot_stack_handle_t create_custom_stack(void)
+{
+	unsigned long entries[4];
+	unsigned int nr_entries;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	return stack_depot_save(entries, nr_entries, GFP_KERNEL);
+}
+
+static noinline void register_recursion_stack(void)
+{
+	recursion_handle = create_custom_stack();
+}
+
+static noinline void register_failure_stack(void)
+{
+	failure_handle = create_custom_stack();
+}
+
+bool stack_depot_capture_init(void)
+{
+	static DEFINE_MUTEX(stack_depot_capture_init_mutex);
+	static bool utility_stacks_ready;
+
+	mutex_lock(&stack_depot_capture_init_mutex);
+	if (!utility_stacks_ready) {
+		register_recursion_stack();
+		register_failure_stack();
+		utility_stacks_ready = true;
+	}
+	mutex_unlock(&stack_depot_capture_init_mutex);
+
+	return utility_stacks_ready;
+}
+
+/* TODO: teach stack_depot_capture_stack to use off stack temporal storage */
+#define CAPTURE_STACK_DEPTH (16)
+
+depot_stack_handle_t stack_depot_capture_stack(gfp_t flags)
+{
+	unsigned long entries[CAPTURE_STACK_DEPTH];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	/*
+	 * Avoid recursion.
+	 *
+	 * Sometimes page metadata allocation tracking requires more
+	 * memory to be allocated:
+	 * - when new stack trace is saved to stack depot
+	 * - when backtrace itself is calculated (ia64)
+	 */
+	if (current->in_capture_stack)
+		return recursion_handle;
+	current->in_capture_stack = 1;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
+	handle = stack_depot_save(entries, nr_entries, flags);
+	if (!handle)
+		handle = failure_handle;
+
+	current->in_capture_stack = 0;
+	return handle;
+}
diff --git a/mm/page_owner.c b/mm/page_owner.c
index fd4af1ad34b8..c3173e34a779 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -15,12 +15,6 @@
 
 #include "internal.h"
 
-/*
- * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
- * to use off stack temporal storage
- */
-#define PAGE_OWNER_STACK_DEPTH (16)
-
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
@@ -37,8 +31,6 @@ struct page_owner {
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
-static depot_stack_handle_t dummy_handle;
-static depot_stack_handle_t failure_handle;
 static depot_stack_handle_t early_handle;
 
 static void init_early_allocated_pages(void);
@@ -68,16 +60,6 @@ static __always_inline depot_stack_handle_t create_dummy_stack(void)
 	return stack_depot_save(entries, nr_entries, GFP_KERNEL);
 }
 
-static noinline void register_dummy_stack(void)
-{
-	dummy_handle = create_dummy_stack();
-}
-
-static noinline void register_failure_stack(void)
-{
-	failure_handle = create_dummy_stack();
-}
-
 static noinline void register_early_stack(void)
 {
 	early_handle = create_dummy_stack();
@@ -88,8 +70,7 @@ static __init void init_page_owner(void)
 	if (!page_owner_enabled)
 		return;
 
-	register_dummy_stack();
-	register_failure_stack();
+	stack_depot_capture_init();
 	register_early_stack();
 	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
@@ -106,33 +87,6 @@ static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
 	return (void *)page_ext + page_owner_ops.offset;
 }
 
-static noinline depot_stack_handle_t save_stack(gfp_t flags)
-{
-	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
-	depot_stack_handle_t handle;
-	unsigned int nr_entries;
-
-	/*
-	 * Avoid recursion.
-	 *
-	 * Sometimes page metadata allocation tracking requires more
-	 * memory to be allocated:
-	 * - when new stack trace is saved to stack depot
-	 * - when backtrace itself is calculated (ia64)
-	 */
-	if (current->in_page_owner)
-		return dummy_handle;
-	current->in_page_owner = 1;
-
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
-	handle = stack_depot_save(entries, nr_entries, flags);
-	if (!handle)
-		handle = failure_handle;
-
-	current->in_page_owner = 0;
-	return handle;
-}
-
 void __reset_page_owner(struct page *page, unsigned short order)
 {
 	int i;
@@ -145,7 +99,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	if (unlikely(!page_ext))
 		return;
 
-	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
+	handle = stack_depot_capture_stack(GFP_NOWAIT | __GFP_NOWARN);
 	for (i = 0; i < (1 << order); i++) {
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 		page_owner = get_page_owner(page_ext);
@@ -189,7 +143,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	if (unlikely(!page_ext))
 		return;
 
-	handle = save_stack(gfp_mask);
+	handle = stack_depot_capture_stack(gfp_mask);
 	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 }
 
-- 
2.37.2.672.g94769d06f0-goog

