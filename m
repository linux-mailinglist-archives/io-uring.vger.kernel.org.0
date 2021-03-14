Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B7E33A47E
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 12:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhCNLPv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 07:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhCNLPp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 07:15:45 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06E8C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 04:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:To:From:CC;
        bh=MdlSU84kiCoHeqvX1aP3s+M3+5HOE/PAhS5rIq/lIjY=; b=BfDwXsIByximi8ZcUZyIpKUgGJ
        kEJsNbaMEMneGAEAKOdBRymP97+TTXw9BaMyK/03km5wtvNT9DjIKvF5Mdl85AuDXKqSOGRmldfa8
        Kv/T97bIKBv+NHzPQfm70y1EayyTUd+y0pSplbU9JLd9DbULb2WSKePdXFIZxpNjWhaUQDC7C3l0B
        LuW6Z0A5D4AhYJe6yCzGpVSD4+4RX3GyFWqvXlkoljFo30duhMFszd3FrQPHgxl61RgQmVb6fJHH1
        LlewWLTaRqA5Gx8ahF/R5MkgdhbmwPxv2TEsE3QAce762cZBH5d+qaW4y9AN+C7oD8zd2PQsx4Ean
        vA94am1nTc3FjXHM7AhgC1ayxn9kb3SCaVwh3D8s2dN9yq8ShBuEUORii7kUQ49gpKQUV3cry/Nfh
        04dQmfXBdPZmEFRGLk6DjyS93A7MrWmyEhyWLZS1QwI4bQxxgb4g0kSfwSb5OTPukyabnr+dLdvPp
        4FtMrUltcUmSUjE1vw44/P6q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLOil-0000Lx-7o
        for io-uring@vger.kernel.org; Sun, 14 Mar 2021 11:15:43 +0000
From:   Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/2] io_uring: remove structures from include/linux/io_uring.h
To:     io-uring@vger.kernel.org
References: <cover.1615719251.git.metze@samba.org>
Message-ID: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
Date:   Sun, 14 Mar 2021 12:15:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cover.1615719251.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
index 642ad08d8964..fd0807a3c9c3 100644
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


