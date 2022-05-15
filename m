Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8528B5277C0
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiEONNN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEONNN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:13 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B6613F55
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620392;
        bh=YeTgbXY1hFXBn3cF4GCvZFOS6oanqEyDJGOjwqDwC7M=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=RQL9Q0+kTzhu6NE/mCOB7/LHK/iZKbBq17w/DUsqnmrdhHrd11O8G7/eqA3ZtYi3g
         4M1Svb51om5W7wfkspQ1CX8+Tu2Gq8QbXDL2VLfz8j3O2vsSuchUv5beta/QcvuEoI
         179aXnveVHYAvbrTPEqvrQSMhjmQqqa0xm/68VqQGDZDgfU5VSTrMs75ifX2yuL8lI
         JnCY6B6B86CdGNmvrIWf/6HVHPa8IXFRAgwuxBdqU+b310jPDwaRLMhOPBHjwcVtnI
         or0EkOqKduv8MS5EmiK9zb8PK0YvvTo124WyXs/L3afV2NS9XhiWasZ+elsObNnWI8
         V6p/DBBPjrg+g==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 7C3DB3E1D26;
        Sun, 15 May 2022 13:13:09 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 08/11] io-wq: batch the handling of fixed worker private works
Date:   Sun, 15 May 2022 21:12:27 +0800
Message-Id: <20220515131230.155267-9-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=684 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu.linux@gmail.com>

From: Hao Xu <howeyxu@tencent.com>

Reduce acct->lock contension by batching the handling of private work
list for fixed_workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 42 +++++++++++++++++++++++++++++++++---------
 fs/io-wq.h |  5 +++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8e152c076dd5..7c13cc01e5e5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -547,8 +547,23 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	return ret;
 }
 
+static inline void conditional_acct_lock(struct io_wqe_acct *acct,
+					 bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_lock(&acct->lock);
+}
+
+static inline void conditional_acct_unlock(struct io_wqe_acct *acct,
+					   bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_unlock(&acct->lock);
+}
+
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
-					   struct io_worker *worker)
+					   struct io_worker *worker,
+					   bool needs_lock)
 	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -556,6 +571,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+	conditional_acct_lock(acct, needs_lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
@@ -564,6 +580,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 
@@ -575,6 +592,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -591,15 +609,16 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&acct->lock);
+		conditional_acct_unlock(acct, needs_lock);
 		unstalled = io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&acct->lock);
+		conditional_acct_lock(acct, needs_lock);
 		if (unstalled) {
 			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 			if (wq_has_sleeper(&wqe->wq->hash->wait))
 				wake_up(&wqe->wq->hash->wait);
 		}
 	}
+	conditional_acct_unlock(acct, needs_lock);
 
 	return NULL;
 }
@@ -633,7 +652,7 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker,
-				  struct io_wqe_acct *acct)
+				  struct io_wqe_acct *acct, bool needs_lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -649,9 +668,7 @@ static void io_worker_handle_work(struct io_worker *worker,
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
-		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
+		work = io_get_next_work(acct, worker, needs_lock);
 		if (work) {
 			__io_worker_busy(wqe, worker);
 
@@ -708,12 +725,19 @@ static void io_worker_handle_work(struct io_worker *worker,
 
 static inline void io_worker_handle_private_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, &worker->acct);
+	struct io_wqe_acct acct;
+
+	raw_spin_lock(&worker->acct.lock);
+	acct = worker->acct;
+	wq_list_clean(&worker->acct.work_list);
+	worker->acct.nr_works = 0;
+	raw_spin_unlock(&worker->acct.lock);
+	io_worker_handle_work(worker, &acct, false);
 }
 
 static inline void io_worker_handle_public_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, io_wqe_get_acct(worker));
+	io_worker_handle_work(worker, io_wqe_get_acct(worker), true);
 }
 
 static int io_wqe_worker(void *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index ba6eee76d028..ef3ce577e6b7 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -40,6 +40,11 @@ struct io_wq_work_list {
 	(list)->first = NULL;					\
 } while (0)
 
+static inline void wq_list_clean(struct io_wq_work_list *list)
+{
+	list->first = list->last = NULL;
+}
+
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
-- 
2.25.1

