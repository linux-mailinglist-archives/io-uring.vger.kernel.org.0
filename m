Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418C2F82B4
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAORmd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbhAORmb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:31 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A772AC061795
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:39 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i63so8134364wma.4
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IbsXg97Fyw+B4TEWyKuwokJYEKTWUw5NVmfxn3+IGWw=;
        b=i4R4b4VWVbiS/VOtcyxVY3mTeOoi6T1EnC2ry36lkSErf5KKGA8RlvHfyR4g9FJq53
         T6DCo3WHiN6qGmBmleeFRsWzF/Gk8xSipSknEqU7immF8GmUU0RjdAJFO40lOVGE/ynh
         a3tX3fzlLGoYMaIcfSRtFbEOACr1ffTVy5Muo+IFVDBb6gxRl5oaXpkrvx29lS7/2ILx
         XgsGhuBpLCyi0RtRx3tLTNRmbvb08EN9/4omLOVcbJttgBs7vw9mrvfhhRD62X6KyiM5
         94zc4W36XA73hIdaXqVxNMDrSpcknhuJdEpZEuUosoiCDmgAZM9NXgy44iKhToWTwW+Y
         FtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IbsXg97Fyw+B4TEWyKuwokJYEKTWUw5NVmfxn3+IGWw=;
        b=ZuogcBB4SlKIHB5AY2nLpGlu6Sv0eK8z+GDWx0bxU1O1HAERPtBahbE0dexgRzDVzQ
         350gyw+/j2g9+42BF80V8sBzp13PLig5s0t6/8bh4GpisVdN7+7hhzEC6DsqOLVRQraQ
         QgGxd3rNZ3zPtJMXZteErhio3QO1IYrl/KhHC32UjADlNUjYRmk/KDRQwrLO9RW5YevG
         K3fMRGolIsl4jUoVbIS+az1NcvAJVWZYmgIEUlVvL+yWpljZSYyVYrjEOfeaXtwCvO9S
         Yg6yB5pAZwQsTCFQNVNMCIo6SZvoXKH4UDTpx1/uturBQnYFfNw0MidczAeS5J3KKSb+
         TlTA==
X-Gm-Message-State: AOAM531epjgQRn/5UyV2ylGNRza753dpuG058R0wR8jrLlLcpbLtX4I/
        zF53u/lSyRsir8JC9/AASlN1JZaWCpE=
X-Google-Smtp-Source: ABdhPJwO1PLX5prawLmYTb8CVnub6gavHR1yoGVO0z6GuNSPWxSkfrfqpRc5S+nfuFsCf355JUYePQ==
X-Received: by 2002:a1c:ddc6:: with SMTP id u189mr9914762wmg.172.1610732498509;
        Fri, 15 Jan 2021 09:41:38 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 4/9] io_uring: add rsrc_ref locking routines
Date:   Fri, 15 Jan 2021 17:37:47 +0000
Message-Id: <47dd0cf012043678d2b066b3d92580043ff7c76e.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Encapsulate resource reference locking into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b46710e88c35..6eeea8d34615 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7274,14 +7274,24 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
+static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
+{
+	spin_lock_bh(&ctx->rsrc_ref_lock);
+}
+
+static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
+{
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
+}
+
 static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = ref_node;
 	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7298,9 +7308,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7690,7 +7700,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7702,7 +7712,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
-- 
2.24.0

