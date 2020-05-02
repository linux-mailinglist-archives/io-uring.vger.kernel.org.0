Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1911C2509
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgEBMI5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMIz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:08:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF2AC061A0C;
        Sat,  2 May 2020 05:08:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so9900676wra.7;
        Sat, 02 May 2020 05:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sTEQKCfC6kscetr49ZU2DCacN/huNg4lxXlOUP6nHps=;
        b=qT5VKXn1HcrzDU98HLgL7bXn0a5onZ50ILLhNwLccKXuPGir9nTNqsRSJyShNAT+ir
         Bko59YGFP3Socz0LFP5wyqDpkynR/n1JcY9DoivNY/7wvBG94d+fFA6zkwb036/sSLSq
         5126nmjLxdprIYeegnbMWbNqqU9GxevhSItb8/yKO0P1T8RFqtgrBYfB2ZvJs6SsB/ih
         irK6NQjU17w5JgzCSFvkt5tDhnD41MOa3M0yuJNAUoME8BgZ1peVApEvo3n9Ve0QHMLq
         up0voNLotyt11uGrgVxN5tw7A/a5VQypGW7bcjOVL5AVgenOUILZR8nb0d+Tp+AJc13A
         XE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTEQKCfC6kscetr49ZU2DCacN/huNg4lxXlOUP6nHps=;
        b=TTMRtGpctr1pXoo5l9VtUy9/pFV2jteYfUfpyQ8DjErsCY7Jh3E+RwTpsJtk5rjcSt
         X+IQZ6bTfJBKQjxUy7YD4OQd1yFeQL/MP5whhx45IIVHF2qeVCbkryGlsPWrUHJw+RKb
         kDM5CSf6L5SJFqyfcRR2TPUTTKIb/Hoq+BnXfuTsQS0H5WKBUUMOj+XYA8BDUp/RhYOG
         leQobkL1cNSb+KfBmo8yFOYr2zDVD9ey8NIghyG2gxXJ10LZ0FPh1LrnqoBYMOtcFjS3
         pvbNBH29Kp9CcoZC8Hn27sIdi4viJEGsCzywbpJ4jjyfY1pLZrSqhRpCSKfNTigaJIiX
         erMw==
X-Gm-Message-State: AGi0PuZBiZkvfXvK9oSZQXBDm2hczaimEi7c4I1Wm8so3dkBf/X3tA5J
        zsXThNUPHdoM7Z3lS1ruHJo=
X-Google-Smtp-Source: APiQypKDe/h1BioxGAEOAkNdV+B1SwF+2t4raDge5RIa8hdRKKk8Rh1uVBJLNueoStDEOVC91IYBIQ==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr9128024wrw.228.1588421333498;
        Sat, 02 May 2020 05:08:53 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j13sm8930716wrx.5.2020.05.02.05.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:08:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: don't trigger timeout with another t-out
Date:   Sat,  2 May 2020 15:07:14 +0300
Message-Id: <f3d4f79e055f7f33058d4233c55ab94e6a21927b.1588420906.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588420906.git.asml.silence@gmail.com>
References: <cover.1588420906.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When deciding whether to fire a timeout basing on number of completions,
ignore CQEs emitted by other timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 148f61734572..827b0b967dc7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1102,33 +1102,20 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
-static inline bool io_check_in_range(u32 pos, u32 start, u32 end)
-{
-	/* if @end < @start, check for [end, MAX_UINT] + [MAX_UINT, start] */
-	return (pos - start) <= (end - start);
-}
-
 static void __io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	u32 end, start;
-
-	start = end = ctx->cached_cq_tail;
 	do {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 							struct io_kiocb, list);
 
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			break;
-		/*
-		 * multiple timeouts may have the same target,
-		 * check that @req is in [first_tail, cur_tail]
-		 */
-		if (!io_check_in_range(req->timeout.target_seq, start, end))
+		if (req->timeout.target_seq != ctx->cached_cq_tail
+					- atomic_read(&ctx->cq_timeouts))
 			break;
 
 		list_del_init(&req->list);
 		io_kill_timeout(req);
-		end = ctx->cached_cq_tail;
 	} while (!list_empty(&ctx->timeout_list));
 }
 
@@ -4730,7 +4717,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail;
+	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
 	/*
-- 
2.24.0

