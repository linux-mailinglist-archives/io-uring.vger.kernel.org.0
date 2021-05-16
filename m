Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07712382155
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEPV7t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhEPV7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:44 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F04C061573
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i17so4393242wrq.11
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6TvB15Wmm97l5SsUwNWRljL4UN1tGudunxUYE3Bw9EM=;
        b=X6qcR4IkPULWQWSwvCcZq7st374dCQ6ACB7+dxDvCjXDuBAgb4MzYa8TFN+YCwH4nM
         xqKrIWSRx8JVtCPl6dnJ/LgbF8nIQMSkQdWpZz0+fO9bKuZD5NuI+A4+Yjubxc/D1Y5Y
         Rptzbh08wivSd0CaJdQqFqyDb66qCgH3kbOL4+/CBmAFIBFNrwQmPup56TAwNhqRmd7s
         dL5iWpnlEylRjDqAvc9Tp84VkhTLrLxHYPuh6kKLFIAUm5CtjU75EO6IgUHo3n6WuNHR
         +R56xtaZP8cfl0sK2Mhu5X5PTsDSSDRjhiP8gZ33ZMc4510WaNqtmUR/OQEtSXmeCOvG
         O1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TvB15Wmm97l5SsUwNWRljL4UN1tGudunxUYE3Bw9EM=;
        b=mJyMwH0h9H2Kjc/3MZkpFAuo9rvQdc8OoMwrfHgcJD/Juzr0VACSaFPothY8j8AI71
         vlWY1/Sq2nPWKIauhfAXDwZh2HYJ8WkefO1YXTDMTvLENynDMofiHob1lofdrTngjFXE
         4+FP2hfXuN0MxfiL6GNGmDH5dmlBquydg82H7ruJXwECayFcFHZ8enWCzvtAxOp26Ihu
         4R32byAcY1RBJ7h8hHalaML5xw+WCSNg5SEwUejEgWKlIgXi5d/6pubcNP6giSDfU7GE
         5tYUC1i3eE/bzU4I7hnD7q3eSZgaqpQTuMcd77DzCB5v3kfbnIP0XDe3bz6S8VrRZ4bo
         v4Wg==
X-Gm-Message-State: AOAM5307WKEe9DYajB1RRSbYaGe1DJxA/ahLB1iCBehOvW84aSKS6i3z
        LPl+lrqxlhbyMPPII4p43N+8jSB2XWA=
X-Google-Smtp-Source: ABdhPJxawONcahXwnqXexFHbetznzvRbaTUH6e7EcTE0WkftT1Wga5zWwjVS9DtadRLlcw+tUgCzrg==
X-Received: by 2002:a5d:618f:: with SMTP id j15mr1176702wru.273.1621202307794;
        Sun, 16 May 2021 14:58:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/13] io_uring: improve sq_thread waiting check
Date:   Sun, 16 May 2021 22:58:01 +0100
Message-Id: <1ee5a696d9fd08645994c58ee147d149a8957d94.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If SQPOLL task finds a ring requesting it to continue running, no need
to set wake flag to rest of the rings as it will be cleared in a moment
anyway, so hide it in a single sqd->ctx_list loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd355438435d..64caf3767414 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6889,11 +6889,10 @@ static int io_sq_thread(void *data)
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
 		if (!io_sqd_events_pending(sqd)) {
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_set_wakeup_flag(ctx);
-
 			needs_sched = true;
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+				io_ring_set_wakeup_flag(ctx);
+
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 				    !list_empty_careful(&ctx->iopoll_list)) {
 					needs_sched = false;
-- 
2.31.1

