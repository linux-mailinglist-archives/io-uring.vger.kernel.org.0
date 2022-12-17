Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4215B64FC49
	for <lists+io-uring@lfdr.de>; Sat, 17 Dec 2022 21:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLQUs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Dec 2022 15:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLQUs5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Dec 2022 15:48:57 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CC9BE31
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:46 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n3so3867533pfq.10
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh4t/ycmHZfX06rOPtzSBBl7/QL2eq7+Ab7eP+nK1Ag=;
        b=eQ/Kg5fPt3APsBvHeMDc17Amcn29vRArSuDTbiPonlrNRAGfh1h9b1iK/Gns5mFOzf
         tTamXb5qbf0bH8xRBdxvYsZVkRnPifHBLT0Y5rAzVkw4wbezpGDqlzdni3s84bjRvluo
         0dUSDRiQbadQVj6oCfmhP4Wp1zcpXwc8fYgH2Q4Zy5iowkbDkmcOsyfg9Pef2RaXhA+w
         YKvAqG8Y3f8p5sUVpZwoDxZcszicV1geSc0mMkoFnlk+BJHfM6XOZW6aRQLT5OUBwyjE
         iZ/fHZao0/uSWmnJMj1k5qOiPhTkAVbhD0xK0sqOC235lxZVzPAhnFazmUPvVWl29FZF
         LQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gh4t/ycmHZfX06rOPtzSBBl7/QL2eq7+Ab7eP+nK1Ag=;
        b=R7SJW/rlx8lnyvO/3tXyf38gNs7YbZ9gl2e5/wHJr1caM/hpKln7gR+BKz5od93WLi
         I/WGnKP97HwDlG53LUB1zHa/BnD1DK7p3AFa0uk7IlEfgZQ72X2U7L6CTnvSODMvz0aT
         B0301siHM2qKGT6/ArNK2xId6OhZv4AIg0iQ0frOG7cY/Kp5LEej743Pl9O8FYn5B0qJ
         EZroY7haWGDbd3gZbd+RzHvUhdypLQpaVeKF35oX1Sj2J0dX3+CCozp2Dk+AjnAZEssJ
         N0oCyDytvwIQR+cm9IKIbhtChDX80GtnBDXR5cJhsCdfK8NdkHDt1NEYWFXR4uNsV9dP
         7u7Q==
X-Gm-Message-State: ANoB5pl7Lb+eOidevGeYVIbSEQUDG8bEmKe6b00mwdMtW61y3talXdjZ
        Y0GZFKufg6fSEstlJyox6qGTujoQvn6pQM/waTI=
X-Google-Smtp-Source: AA0mqf6yCeUahfm828mBpPgxHZ5ixW6su+6eBlxnLc56cTn9GtE5OqzUEjJYh/IsqXsQUohCinr8OA==
X-Received: by 2002:a05:6a00:1c96:b0:578:451c:84a9 with SMTP id y22-20020a056a001c9600b00578451c84a9mr6647074pfw.2.1671310125820;
        Sat, 17 Dec 2022 12:48:45 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i62-20020a62c141000000b0057737e403d9sm3528761pfg.209.2022.12.17.12.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 12:48:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dylany@meta.com, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: don't use TIF_NOTIFY_SIGNAL to test for availability of task_work
Date:   Sat, 17 Dec 2022 13:48:39 -0700
Message-Id: <20221217204840.45213-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217204840.45213-1-axboe@kernel.dk>
References: <20221217204840.45213-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use task_work_pending() as a better test for whether we have task_work
or not, TIF_NOTIFY_SIGNAL is only valid if the any of the task_work
items had been queued with TWA_SIGNAL as the notification mechanism.
Hence task_work_pending() is a more reliable check.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c117e029c8dc..e9f0d41ebb99 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -266,8 +266,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return test_thread_flag(TIF_NOTIFY_SIGNAL) ||
-		!wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
 static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
-- 
2.35.1

