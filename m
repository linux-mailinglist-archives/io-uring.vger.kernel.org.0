Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA02D552DFD
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbiFUJKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243660AbiFUJKa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:10:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408845F52
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ej4so14504626edb.7
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtTg6iGZVEhWH68/9yKl+yPJ6KtmwrlmlNcZKKIBE1w=;
        b=gQxi6ACNekvI/usm4JShsCXJbR+pBM28BTmL3plG4hphY4Bi+gfF2qLCdfpCcHs5tH
         RhXpjEl2RnKqCIPeyhhbF1r4t8Bvq+FF/Wxroav0QxPKrf/TWVBjhyaxmg0CIDURyJuq
         ZT7ui+AJYtSFRlbqWAWdbfbhvKPHWPlno6gDRd36dqAgCoLcc017nxXA+9w4kNMcussB
         1JATOZjzJvSbXk5+OLSFa5SP4CMLl/x0TshS3Wp5dsQDRznE4/bt7CEI/39kn07YxEcu
         SKUtJTUkxpSbcYUWk45XzztjJUXZpQsMQcZ6DV24GYTTkF2nzhzPHtdjsIcCKHPQJ/0+
         Dcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtTg6iGZVEhWH68/9yKl+yPJ6KtmwrlmlNcZKKIBE1w=;
        b=3P3U3Tcto50IvklFW6eAOtjMkE9WH6dXkfOwoOvP3wIgUiH6fFASRH5rITO433zam7
         rt4qTXLAyMvx3Q2cToNyRfiFeZ3cVWnUw0hyp1C06psJjP//0w4iqK1VBglidNQpKtUd
         LAhGdKjOpuIAMq47cqc7FX+Fs12xYhjAaCNN7jGzPEoRFNqeY1VQulcaXople80NT1Dr
         9DLv/f/X+x/lDo/mjrbowhNr+kXy2bmXOgwJdjEVu1OZHgHGpGjI47540zkOoE5SHvqr
         f+j8LEWUbWYeZlaDtO2e7yvMxMbDsd/LgitFbNw1g3KOKhT5YbVarL1ZFA7LA5zzqvU4
         Y1Dw==
X-Gm-Message-State: AJIora/aHa0oT0V90OuyyEqHUOZ6Qgsgc+Vs2HRYRvyH1yyY0BuKYBRi
        ZjO8l7XQdsEAiAQZfOE2byxkIDloSNp4aw==
X-Google-Smtp-Source: AGRyM1t/mFVhuH0uW0nvwmNUCu5+1T/R9aTvCCY6pBi7PQ6eKfJnCBH32tUPiZ9UdXN/J5j+H+OXHQ==
X-Received: by 2002:a05:6402:1c09:b0:435:6562:e70d with SMTP id ck9-20020a0564021c0900b004356562e70dmr23870340edb.203.1655802627479;
        Tue, 21 Jun 2022 02:10:27 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:d61a])
        by smtp.gmail.com with ESMTPSA id cq18-20020a056402221200b00435651c4a01sm9194420edb.56.2022.06.21.02.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:10:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/4] io_uring: move list helpers to a separate file
Date:   Tue, 21 Jun 2022 10:09:01 +0100
Message-Id: <c1d891ce12b30767d1d2a3b7db2ca3abc1ecc4a2.1655802465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655802465.git.asml.silence@gmail.com>
References: <cover.1655802465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's annoying to have io-wq.h as a dependency every time we want some of
struct io_wq_work_list helpers, move them into a separate file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.c    |   1 +
 io_uring/io-wq.h    | 131 -----------------------------------------
 io_uring/io_uring.h |   1 +
 io_uring/slist.h    | 138 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 131 deletions(-)
 create mode 100644 io_uring/slist.h

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 824623bcf1a5..3e34dfbdf946 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -18,6 +18,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
+#include "slist.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 10b80ef78bb8..31228426d192 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -21,137 +21,6 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-#define wq_list_for_each(pos, prv, head)			\
-	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
-
-#define wq_list_for_each_resume(pos, prv)			\
-	for (; pos; prv = pos, pos = (pos)->next)
-
-#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
-#define INIT_WQ_LIST(list)	do {				\
-	(list)->first = NULL;					\
-} while (0)
-
-static inline void wq_list_add_after(struct io_wq_work_node *node,
-				     struct io_wq_work_node *pos,
-				     struct io_wq_work_list *list)
-{
-	struct io_wq_work_node *next = pos->next;
-
-	pos->next = node;
-	node->next = next;
-	if (!next)
-		list->last = node;
-}
-
-/**
- * wq_list_merge - merge the second list to the first one.
- * @list0: the first list
- * @list1: the second list
- * Return the first node after mergence.
- */
-static inline struct io_wq_work_node *wq_list_merge(struct io_wq_work_list *list0,
-						    struct io_wq_work_list *list1)
-{
-	struct io_wq_work_node *ret;
-
-	if (!list0->first) {
-		ret = list1->first;
-	} else {
-		ret = list0->first;
-		list0->last->next = list1->first;
-	}
-	INIT_WQ_LIST(list0);
-	INIT_WQ_LIST(list1);
-	return ret;
-}
-
-static inline void wq_list_add_tail(struct io_wq_work_node *node,
-				    struct io_wq_work_list *list)
-{
-	node->next = NULL;
-	if (!list->first) {
-		list->last = node;
-		WRITE_ONCE(list->first, node);
-	} else {
-		list->last->next = node;
-		list->last = node;
-	}
-}
-
-static inline void wq_list_add_head(struct io_wq_work_node *node,
-				    struct io_wq_work_list *list)
-{
-	node->next = list->first;
-	if (!node->next)
-		list->last = node;
-	WRITE_ONCE(list->first, node);
-}
-
-static inline void wq_list_cut(struct io_wq_work_list *list,
-			       struct io_wq_work_node *last,
-			       struct io_wq_work_node *prev)
-{
-	/* first in the list, if prev==NULL */
-	if (!prev)
-		WRITE_ONCE(list->first, last->next);
-	else
-		prev->next = last->next;
-
-	if (last == list->last)
-		list->last = prev;
-	last->next = NULL;
-}
-
-static inline void __wq_list_splice(struct io_wq_work_list *list,
-				    struct io_wq_work_node *to)
-{
-	list->last->next = to->next;
-	to->next = list->first;
-	INIT_WQ_LIST(list);
-}
-
-static inline bool wq_list_splice(struct io_wq_work_list *list,
-				  struct io_wq_work_node *to)
-{
-	if (!wq_list_empty(list)) {
-		__wq_list_splice(list, to);
-		return true;
-	}
-	return false;
-}
-
-static inline void wq_stack_add_head(struct io_wq_work_node *node,
-				     struct io_wq_work_node *stack)
-{
-	node->next = stack->next;
-	stack->next = node;
-}
-
-static inline void wq_list_del(struct io_wq_work_list *list,
-			       struct io_wq_work_node *node,
-			       struct io_wq_work_node *prev)
-{
-	wq_list_cut(list, node, prev);
-}
-
-static inline
-struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
-{
-	struct io_wq_work_node *node = stack->next;
-
-	stack->next = node->next;
-	return node;
-}
-
-static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
-{
-	if (!work->list.next)
-		return NULL;
-
-	return container_of(work->list.next, struct io_wq_work, list);
-}
-
 typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
 typedef void (io_wq_work_fn)(struct io_wq_work *);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4c4d38ffc5ec..f026d2670959 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/io_uring_types.h>
 #include "io-wq.h"
+#include "slist.h"
 #include "filetable.h"
 
 #ifndef CREATE_TRACE_POINTS
diff --git a/io_uring/slist.h b/io_uring/slist.h
new file mode 100644
index 000000000000..f27601fa4660
--- /dev/null
+++ b/io_uring/slist.h
@@ -0,0 +1,138 @@
+#ifndef INTERNAL_IO_SLIST_H
+#define INTERNAL_IO_SLIST_H
+
+#include <linux/io_uring_types.h>
+
+#define wq_list_for_each(pos, prv, head)			\
+	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
+
+#define wq_list_for_each_resume(pos, prv)			\
+	for (; pos; prv = pos, pos = (pos)->next)
+
+#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
+
+#define INIT_WQ_LIST(list)	do {				\
+	(list)->first = NULL;					\
+} while (0)
+
+static inline void wq_list_add_after(struct io_wq_work_node *node,
+				     struct io_wq_work_node *pos,
+				     struct io_wq_work_list *list)
+{
+	struct io_wq_work_node *next = pos->next;
+
+	pos->next = node;
+	node->next = next;
+	if (!next)
+		list->last = node;
+}
+
+/**
+ * wq_list_merge - merge the second list to the first one.
+ * @list0: the first list
+ * @list1: the second list
+ * Return the first node after mergence.
+ */
+static inline struct io_wq_work_node *wq_list_merge(struct io_wq_work_list *list0,
+						    struct io_wq_work_list *list1)
+{
+	struct io_wq_work_node *ret;
+
+	if (!list0->first) {
+		ret = list1->first;
+	} else {
+		ret = list0->first;
+		list0->last->next = list1->first;
+	}
+	INIT_WQ_LIST(list0);
+	INIT_WQ_LIST(list1);
+	return ret;
+}
+
+static inline void wq_list_add_tail(struct io_wq_work_node *node,
+				    struct io_wq_work_list *list)
+{
+	node->next = NULL;
+	if (!list->first) {
+		list->last = node;
+		WRITE_ONCE(list->first, node);
+	} else {
+		list->last->next = node;
+		list->last = node;
+	}
+}
+
+static inline void wq_list_add_head(struct io_wq_work_node *node,
+				    struct io_wq_work_list *list)
+{
+	node->next = list->first;
+	if (!node->next)
+		list->last = node;
+	WRITE_ONCE(list->first, node);
+}
+
+static inline void wq_list_cut(struct io_wq_work_list *list,
+			       struct io_wq_work_node *last,
+			       struct io_wq_work_node *prev)
+{
+	/* first in the list, if prev==NULL */
+	if (!prev)
+		WRITE_ONCE(list->first, last->next);
+	else
+		prev->next = last->next;
+
+	if (last == list->last)
+		list->last = prev;
+	last->next = NULL;
+}
+
+static inline void __wq_list_splice(struct io_wq_work_list *list,
+				    struct io_wq_work_node *to)
+{
+	list->last->next = to->next;
+	to->next = list->first;
+	INIT_WQ_LIST(list);
+}
+
+static inline bool wq_list_splice(struct io_wq_work_list *list,
+				  struct io_wq_work_node *to)
+{
+	if (!wq_list_empty(list)) {
+		__wq_list_splice(list, to);
+		return true;
+	}
+	return false;
+}
+
+static inline void wq_stack_add_head(struct io_wq_work_node *node,
+				     struct io_wq_work_node *stack)
+{
+	node->next = stack->next;
+	stack->next = node;
+}
+
+static inline void wq_list_del(struct io_wq_work_list *list,
+			       struct io_wq_work_node *node,
+			       struct io_wq_work_node *prev)
+{
+	wq_list_cut(list, node, prev);
+}
+
+static inline
+struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
+{
+	struct io_wq_work_node *node = stack->next;
+
+	stack->next = node->next;
+	return node;
+}
+
+static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
+{
+	if (!work->list.next)
+		return NULL;
+
+	return container_of(work->list.next, struct io_wq_work, list);
+}
+
+#endif // INTERNAL_IO_SLIST_H
\ No newline at end of file
-- 
2.36.1

