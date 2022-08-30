Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165F45A7001
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiH3Vwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiH3VwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:52:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BAC90C77
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n18-20020a25d612000000b0069661a1dc48so726204ybg.20
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=g/YTY0u3yadOEciruM5AsrsoCBr2LdU6F8XKpTCCoXE=;
        b=W9ws8GQM/90cTDmDN4sijcJEomx0StRc0qnBzUb4l/dKXquUVNd+bkQOSXwJxVHeSR
         QG60SQEVm6VA17XfZBoKGGzRXcSLpOO21vFhHqE3hmk2c9gf7/HtTYj3kp+LhucXD7zS
         32XZBjNXwZuxDqFNmQ7tqseycDiUbS6bSZaQn1dUA4lMpujJGMmrMQrbex/Wc04wsxKu
         B3eerDWEH6lgqkNOuwBI3NzTboD1OpHxugThISWmfH4bZEx8AfmzAF8N3fNasLdDbLD+
         eox1A7oZRZT7QuWta0fKi5W+QGVJWyjQVSgZXf5MPYNZ62sspJg2YTeSPJPL6GlufKLs
         TtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=g/YTY0u3yadOEciruM5AsrsoCBr2LdU6F8XKpTCCoXE=;
        b=lnig5tJwRnb/LMIT+pLdpJiXF3C6+Ql7D/sYHs1Lr5CPZc8QnBnrT+CvD4vGLhKyya
         krZj+8ecQg0C6rz8bT+Cwern1QsRDxpDAL4nHu3OLGRC95FPyeDfFPIY/Hz9lo1M8plu
         YRB1xfn78AD+dFQnxXJJC5vjAEBhEAOclHjcrZ4+HjNSPUQdp0P7ZMpTdU4kvO02F6Di
         GFAbLBIqVDXYIA/bHUMHWweTX2xX02B2kFdlChddjKpmjBtAckY39AydaD7n0yk2Gomf
         zR4L8ulVIHzzRr+4lRK89DQBPK3Goxj96j74uqVkvZv6R3bW6w+ehq9nfWza70KDO5jc
         zUVw==
X-Gm-Message-State: ACgBeo1FZVw2ck/XMpqvFTJ9KFDCglMGheC75AIQ2095ojGSBgsVlEZt
        tbDfPLCstOvXue7JL5NfHhWLfqU14I4=
X-Google-Smtp-Source: AA6agR7zbyBaHTavSAdE/8JQpYqzjp+0tJKa0FexURSVp+cX649/Bz10TDDbPo8ER0HHDl/6WW+PqHXP88E=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a05:6902:100b:b0:695:bd4e:95d6 with SMTP id
 w11-20020a056902100b00b00695bd4e95d6mr13705955ybt.595.1661896219160; Tue, 30
 Aug 2022 14:50:19 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:10 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-22-surenb@google.com>
Subject: [RFC PATCH 21/30] lib: implement context capture support for page and
 slab allocators
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

Implement mechanisms for capturing allocation call context which consists
of:
- allocation size
- pid, tgid and name of the allocating task
- allocation timestamp
- allocation call stack
The patch creates alloc_tags.ctx file which can be written to
enable/disable context capture for a specific code tag. Captured context
can be obtained by reading alloc_tags.ctx file.
Usage example:

echo "file include/asm-generic/pgalloc.h line 63 enable" > \
    /sys/kernel/debug/alloc_tags.ctx
cat alloc_tags.ctx
 91.0MiB      212 include/asm-generic/pgalloc.h:63 module:pgtable func:__pte_alloc_one
    size: 4096
    pid: 1551
    tgid: 1551
    comm: cat
    ts: 670109646361
    call stack:
         pte_alloc_one+0xfe/0x130
         __pte_alloc+0x22/0x90
         move_page_tables.part.0+0x994/0xa60
         shift_arg_pages+0xa4/0x180
         setup_arg_pages+0x286/0x2d0
         load_elf_binary+0x4e1/0x18d0
         bprm_execve+0x26b/0x660
         do_execveat_common.isra.0+0x19d/0x220
         __x64_sys_execve+0x2e/0x40
         do_syscall_64+0x38/0x90
         entry_SYSCALL_64_after_hwframe+0x63/0xcd

    size: 4096
    pid: 1551
    tgid: 1551
    comm: cat
    ts: 670109711801
    call stack:
         pte_alloc_one+0xfe/0x130
         __do_fault+0x52/0xc0
         __handle_mm_fault+0x7d9/0xdd0
         handle_mm_fault+0xc0/0x2b0
         do_user_addr_fault+0x1c3/0x660
         exc_page_fault+0x62/0x150
         asm_exc_page_fault+0x22/0x30
...

echo "file include/asm-generic/pgalloc.h line 63 disable" > \
    /sys/kernel/debug/alloc_tags.ctx

Note that disabling context capture will not clear already captured
context but no new context will be captured.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/alloc_tag.h |  28 ++++-
 include/linux/codetag.h   |   3 +-
 lib/Kconfig.debug         |   1 +
 lib/alloc_tag.c           | 239 +++++++++++++++++++++++++++++++++++++-
 lib/codetag.c             |  20 ++--
 5 files changed, 273 insertions(+), 18 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index b3f589afb1c9..66638cbf349a 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -16,27 +16,41 @@
  * an array of these. Embedded codetag utilizes codetag framework.
  */
 struct alloc_tag {
-	struct codetag			ct;
+	struct codetag_with_ctx		ctc;
 	unsigned long			last_wrap;
 	struct raw_lazy_percpu_counter	call_count;
 	struct raw_lazy_percpu_counter	bytes_allocated;
 } __aligned(8);
 
+static inline struct alloc_tag *ctc_to_alloc_tag(struct codetag_with_ctx *ctc)
+{
+	return container_of(ctc, struct alloc_tag, ctc);
+}
+
 static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
 {
-	return container_of(ct, struct alloc_tag, ct);
+	return container_of(ct_to_ctc(ct), struct alloc_tag, ctc);
 }
 
+struct codetag_ctx *alloc_tag_create_ctx(struct alloc_tag *tag, size_t size);
+void alloc_tag_free_ctx(struct codetag_ctx *ctx, struct alloc_tag **ptag);
+bool alloc_tag_enable_ctx(struct alloc_tag *tag, bool enable);
+
 #define DEFINE_ALLOC_TAG(_alloc_tag)					\
 	static struct alloc_tag _alloc_tag __used __aligned(8)		\
-	__section("alloc_tags") = { .ct = CODE_TAG_INIT }
+	__section("alloc_tags") = { .ctc.ct = CODE_TAG_INIT }
 
 #define alloc_tag_counter_read(counter)					\
 	__lazy_percpu_counter_read(counter)
 
 static inline void __alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 {
-	struct alloc_tag *tag = ct_to_alloc_tag(ref->ct);
+	struct alloc_tag *tag;
+
+	if (is_codetag_ctx_ref(ref))
+		alloc_tag_free_ctx(ref->ctx, &tag);
+	else
+		tag = ct_to_alloc_tag(ref->ct);
 
 	__lazy_percpu_counter_add(&tag->call_count, &tag->last_wrap, -1);
 	__lazy_percpu_counter_add(&tag->bytes_allocated, &tag->last_wrap, -bytes);
@@ -51,7 +65,11 @@ do {									\
 
 static inline void __alloc_tag_add(struct alloc_tag *tag, union codetag_ref *ref, size_t bytes)
 {
-	ref->ct = &tag->ct;
+	if (codetag_ctx_enabled(&tag->ctc))
+		ref->ctx = alloc_tag_create_ctx(tag, bytes);
+	else
+		ref->ct = &tag->ctc.ct;
+
 	__lazy_percpu_counter_add(&tag->call_count, &tag->last_wrap, 1);
 	__lazy_percpu_counter_add(&tag->bytes_allocated, &tag->last_wrap, bytes);
 }
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 57736ec77b45..a10c5fcbdd20 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -104,7 +104,8 @@ struct codetag_with_ctx *ct_to_ctc(struct codetag *ct)
 }
 
 void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
-struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
+void codetag_init_iter(struct codetag_iterator *iter,
+		       struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 struct codetag_ctx *codetag_next_ctx(struct codetag_iterator *iter);
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 08c97a978906..2790848464f1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -977,6 +977,7 @@ config ALLOC_TAGGING
 	bool
 	select CODE_TAGGING
 	select LAZY_PERCPU_COUNTER
+	select STACKDEPOT
 
 config PAGE_ALLOC_TAGGING
 	bool "Enable page allocation tagging"
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 082fbde184ef..50d7bdc2a3c8 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -1,12 +1,75 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/alloc_tag.h>
+#include <linux/codetag_ctx.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/seq_buf.h>
+#include <linux/stackdepot.h>
 #include <linux/uaccess.h>
 
+#define STACK_BUF_SIZE 1024
+
+struct alloc_call_ctx {
+	struct codetag_ctx ctx;
+	size_t size;
+	pid_t pid;
+	pid_t tgid;
+	char comm[TASK_COMM_LEN];
+	u64 ts_nsec;
+	depot_stack_handle_t stack_handle;
+} __aligned(8);
+
+static void alloc_tag_ops_free_ctx(struct kref *refcount)
+{
+	kfree(container_of(kref_to_ctx(refcount), struct alloc_call_ctx, ctx));
+}
+
+struct codetag_ctx *alloc_tag_create_ctx(struct alloc_tag *tag, size_t size)
+{
+	struct alloc_call_ctx *ac_ctx;
+
+	/* TODO: use a dedicated kmem_cache */
+	ac_ctx = kmalloc(sizeof(struct alloc_call_ctx), GFP_KERNEL);
+	if (WARN_ON(!ac_ctx))
+		return NULL;
+
+	ac_ctx->size = size;
+	ac_ctx->pid = current->pid;
+	ac_ctx->tgid = current->tgid;
+	strscpy(ac_ctx->comm, current->comm, sizeof(ac_ctx->comm));
+	ac_ctx->ts_nsec = local_clock();
+	ac_ctx->stack_handle =
+			stack_depot_capture_stack(GFP_NOWAIT | __GFP_NOWARN);
+	add_ctx(&ac_ctx->ctx, &tag->ctc);
+
+	return &ac_ctx->ctx;
+}
+EXPORT_SYMBOL_GPL(alloc_tag_create_ctx);
+
+void alloc_tag_free_ctx(struct codetag_ctx *ctx, struct alloc_tag **ptag)
+{
+	*ptag = ctc_to_alloc_tag(ctx->ctc);
+	rem_ctx(ctx, alloc_tag_ops_free_ctx);
+}
+EXPORT_SYMBOL_GPL(alloc_tag_free_ctx);
+
+bool alloc_tag_enable_ctx(struct alloc_tag *tag, bool enable)
+{
+	static bool stack_depot_ready;
+
+	if (enable && !stack_depot_ready) {
+		stack_depot_init();
+		stack_depot_capture_init();
+		stack_depot_ready = true;
+	}
+
+	return codetag_enable_ctx(&tag->ctc, enable);
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 struct alloc_tag_file_iterator {
@@ -50,7 +113,7 @@ static int alloc_tag_file_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	codetag_lock_module_list(cttype, true);
-	iter->ct_iter = codetag_get_ct_iter(cttype);
+	codetag_init_iter(&iter->ct_iter, cttype);
 	codetag_lock_module_list(cttype, false);
 	seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
 	file->private_data = iter;
@@ -111,14 +174,182 @@ static const struct file_operations alloc_tag_file_ops = {
 	.read	= alloc_tag_file_read,
 };
 
+static void alloc_tag_ctx_to_text(struct seq_buf *out, struct codetag_ctx *ctx)
+{
+	struct alloc_call_ctx *ac_ctx;
+	char *buf;
+
+	ac_ctx = container_of(ctx, struct alloc_call_ctx, ctx);
+	seq_buf_printf(out, "    size: %zu\n", ac_ctx->size);
+	seq_buf_printf(out, "    pid: %d\n", ac_ctx->pid);
+	seq_buf_printf(out, "    tgid: %d\n", ac_ctx->tgid);
+	seq_buf_printf(out, "    comm: %s\n", ac_ctx->comm);
+	seq_buf_printf(out, "    ts: %llu\n", ac_ctx->ts_nsec);
+
+	buf = kmalloc(STACK_BUF_SIZE, GFP_KERNEL);
+	if (buf) {
+		int bytes_read = stack_depot_snprint(ac_ctx->stack_handle, buf,
+						     STACK_BUF_SIZE - 1, 8);
+		buf[bytes_read] = '\0';
+		seq_buf_printf(out, "    call stack:\n%s\n", buf);
+	}
+	kfree(buf);
+}
+
+static ssize_t alloc_tag_ctx_file_read(struct file *file, char __user *ubuf,
+				       size_t size, loff_t *ppos)
+{
+	struct alloc_tag_file_iterator *iter = file->private_data;
+	struct codetag_iterator *ct_iter = &iter->ct_iter;
+	struct user_buf	buf = { .buf = ubuf, .size = size };
+	struct codetag_ctx *ctx;
+	struct codetag *prev_ct;
+	int err = 0;
+
+	codetag_lock_module_list(ct_iter->cttype, true);
+	while (1) {
+		err = flush_ubuf(&buf, &iter->buf);
+		if (err || !buf.size)
+			break;
+
+		prev_ct = ct_iter->ct;
+		ctx = codetag_next_ctx(ct_iter);
+		if (!ctx)
+			break;
+
+		if (prev_ct != &ctx->ctc->ct)
+			alloc_tag_to_text(&iter->buf, &ctx->ctc->ct);
+		alloc_tag_ctx_to_text(&iter->buf, ctx);
+	}
+	codetag_lock_module_list(ct_iter->cttype, false);
+
+	return err ? : buf.ret;
+}
+
+#define CTX_CAPTURE_TOKENS()	\
+	x(disable,	0)	\
+	x(enable,	0)
+
+static const char * const ctx_capture_token_strs[] = {
+#define x(name, nr_args)	#name,
+	CTX_CAPTURE_TOKENS()
+#undef x
+	NULL
+};
+
+enum ctx_capture_token {
+#define x(name, nr_args)	TOK_##name,
+	CTX_CAPTURE_TOKENS()
+#undef x
+};
+
+static int enable_ctx_capture(struct codetag_type *cttype,
+			      struct codetag_query *query, bool enable)
+{
+	struct codetag_iterator ct_iter;
+	struct codetag_with_ctx *ctc;
+	struct codetag *ct;
+	unsigned int nfound = 0;
+
+	codetag_lock_module_list(cttype, true);
+
+	codetag_init_iter(&ct_iter, cttype);
+	while ((ct = codetag_next_ct(&ct_iter))) {
+		if (!codetag_matches_query(query, ct, ct_iter.cmod, NULL))
+			continue;
+
+		ctc = ct_to_ctc(ct);
+		if (codetag_ctx_enabled(ctc) == enable)
+			continue;
+
+		if (!alloc_tag_enable_ctx(ctc_to_alloc_tag(ctc), enable)) {
+			pr_warn("Failed to toggle context capture\n");
+			continue;
+		}
+
+		nfound++;
+	}
+
+	codetag_lock_module_list(cttype, false);
+
+	return nfound ? 0 : -ENOENT;
+}
+
+static int parse_command(struct codetag_type *cttype, char *buf)
+{
+	struct codetag_query query = { NULL };
+	char *cmd;
+	int ret;
+	int tok;
+
+	buf = codetag_query_parse(&query, buf);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	cmd = strsep_no_empty(&buf, " \t\r\n");
+	if (!cmd)
+		return -EINVAL;	/* no command */
+
+	tok = match_string(ctx_capture_token_strs,
+			   ARRAY_SIZE(ctx_capture_token_strs), cmd);
+	if (tok < 0)
+		return -EINVAL;	/* unknown command */
+
+	ret = enable_ctx_capture(cttype, &query, tok == TOK_enable);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static ssize_t alloc_tag_ctx_file_write(struct file *file, const char __user *ubuf,
+					size_t len, loff_t *offp)
+{
+	struct alloc_tag_file_iterator *iter = file->private_data;
+	char tmpbuf[256];
+
+	if (len == 0)
+		return 0;
+	/* we don't check *offp -- multiple writes() are allowed */
+	if (len > sizeof(tmpbuf) - 1)
+		return -E2BIG;
+
+	if (copy_from_user(tmpbuf, ubuf, len))
+		return -EFAULT;
+
+	tmpbuf[len] = '\0';
+	parse_command(iter->ct_iter.cttype, tmpbuf);
+
+	*offp += len;
+	return len;
+}
+
+static const struct file_operations alloc_tag_ctx_file_ops = {
+	.owner	= THIS_MODULE,
+	.open	= alloc_tag_file_open,
+	.release = alloc_tag_file_release,
+	.read	= alloc_tag_ctx_file_read,
+	.write	= alloc_tag_ctx_file_write,
+};
+
 static int dbgfs_init(struct codetag_type *cttype)
 {
 	struct dentry *file;
+	struct dentry *ctx_file;
 
 	file = debugfs_create_file("alloc_tags", 0444, NULL, cttype,
 				   &alloc_tag_file_ops);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ctx_file = debugfs_create_file("alloc_tags.ctx", 0666, NULL, cttype,
+				       &alloc_tag_ctx_file_ops);
+	if (IS_ERR(ctx_file)) {
+		debugfs_remove(file);
+		return PTR_ERR(ctx_file);
+	}
 
-	return IS_ERR(file) ? PTR_ERR(file) : 0;
+	return 0;
 }
 
 #else /* CONFIG_DEBUG_FS */
@@ -129,9 +360,10 @@ static int dbgfs_init(struct codetag_type *) { return 0; }
 
 static void alloc_tag_module_unload(struct codetag_type *cttype, struct codetag_module *cmod)
 {
-	struct codetag_iterator iter = codetag_get_ct_iter(cttype);
+	struct codetag_iterator iter;
 	struct codetag *ct;
 
+	codetag_init_iter(&iter, cttype);
 	for (ct = codetag_next_ct(&iter); ct; ct = codetag_next_ct(&iter)) {
 		struct alloc_tag *tag = ct_to_alloc_tag(ct);
 
@@ -147,6 +379,7 @@ static int __init alloc_tag_init(void)
 		.section	= "alloc_tags",
 		.tag_size	= sizeof(struct alloc_tag),
 		.module_unload	= alloc_tag_module_unload,
+		.free_ctx	= alloc_tag_ops_free_ctx,
 	};
 
 	cttype = codetag_register_type(&desc);
diff --git a/lib/codetag.c b/lib/codetag.c
index 2762fda5c016..a936d2988c96 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -26,16 +26,14 @@ void codetag_lock_module_list(struct codetag_type *cttype, bool lock)
 		up_read(&cttype->mod_lock);
 }
 
-struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
+void codetag_init_iter(struct codetag_iterator *iter,
+		       struct codetag_type *cttype)
 {
-	struct codetag_iterator iter = {
-		.cttype = cttype,
-		.cmod = NULL,
-		.mod_id = 0,
-		.ct = NULL,
-	};
-
-	return iter;
+	iter->cttype = cttype;
+	iter->cmod = NULL;
+	iter->mod_id = 0;
+	iter->ct = NULL;
+	iter->ctx = NULL;
 }
 
 static inline struct codetag *get_first_module_ct(struct codetag_module *cmod)
@@ -127,6 +125,10 @@ struct codetag_ctx *codetag_next_ctx(struct codetag_iterator *iter)
 
 	lockdep_assert_held(&iter->cttype->mod_lock);
 
+	/* Move to the first codetag if search just started */
+	if (!iter->ct)
+		codetag_next_ct(iter);
+
 	if (!ctx)
 		return next_ctx_from_ct(iter);
 
-- 
2.37.2.672.g94769d06f0-goog

