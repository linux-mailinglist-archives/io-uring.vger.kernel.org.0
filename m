Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F134178E1
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343567AbhIXQiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347447AbhIXQh3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86358C0613AC
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y89so27464187ede.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qQN2AsTca+viyJstnviKptlGMMwna2ELNMJmPMjmn7w=;
        b=TAM6IdvxX6LvNH0sLDh8hc5vYM/gIApWXgyryg4s0FJWZ3xpLinSj2MHv94QA3hhFo
         kYb9m1kVj/CUvO7RdPhW8AYm7HQxIC4oOP2QqIqweGllAc29ERDDpS/VdvYWpFFsJD+L
         AO80kZ3vgDBjZYHV3X4WjStUr6BM9c7qYs8hXv5y/bmSOlrsoiGa5Cl4zG20eHCQBaKE
         fUJYKqTy55kCJyqOjoNWk5r1prJgYXBq1fjaI32j2VinkYz0XyQUZg9AlIirydL5oCUJ
         SKeYxMFN/oDxCYCKrPgD3ktnPjuzQnsDAg5m8PHLyZO4NIvI5k5Nlbb9Usa3KGLPQmzT
         r4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQN2AsTca+viyJstnviKptlGMMwna2ELNMJmPMjmn7w=;
        b=rjCowNDpoK8EpVaoMRl1QE9wxdGRoa6JA3vLU6IeTcQVg60NpfzzMM80jgrZkJWgk/
         L5UbI4Bw8oXrbnWgPa9d10vENZvvPxL75fFBVoqYW248iQS9g99plgnlc9XbzThUPsaa
         EIFdSKfFkpxcjiDenEvLm7MaP711XPuB2ggMJ5alZ3KalCLImRHGM0yITS3k25ajWjv+
         X6gtAoUuQ5HC8QdyCtmmOCSYwvsn8mCgfo6HO0D+tK0W8UWH3DJJqYfToxPgrERDtpka
         tpmBls5i3FzNqy2Bq55UQICkOVYcAOr84td22jU9ebV6kdPyDBh3mTSn+JWaHhc6WH9s
         jE3g==
X-Gm-Message-State: AOAM532k6HTb536ZvA1t/L93cgqolS2Tzp4jk/6p0NEt/Owbjdtoh2/c
        Tap1aFlLLBA1lXIWhBcc2+A=
X-Google-Smtp-Source: ABdhPJwWT/Uve+5MNsegix8J+WWsEx1cguTlRII1frQ0blhgZ64xNHXYeEoLMGhB7xaFu/SHSU1NrQ==
X-Received: by 2002:a17:907:2658:: with SMTP id ar24mr12556440ejc.329.1632501172111;
        Fri, 24 Sep 2021 09:32:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/23] io-wq: add io_wq_work_node based stack
Date:   Fri, 24 Sep 2021 17:31:44 +0100
Message-Id: <3d53833b5efcde645bfc33aa488651dd6d0d17eb.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apart from just using lists (i.e. io_wq_work_list), we also want to have
stacks, which are a bit faster, and have some interoperability between
them. Add a stack implementation based on io_wq_work_node and some
helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h | 57 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index bf5c4c533760..c870062105d1 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -29,6 +29,15 @@ struct io_wq_work_list {
 	struct io_wq_work_node *last;
 };
 
+#define wq_list_for_each(pos, prv, head)			\
+	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
+
+#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
+#define INIT_WQ_LIST(list)	do {				\
+	(list)->first = NULL;					\
+	(list)->last = NULL;					\
+} while (0)
+
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
@@ -54,6 +63,15 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 	}
 }
 
+static inline void wq_list_add_head(struct io_wq_work_node *node,
+				    struct io_wq_work_list *list)
+{
+	node->next = list->first;
+	if (!node->next)
+		list->last = node;
+	WRITE_ONCE(list->first, node);
+}
+
 static inline void wq_list_cut(struct io_wq_work_list *list,
 			       struct io_wq_work_node *last,
 			       struct io_wq_work_node *prev)
@@ -69,6 +87,31 @@ static inline void wq_list_cut(struct io_wq_work_list *list,
 	last->next = NULL;
 }
 
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
 static inline void wq_list_del(struct io_wq_work_list *list,
 			       struct io_wq_work_node *node,
 			       struct io_wq_work_node *prev)
@@ -76,14 +119,14 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 	wq_list_cut(list, node, prev);
 }
 
-#define wq_list_for_each(pos, prv, head)			\
-	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
+static inline
+struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
+{
+	struct io_wq_work_node *node = stack->next;
 
-#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
-#define INIT_WQ_LIST(list)	do {				\
-	(list)->first = NULL;					\
-	(list)->last = NULL;					\
-} while (0)
+	stack->next = node->next;
+	return node;
+}
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-- 
2.33.0

