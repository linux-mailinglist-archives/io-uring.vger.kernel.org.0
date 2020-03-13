Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F2185136
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgCMVcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:32:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39285 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMVcR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:32:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id r15so13919033wrx.6;
        Fri, 13 Mar 2020 14:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7DbGWN2+kF//whEgQr03cv2/aBaOQJUED7KmNiLDrJM=;
        b=HFQFQ6ECQPVAtjvEJKfBh6yX1cWMdvL8+ZyH9fnSgC3vD0DUeTSJIvBSGW7EynkjIK
         G9CQRvUCtoUvcRDypNwqLvmI2KcE94CgwGZEQ+yB0o+MCRzrRh6OwB6nT/W6ubYNWIcq
         KTB6fIBTr/Rtwt1MvUnGoAYa0lJPV7tEK/iMVlDtXe87mgYIzDuchwxbrW5hq4rl/l0B
         q1gERZngvA5mXJAAWaeEK2J3Xn8iQAfEBmfPhVRihpyQxXosqSNP1pWWY7sDZmh01Rll
         Cgi8XZOWLEP+SCNnwnWbcUAapDt6RwIe8f98L8x/rJjOeCqHqIn9UPp/iyW55wXoXvW4
         fPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DbGWN2+kF//whEgQr03cv2/aBaOQJUED7KmNiLDrJM=;
        b=JX7HUU/oeuIUHyKGyoR6OXN2N+ZScKmXJqN81QK3Vhq6l5OjUdBxlRHTWWN8jbYw4S
         JLRAPsooObQaMY9c25+wQSw3yv6F3pepz2CChdUBd9X2M/lfAUMrnQgx+ww9T1wp8OlK
         KvZQB89bfL6Cq+31doq5XVVkMkW2qlZMPpCm3TY9q/rJfuDCzcG3rUIUeKmNQ7Kwuc8g
         9jRbK5H8qvDOXFZJuln1JYwpsPPw/aSuy+PDcz8IGwxGypPYv2KeIZB3mhPL1EmfTW1D
         Y0AhGaIhF7sjVNPuiwOJdRqHIzX2nn16dJ0iCTHA9fktiNwpm/97EgFrzA5UAKOFtGMc
         /7eQ==
X-Gm-Message-State: ANhLgQ3hSKSWpr/3Mrt9N+XNfWqKQ+QAGOdBfY8UfwP5OTeWYJKrCxvS
        1POqYs6GoLRzXLqtUyh1yao48v7r
X-Google-Smtp-Source: ADFU+vsdqvGcGZnMvy/iI5fV6q4dPiZe2QdHpASETZVqfBOwi6V/Ks9vRLF1vc11oY7cMkqf/rFOFQ==
X-Received: by 2002:a05:6000:12c6:: with SMTP id l6mr20860050wrx.217.1584135135770;
        Fri, 13 Mar 2020 14:32:15 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id v8sm78676011wrw.2.2020.03.13.14.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:32:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io-wq: hash dependant works
Date:   Sat, 14 Mar 2020 00:31:05 +0300
Message-Id: <395f8af8d6133c69cb7a6ef2082e4d7a5c08e8d8.1584130466.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1584130466.git.asml.silence@gmail.com>
References: <cover.1584130466.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable io-wq hashing stuff for dependant works simply by re-enqueueing
such requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e26ceef53cbd..9541df2729de 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -375,11 +375,17 @@ static bool __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
 	return __io_worker_unuse(wqe, worker);
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe, unsigned *hash)
+static inline unsigned int io_get_work_hash(struct io_wq_work *work)
+{
+	return work->flags >> IO_WQ_HASH_SHIFT;
+}
+
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
+	unsigned int hash;
 
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
@@ -391,9 +397,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe, unsigned *hash)
 		}
 
 		/* hashed, can run if not already running */
-		*hash = work->flags >> IO_WQ_HASH_SHIFT;
-		if (!(wqe->hash_map & BIT(*hash))) {
-			wqe->hash_map |= BIT(*hash);
+		hash = io_get_work_hash(work);
+		if (!(wqe->hash_map & BIT(hash))) {
+			wqe->hash_map |= BIT(hash);
 			wq_node_del(&wqe->work_list, node, prev);
 			return work;
 		}
@@ -470,15 +476,17 @@ static void io_assign_current_work(struct io_worker *worker,
 	spin_unlock_irq(&worker->lock);
 }
 
+static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
+
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	unsigned hash = -1U;
 
 	do {
 		struct io_wq_work *work;
+		unsigned int hash;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -487,7 +495,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe, &hash);
+		work = io_get_next_work(wqe);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 		else if (!wq_list_empty(&wqe->work_list))
@@ -511,11 +519,16 @@ static void io_worker_handle_work(struct io_worker *worker)
 				work->flags |= IO_WQ_WORK_CANCEL;
 
 			old_work = work;
+			hash = io_get_work_hash(work);
 			work->func(&work);
 			work = (old_work == work) ? NULL : work;
 			io_assign_current_work(worker, work);
 			wq->free_work(old_work);
 
+			if (work && io_wq_is_hashed(work)) {
+				io_wqe_enqueue(wqe, work);
+				work = NULL;
+			}
 			if (hash != -1U) {
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
-- 
2.24.0

