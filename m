Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5435F1A2
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhDNKsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhDNKsf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:35 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFDBC061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h4so10376229wrt.12
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r2rUyVx69NtQe/JuEWNbtS17jy4jnwfRvpUBRCF96P0=;
        b=icwNIWhC2V6yCVrGNWVCOQ4qDpjrPxV77q6mv4aHvss1eaAJ0PYaqIfJetuGTLnvme
         mkT7kXKMcRtvgaxn8rCT043jD9B/Ar2ClA355tD1z01+AWce4caYtmKjAjOmlVTuDOcL
         /1YYVAGU1USVY0cgF6xLUDPK4qdYZORs1j4wpP58MsNizqTa+sBBqzOcnKu9Ffn6nGCW
         EMut+EuzoDXZYzdBA3vyB1aPKWI3z38tVJe10AkvJpX9IhVulrOiO82gx5hcNCDzcxWd
         YEWs87PDCqdfe5YuvGVNmSC5W5xEJJ2vecb9IEyRGKYCN9ITiSWaEidSRQftGl5B/R1z
         Pq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r2rUyVx69NtQe/JuEWNbtS17jy4jnwfRvpUBRCF96P0=;
        b=ryWhlrhL0gch14v5vTmrVquiDi3nm7LNTfS16y7JVAgiiiLLnrEeHxMv7TOZ76MdrW
         oWLqkIE/IamDpoSFSBsiHPmk+f6PjZ3f1+W24yoShxrDUcr44UPYEAX6s9n2t2xD/P4V
         ePdcxaWXGTboNXyu24sTzuotaVk9ClBE4VbLSq6vpoipO81yi5vOtR+x0RY53wma+MJN
         OFIR6er06ycUPSqst/fhRrifP6b4vx+Rl41q5QQK82/39sNAikQxAzWuTbivzQwPG4z1
         M9p/ogqRG75LDOGAZALDD9BpOLIl4sAk5006xkvQ8eXKeUv3PeP/biaCM5zzJAv9A8Ut
         WJug==
X-Gm-Message-State: AOAM532m4ALl8cGHBcDzBgmWOOHGL7D5okAPVWzjT5xKb5LPXnShPdXR
        egzU+ahqS+aUcEMPh+tHpOA=
X-Google-Smtp-Source: ABdhPJwy4kLihgC2sGnCShOShbH5JneHpySPR5nHEl5qfhPTQjxWTUXjF1WF2GfVc/04hYeUR76+AQ==
X-Received: by 2002:adf:a40f:: with SMTP id d15mr33338692wra.375.1618397290607;
        Wed, 14 Apr 2021 03:48:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: improve sqpoll event/state handling
Date:   Wed, 14 Apr 2021 11:43:50 +0100
Message-Id: <2c8c6e0710653bf6396ea011be106dcb57e175fc.1618396838.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618396838.git.asml.silence@gmail.com>
References: <cover.1618396838.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As sqd->state changes rarely, don't check every event one by one but
look them all at once. Add a helper function. Also don't go into event
waiting sleeping with STOP flag set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3b679c5547e..693fb5c5e58c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6742,6 +6742,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	return submitted;
 }
 
+static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
+{
+	return READ_ONCE(sqd->state);
+}
+
 static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
@@ -6796,6 +6801,24 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
+static bool io_sqd_handle_event(struct io_sq_data *sqd)
+{
+	bool did_sig = false;
+	struct ksignal ksig;
+
+	if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
+	    signal_pending(current)) {
+		mutex_unlock(&sqd->lock);
+		if (signal_pending(current))
+			did_sig = get_signal(&ksig);
+		cond_resched();
+		mutex_lock(&sqd->lock);
+	}
+	io_run_task_work();
+	io_run_task_work_head(&sqd->park_task_work);
+	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -6818,29 +6841,17 @@ static int io_sq_thread(void *data)
 	/* a user may had exited before the thread wstarted */
 	io_run_task_work_head(&sqd->park_task_work);
 
-	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
+	while (1) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
-		if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
-		    signal_pending(current)) {
-			bool did_sig = false;
-
-			mutex_unlock(&sqd->lock);
-			if (signal_pending(current)) {
-				struct ksignal ksig;
-
-				did_sig = get_signal(&ksig);
-			}
-			cond_resched();
-			mutex_lock(&sqd->lock);
-			io_run_task_work();
-			io_run_task_work_head(&sqd->park_task_work);
-			if (did_sig)
+		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
+			if (io_sqd_handle_event(sqd))
 				break;
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
+
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -6877,7 +6888,7 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (needs_sched && !io_sqd_events_pending(sqd)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-- 
2.24.0

