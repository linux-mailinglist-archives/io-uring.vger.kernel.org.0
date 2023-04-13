Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A4E6E0FFF
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjDMO3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDMO3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFFC44B6
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v10so2063953wmn.5
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396137; x=1683988137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTOKH/T+nrgZmNzA+urhMPeBoAc4bSAgEXD1T3vQklA=;
        b=j8gC9J5fvxqDr97HoS+gN2Kwv5MHIQWfai8zwwHUKfOUjVcG8VNOXs0cZnEdgC9ysF
         Kv4sP1go8bFIBQWPpiwSaMid9T2kwuWGTrl87pjJhadzOz99OUHabWcXwsxyC4/M02EE
         w73UKsQaIP4fp6YRCYBmEVKUfzx4/XxwoNoHCS/i+3mEqCjoVFAInnRUGYxrc0E/NIO9
         jHLW0sKYyiSWdaWk4SdVYZ9IunwBjYQl3TvXc54DvEUXVy4e1DF9Mg8TqNdSuEkls7Wq
         G6y6bBMBB/cEglnlKMeR2ByIgz5Z+pf2A6/qO2YWc6gyjd78wui2QelmXaL+LHxK0vlg
         3g7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396137; x=1683988137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTOKH/T+nrgZmNzA+urhMPeBoAc4bSAgEXD1T3vQklA=;
        b=T6PV2/UnEs+8WLJk85KbcwUM6Bjz2iiydTkPcTLFld6f9ijl5Qi8STWMJJemztBw2Z
         qK9pFFUV94JRao4fkQgPuakkxvyH3tgtHnwTvvlOCo3WHvk9Z+zbtvvTEGycbgEhZTpJ
         MUWN3dwnmievBi0ZoBPsqOLhAuUOg69RdueOzvBryrzqs3UHTGAe2dTJJ+yajWiDZSNi
         rplkjArL+cnq5G22F1VZBE/KjXfMn9FFeZQiRgOczd4rPsDvDrpUS+cvfiDddJHURpcy
         08dSmZs5IzBgt+5ix1fB3ToLc+tx+8nnUyehDu/b9Bmpdbshu+26SuhoNgFtm3tfJZfG
         29ow==
X-Gm-Message-State: AAQBX9fTftMbswIb6TD/TnlHD/ERseZGCS2ycbYfl3iIa1Ne5t2dAfJu
        2E3akkWJCHRte7xZR7/yEQ8EcokubB8=
X-Google-Smtp-Source: AKy350YktSVyOlm4y40Ga40+DMlMuE1hPBMUuxJ2UggT6gBLxyTPUhrdCDY2fW93j6p0Ge8g09OXbw==
X-Received: by 2002:a05:600c:28d:b0:3ed:ce50:435a with SMTP id 13-20020a05600c028d00b003edce50435amr2039162wmk.10.1681396136914;
        Thu, 13 Apr 2023 07:28:56 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 04/10] io_uring/rsrc: use wq for quiescing
Date:   Thu, 13 Apr 2023 15:28:08 +0100
Message-Id: <1d0dbc74b3b4fd67c8f01819e680c5e0da252956.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace completions with waitqueues for rsrc data quiesce, the main
wakeup condition is when data refs hit zero. Note that data refs are
only changes under ->uring_lock, so we prepare before mutex_unlock()
reacquire it after taking the lock back. This change will be needed
in the next patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  1 +
 io_uring/rsrc.c                | 18 ++++++++++++------
 io_uring/rsrc.h                |  1 -
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 40cab420b1bd..5c9645319770 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -333,6 +333,7 @@ struct io_ring_ctx {
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
+	struct wait_queue_head		rsrc_quiesce_wq;
 
 	struct list_head		io_buffers_pages;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9083a8466ebf..3c1c8c788b7b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -321,6 +321,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
+	init_waitqueue_head(&ctx->rsrc_quiesce_wq);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d7e7528f7159..f9ce4076c73d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -158,6 +158,7 @@ static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
+	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
 	if (ref_node->inline_items)
@@ -171,13 +172,13 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
 	if (io_put_rsrc_data_ref(rsrc_data))
-		complete(&rsrc_data->done);
+		wake_up_all(&ctx->rsrc_quiesce_wq);
 }
 
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
-	if (data && !io_put_rsrc_data_ref(data))
-		wait_for_completion(&data->done);
+	if (data)
+		WARN_ON_ONCE(!io_put_rsrc_data_ref(data));
 }
 
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
@@ -257,6 +258,7 @@ int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 				      struct io_ring_ctx *ctx)
 {
+	DEFINE_WAIT(we);
 	int ret;
 
 	/* As we may drop ->uring_lock, other task may have started quiesce */
@@ -273,7 +275,9 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 
 	data->quiesce = true;
 	do {
+		prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
 		mutex_unlock(&ctx->uring_lock);
+
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
 			mutex_lock(&ctx->uring_lock);
@@ -285,12 +289,15 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			}
 			break;
 		}
-		wait_for_completion_interruptible(&data->done);
+
+		schedule();
+		__set_current_state(TASK_RUNNING);
 		mutex_lock(&ctx->uring_lock);
 		ret = 0;
 	} while (data->refs);
-	data->quiesce = false;
 
+	finish_wait(&ctx->rsrc_quiesce_wq, &we);
+	data->quiesce = false;
 	return ret;
 }
 
@@ -366,7 +373,6 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 				goto fail;
 		}
 	}
-	init_completion(&data->done);
 	*pdata = data;
 	return 0;
 fail:
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 88adcb0b7963..d93ba4e9742a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -35,7 +35,6 @@ struct io_rsrc_data {
 	u64				**tags;
 	unsigned int			nr;
 	rsrc_put_fn			*do_put;
-	struct completion		done;
 	int				refs;
 	bool				quiesce;
 };
-- 
2.40.0

