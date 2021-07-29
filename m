Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60FD3DA71A
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhG2PGj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhG2PGj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:39 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65DC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so4269062wmq.2
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=50Gv/IuERoGx4qq2IxVMxfipCk8jqUvvG+rt9czHmuM=;
        b=iLtn68nVvSx+FQ24JI9hOBFujXpB5SgimUAVB8cSn2uMk7L/4na3/MhZ0FH5ElEQBn
         9QVPJAiF30Mb6JSgViAcxsA/3rPPHeS6zil4FuD28Rosb86i1WEBeKv09f/DJbR6SS8+
         aOQ37jYwVBO+KJzo1rSvVnN0YmJ7zf9yfxBPrOZql0quizBpHzaOqL1rWRWtC01Nlrdf
         j+5LEV7gRdpxod7vKFmeo8SPk6JSXOaUh3/iwJ1+VnKiun4/AjKNJKo/Fu20SL1Mjgdw
         MbA9LHWP6UG12UkXoz7VYbZMaS0zFqseAG7wCCj/sWIPbRuURU4ePTasVfZYLfem2RI7
         Q2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=50Gv/IuERoGx4qq2IxVMxfipCk8jqUvvG+rt9czHmuM=;
        b=b53Pg26I4sVbO4a1hOGGsAdFKpW3X370pmYi8IXwe42WVXrgcZaWlPEJ7i+5wuW38p
         KFWJfzo7NAQTOby1AHxaqfzIX4ParxlShFzmp2CYxiReezC4Ufa9XXN2quzll0/zTpj5
         fc7FAvkpYJTrEp45ft2gVJGkneCEv40Q+RmGIHcpgbgHf9JB3zBx8WlhyL87hxWyEE26
         j0HyfUzd8uSuejp4vPLT9L6aZ/e8kSh5HITlCFEEXwmUkUGcWdSNcLKER2y7qneJlL6+
         h/4uMG1ByU55fqnQ2KT35WxcFYIYn3hvIF0PiQ9POAKZJNsMtscn1dGyPkhJd+Cp3WkL
         LMPQ==
X-Gm-Message-State: AOAM531mUdesMuFm0V0L96JDITU8Wk3iemLPSnDBbA8WRxPY96fgUW5x
        /dPs6Ee1kTjLTcG4K4JJZxzf9E/zFwM=
X-Google-Smtp-Source: ABdhPJymaGfIv3JJhspZZjkwTRAp8GmHVi+TY8nxMX3YyNJqWHqcLq4Z+fXhsd3wmNJ/7L/gMT6hoA==
X-Received: by 2002:a7b:c083:: with SMTP id r3mr5227125wmh.97.1627571193800;
        Thu, 29 Jul 2021 08:06:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/23] io_uring: improve ctx hang handling
Date:   Thu, 29 Jul 2021 16:05:39 +0100
Message-Id: <2d9c504aa9ec1a3cad16e58b08403a781ae49468.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_ring_exit_work() can't get it done in 5 minutes, something is
going very wrong, don't keep spinning at HZ / 20 rate, it doesn't help
and it may take much of CPU time if there is a lot of workers stuck as
such.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ee5ba115cfc..ce56b2952042 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8789,6 +8789,7 @@ static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
+	unsigned long interval = HZ / 20;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -8813,8 +8814,11 @@ static void io_ring_exit_work(struct work_struct *work)
 			io_sq_thread_unpark(sqd);
 		}
 
-		WARN_ON_ONCE(time_after(jiffies, timeout));
-	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
+		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
+			/* there is little hope left, don't run it too often */
+			interval = HZ * 60;
+		}
+	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
 
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
-- 
2.32.0

