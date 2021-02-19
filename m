Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B589731FFFE
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSUuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhBSUuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:50:08 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19089C06178B
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:28 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id f7so9151700wrt.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pXTyEz8O62usv0oer+Z/NQlk1xyLpAMa19gtzs2H1qs=;
        b=eu+q427W1gk/G1RPlq6MJkJhmHPZAW41lAN4vg/DuYW4+EPMdTuJcwBIYSwFuzWo2G
         xf3u6aO6Y8jJaWcDZ0KXOxSk0iotARS7AXEdAHGQq4A0aCQL6858Fc1DCCUdMGjXDgmp
         kBvwTw2DRq7z6dSBaT23/W+GIBLCghgjNFH7e3+v0BWMaO9yiFQV1HWNn6H6E8mnk/Bo
         xlxvma8m1ksD0NMHu+ekIzyANWiAWx1Pp0kqwlrsHdJOWG9geoB80UJeRYZfDiwX+Xu0
         FVl1uZYHd/RF5WLddnw+Nr1w8lu5Fi0Ww5+nNRoeCZP9NzLD9ohp8VpZy6ngu9IopuiH
         D6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pXTyEz8O62usv0oer+Z/NQlk1xyLpAMa19gtzs2H1qs=;
        b=n1YPuJPQ5BlXtGB0wnBCvE/oXCU3IM9/UXDicRDFiR7CMI22PIuGJGXv5TeLAS9sx3
         gfjlIIG7TR1tHH8iSpbFpph90ixdYCtHvrlmq5Xu8F32uf+8B0zUD3/3C92a9DEX4Nn6
         HSJd6E7wiFbFqOB5DFiIQ6Njgnk6amj5w+rk1M6cHOQD+AHCTA5Am9JE8Aj0AofbvrxQ
         6Dx/UA11cXW91lvaiSROhIuopQf0WhNE2ih3BjANjuy3SJt6w6S3mWR3irFIYekAc7Bg
         ogM8J/aqY9LL1AnSy+E4Me7rXgMnLOckNjKN1kI359TAYAxSnL2anO8ngm/ldti0GZe6
         vEDw==
X-Gm-Message-State: AOAM533T2SVfSIxHvaatM6vp4bj83SYLC0p9DH6zRU9SKKDfk2WVXzTU
        cQQcJPQjmKbSpMXXpzJZ7rC85v+XJhN7bQ==
X-Google-Smtp-Source: ABdhPJyoPM0qxRz9C0asqPGSnuobWoybSrHZKVe0ehy45PcjXY8+2PnKVCf2ITyByhWK6b2SxciWPw==
X-Received: by 2002:adf:fdd0:: with SMTP id i16mr10765314wrs.215.1613767766830;
        Fri, 19 Feb 2021 12:49:26 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id l17sm3207298wmq.46.2021.02.19.12.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 12:49:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: keep generic rsrc infra generic
Date:   Fri, 19 Feb 2021 20:45:26 +0000
Message-Id: <ac03a75f46c07a6ed18a02dbed3a8f2e35271f3d.1613767375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613767375.git.asml.silence@gmail.com>
References: <cover.1613767375.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_ref_quiesce() is a generic resource function, though now it
was wired to allocate and initialise ref nodes with file-specific
callbacks/etc. Keep it sane by passing in as a parameters everything we
need for initialisations, otherwise it will hurt us badly one day.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38ed52065a29..f3af499b12a9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1036,8 +1036,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
-static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct fixed_rsrc_ref_node *ref_node);
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 static bool io_rw_reissue(struct io_kiocb *req);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
@@ -7330,11 +7329,19 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 
 static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			       struct io_ring_ctx *ctx,
-			       struct fixed_rsrc_ref_node *backup_node)
+			       void (*rsrc_put)(struct io_ring_ctx *ctx,
+						struct io_rsrc_put *prsrc))
 {
+	struct fixed_rsrc_ref_node *backup_node;
 	int ret;
 
 	do {
+		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		if (!backup_node)
+			return -ENOMEM;
+		backup_node->rsrc_data = data;
+		backup_node->rsrc_put = rsrc_put;
+
 		io_sqe_rsrc_kill_node(ctx, data);
 		percpu_ref_kill(&data->refs);
 		flush_delayed_work(&ctx->rsrc_put_work);
@@ -7349,13 +7356,8 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-
 		if (ret < 0)
 			return ret;
-		backup_node = alloc_fixed_rsrc_ref_node(ctx);
-		if (!backup_node)
-			return -ENOMEM;
-		init_fixed_file_ref_node(ctx, backup_node);
 	} while (1);
 
 	destroy_fixed_rsrc_ref_node(backup_node);
@@ -7390,7 +7392,6 @@ static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
-	struct fixed_rsrc_ref_node *backup_node;
 	unsigned nr_tables, i;
 	int ret;
 
@@ -7401,12 +7402,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 */
 	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
-	backup_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, backup_node);
-
-	ret = io_rsrc_ref_quiesce(data, ctx, backup_node);
+	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
 	if (ret)
 		return ret;
 
-- 
2.24.0

