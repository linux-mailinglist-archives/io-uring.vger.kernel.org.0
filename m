Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D461F5A702F
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiH3Vz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiH3Vxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:53:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C293C985B4
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d8-20020a25bc48000000b00680651cf051so725876ybk.23
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=I4E0zbgDI9VG+bn61bv+haOxSwGhD/tyP2DJbq3PPno=;
        b=lMDbTLhz/ohye/t587Ty2qYkwt84HzoX6h4AilPBmG9LeLK/WaDZ7EvrZIWUeDFZwN
         baQ3A+GzmoJpCC2Qp6Nin3hCbTA3XMAwcRsC3ADvEnF19vQrwy6RoUEvm7OappAdU5l3
         60OMhVhHNpayFnTLjtsN7/Lu9JsBb/KhrGHPzY9WG93dKLmDa68Or3m8sTRshadBMxRo
         gvNxqguLj4zV89o7/OmZtheKpzYwtex2+d9trxVpf+SrcS8bxpKkphWAXzDnCiw+XQbW
         tpWgaNqbZfcBTDlXT2S+rQcVcH5VK0aSOJyORG8U2BkSE5BmUcnQE78u9yJeVf5iO1RV
         3uQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=I4E0zbgDI9VG+bn61bv+haOxSwGhD/tyP2DJbq3PPno=;
        b=ApR5K3FParpSIZWRO1DPZ4mwB3y+aQ6cqN8FjbHGDO0tUpnrtrxbNGKNtQnrGQxqm/
         l9gv7LjLJGYYXATkGZJJGNOX8ncfxM0gl0WSs4cSbg/GUxBSLeTVIvNvVmKVVs8DAoWL
         IOHlHPPoVvbP/Fn9TXLaXcRzcXYXYC1xE60IcDwGM/err+WoD7DFm2x5HhEAmGRi92cW
         wzBTkFT5MjyQL1tFnw4w05u3C9AH/9mIZL6q8YqBcOw9HjLrajHsQTUhjBw3aCCCGodw
         je9cHVBfie0GqeWHT3ctk1bXodujHJ4ZL2u+FYPRld3aPSYpwfgaBsgsqLttlLyO6SS6
         Ncrw==
X-Gm-Message-State: ACgBeo0YwmCn+QVwqo1eqwIQVK3o8giLTiXRmz2oM8kxj6d6uIgcyUYE
        jki7IMsKzMCuOhj2rvVp59LR5IFXpF4=
X-Google-Smtp-Source: AA6agR7dI1wO7X0I+X6vkeMAF4jNOS1nU0nYZhacVn04sWRsl5inyAJXnu3ndUKBzLRifBhinWG6G+5CS9s=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:4f0b:0:b0:69c:2b2c:f6e5 with SMTP id
 d11-20020a254f0b000000b0069c2b2cf6e5mr7392973ybb.298.1661896240890; Tue, 30
 Aug 2022 14:50:40 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:18 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-30-surenb@google.com>
Subject: [RFC PATCH 29/30] dyndbg: Convert to code tagging
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

This converts dynamic debug to the new code tagging framework, which
provides an interface for iterating over objects in a particular elf
section.

It also converts the debugfs interface from seq_file to the style used
by other code tagging users, which also makes the code a bit smaller and
simpler.

It doesn't yet convert struct _ddebug to use struct codetag; another
cleanup could convert it to that, and to codetag_query_parse().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
---
 include/asm-generic/codetag.lds.h |   5 +-
 include/asm-generic/vmlinux.lds.h |   5 -
 include/linux/dynamic_debug.h     |  11 +-
 kernel/module/internal.h          |   2 -
 kernel/module/main.c              |  23 --
 lib/dynamic_debug.c               | 452 ++++++++++--------------------
 6 files changed, 158 insertions(+), 340 deletions(-)

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
index b087cf1874a9..b7e351f80e9e 100644
--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -8,10 +8,11 @@
 	KEEP(*(_name))			\
 	__stop_##_name = .;
 
-#define CODETAG_SECTIONS()		\
+#define CODETAG_SECTIONS()				\
 	SECTION_WITH_BOUNDARIES(alloc_tags)		\
 	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)	\
 	SECTION_WITH_BOUNDARIES(time_stats_tags)	\
-	SECTION_WITH_BOUNDARIES(error_code_tags)
+	SECTION_WITH_BOUNDARIES(error_code_tags)	\
+	SECTION_WITH_BOUNDARIES(dyndbg)
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c2dc2a59ab2e..d3fb914d157f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -345,11 +345,6 @@
 	__end_once = .;							\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
-	/* implement dynamic printk debug */				\
-	. = ALIGN(8);							\
-	__start___dyndbg = .;						\
-	KEEP(*(__dyndbg))						\
-	__stop___dyndbg = .;						\
 	CODETAG_SECTIONS()						\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index dce631e678dd..6a57009dd29e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -58,9 +58,6 @@ struct _ddebug {
 /* exported for module authors to exercise >control */
 int dynamic_debug_exec_queries(const char *query, const char *modname);
 
-int ddebug_add_module(struct _ddebug *tab, unsigned int n,
-				const char *modname);
-extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
 void __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
@@ -89,7 +86,7 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 
 #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
 	static struct _ddebug  __aligned(8)			\
-	__section("__dyndbg") name = {				\
+	__section("dyndbg") name = {				\
 		.modname = KBUILD_MODNAME,			\
 		.function = __func__,				\
 		.filename = __FILE__,				\
@@ -187,12 +184,6 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 #include <linux/errno.h>
 #include <linux/printk.h>
 
-static inline int ddebug_add_module(struct _ddebug *tab, unsigned int n,
-				    const char *modname)
-{
-	return 0;
-}
-
 static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index f1b6c477bd93..f867c57ab74f 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -62,8 +62,6 @@ struct load_info {
 	Elf_Shdr *sechdrs;
 	char *secstrings, *strtab;
 	unsigned long symoffs, stroffs, init_typeoffs, core_typeoffs;
-	struct _ddebug *debug;
-	unsigned int num_debug;
 	bool sig_ok;
 #ifdef CONFIG_KALLSYMS
 	unsigned long mod_kallsyms_init_off;
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d253277492fd..28e3b337841b 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1163,9 +1163,6 @@ static void free_module(struct module *mod)
 	mod->state = MODULE_STATE_UNFORMED;
 	mutex_unlock(&module_mutex);
 
-	/* Remove dynamic debug info */
-	ddebug_remove_module(mod->name);
-
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
@@ -1600,19 +1597,6 @@ static void free_modinfo(struct module *mod)
 	}
 }
 
-static void dynamic_debug_setup(struct module *mod, struct _ddebug *debug, unsigned int num)
-{
-	if (!debug)
-		return;
-	ddebug_add_module(debug, num, mod->name);
-}
-
-static void dynamic_debug_remove(struct module *mod, struct _ddebug *debug)
-{
-	if (debug)
-		ddebug_remove_module(mod->name);
-}
-
 void * __weak module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
@@ -2113,9 +2097,6 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 	if (section_addr(info, "__obsparm"))
 		pr_warn("%s: Ignoring obsolete parameters\n", mod->name);
 
-	info->debug = section_objs(info, "__dyndbg",
-				   sizeof(*info->debug), &info->num_debug);
-
 	return 0;
 }
 
@@ -2808,9 +2789,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		goto free_arch_cleanup;
 	}
 
-	init_build_id(mod, info);
-	dynamic_debug_setup(mod, info->debug, info->num_debug);
-
 	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
 	ftrace_module_init(mod);
 
@@ -2875,7 +2853,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
  ddebug_cleanup:
 	ftrace_release_mod(mod);
-	dynamic_debug_remove(mod, info->debug);
 	synchronize_rcu();
 	kfree(mod->args);
  free_arch_cleanup:
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index dd7f56af9aed..e9079825fb3b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) "dyndbg: " fmt
 
+#include <linux/codetag.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -36,19 +37,37 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/netdevice.h>
+#include <linux/seq_buf.h>
 
 #include <rdma/ib_verbs.h>
 
-extern struct _ddebug __start___dyndbg[];
-extern struct _ddebug __stop___dyndbg[];
+static struct codetag_type *cttype;
 
-struct ddebug_table {
-	struct list_head link;
-	const char *mod_name;
-	unsigned int num_ddebugs;
-	struct _ddebug *ddebugs;
+struct user_buf {
+	char __user		*buf;	/* destination user buffer */
+	size_t			size;	/* size of requested read */
+	ssize_t			ret;	/* bytes read so far */
 };
 
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
 struct ddebug_query {
 	const char *filename;
 	const char *module;
@@ -58,8 +77,9 @@ struct ddebug_query {
 };
 
 struct ddebug_iter {
-	struct ddebug_table *table;
-	unsigned int idx;
+	struct codetag_iterator ct_iter;
+	struct seq_buf		buf;
+	char			rawbuf[4096];
 };
 
 struct flag_settings {
@@ -67,8 +87,6 @@ struct flag_settings {
 	unsigned int mask;
 };
 
-static DEFINE_MUTEX(ddebug_lock);
-static LIST_HEAD(ddebug_tables);
 static int verbose;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, " dynamic_debug/control processing "
@@ -152,78 +170,76 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
 static int ddebug_change(const struct ddebug_query *query,
 			 struct flag_settings *modifiers)
 {
-	int i;
-	struct ddebug_table *dt;
+	struct codetag_iterator ct_iter;
+	struct codetag *ct;
 	unsigned int newflags;
 	unsigned int nfound = 0;
 	struct flagsbuf fbuf;
 
-	/* search for matching ddebugs */
-	mutex_lock(&ddebug_lock);
-	list_for_each_entry(dt, &ddebug_tables, link) {
+	codetag_lock_module_list(cttype, true);
+	codetag_init_iter(&ct_iter, cttype);
+
+	while ((ct = codetag_next_ct(&ct_iter))) {
+		struct _ddebug *dp = (void *) ct;
 
 		/* match against the module name */
 		if (query->module &&
-		    !match_wildcard(query->module, dt->mod_name))
+		    !match_wildcard(query->module, dp->modname))
 			continue;
 
-		for (i = 0; i < dt->num_ddebugs; i++) {
-			struct _ddebug *dp = &dt->ddebugs[i];
-
-			/* match against the source filename */
-			if (query->filename &&
-			    !match_wildcard(query->filename, dp->filename) &&
-			    !match_wildcard(query->filename,
-					   kbasename(dp->filename)) &&
-			    !match_wildcard(query->filename,
-					   trim_prefix(dp->filename)))
-				continue;
+		/* match against the source filename */
+		if (query->filename &&
+		    !match_wildcard(query->filename, dp->filename) &&
+		    !match_wildcard(query->filename,
+				   kbasename(dp->filename)) &&
+		    !match_wildcard(query->filename,
+				   trim_prefix(dp->filename)))
+			continue;
 
-			/* match against the function */
-			if (query->function &&
-			    !match_wildcard(query->function, dp->function))
-				continue;
+		/* match against the function */
+		if (query->function &&
+		    !match_wildcard(query->function, dp->function))
+			continue;
 
-			/* match against the format */
-			if (query->format) {
-				if (*query->format == '^') {
-					char *p;
-					/* anchored search. match must be at beginning */
-					p = strstr(dp->format, query->format+1);
-					if (p != dp->format)
-						continue;
-				} else if (!strstr(dp->format, query->format))
+		/* match against the format */
+		if (query->format) {
+			if (*query->format == '^') {
+				char *p;
+				/* anchored search. match must be at beginning */
+				p = strstr(dp->format, query->format+1);
+				if (p != dp->format)
 					continue;
-			}
-
-			/* match against the line number range */
-			if (query->first_lineno &&
-			    dp->lineno < query->first_lineno)
-				continue;
-			if (query->last_lineno &&
-			    dp->lineno > query->last_lineno)
+			} else if (!strstr(dp->format, query->format))
 				continue;
+		}
+
+		/* match against the line number range */
+		if (query->first_lineno &&
+		    dp->lineno < query->first_lineno)
+			continue;
+		if (query->last_lineno &&
+		    dp->lineno > query->last_lineno)
+			continue;
 
-			nfound++;
+		nfound++;
 
-			newflags = (dp->flags & modifiers->mask) | modifiers->flags;
-			if (newflags == dp->flags)
-				continue;
+		newflags = (dp->flags & modifiers->mask) | modifiers->flags;
+		if (newflags == dp->flags)
+			continue;
 #ifdef CONFIG_JUMP_LABEL
-			if (dp->flags & _DPRINTK_FLAGS_PRINT) {
-				if (!(modifiers->flags & _DPRINTK_FLAGS_PRINT))
-					static_branch_disable(&dp->key.dd_key_true);
-			} else if (modifiers->flags & _DPRINTK_FLAGS_PRINT)
-				static_branch_enable(&dp->key.dd_key_true);
+		if (dp->flags & _DPRINTK_FLAGS_PRINT) {
+			if (!(modifiers->flags & _DPRINTK_FLAGS_PRINT))
+				static_branch_disable(&dp->key.dd_key_true);
+		} else if (modifiers->flags & _DPRINTK_FLAGS_PRINT)
+			static_branch_enable(&dp->key.dd_key_true);
 #endif
-			dp->flags = newflags;
-			v4pr_info("changed %s:%d [%s]%s =%s\n",
-				 trim_prefix(dp->filename), dp->lineno,
-				 dt->mod_name, dp->function,
-				 ddebug_describe_flags(dp->flags, &fbuf));
-		}
+		dp->flags = newflags;
+		v4pr_info("changed %s:%d [%s]%s =%s\n",
+			 trim_prefix(dp->filename), dp->lineno,
+			 dp->modname, dp->function,
+			 ddebug_describe_flags(dp->flags, &fbuf));
 	}
-	mutex_unlock(&ddebug_lock);
+	codetag_lock_module_list(cttype, false);
 
 	if (!nfound && verbose)
 		pr_info("no matches for query\n");
@@ -794,187 +810,96 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	return len;
 }
 
-/*
- * Set the iterator to point to the first _ddebug object
- * and return a pointer to that first object.  Returns
- * NULL if there are no _ddebugs at all.
- */
-static struct _ddebug *ddebug_iter_first(struct ddebug_iter *iter)
-{
-	if (list_empty(&ddebug_tables)) {
-		iter->table = NULL;
-		iter->idx = 0;
-		return NULL;
-	}
-	iter->table = list_entry(ddebug_tables.next,
-				 struct ddebug_table, link);
-	iter->idx = 0;
-	return &iter->table->ddebugs[iter->idx];
-}
-
-/*
- * Advance the iterator to point to the next _ddebug
- * object from the one the iterator currently points at,
- * and returns a pointer to the new _ddebug.  Returns
- * NULL if the iterator has seen all the _ddebugs.
- */
-static struct _ddebug *ddebug_iter_next(struct ddebug_iter *iter)
-{
-	if (iter->table == NULL)
-		return NULL;
-	if (++iter->idx == iter->table->num_ddebugs) {
-		/* iterate to next table */
-		iter->idx = 0;
-		if (list_is_last(&iter->table->link, &ddebug_tables)) {
-			iter->table = NULL;
-			return NULL;
-		}
-		iter->table = list_entry(iter->table->link.next,
-					 struct ddebug_table, link);
-	}
-	return &iter->table->ddebugs[iter->idx];
-}
-
-/*
- * Seq_ops start method.  Called at the start of every
- * read() call from userspace.  Takes the ddebug_lock and
- * seeks the seq_file's iterator to the given position.
- */
-static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
-{
-	struct ddebug_iter *iter = m->private;
-	struct _ddebug *dp;
-	int n = *pos;
-
-	mutex_lock(&ddebug_lock);
-
-	if (!n)
-		return SEQ_START_TOKEN;
-	if (n < 0)
-		return NULL;
-	dp = ddebug_iter_first(iter);
-	while (dp != NULL && --n > 0)
-		dp = ddebug_iter_next(iter);
-	return dp;
-}
-
-/*
- * Seq_ops next method.  Called several times within a read()
- * call from userspace, with ddebug_lock held.  Walks to the
- * next _ddebug object with a special case for the header line.
- */
-static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	struct ddebug_iter *iter = m->private;
-	struct _ddebug *dp;
-
-	if (p == SEQ_START_TOKEN)
-		dp = ddebug_iter_first(iter);
-	else
-		dp = ddebug_iter_next(iter);
-	++*pos;
-	return dp;
-}
-
 /*
  * Seq_ops show method.  Called several times within a read()
  * call from userspace, with ddebug_lock held.  Formats the
  * current _ddebug as a single human-readable line, with a
  * special case for the header line.
  */
-static int ddebug_proc_show(struct seq_file *m, void *p)
+static void ddebug_to_text(struct seq_buf *out, struct _ddebug *dp)
 {
-	struct ddebug_iter *iter = m->private;
-	struct _ddebug *dp = p;
 	struct flagsbuf flags;
+	char *buf;
+	size_t len;
 
-	if (p == SEQ_START_TOKEN) {
-		seq_puts(m,
-			 "# filename:lineno [module]function flags format\n");
-		return 0;
-	}
-
-	seq_printf(m, "%s:%u [%s]%s =%s \"",
+	seq_buf_printf(out, "%s:%u [%s]%s =%s \"",
 		   trim_prefix(dp->filename), dp->lineno,
-		   iter->table->mod_name, dp->function,
+		   dp->modname, dp->function,
 		   ddebug_describe_flags(dp->flags, &flags));
-	seq_escape(m, dp->format, "\t\r\n\"");
-	seq_puts(m, "\"\n");
 
-	return 0;
-}
+	len = seq_buf_get_buf(out, &buf);
+	len = string_escape_mem(dp->format, strlen(dp->format),
+				buf, len, ESCAPE_OCTAL, "\t\r\n\"");
+	seq_buf_commit(out, len);
 
-/*
- * Seq_ops stop method.  Called at the end of each read()
- * call from userspace.  Drops ddebug_lock.
- */
-static void ddebug_proc_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&ddebug_lock);
+	seq_buf_puts(out, "\"\n");
 }
 
-static const struct seq_operations ddebug_proc_seqops = {
-	.start = ddebug_proc_start,
-	.next = ddebug_proc_next,
-	.show = ddebug_proc_show,
-	.stop = ddebug_proc_stop
-};
-
 static int ddebug_proc_open(struct inode *inode, struct file *file)
 {
-	return seq_open_private(file, &ddebug_proc_seqops,
-				sizeof(struct ddebug_iter));
+	struct ddebug_iter *iter;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	codetag_lock_module_list(cttype, true);
+	codetag_init_iter(&iter->ct_iter, cttype);
+	codetag_lock_module_list(cttype, false);
+	seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
+	file->private_data = iter;
+
+	return 0;
 }
 
-static const struct file_operations ddebug_proc_fops = {
-	.owner = THIS_MODULE,
-	.open = ddebug_proc_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_private,
-	.write = ddebug_proc_write
-};
+static int ddebug_proc_release(struct inode *inode, struct file *file)
+{
+	struct ddebug_iter *iter = file->private_data;
 
-static const struct proc_ops proc_fops = {
-	.proc_open = ddebug_proc_open,
-	.proc_read = seq_read,
-	.proc_lseek = seq_lseek,
-	.proc_release = seq_release_private,
-	.proc_write = ddebug_proc_write
-};
+	kfree(iter);
+	return 0;
+}
 
-/*
- * Allocate a new ddebug_table for the given module
- * and add it to the global list.
- */
-int ddebug_add_module(struct _ddebug *tab, unsigned int n,
-			     const char *name)
+static ssize_t ddebug_proc_read(struct file *file, char __user *ubuf,
+				   size_t size, loff_t *ppos)
 {
-	struct ddebug_table *dt;
+	struct ddebug_iter *iter = file->private_data;
+	struct user_buf	buf = { .buf = ubuf, .size = size };
+	struct codetag *ct;
+	int err = 0;
 
-	dt = kzalloc(sizeof(*dt), GFP_KERNEL);
-	if (dt == NULL) {
-		pr_err("error adding module: %s\n", name);
-		return -ENOMEM;
-	}
-	/*
-	 * For built-in modules, name lives in .rodata and is
-	 * immortal. For loaded modules, name points at the name[]
-	 * member of struct module, which lives at least as long as
-	 * this struct ddebug_table.
-	 */
-	dt->mod_name = name;
-	dt->num_ddebugs = n;
-	dt->ddebugs = tab;
+	codetag_lock_module_list(iter->ct_iter.cttype, true);
+	while (1) {
+		err = flush_ubuf(&buf, &iter->buf);
+		if (err || !buf.size)
+			break;
+
+		ct = codetag_next_ct(&iter->ct_iter);
+		if (!ct)
+			break;
 
-	mutex_lock(&ddebug_lock);
-	list_add(&dt->link, &ddebug_tables);
-	mutex_unlock(&ddebug_lock);
+		ddebug_to_text(&iter->buf, (void *) ct);
+	}
+	codetag_lock_module_list(iter->ct_iter.cttype, false);
 
-	vpr_info("%3u debug prints in module %s\n", n, dt->mod_name);
-	return 0;
+	return err ? : buf.ret;
 }
 
+static const struct file_operations ddebug_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ddebug_proc_open,
+	.read		= ddebug_proc_read,
+	.release	= ddebug_proc_release,
+	.write		= ddebug_proc_write,
+};
+
+static const struct proc_ops proc_fops = {
+	.proc_open	= ddebug_proc_open,
+	.proc_read	= ddebug_proc_read,
+	.proc_release	= ddebug_proc_release,
+	.proc_write	= ddebug_proc_write,
+};
+
 /* helper for ddebug_dyndbg_(boot|module)_param_cb */
 static int ddebug_dyndbg_param_cb(char *param, char *val,
 				const char *modname, int on_err)
@@ -1015,47 +940,6 @@ int ddebug_dyndbg_module_param_cb(char *param, char *val, const char *module)
 	return ddebug_dyndbg_param_cb(param, val, module, -ENOENT);
 }
 
-static void ddebug_table_free(struct ddebug_table *dt)
-{
-	list_del_init(&dt->link);
-	kfree(dt);
-}
-
-/*
- * Called in response to a module being unloaded.  Removes
- * any ddebug_table's which point at the module.
- */
-int ddebug_remove_module(const char *mod_name)
-{
-	struct ddebug_table *dt, *nextdt;
-	int ret = -ENOENT;
-
-	mutex_lock(&ddebug_lock);
-	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
-		if (dt->mod_name == mod_name) {
-			ddebug_table_free(dt);
-			ret = 0;
-			break;
-		}
-	}
-	mutex_unlock(&ddebug_lock);
-	if (!ret)
-		v2pr_info("removed module \"%s\"\n", mod_name);
-	return ret;
-}
-
-static void ddebug_remove_all_tables(void)
-{
-	mutex_lock(&ddebug_lock);
-	while (!list_empty(&ddebug_tables)) {
-		struct ddebug_table *dt = list_entry(ddebug_tables.next,
-						      struct ddebug_table,
-						      link);
-		ddebug_table_free(dt);
-	}
-	mutex_unlock(&ddebug_lock);
-}
-
 static __initdata int ddebug_init_success;
 
 static int __init dynamic_debug_init_control(void)
@@ -1083,45 +967,19 @@ static int __init dynamic_debug_init_control(void)
 
 static int __init dynamic_debug_init(void)
 {
-	struct _ddebug *iter, *iter_start;
-	const char *modname = NULL;
+	const struct codetag_type_desc desc = {
+		.section = "dyndbg",
+		.tag_size = sizeof(struct _ddebug),
+	};
 	char *cmdline;
-	int ret = 0;
-	int n = 0, entries = 0, modct = 0;
+	int ret;
 
-	if (&__start___dyndbg == &__stop___dyndbg) {
-		if (IS_ENABLED(CONFIG_DYNAMIC_DEBUG)) {
-			pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
-			return 1;
-		}
-		pr_info("Ignore empty _ddebug table in a CONFIG_DYNAMIC_DEBUG_CORE build\n");
-		ddebug_init_success = 1;
-		return 0;
-	}
-	iter = __start___dyndbg;
-	modname = iter->modname;
-	iter_start = iter;
-	for (; iter < __stop___dyndbg; iter++) {
-		entries++;
-		if (strcmp(modname, iter->modname)) {
-			modct++;
-			ret = ddebug_add_module(iter_start, n, modname);
-			if (ret)
-				goto out_err;
-			n = 0;
-			modname = iter->modname;
-			iter_start = iter;
-		}
-		n++;
-	}
-	ret = ddebug_add_module(iter_start, n, modname);
+	cttype = codetag_register_type(&desc);
+	ret = PTR_ERR_OR_ZERO(cttype);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	ddebug_init_success = 1;
-	vpr_info("%d prdebugs in %d modules, %d KiB in ddebug tables, %d kiB in __dyndbg section\n",
-		 entries, modct, (int)((modct * sizeof(struct ddebug_table)) >> 10),
-		 (int)((entries * sizeof(struct _ddebug)) >> 10));
 
 	/* now that ddebug tables are loaded, process all boot args
 	 * again to find and activate queries given in dyndbg params.
@@ -1132,14 +990,12 @@ static int __init dynamic_debug_init(void)
 	 * slightly noisy if verbose, but harmless.
 	 */
 	cmdline = kstrdup(saved_command_line, GFP_KERNEL);
+	if (!cmdline)
+		return -ENOMEM;
 	parse_args("dyndbg params", cmdline, NULL,
 		   0, 0, 0, NULL, &ddebug_dyndbg_boot_param_cb);
 	kfree(cmdline);
 	return 0;
-
-out_err:
-	ddebug_remove_all_tables();
-	return 0;
 }
 /* Allow early initialization for boot messages via boot param */
 early_initcall(dynamic_debug_init);
-- 
2.37.2.672.g94769d06f0-goog

