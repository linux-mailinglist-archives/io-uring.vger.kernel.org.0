Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC83ABA64
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhFQRQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhFQRQx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:53 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E82DC061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j18so3744528wms.3
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3ZJri6LhV0WV3gdp096U7qnTXrMTCBsa58/9gR/Qtyc=;
        b=olar5Ukh6L0iDKYOFWT6eFNQlWr3OzFO73FhJFtEDBlk1dejtSxNVidKUX0HmCQrql
         AOtJBJGpel5El+0X21EYON+dwuy9bYf1djZ2GfYkXjYyCuboMRGd7qQ9ixgVw8xTdAwZ
         IyT3A53SOnAcOPh7ajgAI3TAvLpeNhCobFU5Ns/0Yf5i2oBRvr9nKW42SkKTRc5YIyGt
         qTUJ2QOzexpXSF7WNLMFlIiRGpBTwc3v5CvCmALnegHTYX0UrHnscQcnE2ZDzbL2eafF
         UUdJMUeDkX30DV6SMhnzMI3tz70QVN4i8COgbUqrivRrwhYyaaTJTjEowIKwq+XtCq5r
         r34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ZJri6LhV0WV3gdp096U7qnTXrMTCBsa58/9gR/Qtyc=;
        b=WPgx+EtsoBOjJsqMGbnSXhQSuGZ43aiKvVs/qpkXxkO7jYsRkmU96y4vKBQLIi4iPm
         vCTO/vjlDJD5bywuDqWL+4bUT8bNOaA8+M2iOGSrwLArUGWsRpUEfY/D03NZPiksoEdj
         A2hKOQOjev8McU21Hb2mGJNdcxGV45hEab5M+tuQ2ShQ2teCRx6gvz8dAIxf6S0S8ZDI
         IYaTHVd6Csl/bhdOmUoxIuclLRiUYsRe+bIDjDh1HdfSBMfK6Hu30Iwa2n+R6Xz3KRfx
         Oe3X0JZ2GsRVqnW+9ZIDfkQjV75suyv9CH4nsIu8NfBKTXO/D/tXLV/51p5Wfg7NIuRa
         uvdw==
X-Gm-Message-State: AOAM530V4aA6ZDH6iZcaF5ILgY65tPFA63K/U8gQCWSleBa1j6+eenH2
        0gdhcVJfm4dSlLeonKdlpoY=
X-Google-Smtp-Source: ABdhPJxb0LKRHaYcts5CcX/QzIJhCpVY6isfp8wvkY6CD8wUK+gi5fewS51IUUGSxDHIc6bn+xmtFA==
X-Received: by 2002:a05:600c:1c84:: with SMTP id k4mr6349409wms.164.1623950083906;
        Thu, 17 Jun 2021 10:14:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/12] io_uring: don't resched with empty task_list
Date:   Thu, 17 Jun 2021 18:14:09 +0100
Message-Id: <c4173e288e69793d03c7d7ce826f9d28afba718a.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Entering tctx_task_work() with empty task_list is a strange scenario,
that can happen only on rare occasion during task exit, so let's not
check for task_list emptiness in advance and do it do-while style. The
code still correct for the empty case, just would do extra work about
which we don't care.

Do extra step and do the check before cond_resched(), so we don't
resched if have nothing to execute.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 31afe25596d7..2fdca298e173 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1896,7 +1896,7 @@ static void tctx_task_work(struct callback_head *cb)
 
 	clear_bit(0, &tctx->task_state);
 
-	while (!wq_list_empty(&tctx->task_list)) {
+	while (1) {
 		struct io_wq_work_node *node;
 
 		spin_lock_irq(&tctx->task_lock);
@@ -1917,6 +1917,8 @@ static void tctx_task_work(struct callback_head *cb)
 			req->task_work.func(&req->task_work);
 			node = next;
 		}
+		if (wq_list_empty(&tctx->task_list))
+			break;
 		cond_resched();
 	}
 
-- 
2.31.1

