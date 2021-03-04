Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A549632C9A5
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbhCDBKE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355772AbhCDAdh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:33:37 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F8C0613E9
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:23 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id s16so15045161plr.9
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKN9u53G4zeydtvpEl9PiMxLYSgsXopkghSUc88bEu4=;
        b=kOJKnoHFjZgKcMlMsvl4SUgxdbSflRpERgq2IhjZSPWwf3F7o2UjFIuiLJSNeAGosj
         PM08x1poej1yeowwUuEirupap3HJf6JIq5WwfRFRLezV4o6AbM+Y23uFMDhDMroukIkF
         byUvl57CVuY7+u7kgl0hiKMwNdPIqlNOBfJlIKxuJYYv/lAHDfYnEvT43MngZAvPGTnq
         ThX5ZqtYcQ4H4pGQHUfcKbc/wcdVh1QtyGT5ivarJ9LC3UCpCSbJow7e6/nSenWQz+JK
         TJoFth7s1t5shijslzCIMrLb0v1QPzCPjVjKAXuHB8LKeNUFpPgINgyZc2mqhPweeQ96
         njjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKN9u53G4zeydtvpEl9PiMxLYSgsXopkghSUc88bEu4=;
        b=YVipyDMj2l3LeHkE8jqlVyv74de1NM/UoVrkC7BhnQI+9M73ZsAQ15QX5MGWCdaAWU
         2m3vPkJVDJlPHHHsqvQH9BoDXY3jctI992Vhp1cHH+ZJRUo64By4uSpsujSLbLz/OOQC
         E//gghTTO9WjxJaa7QF8gHD4KmvO3DBxMPOZMGBgZjSybvD1/D13UrdvkGUWP/aBK3R9
         BexCwMqowXKAgzE5lHn9u3b9KSi/Bvym0l8GVnilizQTVd+BqriZYibs2WGMzfkdkkLS
         yFPfjWe2huWhKe2w/BLdnUARNX8R87kec2cw2IoqYz+f7Ss30WVnvl3FgxmSflfSY8Z/
         1cjA==
X-Gm-Message-State: AOAM530Dm6vPY18vcbdRBnCYgNWz4q6CmUnAZx21olRTJ0ITp62m/Zap
        Q63JT5I56MtXw87sYK0oMNcyKrcMbwTdQ532
X-Google-Smtp-Source: ABdhPJwVQYoWHlCNektLFoxDs8JWt2zv+pfzv8JEBBDQtYillJwoR1c7rWDIeDt16HVzfxiculQejg==
X-Received: by 2002:a17:90a:31cc:: with SMTP id j12mr1568241pjf.203.1614817643237;
        Wed, 03 Mar 2021 16:27:23 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/33] io_uring: remove unused argument 'tsk' from io_req_caches_free()
Date:   Wed,  3 Mar 2021 17:26:42 -0700
Message-Id: <20210304002700.374417-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We prune the full cache regardless, get rid of the dead argument.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4afe3dd1430c..fa5b589b4516 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8395,7 +8395,7 @@ static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
 	}
 }
 
-static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
 	struct io_comp_state *cs = &ctx->submit_state.comp;
@@ -8455,7 +8455,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
-	io_req_caches_free(ctx, NULL);
+	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_hash);
@@ -8987,7 +8987,7 @@ static int io_uring_flush(struct file *file, void *data)
 
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
 		io_uring_cancel_task_requests(ctx, NULL);
-		io_req_caches_free(ctx, current);
+		io_req_caches_free(ctx);
 	}
 
 	io_run_ctx_fallback(ctx);
-- 
2.30.1

