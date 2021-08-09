Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E43E4541
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhHIMFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB63C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u1so421771wmm.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ht2d7/XYv7uvaw97KZYMhjBCD4h0Y9bbJKcSMrmeo6Y=;
        b=HureMIxriYJTHl38bBRVT39XP+9Kz47BvE/EYB2/FLrR9tBe/eoYIrOZ2jmD8ZqPND
         K9m7vc3NyxN22WJUFSQsU8TgKTk9OHpzrF6yz8V5GPUI9zIBCwCLUUoFPSLXJD6HT1Wu
         21biMmyNIO97aPGZJTPUsZjJzSFsu60BItfdzs5U/EsOFnjm2Nq/51bin4tHDQhBJTzI
         oBPROzvuBKc6TRelZ4RL+TXSxGQAyEtmkJFWhekcpJGD37m98Gg+4J9Ra63al8BXqwrk
         nxNkGoC9gvkN4xmLKnIEROnYzc5GNBSOxDAmvLNwlWi9nSjjJWvukcUAMHhZS2DKY3Zc
         aSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ht2d7/XYv7uvaw97KZYMhjBCD4h0Y9bbJKcSMrmeo6Y=;
        b=KeIOpEM2Uv5E8JWCi/AZ6S3Ai3ZUHZTJCJW7flE0neCTc6r4Dg0HPz4BmVzS6MXmC1
         yBlX08qdiB/03vGMMIEo1/E73wiV+/AkvaA79RyZEFoOHWcF1H5C7L5k4J3PT3nfa1qj
         twVQG/3M816ay+zau0VLYvG55RAJouTsbxUMZj/CSuv4lI85UAcaGfDJsTcq8EUZojbt
         pw74k0eNHo8wxXRkQrVhVZ0Hvl9QSe76hheGhuIALdR5o4E6zyFyUTZxdlMsxcmRPVwO
         R0Y3BwfsHGD6R6TbwSvq4UlyJ7bg4Wgv+VmH1F311x81JgIXLrcbX9mGzrKLMoyWelRX
         1IYA==
X-Gm-Message-State: AOAM532pyLoev9s+ZctgGyzzroSSkA5VfBiDCTEbyf9QqbmRcHBHKdr8
        NIyslARhDxgrggoM/BS8iZY=
X-Google-Smtp-Source: ABdhPJy4C2VMIfnU0F05aGgjOiwI3bzYiM5oBOq4rAalUHRpGFkpJqn5fPjz1LICTLJ6peB0gabPsQ==
X-Received: by 2002:a05:600c:4105:: with SMTP id j5mr33570357wmi.86.1628510718936;
        Mon, 09 Aug 2021 05:05:18 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 17/28] io_uring: improve ctx hang handling
Date:   Mon,  9 Aug 2021 13:04:17 +0100
Message-Id: <9e2d1ca81d569f6bc628af1a42ff6663bff7ce9c.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index cbd39ac2e92b..a6fe8332d3fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8800,6 +8800,7 @@ static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
+	unsigned long interval = HZ / 20;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -8824,8 +8825,11 @@ static void io_ring_exit_work(struct work_struct *work)
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

