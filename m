Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2B351C9E
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbhDASS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDASKu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:10:50 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D359C0045F9
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z2so2104828wrl.5
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4ARJwuNAMMGt+m3kcxOnP2Vzq9zI3Aux7tP2KoVD+RY=;
        b=OCtfEOgImCrtNj1gl+7zC3h+xKfIT6QyobMmQJWUgExLpBjyexnn+166W0WisuYwoL
         Zouck4cm8s4lrhFzq9nVdhtR26ybUZhUZZByM8R3b5Rk04fHU3+PGQXyULV7JaBg4jKB
         zq6uwgMquhu69WG4w85ImCmRyxGeTcq5TJnMRUdjU9NN6b2OQUg61es4zKKOhGZQWDrg
         Rn6EXiACouqZXt+AyvXNkc+DfNCbiXxDfTpDFxt0U/wW50H5GRbWDyAELoW6W2Qt6cqX
         wlXjq6pChWUJlt/AvnDQdMXpNTD2AyPPUs6vDq4mF8/9M31BwLg+ryhYlKwSzfnECyCQ
         4Ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ARJwuNAMMGt+m3kcxOnP2Vzq9zI3Aux7tP2KoVD+RY=;
        b=oKT7WD1AQgmWHAuqke6sx1AS8k5TNFIZ7obAkhZV6j2Mi4uVHGdmVgEy9PGCoJHh+F
         Bmxh2Kbd3cAqSmuysME5A588QiIpoJ3C8q2WW7OZuivQUrhcfnv2ljM+nmZoLLGCXvyq
         5zs/c161wU+cmeera3GRLEYwQkknPYEioyXN8YKytM81i94/A5bzYnZSwwNjFsHSzXoY
         vrcud73K4vwEOqmUxqcZxS/HewytxB7CpjAxgLnfoT3LeoDSB7Xn/S9GvZe4D+W/26dm
         Y6oftLrLb5k67gycaqDUdnU7mtTzIDvOhavSI7zLes8Wf82sZ1WEV8L5HcYWYuGGeBI3
         EYFw==
X-Gm-Message-State: AOAM532heOHEkyvKl+EwccE9MiG2tJ+BpPb54M2o5iipruJ5A1YdGlkK
        9NVsU9/B8ndXfhKGYhfcePzgpJMXRkbGJw==
X-Google-Smtp-Source: ABdhPJxAvPUOMkVbaXcGV+mhneUGvmCWT8TiUvPLO905LE3by4mF+y/8lZGdzUVyFE+4hIPznRV7kw==
X-Received: by 2002:a5d:4105:: with SMTP id l5mr10587184wrp.105.1617288505151;
        Thu, 01 Apr 2021 07:48:25 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 08/26] io_uring: reuse io_rsrc_node_destroy()
Date:   Thu,  1 Apr 2021 15:43:47 +0100
Message-Id: <cccafba41aee1e5bb59988704885b1340aef3a27.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reuse io_rsrc_node_destroy() in __io_rsrc_put_work(). Also move it to a
more appropriate place -- to the other node routines, and remove forward
declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 47c76ec422ba..17e7bed2e945 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1025,7 +1025,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
-static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
@@ -7075,6 +7074,12 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
+static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
+{
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
+}
+
 static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 				struct io_rsrc_data *data_to_kill)
 {
@@ -7520,8 +7525,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		kfree(prsrc);
 	}
 
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
+	io_rsrc_node_destroy(ref_node);
 	percpu_ref_put(&rsrc_data->refs);
 }
 
@@ -7589,12 +7593,6 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	return ref_node;
 }
 
-static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
-{
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
-}
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
-- 
2.24.0

