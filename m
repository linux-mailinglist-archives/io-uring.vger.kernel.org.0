Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA4554B371
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiFNOhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbiFNOhq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7EA17593
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so117423wma.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D8sFDmp4NCj8bAwGZ38Oxd60P7D2GVHJ5ZCu/JRHls8=;
        b=JQ2rUzbbr6ynGLDV1KXga1yA3VViPP0IkuWyTwsxl1m9u2O6ZXLFBm+sdNI5E/Eyng
         2SMcLPBd5kS8UHwOm4sLwQ/QxN8F2vZx5M67y8g+LmDBmuE+T6fF85rVzKgT+Rgm10J5
         lKv3wuKvO2UjuOhFiRTax9MlU+loKoJmNFzK3qS9ahmcGlT7l4MsJxM1jcddRkziHx3c
         DuaoJwgJLSuuDKU3zYHJfAGwMJJIL2RH8KFaXB1UnMu+TEbs8KWBOxiYbVV3vGRhIdZj
         mMg+NAy1xFjVvJTRKaTMEMBO+mmt/+HD7FuWeGTXcB1ukJ484uMmWo9L03AOPXUHWAQM
         5MhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8sFDmp4NCj8bAwGZ38Oxd60P7D2GVHJ5ZCu/JRHls8=;
        b=gQb+N3WRNyB9dG+qKbuhKIoWxKrbYDxeJ8shw97z7M9V57U069APqmcN9KQmp6QE/K
         Y2V1oJW9lexDujHbth4ChQlUnMEOSrnvcLuAZZjvOLcAlxgYO9qR3EB4JFkZ3C+o6ICh
         MX3Yr18D2kvRqcV2FgDqtQfYRoPGDGhVNK419CasYA0YAYcpCfUSkKPYZOPESg4Wpqrq
         fcgT4lNLxmzVCdVsCQdnChikhOk1LcRLcH+gyWuAWifpl9fmSwsDUYtiTTAxAshObvwF
         HAyFbdIk8uzHJpgSwWT9TTx4ocquuQ3tTHZSAnLjUrU9IwaQQSOugsDaCaA3TsRN2XkW
         aRFw==
X-Gm-Message-State: AOAM5328vlOFMULu2GtZ/bn+0KUUQ7CXLTLpXDe+gIaAXfZrRLNK+FdC
        IjIektou4s2ES+ZAo95ru0azi/GG+SEYTw==
X-Google-Smtp-Source: ABdhPJxBzELWc5rfW1QCUhZqBMPfwwwSPUPSZGvdm656ldCCjLnZj+4UJ9sySXUJITYHq5SBYmqMPw==
X-Received: by 2002:a05:600c:35d2:b0:397:84c9:6fe8 with SMTP id r18-20020a05600c35d200b0039784c96fe8mr4499873wmq.206.1655217463376;
        Tue, 14 Jun 2022 07:37:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 04/25] io_uring: refactor ctx slow data placement
Date:   Tue, 14 Jun 2022 15:36:54 +0100
Message-Id: <c600cc3615eeea7c876a7c0edd058b880519e175.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Shove all slow path data at the end of ctx and get rid of extra
indention.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring_types.h | 81 +++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 4f52dcbbda56..ca8e25992ece 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -183,7 +183,6 @@ struct io_ring_ctx {
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
 		u32			pers_next;
-		unsigned		sq_thread_idle;
 	} ____cacheline_aligned_in_smp;
 
 	/* IRQ completion list, under ->completion_lock */
@@ -230,23 +229,6 @@ struct io_ring_ctx {
 		struct list_head	io_buffers_comp;
 	} ____cacheline_aligned_in_smp;
 
-	struct io_restriction		restrictions;
-
-	/* slow path rsrc auxilary data, used by update/register */
-	struct {
-		struct io_rsrc_node		*rsrc_backup_node;
-		struct io_mapped_ubuf		*dummy_ubuf;
-		struct io_rsrc_data		*file_data;
-		struct io_rsrc_data		*buf_data;
-
-		struct delayed_work		rsrc_put_work;
-		struct llist_head		rsrc_put_llist;
-		struct list_head		rsrc_ref_list;
-		spinlock_t			rsrc_ref_lock;
-
-		struct list_head	io_buffers_pages;
-	};
-
 	/* timeouts */
 	struct {
 		spinlock_t		timeout_lock;
@@ -257,30 +239,45 @@ struct io_ring_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	/* Keep this last, we don't need it for the fast path */
-	struct {
-		#if defined(CONFIG_UNIX)
-			struct socket		*ring_sock;
-		#endif
-		/* hashed buffered write serialization */
-		struct io_wq_hash		*hash_map;
-
-		/* Only used for accounting purposes */
-		struct user_struct		*user;
-		struct mm_struct		*mm_account;
-
-		/* ctx exit and cancelation */
-		struct llist_head		fallback_llist;
-		struct delayed_work		fallback_work;
-		struct work_struct		exit_work;
-		struct list_head		tctx_list;
-		struct completion		ref_comp;
-
-		/* io-wq management, e.g. thread count */
-		u32				iowq_limits[2];
-		bool				iowq_limits_set;
-
-		struct list_head		defer_list;
-	};
+
+	struct io_restriction		restrictions;
+
+	/* slow path rsrc auxilary data, used by update/register */
+	struct io_rsrc_node		*rsrc_backup_node;
+	struct io_mapped_ubuf		*dummy_ubuf;
+	struct io_rsrc_data		*file_data;
+	struct io_rsrc_data		*buf_data;
+
+	struct delayed_work		rsrc_put_work;
+	struct llist_head		rsrc_put_llist;
+	struct list_head		rsrc_ref_list;
+	spinlock_t			rsrc_ref_lock;
+
+	struct list_head		io_buffers_pages;
+
+	#if defined(CONFIG_UNIX)
+		struct socket		*ring_sock;
+	#endif
+	/* hashed buffered write serialization */
+	struct io_wq_hash		*hash_map;
+
+	/* Only used for accounting purposes */
+	struct user_struct		*user;
+	struct mm_struct		*mm_account;
+
+	/* ctx exit and cancelation */
+	struct llist_head		fallback_llist;
+	struct delayed_work		fallback_work;
+	struct work_struct		exit_work;
+	struct list_head		tctx_list;
+	struct completion		ref_comp;
+
+	/* io-wq management, e.g. thread count */
+	u32				iowq_limits[2];
+	bool				iowq_limits_set;
+
+	struct list_head		defer_list;
+	unsigned			sq_thread_idle;
 };
 
 enum {
-- 
2.36.1

