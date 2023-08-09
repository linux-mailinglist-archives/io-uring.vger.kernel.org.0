Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BBE776901
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 21:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjHITnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 15:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjHITnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 15:43:14 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7108410FF
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 12:43:13 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bbadf9ed37so355775ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 12:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691610193; x=1692214993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RPJ/aUV9FK+5POIObVoWUi/BhbkItEMofyKg8MdS0mk=;
        b=F6coCqzfFackcp5v1E5NT9/7nCDvZxWSogdy1iKICjmg913VMn8gqyBgLOLqZXdEdQ
         MHyWcILG778ZQh4+3BPTD5zJDU+9vuYqCMYg5DZ49l7yO70Qtopo8EBSOaY5TVxwyXFy
         TpFojrJfFY/wQpPdLkiGxn8cjgodtKF6inaKccTlvWRASaOcF0sCUeY3th8oBWXmIU57
         EGVmCNQhjGDO7B//R+GFFQnNCErGu4SLJhx9qMGMIsUIYAqXJh0+7d1IyhyZffufONZa
         gM2Iw6cVTvFb2dukfsi+VKRUjVGiW2u7gJJtI9nJKJkxfdyYhzA9IsL4SIsML9K+gvQ9
         tHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691610193; x=1692214993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPJ/aUV9FK+5POIObVoWUi/BhbkItEMofyKg8MdS0mk=;
        b=LlKdHLARvhcS41iorH/wzhRSnyU2dLFcP2NroyUpPDsh/M6Pj+vGe5r8dXKNq2OlaS
         d34KJqAr8FriAoqr2Ws6Ue2XYCRh8FN/w7+DwG3cVqQeX01fpbU1VIrtLjXPbB+3vDz9
         q9ZbMmoJ/m4Zs5o7h3jFanmhi6o9F5UcVnhYJZVeZIQMljoq5LnwPNUiTicjWqNXUmHH
         knceCqYrM/0rNYc66VTJ7XxKSeoBYOkfoC7R2S91CIS1R/coajeQZnhdmeYNhn+NROZ9
         ra+7pWH8JlOJVq0MASqwkhldE6VCUULDvj36Bn6m5vMqZWOJh0u38vzIh+CyB9GoQW2q
         Fi3w==
X-Gm-Message-State: AOJu0YwPxO+YuZuC5zuzA/i9X2s9t4dqwTVCCFd4ZTUlojuiLhBucqp0
        zk+AKt+A3Qk/+HUs9Y9ZI4nPP77XCWjAuqqXo9Q=
X-Google-Smtp-Source: AGHT+IEQYp1i6F+ybe+0X92Bx9MDV8AbuLhp+3FVB12mhB1zn70QweSt74f4X1l9uDr2zkL+qdToOg==
X-Received: by 2002:a17:902:ea0b:b0:1bb:9e6e:a9f3 with SMTP id s11-20020a170902ea0b00b001bb9e6ea9f3mr70601plg.4.1691610192724;
        Wed, 09 Aug 2023 12:43:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902eb1300b001b8953365aesm11588919plb.22.2023.08.09.12.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:43:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/io-wq: reduce frequency of acct->lock acquisitions
Date:   Wed,  9 Aug 2023 13:43:05 -0600
Message-Id: <20230809194306.170979-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809194306.170979-1-axboe@kernel.dk>
References: <20230809194306.170979-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we check if we have work to run, we grab the acct lock, check,
drop it, and then return the result. If we do have work to run, then
running the work will again grab acct->lock and get the work item.

This causes us to grab acct->lock more frequently than we need to.
If we have work to do, have io_acct_run_queue() return with the acct
lock still acquired. io_worker_handle_work() is then always invoked
with the acct lock already held.

In a simple test cases that stats files (IORING_OP_STATX always hits
io-wq), we see a nice reduction in locking overhead with this change:

19.32%   -12.55%  [kernel.kallsyms]      [k] __cmpwait_case_32
20.90%   -12.07%  [kernel.kallsyms]      [k] queued_spin_lock_slowpath

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 3e7025b9e0dd..18a049fc53ef 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -232,17 +232,25 @@ static void io_worker_exit(struct io_worker *worker)
 	do_exit(0);
 }
 
-static inline bool io_acct_run_queue(struct io_wq_acct *acct)
+static inline bool __io_acct_run_queue(struct io_wq_acct *acct)
 {
-	bool ret = false;
+	return !test_bit(IO_ACCT_STALLED_BIT, &acct->flags) &&
+		!wq_list_empty(&acct->work_list);
+}
 
+/*
+ * If there's work to do, returns true with acct->lock acquired. If not,
+ * returns false with no lock held.
+ */
+static inline bool io_acct_run_queue(struct io_wq_acct *acct)
+	__acquires(&acct->lock)
+{
 	raw_spin_lock(&acct->lock);
-	if (!wq_list_empty(&acct->work_list) &&
-	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-		ret = true;
-	raw_spin_unlock(&acct->lock);
+	if (__io_acct_run_queue(acct))
+		return true;
 
-	return ret;
+	raw_spin_unlock(&acct->lock);
+	return false;
 }
 
 /*
@@ -397,6 +405,7 @@ static void io_wq_dec_running(struct io_worker *worker)
 	if (!io_acct_run_queue(acct))
 		return;
 
+	raw_spin_unlock(&acct->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wq->worker_refs);
 	io_queue_worker_create(worker, acct, create_worker_cb);
@@ -521,9 +530,13 @@ static void io_assign_current_work(struct io_worker *worker,
 	raw_spin_unlock(&worker->lock);
 }
 
-static void io_worker_handle_work(struct io_worker *worker)
+/*
+ * Called with acct->lock held, drops it before returning
+ */
+static void io_worker_handle_work(struct io_wq_acct *acct,
+				  struct io_worker *worker)
+	__releases(&acct->lock)
 {
-	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wq *wq = worker->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
@@ -537,7 +550,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
 		work = io_get_next_work(acct, worker);
 		raw_spin_unlock(&acct->lock);
 		if (work) {
@@ -591,6 +603,10 @@ static void io_worker_handle_work(struct io_worker *worker)
 					wake_up(&wq->hash->wait);
 			}
 		} while (work);
+
+		if (!__io_acct_run_queue(acct))
+			break;
+		raw_spin_lock(&acct->lock);
 	} while (1);
 }
 
@@ -611,8 +627,13 @@ static int io_wq_worker(void *data)
 		long ret;
 
 		set_current_state(TASK_INTERRUPTIBLE);
+
+		/*
+		 * If we have work to do, io_acct_run_queue() returns with
+		 * the acct->lock held. If not, it will drop it.
+		 */
 		while (io_acct_run_queue(acct))
-			io_worker_handle_work(worker);
+			io_worker_handle_work(acct, worker);
 
 		raw_spin_lock(&wq->lock);
 		/*
@@ -645,8 +666,8 @@ static int io_wq_worker(void *data)
 		}
 	}
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-		io_worker_handle_work(worker);
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) && io_acct_run_queue(acct))
+		io_worker_handle_work(acct, worker);
 
 	io_worker_exit(worker);
 	return 0;
-- 
2.40.1

