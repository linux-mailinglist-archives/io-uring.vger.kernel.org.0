Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4EE174291
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgB1WyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:13 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51987 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgB1WyN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so5104895wmi.1;
        Fri, 28 Feb 2020 14:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S7cYMDmxLfFxtr4139bz98MEaSx/Q8a11mNaWx3kEcI=;
        b=HuKG2/RGwxRHRD0OaBzH4i6MIByZNPcUDPWjfB/ryLsYiomobgqtEEIbi82WOJ11Vc
         m7Cnr6azvh1L1ScpCv3728qouFjqCzhij/oRWoKiZZoapifz+a6PLV03ZWeL612TMes2
         y3GYTK3MK61/NUDk8jDl7/qq6eDBjp3pnO7QF22mPfE0zGejFeKbYEJ0SENfgJWDDk02
         zgSseXcyc1nwsqAZm7U2tFK6wd+oRVgORZnq8rWv/f7DVLGfbrDeQzCdUfkQLWUxWyo2
         BTiGOch2GmspfrMmiN+LRXfVQHYNlvYeaMvSPyHlmAf5Ipr96q1sR9OC+2SB3nWd6ojJ
         6mng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7cYMDmxLfFxtr4139bz98MEaSx/Q8a11mNaWx3kEcI=;
        b=qxs67JbrvwkF9ShOnNolEkpgspS8pOwmge2AGK5eZqTV+5tiGu5Q73ND1W1ibIPAwA
         pxDLp26v+UtZxvrTEraJQfGhwMm+fDEpx0e4/LGVFZ+2xeAgzbtPV0QUy4bq3IWuHW8t
         +yzOEGZRwzNCFYpu8shExKombyaSOeNAv/zmdbwpFTsc5LYv1XgzT4VTg8XPaW8HLt8z
         13MVZNbapxycQWz6NhWeYp5nj8VY7r0ZyhZS5CCTf3uZSKVxCC+ITit7Bioy1E4S/Rfi
         ehowyZ7ssLj2YLjEDQ27cxzUucEZyIkYMs/HS/uwptFkEMMotFFqBBPU7skXAzdX1gRY
         TJIw==
X-Gm-Message-State: APjAAAUC8glEqR410SdXjwfgG2dgzYzFCOnDHPG60MdzNDJO7B/zvOwL
        HKNZIayZNO6cbOpKIuLO0dVjLC2N
X-Google-Smtp-Source: APXvYqxvNYQGmjE7r62avOHJ3CAZTwPS7uMEMIx5YMLC5yryLFMiBTKgTH1OeyRFux2FwfAhkxLl1w==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr6525056wme.37.1582930451569;
        Fri, 28 Feb 2020 14:54:11 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring/io-wq: allow put_work return next work
Date:   Sat, 29 Feb 2020 01:53:09 +0300
Message-Id: <6e1bf69ad183510b7881389a38cc556fad4cf8d8.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582929017.git.asml.silence@gmail.com>
References: <cover.1582929017.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Formerly work->func() was returning next work to exeucute. Make put_work
do the same. As put_work() is the last thing happening with work during
issuing, it have all info needed to deduce the next job.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 17 +++++------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 29 ++++++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a830eddaffbe..8bdda5e23dcd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -443,7 +443,7 @@ static void io_wq_switch_creds(struct io_worker *worker,
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
-	struct io_wq_work *work, *old_work = NULL, *put_work = NULL;
+	struct io_wq_work *work, *old_work = NULL;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -464,8 +464,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		spin_unlock_irq(&wqe->lock);
-		if (put_work && wq->put_work)
-			wq->put_work(old_work);
 		if (!work)
 			break;
 next:
@@ -497,10 +495,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
 
-		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL)) {
-			put_work = work;
+		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL))
 			wq->get_work(work);
-		}
 
 		old_work = work;
 		work->func(work);
@@ -509,6 +505,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 		worker->cur_work = NULL;
 		spin_unlock_irq(&worker->lock);
 
+		if (wq->put_work && !(work->flags & IO_WQ_WORK_INTERNAL))
+			wq->put_work(&work);
+
 		spin_lock_irq(&wqe->lock);
 
 		if (hash != -1U) {
@@ -517,12 +516,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 		if (work && work != old_work) {
 			spin_unlock_irq(&wqe->lock);
-
-			if (put_work && wq->put_work) {
-				wq->put_work(put_work);
-				put_work = NULL;
-			}
-
 			/* dependent work not hashed */
 			hash = -1U;
 			goto next;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 508615af4552..f1d717e9acc1 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -83,7 +83,7 @@ struct io_wq_work {
 	} while (0)						\
 
 typedef void (get_work_fn)(struct io_wq_work *);
-typedef void (put_work_fn)(struct io_wq_work *);
+typedef void (put_work_fn)(struct io_wq_work **);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c49ed2846f85..9b220044b608 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5939,11 +5939,34 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	return __io_sqe_files_update(ctx, &up, nr_args);
 }
 
-static void io_put_work(struct io_wq_work *work)
+static void io_link_work_cb(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *link = work->data;
 
-	io_put_req(req);
+	io_queue_linked_timeout(link);
+	io_wq_submit_work(work);
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	io_prep_next_work(req, &link);
+	*workptr = &req->work;
+	if (link) {
+		req->work.func = io_link_work_cb;
+		req->work.data = link;
+	}
+}
+
+static void io_put_work(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	io_put_req_find_next(req, &nxt);
+	if (nxt)
+		io_wq_assign_next(workptr, nxt);
 }
 
 static void io_get_work(struct io_wq_work *work)
-- 
2.24.0

