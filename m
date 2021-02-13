Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B891031AD03
	for <lists+io-uring@lfdr.de>; Sat, 13 Feb 2021 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhBMQPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Feb 2021 11:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhBMQOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Feb 2021 11:14:53 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536C9C061756
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:13 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w18so1508864pfu.9
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XNy3L39NaS5zKAhFdXyMrryqgLpbpXOgLTjoN6Nittw=;
        b=eCazHStzPipprWG/XuJO9huQ2EHOOS20RBrohGIgMP37/T76/4MG7e4gXsOk3mRl5/
         CmsheprRsX3NrTAZGXv8THRvZPIW8jksmbr4HDzgiCpQnG7toU2/IJ4mAtzdmZA8DKbx
         gQfTQXAhqsriPO3IqMngzG92Abxytzfa5uPbH3of8qQoEyPuqtejzVfAmmQku4EI+Glq
         QckTh0/o2Q0oHqeiqxoc7hPXVCo2bxmu/MDsaptnKdKM1iLgVibOX/+kCsVpVZMz5BV2
         74Mquno+yHnc6thP0yoNAhJqWd/cvkS4PxRPVfqArZDxzFtBMcoAJO09fFtLoiMYwKyN
         qavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XNy3L39NaS5zKAhFdXyMrryqgLpbpXOgLTjoN6Nittw=;
        b=Mo4xP7MF+iwXwEMCgUYcmvWaws+91tMBTK5j5k5ysHCIIpVl9ME1rscUkzNL1TWs9/
         l690WkV4eYLXAWwKuviUYi0LqjRykfUgeeBD202iZuzjnopr07HbYf174rTdFsXkfmv3
         aFNKioGxU/0lsdeXTZ5KUY9Iniu1bBMDVUm/d9zX8mJgKu/fAFfk0dmV4gbd5xVD2snZ
         BehiRjyvMM5C+RxiGi5I7laLq6Bqw6D8DIkldZcjl/Acel1g22poR+izOoLAKcKLJ0fc
         /mLxdk5iGOlywD6nZ4efM6/NgjvgVSmWGeeXUKrOPQ0WQ68CI+mSVM54Iu72pKRMZ6hY
         nc5g==
X-Gm-Message-State: AOAM533NBRczVUpXujaKxongmNUIj/XzOSr3DCJfILKUOCOI/+NqrDC2
        k+COieE4XOYxyVReSH7TBKgk0XeE+fZKYw==
X-Google-Smtp-Source: ABdhPJyn/2ZLnTKw5cH4e/7Yh/5BYYLwO2OB2FA9ezKNWPY3WN+flpAHfPZaD9JtRilA63EJyF2FJg==
X-Received: by 2002:a63:5023:: with SMTP id e35mr7906390pgb.56.1613232852324;
        Sat, 13 Feb 2021 08:14:12 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 124sm11984975pfd.59.2021.02.13.08.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 08:14:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: allow task match to be passed to io_req_cache_free()
Date:   Sat, 13 Feb 2021 09:14:04 -0700
Message-Id: <20210213161406.1610835-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210213161406.1610835-1-axboe@kernel.dk>
References: <20210213161406.1610835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No changes in this patch, just allows a caller to pass in a targeted
task that we must match for freeing requests in the cache.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e8cb739c835..9cd7b03a6f34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8681,12 +8681,13 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	idr_destroy(&ctx->io_buffer_idr);
 }
 
-static void io_req_cache_free(struct list_head *list)
+static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
 {
-	while (!list_empty(list)) {
-		struct io_kiocb *req;
+	struct io_kiocb *req, *nxt;
 
-		req = list_first_entry(list, struct io_kiocb, compl.list);
+	list_for_each_entry_safe(req, nxt, list, compl.list) {
+		if (tsk && req->task != tsk)
+			continue;
 		list_del(&req->compl.list);
 		kmem_cache_free(req_cachep, req);
 	}
@@ -8742,8 +8743,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
-	io_req_cache_free(&ctx->submit_state.comp.free_list);
-	io_req_cache_free(&ctx->submit_state.comp.locked_free_list);
+	io_req_cache_free(&ctx->submit_state.comp.free_list, NULL);
+	io_req_cache_free(&ctx->submit_state.comp.locked_free_list, NULL);
 	kfree(ctx);
 }
 
-- 
2.30.0

