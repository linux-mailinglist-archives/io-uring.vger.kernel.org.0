Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4A382154
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEPV7q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEPV7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2012C06174A
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:27 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u133so2508969wmg.1
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uRLJtpmb9kLy8fTYy6A4c5QYQvkrrFTiRglXVlQXUR4=;
        b=u8GOQLGlrzUzHkPKMBE/b0FzKmooCm9TPBPBL4DbECv5LoJzM0mN6aIjpfRkjlrqro
         +xEn9xb7O5YF+QmC52Zo9/rK2rUsPJ145ZKtyyBUCySO9bkX/8ZJwatwydXmn+30BP22
         vN3h8cNO5zCQ43FXYLMjKT++gf0155oQL0/8RUuspNr9+GmCd8aDUFGI7s2t3b7fKMwk
         aEs+Jp3Wfg+ZCEr3d2CNN/eqisZpHDIJI62ic6/09H2ibWofgFMv6+EBjfp49EV+hDp6
         WWuPfpEdLcQpfsX6TsS+7b5VDbUbTLjC6eNxENmSYslTl594Uk44bIEGhqW09dRVilJM
         LxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRLJtpmb9kLy8fTYy6A4c5QYQvkrrFTiRglXVlQXUR4=;
        b=AWiPSNHD4fMQ+jHar21Z2OHINizqTZCEi9haSwi8Ap43gww9A3GOSWFeGKtJm4FKBR
         M7R7vI+YmBu1go5d75XR7dfnwWBGXqwa3OIy/db3G82V+sf1VE/qjbGP0AMw0vlVGkdg
         6FHpeTVmz41tR2DdtNPx1z+pshsNzqThHAL7uK6WR5CyedEFatrHIp2kMRs1dg9JdUR5
         4kKJBnGtUt8voKD6MgxuVfVX0Ekhu8YDobt6Ha1Ia5HQEAqR2pntK/SwnA8iDxdksV2v
         MyqI3WDRSaQDY9qgR5+5TZr/YPekMuG2hFTBimCp2cPVqtYduKohboV0JR5ayzA74qDX
         u77Q==
X-Gm-Message-State: AOAM533ZQnCnhZpHlfXOvNRyRmKDy820Nc1MtF9dt6gBm1Ogorx4chfw
        I+9HED6b7K2hAzkjfjUSpIU=
X-Google-Smtp-Source: ABdhPJxqKWzHWyhjDS4f7BpyWR5tUbjJ5cYsyDMUtcApEG+I2e4dHNmcU7kQirAQNfF5/YJ6F9S0VA==
X-Received: by 2002:a05:600c:3596:: with SMTP id p22mr20213377wmq.34.1621202306618;
        Sun, 16 May 2021 14:58:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/13] io_uring: improve sqpoll event/state handling
Date:   Sun, 16 May 2021 22:58:00 +0100
Message-Id: <645025f95c7eeec97f88ff497785f4f1d6f3966f.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
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
index e481ac8a757a..dd355438435d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6752,6 +6752,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
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
@@ -6810,6 +6815,24 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
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
@@ -6831,29 +6854,17 @@ static int io_sq_thread(void *data)
 	/* a user may had exited before the thread started */
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
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (!io_sqd_events_pending(sqd)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-- 
2.31.1

