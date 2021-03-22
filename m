Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F272834367F
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCVCDV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCVCCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:49 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0DAC061756
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:49 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p19so8589715wmq.1
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U0DFVF2PZSqfCZ5n0bZ6r+M5weL2a92ghPvc66xdypY=;
        b=CFntpXtCh4NtSNDJuPKNN/9VMWKlQjCL4wxRDsUGno6H5ADCnTg9VMr7CZ2Ck+AbNa
         Htnu0p/Rf3de6NIWhUiwt5Z66SIA0qbYV5SCGKTsMeJZtGvVrTBQEXWaTemX/uqanGqB
         JUc2QYxEjNZjblLyfjofE0EVjgbbZAXxbv9iwpwQdGnOROpSlVIL1JBRYW/UMGfLLiLM
         zn0EIpwShtWAcNgBg+4hchnKlJwJTw12DfrGWo30495pQJL9Dr2GmFsZCszj3J2AcBrn
         vw5gBGyvJqcbwpK7pbaSoi3D8W2ARtUlrxVwk339VVmITT/iDUCuc8SwQA5EbZh1DkbL
         4lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U0DFVF2PZSqfCZ5n0bZ6r+M5weL2a92ghPvc66xdypY=;
        b=pqgsJC6NtcOiP+bEytxH6DurwYcLeBrFkh89EtR1/BwD7ydyR9iSHDbsrLBxdEyidS
         M16kTOITgkWy4l0sleca6P9G/Cgcl4S9oBz11tN/1efHRKhs6vo4mbJBTMD96/h1Dj6O
         SFwyC2fl/juAXlO4UM7TwNX+6f8psFxE2hz+zV8qQc1yVrI85QV1juQdZBUptHSJoIRR
         iQxzNL0ptG+GPUj/HSYYkq1+oe7BBmEV1xDWVqCoGw3QKJ/yhQoz5Bs/vtag58QytXQC
         ERy3+e2sWv4PLWMX29OyCHJziN5Rw9GH1th074m17RIg7LWmilh0uKY+Z+O670jiwMZ6
         kIpQ==
X-Gm-Message-State: AOAM531Ba6sztFje/JeLVAfFgQWg+QtdnrUN3DigAcTB8rXVpJSMmZHf
        bBm4v+hfTc4iGGC7UKCNyq4=
X-Google-Smtp-Source: ABdhPJxQin/JR97XjhA5CU8A5wcPTQ1q7cV+c2vecPGzmLETh4aZl7Fz1wJPJg8FCFJeECvsvlsEkg==
X-Received: by 2002:a1c:ddc6:: with SMTP id u189mr14084601wmg.171.1616378567980;
        Sun, 21 Mar 2021 19:02:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/11] io_uring: kill unused REQ_F_NO_FILE_TABLE
Date:   Mon, 22 Mar 2021 01:58:30 +0000
Message-Id: <c24dfcb0ea0b7877169d740f163f708e5445d13a.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

current->files are always valid now even for io-wq threads, so kill not
used anymore REQ_F_NO_FILE_TABLE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8609ca962dea..b666453bc479 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -694,7 +694,6 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
-	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	/* keep async read/write and isreg together and in order */
@@ -736,8 +735,6 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
-	/* doesn't need file table for this request */
-	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* linked timeout is active, i.e. prepared by link's head */
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
@@ -4188,12 +4185,8 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		/* only need file table for an actual valid fd */
-		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
-			req->flags |= REQ_F_NO_FILE_TABLE;
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
-	}
 
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);
-- 
2.24.0

