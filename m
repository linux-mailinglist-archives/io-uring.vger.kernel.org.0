Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7F417CAB
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346807AbhIXVCf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346567AbhIXVC3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:29 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB73C06161E
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v24so40889499eda.3
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qQN2AsTca+viyJstnviKptlGMMwna2ELNMJmPMjmn7w=;
        b=Hj2KNHl6ABdg7Cyqs2qRvMrPV4pYEF2YAywYy4naGUwfMHLTBt0EFs1HcZrNhIkYGB
         ra7Lz0fqGMGx4oXPysrG6i0Gx3IrVARzhf7Vy1OgN1xTWyBdSaPZs6H7Gw4aeoU0VxcN
         HzzlQ9cwqgqe/Zq40900fNv43KCOYMgkIdqji3IrPHhqou62UIH1/jPgG68wX3F8/Fkp
         C7S5c2xUwB9WYiEw3/AF6qURXCdCHtlTLrLDyTvXiwFCZRaGu6Z3AIDL9+zamxiKMH5c
         l/p7oWTmrx/pm2PTFJD/7j6lIMNWDrAX9A0FbPAhPyAafbJFefY0txzguy02LxV37Fz3
         CEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQN2AsTca+viyJstnviKptlGMMwna2ELNMJmPMjmn7w=;
        b=HpIjYbib4PN9mraJqsONOdM792LPQao7u1qpzbsL8HWUKKx+KEzRIJsjYcNxlX1mS2
         ZVkjN6jwXi0pfSDVYkcZlSJ6BpqB9pMk4DXpvWACz0Hj8e+xsWuiBQUwN9cGFUoqYdB2
         H3F9IY3eRoa2oH7PEtcD9Zzg/Cxzt4bhf8WjLjW7JZ+K24pafaTXCkiy5huhurZOx/lH
         Ggr+z8tTHqhaHAWpC5mtvCRVodjcdHJ4fqn/AlYqIQAFP0quH6WuYhZxRFWi+KAOed5l
         +m5to1JXM/p3fYj+dzgUK7o527PQHVT4TcxK+6Q7PubUArsbjYkENsCdyxNAFOVVCOfK
         Qa8w==
X-Gm-Message-State: AOAM530bWZx0k5shNKHuxEn1dTqcoAP8/nBHRWS9ZisBtZTk1rpdryz9
        X6G1IbUJvIdxguE1uGoHIO4jrXH1m84=
X-Google-Smtp-Source: ABdhPJwuB5nPRru9rDpsWrNOFIA3TG8S95kiZ5q2B8H+gfRsZ3qIkPGncS++SwBV1eR9d4LhARg3ag==
X-Received: by 2002:a17:906:af1a:: with SMTP id lx26mr2814290ejb.563.1632517254826;
        Fri, 24 Sep 2021 14:00:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 06/24] io-wq: add io_wq_work_node based stack
Date:   Fri, 24 Sep 2021 21:59:46 +0100
Message-Id: <5d3a412a5ac0d47e0f0499d70d2207d70a68925e.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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

