Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA154E142
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 14:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiFPM6r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 08:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbiFPM6q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 08:58:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03B3C4B4
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g7so2090757eda.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TypfCrGXvCH86H9k4RtvB6h6H3NN9UXiatL6xH054BU=;
        b=pOMuCNyCzkVmcUxdGSXzNKV3w/mIranrX1s3n9y/jM3tK+me+SsxUHGSFVZPT4quVu
         Z53ShERk4z7yr7PquOZQqHgZLhlS2pYVAVh/QUswJkoKd2HdNFzarC8nZXWG9j787P4y
         cXtd3kGTnXVpS6LZYs5IsE/OA2OlP/QoVPqkscGi+74wdkfBlwM6TZF/+MPV8iqWTP6u
         2brjvQ3DCDZ/OWXq4ztqOTp/1GVtZYA55rpTJvxWIAWAYCdK8s6Etq/FyIiPsthoHQ2M
         PWCTth9PfYKI/HN0nVeNLcDeUxHJ7Y0vpJdO+RwinhwmLDX2QuhrJk1yWMumKVtpy2I+
         LotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TypfCrGXvCH86H9k4RtvB6h6H3NN9UXiatL6xH054BU=;
        b=Ab7rE4NySxy7dWP8SswSNgQR4jd6Wq1Pi2xp/RhJ3WnBvtRdqcGZvKYPtNws5O9ai3
         iBVAMJte9UyQ1JAli9ghAUrHPtPqSX78glrq2DysAdi2A3OSn4pvwJqwNSn/qLXdEfDM
         RtfJxNEMqBGn56d9xsfnia2pgV1ZOdgGC5ny3JC6rkh+uofKUDIrc6pUMIUm+FOCnlAo
         vSXLOvntDsoiLsLaZTUK+c2eke0yN7MTFyLLclNmem8lXVqqieK9wBof54HpPMcX1stX
         HFwuOL94LWYfYJ/UZLS39n27D9Nudar/C5UtHygaWpqJZLftdUvftR42+5TlNVUyIron
         nfhA==
X-Gm-Message-State: AJIora/aKYV3eZaeMirkJ+R6JN3x0OlZjyQsi+F5mfKTFnLlGBiDjNlr
        Lb2EP9ES/lwHozAF4D4qYBzw7rWELLxY6Q==
X-Google-Smtp-Source: AGRyM1tSHpO0zOnnNknLi9AHuXjdfhx1irIOYcrsyJ6n+0PF6K//sn1gSF0SnNoaShXTRZX0bgtEjw==
X-Received: by 2002:a05:6402:f97:b0:431:8d1d:397d with SMTP id eh23-20020a0564020f9700b004318d1d397dmr6342344edb.423.1655384322927;
        Thu, 16 Jun 2022 05:58:42 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:139d])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00711d5baae0esm746896ejg.145.2022.06.16.05.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:58:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/3] io_uring: make io_uring_types.h public
Date:   Thu, 16 Jun 2022 13:57:19 +0100
Message-Id: <a15f12e8cb7289b2de0deaddcc7518d98a132d17.1655384063.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655384063.git.asml.silence@gmail.com>
References: <cover.1655384063.git.asml.silence@gmail.com>
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

Move io_uring types to linux/include, need them public so tracing can
see the definitions and we can clean trace/events/io_uring.h

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 {io_uring => include/linux}/io_uring_types.h | 28 ++++++++++++++++++--
 io_uring/filetable.h                         | 11 --------
 io_uring/io-wq.h                             | 17 +-----------
 io_uring/io_uring.h                          |  4 ++-
 io_uring/refs.h                              |  2 +-
 5 files changed, 31 insertions(+), 31 deletions(-)
 rename {io_uring => include/linux}/io_uring_types.h (96%)

diff --git a/io_uring/io_uring_types.h b/include/linux/io_uring_types.h
similarity index 96%
rename from io_uring/io_uring_types.h
rename to include/linux/io_uring_types.h
index 65ac7cdaaa73..779c72da5b8f 100644
--- a/io_uring/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -6,8 +6,32 @@
 #include <linux/bitmap.h>
 #include <uapi/linux/io_uring.h>
 
-#include "io-wq.h"
-#include "filetable.h"
+struct io_wq_work_node {
+	struct io_wq_work_node *next;
+};
+
+struct io_wq_work_list {
+	struct io_wq_work_node *first;
+	struct io_wq_work_node *last;
+};
+
+struct io_wq_work {
+	struct io_wq_work_node list;
+	unsigned flags;
+	/* place it here instead of io_kiocb as it fills padding and saves 4B */
+	int cancel_seq;
+};
+
+struct io_fixed_file {
+	/* file * with additional FFS_* flags */
+	unsigned long file_ptr;
+};
+
+struct io_file_table {
+	struct io_fixed_file *files;
+	unsigned long *bitmap;
+	unsigned int alloc_hint;
+};
 
 struct io_hash_bucket {
 	spinlock_t		lock;
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index c404360f7090..6b58aa48bc45 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -22,17 +22,6 @@ struct io_kiocb;
 #endif
 #define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG|FFS_SCM)
 
-struct io_fixed_file {
-	/* file * with additional FFS_* flags */
-	unsigned long file_ptr;
-};
-
-struct io_file_table {
-	struct io_fixed_file *files;
-	unsigned long *bitmap;
-	unsigned int alloc_hint;
-};
-
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
 void io_free_file_tables(struct io_file_table *table);
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 3f54ee2a8eeb..10b80ef78bb8 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -2,6 +2,7 @@
 #define INTERNAL_IO_WQ_H
 
 #include <linux/refcount.h>
+#include <linux/io_uring_types.h>
 
 struct io_wq;
 
@@ -20,15 +21,6 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-struct io_wq_work_node {
-	struct io_wq_work_node *next;
-};
-
-struct io_wq_work_list {
-	struct io_wq_work_node *first;
-	struct io_wq_work_node *last;
-};
-
 #define wq_list_for_each(pos, prv, head)			\
 	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
 
@@ -152,13 +144,6 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 	return node;
 }
 
-struct io_wq_work {
-	struct io_wq_work_node list;
-	unsigned flags;
-	/* place it here instead of io_kiocb as it fills padding and saves 4B */
-	int cancel_seq;
-};
-
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 {
 	if (!work->list.next)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3f6cad3d356c..16e46b09253a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,7 +3,9 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
-#include "io_uring_types.h"
+#include <linux/io_uring_types.h>
+#include "io-wq.h"
+#include "filetable.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 334c5ead4c43..1336de3f2a30 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -2,7 +2,7 @@
 #define IOU_REQ_REF_H
 
 #include <linux/atomic.h>
-#include "io_uring_types.h"
+#include <linux/io_uring_types.h>
 
 /*
  * Shamelessly stolen from the mm implementation of page reference checking,
-- 
2.36.1

