Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E04403CB1
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbhIHPmr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349628AbhIHPmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:46 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F8AC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso1966472wms.3
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GEOOH2faZRUhmLSbk4VOHRr0WSWLU+IWnH3o1SmCsvE=;
        b=iExMosD8/ZA0OFQRWoa8RPBgCIkWcrlliJ6ZtW9+Z2jcdxkluMRij+d7tOX2r/XSTJ
         WJEnMbdeb3/RUW+ewGs0q6gvsU5JOUVruHqRopW8dylM+7ba94KRJNSViGy4GL8Rfn3g
         bLtffzdl/2ND6/6WjjFt/A01DhvX6aMhLe0y5J7mE/Iw79YBE9nsjtnPtEhxyVCrsKtg
         9k0BkRUsBG22E4i8C/bsCQyLjc9BeEpxyTNcGpvUAkXsqzSv0wxqfoAfdOeIaTu7R4Hk
         SqgwyX0RmEWmblj82atdA0C+oUN1EwUOrF9gcWLvy234d1+8lOrJvoY65MexrNDy2z53
         N0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEOOH2faZRUhmLSbk4VOHRr0WSWLU+IWnH3o1SmCsvE=;
        b=NAe3o91ToRqejw4JwHpssXnwZGWMuGUNhvLsJRb0fI+g6mIXnFtxldBorz0pEYwHzJ
         sXxASvk4eehf+OxnCI5k1gVppCMUrwo/hRhFni0mZ/VezFWeM4xgeI3hS0zbMg/07zfc
         /RRo5eucgAmwljKzlLt42l/cjviSpIi6zdnJ+HbyZMOk8CAF5pA05hYABQgx6DVsU4XA
         9cdcBFugYi+XNadQmzF6niW8AEzV/NXegf4ytF3HEvPuo7ejoe8TehElanXKWMKtZtX0
         WOF2PHBxOQlR5h6AU+eHlM61X4X5Hp/INcBMrAIdUhQJfsmZyuRpqGTbwhGblv2klrZw
         VH0Q==
X-Gm-Message-State: AOAM5321RsCBmR+xtnPCKxRcPjblSENtWBe94cb0RxR5inWIn6vmdkbk
        K4EdRfvJaMdIh+qrlU1ujpaTrC3F+h4=
X-Google-Smtp-Source: ABdhPJzwch62oavaMms3CddUY+CdunrghnbIDxaeFFw+1qbmh+/zwiy9WGaR4v+o6zZjlGnmfOfibA==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr4377523wmq.98.1631115697120;
        Wed, 08 Sep 2021 08:41:37 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: kill extra wake_up_process in tw add
Date:   Wed,  8 Sep 2021 16:40:53 +0100
Message-Id: <7e90cf643f633e857443e0c9e72471b221735c50.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631115443.git.asml.silence@gmail.com>
References: <cover.1631115443.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

TWA_SIGNAL already wakes the thread, no need in wake_up_process() after
it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d911f8808bf..9dfc243ade9e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2196,8 +2196,9 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	 * will do the job.
 	 */
 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-	if (!task_work_add(tsk, &tctx->task_work, notify)) {
-		wake_up_process(tsk);
+	if (likely(!task_work_add(tsk, &tctx->task_work, notify))) {
+		if (notify == TWA_NONE)
+			wake_up_process(tsk);
 		return;
 	}
 
-- 
2.33.0

