Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F319733B1E7
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 12:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCOL6V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 07:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhCOL5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 07:57:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6266DC061574
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 04:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=va1v1vuqDKPEDIqrTVqfdNTDZN5glr3vmqbQCdLJIYc=; b=X2WNml7wxoT1GdezAEZdqGq3pz
        y+hXhZifhuf4TBpsQhE8nhxyfQS9rUPc0AABJCuodg2jXKsA5lTH4ONq82ouXtO9bdGOiA3QLajCo
        bfN7L6NBGr5CR2HelAcDNRCJuZgYBXvNXivx19JdTlnAvgDLcENaTnjxYdAXC56xdpLfRyvgllo6F
        UCWi6VaHDA8n/6MzR1wNq6PPTPX/qna9TcXDnT7R2K49BTLiycq2TZ205Hqf7XItT5Esy6cJIa9S9
        7aLhPp4s83UDs/lZ27JYjUrLZZXON7MV/CHN0I9Q1nMZwLhbZsvS94c13mOOHb5vtbLEZZOqBFX5D
        qSjU18zYGVNbsk7Qo66M3D7kmspl9Xohec6OjtzQfOpIrS9QvfR6GC7BaXzchFGwCzvAO3tIx0cU5
        7ZuGZtQ9y8RP/Z+lMfaX0zT0FQVEmmcy8WNKPP1/FiDVOsmil6OhtB4erDUcZA7gdSnMqU/J2/fc5
        3AiydegAoTALtSSKTr+jV0DV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLlr4-0002AY-Hl; Mon, 15 Mar 2021 11:57:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 1/2] io_uring: remove structures from include/linux/io_uring.h
Date:   Mon, 15 Mar 2021 12:56:56 +0100
Message-Id: <8c1d14f3748105f4caeda01716d47af2fa41d11c.1615809009.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615809009.git.metze@samba.org>
References: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org> <cover.1615809009.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

---
 fs/io-wq.h               | 10 +++++++++-
 fs/io_uring.c            | 16 ++++++++++++++++
 include/linux/io_uring.h | 25 -------------------------
 3 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 1ac2f3248088..80d590564ff9 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -2,7 +2,6 @@
 #define INTERNAL_IO_WQ_H
 
 #include <linux/refcount.h>
-#include <linux/io_uring.h>
 
 struct io_wq;
 
@@ -21,6 +20,15 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
+struct io_wq_work_node {
+	struct io_wq_work_node *next;
+};
+
+struct io_wq_work_list {
+	struct io_wq_work_node *first;
+	struct io_wq_work_node *last;
+};
+
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58d62dd9f8e4..52b5ed71d770 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -454,6 +454,22 @@ struct io_ring_ctx {
 	struct list_head		tctx_list;
 };
 
+struct io_uring_task {
+	/* submission side */
+	struct xarray		xa;
+	struct wait_queue_head	wait;
+	void			*last;
+	void			*io_wq;
+	struct percpu_counter	inflight;
+	atomic_t		in_idle;
+	bool			sqpoll;
+
+	spinlock_t		task_lock;
+	struct io_wq_work_list	task_list;
+	unsigned long		task_state;
+	struct callback_head	task_work;
+};
+
 /*
  * First field must be the file pointer in all the
  * iocb unions! See also 'struct kiocb' in <linux/fs.h>
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 9761a0ec9f95..79cde9906be0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,31 +5,6 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
-struct io_wq_work_node {
-	struct io_wq_work_node *next;
-};
-
-struct io_wq_work_list {
-	struct io_wq_work_node *first;
-	struct io_wq_work_node *last;
-};
-
-struct io_uring_task {
-	/* submission side */
-	struct xarray		xa;
-	struct wait_queue_head	wait;
-	void			*last;
-	void			*io_wq;
-	struct percpu_counter	inflight;
-	atomic_t		in_idle;
-	bool			sqpoll;
-
-	spinlock_t		task_lock;
-	struct io_wq_work_list	task_list;
-	unsigned long		task_state;
-	struct callback_head	task_work;
-};
-
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
-- 
2.25.1

