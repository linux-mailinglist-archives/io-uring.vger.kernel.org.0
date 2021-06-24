Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9073B30FB
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFXOMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFXOMo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22553C061756
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j2so6805707wrs.12
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=K7SwuMAkjr3XlJrYld07Rja8ftqfj6qa08J2j30C8Is=;
        b=cWFTyoPYPMRklDY6DqPUIg8EPYAqCL8GvwLO2Tl/b43PCKckiXHTkGkCcnHH+yqczH
         OOr7IFIXShpG1X5XyjB9Kvyqb5jvBOqDapAKGFxKJROsg4Y8Y37e+J/1cqHOkoBGvYyL
         Gpc/VsLhbbzqq/KuHnhLVYRSCZc55+gI++Ckbb695iZXFNFrI6e918W9s3Pn+k8ssysf
         nweigcTFY30f1Emf0B2HGElQYi4NAhlggVhzedIUrx5cRHu5GJbbzvlBBfl602+Lp8wD
         x1S1PYa1F+DKqg7KeoAym1g9qBpCVmHfEDdCxZLE9uisGCVHZ/qMOiJFnro4ZogEmt9X
         Nfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K7SwuMAkjr3XlJrYld07Rja8ftqfj6qa08J2j30C8Is=;
        b=KHWomIDg78bQ1gOBtFYHAVnY3318R9NHZkhnK+p7EiLcWILM2xZu2eeBvL+3XYL/zO
         bTi146TIIn/TIif2ZcXjF5VgId4kQsas33okHbAZNbD+Dbgt3+0FTcvJSFOgItptxSN4
         aZ7g5vTTuwOI/Tt9ncREzdoWk9jWx+5a5+IAdl5uS0AfzfgUFcQRaGFF1e0KqaImf3ZN
         btB0drD5DKlukBk9uL8btqpHsztoWCesWRSiOC2W2uwTjA88aPXsErZDL0U0gAcfjcYX
         IHpobS9Kmdenv/Q2mRE4E29taoW3h9EZNn9/f2hRaEKtyWegeGlh/oaNAGR3CYGGQ7cv
         eJbg==
X-Gm-Message-State: AOAM533Ykvj23S/LQlh8P5SpFoRtHT9D5BZzrFlZztg28K8rNF23oOVU
        bAngC4P8SDnAuu1r9+U6xMc=
X-Google-Smtp-Source: ABdhPJyOwT6L/zfaFv6e0E40kAX4s4xYnvTxLzWL2ZowW0LRiHkxFKnv3oYgwnztv1GrHaSQWt9mUA==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr4669305wrr.188.1624543823747;
        Thu, 24 Jun 2021 07:10:23 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/6] io_uring: don't change sqpoll creds if not needed
Date:   Thu, 24 Jun 2021 15:09:55 +0100
Message-Id: <c54368da2357ac539e0a333f7cfff70d5fb045b2.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQPOLL doesn't need to change creds if it's not submitting requests.
Move creds overriding into __io_sq_thread() after checking if there are
SQEs pending.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14a90e4e4149..cf72cc3fd8f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6999,6 +6999,10 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 	if (!list_empty(&ctx->iopoll_list) || to_submit) {
 		unsigned nr_events = 0;
+		const struct cred *creds = NULL;
+
+		if (ctx->sq_creds != current_cred())
+			creds = override_creds(ctx->sq_creds);
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
@@ -7015,6 +7019,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
+		if (creds)
+			revert_creds(creds);
 	}
 
 	return ret;
@@ -7066,7 +7072,6 @@ static int io_sq_thread(void *data)
 
 	mutex_lock(&sqd->lock);
 	while (1) {
-		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
 		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
@@ -7079,13 +7084,8 @@ static int io_sq_thread(void *data)
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			const struct cred *creds = NULL;
+			int ret = __io_sq_thread(ctx, cap_entries);
 
-			if (ctx->sq_creds != current_cred())
-				creds = override_creds(ctx->sq_creds);
-			ret = __io_sq_thread(ctx, cap_entries);
-			if (creds)
-				revert_creds(creds);
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
-- 
2.32.0

