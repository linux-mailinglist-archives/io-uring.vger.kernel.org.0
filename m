Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84340A480
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhINDea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbhINDe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:34:29 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAB4C061766
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:12 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id b14so10198442qtb.0
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=vMfQCt+uLiO0djmjLUrPCnseEyBZjnenjfAhu7qlx0c=;
        b=DELMydZBjcy90XHQNhrcdYJK+dNl9s7myCh4iee3FoXNQTcewYIs7pPA+h+8CLJITi
         uDDyjDuqZHtMuCUaVz+KXwCocx6X//HZta2IaG6EdZgs7vz04Hj355uWD4Alzbeuc192
         x7Bnvhh0Wj8lsR7kT0Y6soGJC1y5pfYT1z3tz07pvKbMgEvlQKQbIY1Z/jtDc0s6j6+N
         5iSyQtxwMeY+ByidHXn2mbUKyKloCKMuCt2kUyBErVjpe82Z82B8zT0dupSFu8Z9u4t3
         c6T7zSHMOZPMTAkV+2tqTctzK2uxl57jWHZzei170essgxv1D5CR9okx9a284y1ASK9q
         9t5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vMfQCt+uLiO0djmjLUrPCnseEyBZjnenjfAhu7qlx0c=;
        b=KuZJ9rlB9nghZJz50wSFmuj6rMkvo/5Xy5NSCkj0etn/Jh3LH9XgMBXJue4+8oa6yh
         ROqfV2lcxCQV16tbmj2EsWwgNGWGChf8pkYCzkeWtICbdaTQEZ6bIyD2d+PPe5qaFihm
         xLP/H/KhFYZ5Tp+E9vfhvPclro73y1AmSA2deafnGV/wA9zB5EXhHe1O5WMyx6733PwE
         ta/pO6oL+6/T/vGxNNaaxqYStbzLPyw99iRNQxZQUyzDDLN0H4LVzbmWiUi1ZgHokYt2
         VIliwFWbf12uldmFb+fwv2ICZrVPu5IDvZeYTRdhk4ZHiuPoN3nBuVkdKUNWUmnmpYzd
         1ZBg==
X-Gm-Message-State: AOAM531awxcYyw30rfgkCjUkYshRRgXE8xxdI70FIovCKcdDBj88gWBt
        Hc04JC5um/5VWOr21Pv/Azfp
X-Google-Smtp-Source: ABdhPJzHVPH6/dQ4CfMF8kWcsd/i6+k7cFmQWVNP6WoHx1hyTmgKpJ1LDwYfNyuZxdo259sPFpBGBQ==
X-Received: by 2002:a05:622a:1911:: with SMTP id w17mr2845124qtc.228.1631590391328;
        Mon, 13 Sep 2021 20:33:11 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id 21sm6682576qkk.51.2021.09.13.20.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 20:33:10 -0700 (PDT)
Subject: [PATCH v3 3/8] audit: add filtering for io_uring records
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 13 Sep 2021 23:33:10 -0400
Message-ID: <163159039025.470089.10174083902520146275.stgit@olly>
In-Reply-To: <163159032713.470089.11728103630366176255.stgit@olly>
References: <163159032713.470089.11728103630366176255.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds basic audit io_uring filtering, using as much of the
existing audit filtering infrastructure as possible.  In order to do
this we reuse the audit filter rule's syscall mask for the io_uring
operation and we create a new filter for io_uring operations as
AUDIT_FILTER_URING_EXIT/audit_filter_list[7].

Thanks to Richard Guy Briggs for his review, feedback, and work on
the corresponding audit userspace changes.

Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v3:
- removed work-in-progress warning from the description
v2:
- incorporate feedback from Richard
v1:
- initial draft
---
 include/uapi/linux/audit.h |    3 +-
 kernel/audit_tree.c        |    3 +-
 kernel/audit_watch.c       |    3 +-
 kernel/auditfilter.c       |   15 +++++++++--
 kernel/auditsc.c           |   61 ++++++++++++++++++++++++++++++++++----------
 5 files changed, 65 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index a1997697c8b1..ecf1edd2affa 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -167,8 +167,9 @@
 #define AUDIT_FILTER_EXCLUDE	0x05	/* Apply rule before record creation */
 #define AUDIT_FILTER_TYPE	AUDIT_FILTER_EXCLUDE /* obsolete misleading naming */
 #define AUDIT_FILTER_FS		0x06	/* Apply rule at __audit_inode_child */
+#define AUDIT_FILTER_URING_EXIT	0x07	/* Apply rule at io_uring op exit */
 
-#define AUDIT_NR_FILTERS	7
+#define AUDIT_NR_FILTERS	8
 
 #define AUDIT_FILTER_PREPEND	0x10	/* Prepend to front of list */
 
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 2cd7b5694422..338c53a961c5 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -726,7 +726,8 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
 {
 
 	if (pathname[0] != '/' ||
-	    rule->listnr != AUDIT_FILTER_EXIT ||
+	    (rule->listnr != AUDIT_FILTER_EXIT &&
+	     rule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    op != Audit_equal ||
 	    rule->inode_f || rule->watch || rule->tree)
 		return -EINVAL;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 2acf7ca49154..698b62b4a2ec 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -183,7 +183,8 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
 		return -EOPNOTSUPP;
 
 	if (path[0] != '/' || path[len-1] == '/' ||
-	    krule->listnr != AUDIT_FILTER_EXIT ||
+	    (krule->listnr != AUDIT_FILTER_EXIT &&
+	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    op != Audit_equal ||
 	    krule->inode_f || krule->watch || krule->tree)
 		return -EINVAL;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index db2c6b59dfc3..d75acb014ccd 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -44,7 +44,8 @@ struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
 	LIST_HEAD_INIT(audit_filter_list[4]),
 	LIST_HEAD_INIT(audit_filter_list[5]),
 	LIST_HEAD_INIT(audit_filter_list[6]),
-#if AUDIT_NR_FILTERS != 7
+	LIST_HEAD_INIT(audit_filter_list[7]),
+#if AUDIT_NR_FILTERS != 8
 #error Fix audit_filter_list initialiser
 #endif
 };
@@ -56,6 +57,7 @@ static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
 	LIST_HEAD_INIT(audit_rules_list[4]),
 	LIST_HEAD_INIT(audit_rules_list[5]),
 	LIST_HEAD_INIT(audit_rules_list[6]),
+	LIST_HEAD_INIT(audit_rules_list[7]),
 };
 
 DEFINE_MUTEX(audit_filter_mutex);
@@ -151,7 +153,8 @@ char *audit_unpack_string(void **bufp, size_t *remain, size_t len)
 static inline int audit_to_inode(struct audit_krule *krule,
 				 struct audit_field *f)
 {
-	if (krule->listnr != AUDIT_FILTER_EXIT ||
+	if ((krule->listnr != AUDIT_FILTER_EXIT &&
+	     krule->listnr != AUDIT_FILTER_URING_EXIT) ||
 	    krule->inode_f || krule->watch || krule->tree ||
 	    (f->op != Audit_equal && f->op != Audit_not_equal))
 		return -EINVAL;
@@ -248,6 +251,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *
 		pr_err("AUDIT_FILTER_ENTRY is deprecated\n");
 		goto exit_err;
 	case AUDIT_FILTER_EXIT:
+	case AUDIT_FILTER_URING_EXIT:
 	case AUDIT_FILTER_TASK:
 #endif
 	case AUDIT_FILTER_USER:
@@ -332,6 +336,10 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
 		if (entry->rule.listnr != AUDIT_FILTER_FS)
 			return -EINVAL;
 		break;
+	case AUDIT_PERM:
+		if (entry->rule.listnr == AUDIT_FILTER_URING_EXIT)
+			return -EINVAL;
+		break;
 	}
 
 	switch (entry->rule.listnr) {
@@ -980,7 +988,8 @@ static inline int audit_add_rule(struct audit_entry *entry)
 	}
 
 	entry->rule.prio = ~0ULL;
-	if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
+	if (entry->rule.listnr == AUDIT_FILTER_EXIT ||
+	    entry->rule.listnr == AUDIT_FILTER_URING_EXIT) {
 		if (entry->rule.flags & AUDIT_FILTER_PREPEND)
 			entry->rule.prio = ++prio_high;
 		else
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 62fb502da3fc..3cbcc999aff6 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -805,6 +805,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
 	return rule->mask[word] & bit;
 }
 
+/**
+ * audit_filter_uring - apply filters to an io_uring operation
+ * @tsk: associated task
+ * @ctx: audit context
+ */
+static void audit_filter_uring(struct task_struct *tsk,
+			       struct audit_context *ctx)
+{
+	struct audit_entry *e;
+	enum audit_state state;
+
+	if (auditd_test_task(tsk))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
+				list) {
+		if (audit_in_mask(&e->rule, ctx->uring_op) &&
+		    audit_filter_rules(tsk, &e->rule, ctx, NULL, &state,
+				       false)) {
+			rcu_read_unlock();
+			ctx->current_state = state;
+			return;
+		}
+	}
+	rcu_read_unlock();
+	return;
+}
+
 /* At syscall exit time, this filter is called if the audit_state is
  * not low enough that auditing cannot take place, but is also not
  * high enough that we already know we have to write an audit record
@@ -1765,7 +1794,7 @@ static void audit_log_exit(void)
  * __audit_free - free a per-task audit context
  * @tsk: task whose audit context block to free
  *
- * Called from copy_process and do_exit
+ * Called from copy_process, do_exit, and the io_uring code
  */
 void __audit_free(struct task_struct *tsk)
 {
@@ -1783,15 +1812,21 @@ void __audit_free(struct task_struct *tsk)
 	 * random task_struct that doesn't doesn't have any meaningful data we
 	 * need to log via audit_log_exit().
 	 */
-	if (tsk == current && !context->dummy &&
-	    context->context == AUDIT_CTX_SYSCALL) {
+	if (tsk == current && !context->dummy) {
 		context->return_valid = AUDITSC_INVALID;
 		context->return_code = 0;
-
-		audit_filter_syscall(tsk, context);
-		audit_filter_inodes(tsk, context);
-		if (context->current_state == AUDIT_STATE_RECORD)
-			audit_log_exit();
+		if (context->context == AUDIT_CTX_SYSCALL) {
+			audit_filter_syscall(tsk, context);
+			audit_filter_inodes(tsk, context);
+			if (context->current_state == AUDIT_STATE_RECORD)
+				audit_log_exit();
+		} else if (context->context == AUDIT_CTX_URING) {
+			/* TODO: verify this case is real and valid */
+			audit_filter_uring(tsk, context);
+			audit_filter_inodes(tsk, context);
+			if (context->current_state == AUDIT_STATE_RECORD)
+				audit_log_uring(context);
+		}
 	}
 
 	audit_set_context(tsk, NULL);
@@ -1875,12 +1910,6 @@ void __audit_uring_exit(int success, long code)
 {
 	struct audit_context *ctx = audit_context();
 
-	/*
-	 * TODO: At some point we will likely want to filter on io_uring ops
-	 *       and other things similar to what we do for syscalls, but that
-	 *       is something for another day; just record what we can here.
-	 */
-
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
 		/*
 		 * NOTE: See the note in __audit_uring_entry() about the case
@@ -1903,6 +1932,8 @@ void __audit_uring_exit(int success, long code)
 		 * the behavior here.
 		 */
 		audit_filter_syscall(current, ctx);
+		if (ctx->current_state != AUDIT_STATE_RECORD)
+			audit_filter_uring(current, ctx);
 		audit_filter_inodes(current, ctx);
 		if (ctx->current_state != AUDIT_STATE_RECORD)
 			return;
@@ -1915,6 +1946,8 @@ void __audit_uring_exit(int success, long code)
 	if (!list_empty(&ctx->killed_trees))
 		audit_kill_trees(ctx);
 
+	/* run through both filters to ensure we set the filterkey properly */
+	audit_filter_uring(current, ctx);
 	audit_filter_inodes(current, ctx);
 	if (ctx->current_state != AUDIT_STATE_RECORD)
 		goto out;

