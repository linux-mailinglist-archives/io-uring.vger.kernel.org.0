Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBF18F0BC
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 09:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgCWIUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 04:20:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37375 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbgCWIUX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 04:20:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id d1so13601164wmb.2;
        Mon, 23 Mar 2020 01:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4X1Z6DBl4C8HGw65pPFrYCqZJP71M3Q/BOMQzOBqfdc=;
        b=CV6q6lN3RkNvtZvP3NicZuIziS4Fjd5YCd9o6JxBg4su/vAT7W19fnSInrMUuhK9rA
         QxUOZTeeslkpfd0kMIUc61KInphJ/y60CWO9u8crqYUkfYV8Tt0kTJ37F0KFvTD/C2Jh
         8U1epqG4jjagnkoNoMjD9LwN2mQXizRnmHXN9MZaiuVfmHDmVbBS3Tquf7gRQ4aZah29
         xR7nMhpNi8QysiNcpjxAsBI3kNj3i28LgQHTJM+joFDExF+Azh8dNdD7fZ5kKw6DjlAH
         oBlUEef91L2T8t74vARHfu5j3bOZ0bk+EfCv+Wobii4ROWJheV9gmDpAAPeexRcY1kZo
         NEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4X1Z6DBl4C8HGw65pPFrYCqZJP71M3Q/BOMQzOBqfdc=;
        b=Um50o1nJwOUEntwZyPpGOZglpvolB2ZYZx4cfZCU0+N0toxNyKP+8qjqUrZGvJZM3D
         U3zL4h7L3GsD3AYWeFvYMOtytGRlcbHzgzQIWyvt85UYjlyECfq2jXbJsbaDoW4J4oDa
         BIb8HY69PIAP24Qsin3sDmN5m+ADjR2lj4UKRQnntUp6GpRluPEJM4fCfxiWzMj8YfNa
         5FN9SzxBsvxrP6WOYsswDiMcaR1JNEgl++EiES4Zwi0oI2+snuxRsE4u3U5xWRhF1TIO
         R6BIBdymZQXB8okH9ILSTn/7375XHO9Llwak9gdB9cedEpoCvk97WQYUeZsMJNSNMB7A
         6WjA==
X-Gm-Message-State: ANhLgQ3+xnpLb1Ryok5othzfEvVgUt66Uux688iogG2wAcBER7t5tHQZ
        ulo6GQgZVbdzvswViIE8AbJXxggJ
X-Google-Smtp-Source: ADFU+vvZKjlztybgaUz1LfLsvTStISrbBPVn+CkN+v51pTczGTOuF0tuZECZeoD31b9f9lyQ0ZQ2LQ==
X-Received: by 2002:a05:600c:2293:: with SMTP id 19mr19359496wmf.84.1584951621607;
        Mon, 23 Mar 2020 01:20:21 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id o67sm5096814wmo.5.2020.03.23.01.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 01:20:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: Fix ->data corruption on re-enqueue
Date:   Mon, 23 Mar 2020 11:19:14 +0300
Message-Id: <dfc0b13b8ccc5f7780fd94c1f7e4db724ac7513d.1584951486.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
References: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

work->data and work->list are shared in union. io_wq_assign_next() sets
->data if a req having a linked_timeout, but then io-wq may want to use
work->list, e.g. to do re-enqueue of a request, so corrupting ->data.

Don't need ->data, remove it and get linked_timeout through @link_list.

Fixes: 60cf46ae6054 ("io-wq: hash dependent work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    | 5 +----
 fs/io_uring.c | 9 ++++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 298b21f4a4d2..d2a5684bf673 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -63,10 +63,7 @@ static inline void wq_node_del(struct io_wq_work_list *list,
 } while (0)
 
 struct io_wq_work {
-	union {
-		struct io_wq_work_node list;
-		void *data;
-	};
+	struct io_wq_work_node list;
 	void (*func)(struct io_wq_work **);
 	struct files_struct *files;
 	struct mm_struct *mm;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5267e331b4a4..ce8f38aa070a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1567,9 +1567,10 @@ static void io_free_req(struct io_kiocb *req)
 
 static void io_link_work_cb(struct io_wq_work **workptr)
 {
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *link;
 
+	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
 	io_queue_linked_timeout(link);
 	io_wq_submit_work(workptr);
 }
@@ -1584,10 +1585,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
-	if (link) {
+	if (link)
 		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
 }
 
 /*
-- 
2.24.0

