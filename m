Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ADF334BDD
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhCJWoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhCJWob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:31 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A219C061574
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:31 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y13so9694697pfr.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnlWTmvZzR454d3YCmWjC6EBvh1B1ejWi+vO/YNiOn4=;
        b=ZroTEFeaL4NLQtJQTjtRIIdlFPDON05cwfCwAgYpSK7YJ0luZ/6qCaxtrJ3plgWqCY
         dBGqHjNHxM9M0405YvysJrUHWUYvx2jobROarlB+RB2hIE41Unw6kxlhTfQtV5jn0jrF
         MTQgK4aMUnseH/bkXs2erpYMs0e+rDGq+0Myu8Cv2yJ5FJ6XFoTYvMG+FiBD270CGy4o
         DCJ4HzhZcoVvH7yF2X/Tm2xdygjtNOAmWx9JWxVRJ7xll8wDpvsGKrGBPMTS3vROLQgR
         BQwUVjXilT64QL18a27oOoLr2+YwCAM+onZ/mPn+rnuEzU+JWfU4Zb6ThPI98f6+OSEB
         YDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnlWTmvZzR454d3YCmWjC6EBvh1B1ejWi+vO/YNiOn4=;
        b=l9za8/jvHNmViqMNRTAD3vfJFUdpafcZoy0iU+V7R1evyyy4Q4069d8ghJ2wnMqSjy
         aw2Qf4M5Uh81SRwsLQIqVCRt35F6jSA4X8/AsF7vNR2qCeR9uNQzjoeQj84f1qgGREJI
         XeMdrXyX6F4a1NVzrpRuwespy3WaydWynETpDks44vwzQU+6cE3uhRvuy3AFZjbvO4p3
         E0dD/7FjKcQ7Bs2T/0EE+IKRMVrfctaAD3AALUKPHtOmT9v3xpcjZNkv3XrUT7yQwX70
         U1ULMxYyJl1/Gxq1c+2Cw+dN0T+L3ht6KTDqWiPos0G4/Dz5SZC+W5JKExNeC3JCzsGC
         mfxA==
X-Gm-Message-State: AOAM533XD5P28OXh09tKaBKCktyjAWQ5d6OMx3rZHwS8cWxyrdvmAkMA
        ZVSGvDckgjXt+y33PTFATL0JbI4InXd47A==
X-Google-Smtp-Source: ABdhPJyMAtChRaLkEJnqDG0mnTAk5ohgMoch9yktCaXeiOoiYgHPEX/z8iPK4h1HtwIl0rzIZd2BnQ==
X-Received: by 2002:a63:c248:: with SMTP id l8mr4699864pgg.136.1615416270332;
        Wed, 10 Mar 2021 14:44:30 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 26/27] io_uring: fix invalid ctx->sq_thread_idle
Date:   Wed, 10 Mar 2021 15:43:57 -0700
Message-Id: <20210310224358.1494503-27-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

We have to set ctx->sq_thread_idle before adding a ring to an SQ task,
otherwise sqd races for seeing zero and accounting it as such.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14165e18020c..7072c0eb22c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7829,14 +7829,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
-		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
-		io_sq_thread_unpark(sqd);
-
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
+		io_sq_thread_park(sqd);
+		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+		io_sq_thread_unpark(sqd);
+
 		if (sqd->thread)
 			return 0;
 
-- 
2.30.2

