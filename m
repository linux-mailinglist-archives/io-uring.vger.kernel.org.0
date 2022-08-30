Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8229A5A6FB3
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiH3Vug (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiH3VuQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:50:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B3391097
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-335420c7bfeso188916837b3.16
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=v/Q5RZvHm0ms6516zJ+eaQEhTJBhgieG8iYB8LZreqU=;
        b=dSiwJ3rjpD9k+D3ejPNjLVoeg6kQsBAXkS5tHCQ4weDhFLA/IwvZ3Q8/4xxcyoMJ6e
         isFuqbINTHNxbJqZ7EEbgu9o53Xs56RjzRvuvf4eTeoYNkY9SG5lERFqePgEz5jBEIRg
         QvId775FjFECHp0OGiyatkPffLAyhQT41MfBQyoy2O41OqYeYbXsV3zL5yP1EhqhzEDG
         Ak4e/fA+4cROH7t1gmYSTnptvwHELHiW/qlFXek1xTxDu9n3XVI1sWuwSvdDGMPhmsh6
         FLJrfKaSpeVUrcOZuw1Sf/dHnHK+0uqWtXMcZsMOZh3YPgQfnsV4y3UN2W3I7st9KiwO
         9X+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=v/Q5RZvHm0ms6516zJ+eaQEhTJBhgieG8iYB8LZreqU=;
        b=f8FpcA9dpb5YJNup/k03d2+rE8p+hq9lD1fmw+2pspg6XpLMe//VgGlrwp2fF4J2Am
         y6065K4se5l04IbGkkItJ3gzbkXZlt94oVBXbobIY1ZnHgXqUpKYbmyPuNzDccD7sK3r
         haVIiQFmdZ7hB+1TQ14w5kR5PZ6Q71ja7bf16vwFIKxHVVH55aB6GrK0mJJ9BG6bmMk7
         7TQKiiVxlXoyzuFrbso2J9iCJ+wTyvjBO6syF1qAD61pW7729wJotzouT91wxLLC5kt5
         KA9tKM08TNK847jzXa6gG/nHWvC6kWX843uqdUFpqUUcjj2OkywO5/gEy5OHoCK5tMVB
         4znA==
X-Gm-Message-State: ACgBeo2nr/k8qwAkQS1B0x4lQYW4Yamr23EafA8iFb0WWMyNzruXD11P
        EpNJU9pAZYgxGTQlnWkaooUCI57OCAk=
X-Google-Smtp-Source: AA6agR5yxP3HtYw1/nnJdlitQAiJ4+t1NlijduSUdtY4FE0+dYeCh7gN+ZXU56IyxNeDRenvKE9hkSpDyvU=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:2586:0:b0:695:9529:c9a6 with SMTP id
 l128-20020a252586000000b006959529c9a6mr13158054ybl.591.1661896181976; Tue, 30
 Aug 2022 14:49:41 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:48:56 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-8-surenb@google.com>
Subject: [RFC PATCH 07/30] lib: add support for allocation tagging
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

Introduce CONFIG_ALLOC_TAGGING which provides definitions to easily
instrument allocators. It also registers an "alloc_tags" codetag type
with defbugfs interface to output allocation tags information.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/asm-generic/codetag.lds.h |  14 +++
 include/asm-generic/vmlinux.lds.h |   3 +
 include/linux/alloc_tag.h         |  66 +++++++++++++
 lib/Kconfig.debug                 |   5 +
 lib/Makefile                      |   2 +
 lib/alloc_tag.c                   | 158 ++++++++++++++++++++++++++++++
 scripts/module.lds.S              |   7 ++
 7 files changed, 255 insertions(+)
 create mode 100644 include/asm-generic/codetag.lds.h
 create mode 100644 include/linux/alloc_tag.h
 create mode 100644 lib/alloc_tag.c

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
new file mode 100644
index 000000000000..64f536b80380
--- /dev/null
+++ b/include/asm-generic/codetag.lds.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_GENERIC_CODETAG_LDS_H
+#define __ASM_GENERIC_CODETAG_LDS_H
+
+#define SECTION_WITH_BOUNDARIES(_name)	\
+	. = ALIGN(8);			\
+	__start_##_name = .;		\
+	KEEP(*(_name))			\
+	__stop_##_name = .;
+
+#define CODETAG_SECTIONS()		\
+	SECTION_WITH_BOUNDARIES(alloc_tags)
+
+#endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 7515a465ec03..c2dc2a59ab2e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -50,6 +50,8 @@
  *               [__nosave_begin, __nosave_end] for the nosave data
  */
 
+#include <asm-generic/codetag.lds.h>
+
 #ifndef LOAD_OFFSET
 #define LOAD_OFFSET 0
 #endif
@@ -348,6 +350,7 @@
 	__start___dyndbg = .;						\
 	KEEP(*(__dyndbg))						\
 	__stop___dyndbg = .;						\
+	CODETAG_SECTIONS()						\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
new file mode 100644
index 000000000000..b3f589afb1c9
--- /dev/null
+++ b/include/linux/alloc_tag.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * allocation tagging
+ */
+#ifndef _LINUX_ALLOC_TAG_H
+#define _LINUX_ALLOC_TAG_H
+
+#include <linux/bug.h>
+#include <linux/codetag.h>
+#include <linux/container_of.h>
+#include <linux/lazy-percpu-counter.h>
+
+/*
+ * An instance of this structure is created in a special ELF section at every
+ * allocation callsite. At runtime, the special section is treated as
+ * an array of these. Embedded codetag utilizes codetag framework.
+ */
+struct alloc_tag {
+	struct codetag			ct;
+	unsigned long			last_wrap;
+	struct raw_lazy_percpu_counter	call_count;
+	struct raw_lazy_percpu_counter	bytes_allocated;
+} __aligned(8);
+
+static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
+{
+	return container_of(ct, struct alloc_tag, ct);
+}
+
+#define DEFINE_ALLOC_TAG(_alloc_tag)					\
+	static struct alloc_tag _alloc_tag __used __aligned(8)		\
+	__section("alloc_tags") = { .ct = CODE_TAG_INIT }
+
+#define alloc_tag_counter_read(counter)					\
+	__lazy_percpu_counter_read(counter)
+
+static inline void __alloc_tag_sub(union codetag_ref *ref, size_t bytes)
+{
+	struct alloc_tag *tag = ct_to_alloc_tag(ref->ct);
+
+	__lazy_percpu_counter_add(&tag->call_count, &tag->last_wrap, -1);
+	__lazy_percpu_counter_add(&tag->bytes_allocated, &tag->last_wrap, -bytes);
+	ref->ct = NULL;
+}
+
+#define alloc_tag_sub(_ref, _bytes)					\
+do {									\
+	if ((_ref) && (_ref)->ct)					\
+		__alloc_tag_sub(_ref, _bytes);				\
+} while (0)
+
+static inline void __alloc_tag_add(struct alloc_tag *tag, union codetag_ref *ref, size_t bytes)
+{
+	ref->ct = &tag->ct;
+	__lazy_percpu_counter_add(&tag->call_count, &tag->last_wrap, 1);
+	__lazy_percpu_counter_add(&tag->bytes_allocated, &tag->last_wrap, bytes);
+}
+
+#define alloc_tag_add(_ref, _bytes)					\
+do {									\
+	DEFINE_ALLOC_TAG(_alloc_tag);					\
+	if (_ref && !WARN_ONCE(_ref->ct, "alloc_tag was not cleared"))	\
+		__alloc_tag_add(&_alloc_tag, _ref, _bytes);		\
+} while (0)
+
+#endif /* _LINUX_ALLOC_TAG_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 22bc1eff7f8f..795bf6993f8a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -973,6 +973,11 @@ config CODE_TAGGING
 	bool
 	select KALLSYMS
 
+config ALLOC_TAGGING
+	bool
+	select CODE_TAGGING
+	select LAZY_PERCPU_COUNTER
+
 source "lib/Kconfig.kasan"
 source "lib/Kconfig.kfence"
 
diff --git a/lib/Makefile b/lib/Makefile
index 574d7716e640..dc00533fc5c8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -228,6 +228,8 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_CODE_TAGGING) += codetag.o
+obj-$(CONFIG_ALLOC_TAGGING) += alloc_tag.o
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
new file mode 100644
index 000000000000..082fbde184ef
--- /dev/null
+++ b/lib/alloc_tag.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/alloc_tag.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/seq_buf.h>
+#include <linux/uaccess.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+struct alloc_tag_file_iterator {
+	struct codetag_iterator ct_iter;
+	struct seq_buf		buf;
+	char			rawbuf[4096];
+};
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
+static int alloc_tag_file_open(struct inode *inode, struct file *file)
+{
+	struct codetag_type *cttype = inode->i_private;
+	struct alloc_tag_file_iterator *iter;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	codetag_lock_module_list(cttype, true);
+	iter->ct_iter = codetag_get_ct_iter(cttype);
+	codetag_lock_module_list(cttype, false);
+	seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
+	file->private_data = iter;
+
+	return 0;
+}
+
+static int alloc_tag_file_release(struct inode *inode, struct file *file)
+{
+	struct alloc_tag_file_iterator *iter = file->private_data;
+
+	kfree(iter);
+	return 0;
+}
+
+static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
+{
+	struct alloc_tag *tag = ct_to_alloc_tag(ct);
+	char buf[10];
+
+	string_get_size(alloc_tag_counter_read(&tag->bytes_allocated), 1,
+			STRING_UNITS_2, buf, sizeof(buf));
+
+	seq_buf_printf(out, "%8s %8lld ", buf, alloc_tag_counter_read(&tag->call_count));
+	codetag_to_text(out, ct);
+	seq_buf_putc(out, '\n');
+}
+
+static ssize_t alloc_tag_file_read(struct file *file, char __user *ubuf,
+				   size_t size, loff_t *ppos)
+{
+	struct alloc_tag_file_iterator *iter = file->private_data;
+	struct user_buf	buf = { .buf = ubuf, .size = size };
+	struct codetag *ct;
+	int err = 0;
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
+		alloc_tag_to_text(&iter->buf, ct);
+	}
+	codetag_lock_module_list(iter->ct_iter.cttype, false);
+
+	return err ? : buf.ret;
+}
+
+static const struct file_operations alloc_tag_file_ops = {
+	.owner	= THIS_MODULE,
+	.open	= alloc_tag_file_open,
+	.release = alloc_tag_file_release,
+	.read	= alloc_tag_file_read,
+};
+
+static int dbgfs_init(struct codetag_type *cttype)
+{
+	struct dentry *file;
+
+	file = debugfs_create_file("alloc_tags", 0444, NULL, cttype,
+				   &alloc_tag_file_ops);
+
+	return IS_ERR(file) ? PTR_ERR(file) : 0;
+}
+
+#else /* CONFIG_DEBUG_FS */
+
+static int dbgfs_init(struct codetag_type *) { return 0; }
+
+#endif /* CONFIG_DEBUG_FS */
+
+static void alloc_tag_module_unload(struct codetag_type *cttype, struct codetag_module *cmod)
+{
+	struct codetag_iterator iter = codetag_get_ct_iter(cttype);
+	struct codetag *ct;
+
+	for (ct = codetag_next_ct(&iter); ct; ct = codetag_next_ct(&iter)) {
+		struct alloc_tag *tag = ct_to_alloc_tag(ct);
+
+		__lazy_percpu_counter_exit(&tag->call_count);
+		__lazy_percpu_counter_exit(&tag->bytes_allocated);
+	}
+}
+
+static int __init alloc_tag_init(void)
+{
+	struct codetag_type *cttype;
+	const struct codetag_type_desc desc = {
+		.section	= "alloc_tags",
+		.tag_size	= sizeof(struct alloc_tag),
+		.module_unload	= alloc_tag_module_unload,
+	};
+
+	cttype = codetag_register_type(&desc);
+	if (IS_ERR_OR_NULL(cttype))
+		return PTR_ERR(cttype);
+
+	return dbgfs_init(cttype);
+}
+module_init(alloc_tag_init);
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 3a3aa2354ed8..e73a8781f239 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -12,6 +12,8 @@
 # define SANITIZER_DISCARDS
 #endif
 
+#include <asm-generic/codetag.lds.h>
+
 SECTIONS {
 	/DISCARD/ : {
 		*(.discard)
@@ -47,6 +49,7 @@ SECTIONS {
 	.data : {
 		*(.data .data.[0-9a-zA-Z_]*)
 		*(.data..L*)
+		CODETAG_SECTIONS()
 	}
 
 	.rodata : {
@@ -62,6 +65,10 @@ SECTIONS {
 		*(.text.__cfi_check)
 		*(.text .text.[0-9a-zA-Z_]* .text..L.cfi*)
 	}
+#else
+	.data : {
+		CODETAG_SECTIONS()
+	}
 #endif
 }
 
-- 
2.37.2.672.g94769d06f0-goog

