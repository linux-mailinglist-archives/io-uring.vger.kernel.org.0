Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8F5ABFE3
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiICQwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 12:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiICQwm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 12:52:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA125C47
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 09:52:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso8411386pjk.0
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 09:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=epndrfcBIAu7oOwtOoo29Z1hPOOMo+qcgkQJ015903E=;
        b=YdeCDwghJYEn5E+PFT2ZuD2Hb7dGU82UDM5mW8fibAvG+YzaJwA7JMJOuHbXpc79se
         yFqlYjPIJfQ3ULtsGrNz91KaTknHntCLMM0Ex9L8lN9gE1Sr0Mlnu5RJBO54XHkuSVr+
         kqaXKJ20ElFCfqy1CkkSqmxjzq8jLfZhS11S1e4W2aTqPaUxYML8wIADcFbndTngvd2j
         3HWnabWmGN9AXJSqbSqQRA7R19bHkmuyz7776hv+o/1e5IFkN6NgsSruwIEDGLyPczO1
         iHREzqf89aGycLGV+lsEWU6K0tzFzHQcsp996QT6Jxb4pDb9t/FQPoMjOtsIm7TyGqx+
         lapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=epndrfcBIAu7oOwtOoo29Z1hPOOMo+qcgkQJ015903E=;
        b=F9GnNy4nGVPwhMNr6log3W5W05gz1V54ai7diSFUcbmIMDk2eZ2Lua/KzzbgJttPy2
         N/f3urH1QrwJ1ogBT/4rAe1SxjWIvL7zxKZFV/bL2NDrcpxLJxMJvv8lp8WuYLIUpzU/
         0MCVwI25gti2u6+jaT0xOmFIA1195tdRctezLBRNY+qU5qyhBVKGmEJnLuHBHh/kG5w8
         9/Q/26opI8nT2fMrInCDIwNLZ4w6+vltEPlEGZQtemhsRl0x9UDbM2+XtJ1hv8jRzI8l
         /kiAbCj1lQAyBkvToA81s180fEe90odcQoNC2xYrOkVnHWYEgu2P3L5LVzOpE/YS0Hq2
         o9fQ==
X-Gm-Message-State: ACgBeo2QgpfKz6V8Xs6FrpWK3ol2MgnsSlkwRRfG9aQT+VfwOETkDTrZ
        hr/aUKBl0bqHltRQqaPEcWEAe512PQP2Ew==
X-Google-Smtp-Source: AA6agR6upUwzCSiGU0ShI+eXDkq21FlEVmpvF4kxWTQISGHcJ85ur1yoJI6JPAwBxMSSfsfkXgRGdw==
X-Received: by 2002:a17:902:d4c8:b0:174:a871:152d with SMTP id o8-20020a170902d4c800b00174a871152dmr31182003plg.4.1662223960849;
        Sat, 03 Sep 2022 09:52:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm4187296pfb.23.2022.09.03.09.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:52:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: ensure iopoll runs local task work as well
Date:   Sat,  3 Sep 2022 10:52:33 -0600
Message-Id: <20220903165234.210547-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220903165234.210547-1-axboe@kernel.dk>
References: <20220903165234.210547-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Combine the two checks we have for task_work running and whether or not
we need to shuffle the mutex into one, so we unify how task_work is run
in the iopoll loop. This helps ensure that local task_work is run when
needed, and also optimizes that path to avoid a mutex shuffle if it's
not needed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 39 ++++++++++++++++++++-------------------
 io_uring/io_uring.h |  6 ++++++
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f841f0e126bc..118db2264189 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1428,25 +1428,26 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (wq_list_empty(&ctx->iopoll_list)) {
-			u32 tail = ctx->cached_cq_tail;
-
-			mutex_unlock(&ctx->uring_lock);
-			ret = io_run_task_work_ctx(ctx);
-			mutex_lock(&ctx->uring_lock);
-			if (ret < 0)
-				break;
-
-			/* some requests don't go through iopoll_list */
-			if (tail != ctx->cached_cq_tail ||
-			    wq_list_empty(&ctx->iopoll_list))
-				break;
-		}
-
-		if (task_work_pending(current)) {
-			mutex_unlock(&ctx->uring_lock);
-			io_run_task_work();
-			mutex_lock(&ctx->uring_lock);
+		if (wq_list_empty(&ctx->iopoll_list) ||
+		    io_task_work_pending(ctx)) {
+			if (!llist_empty(&ctx->work_llist))
+				__io_run_local_work(ctx, true);
+			if (task_work_pending(current) ||
+			    wq_list_empty(&ctx->iopoll_list)) {
+				u32 tail = ctx->cached_cq_tail;
+
+				mutex_unlock(&ctx->uring_lock);
+				ret = io_run_task_work();
+				mutex_lock(&ctx->uring_lock);
+
+				if (ret < 0)
+					break;
+
+				/* some requests don't go through iopoll_list */
+				if (tail != ctx->cached_cq_tail ||
+				    wq_list_empty(&ctx->iopoll_list))
+					break;
+			}
 		}
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0f90d1dfa42b..9d89425292b7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -236,6 +236,12 @@ static inline int io_run_task_work(void)
 	return 0;
 }
 
+static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
+{
+	return test_thread_flag(TIF_NOTIFY_SIGNAL) ||
+		!wq_list_empty(&ctx->work_llist);
+}
+
 static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
 {
 	int ret = 0;
-- 
2.35.1

