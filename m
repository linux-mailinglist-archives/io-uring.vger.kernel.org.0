Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D46254CEC3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356543AbiFOQed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356579AbiFOQeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:31 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F058E41312
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:30 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so1441088wme.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYS0pPd4DSDus0EjpouGi5yssHH1VdtV2aAPsGUOfVo=;
        b=QTbYI2codfBkD1HZWYIgrgt4xzLeqK5dr+GNtZGhQOrs8eUaep0cO8hSxRpYAWBquk
         3CUlJFFCeOpl9NYlgIWREYtyV1caGJv9FOExMqMyaBvdHhSfmYv0Vt8jRoLrOTSide6s
         8R3JDrIOTGUDmb+GkToO2YhtJPfv/8iTXf96H339qjNowUXIeZXrQTD+TlQKId2Fdapa
         pwSqZfO3rV5yaAUffxQyKNAIs7vSq+/DagXhrIzu4D88ayhA81zs8QNSYeWP7T1CyZ13
         /p+sV3YR/fzQ1Sq6L8QSzmKKao+ZTBcUkrF3/O5Owis0ilEybYJRd5ElyBIP6bxok+2X
         m35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYS0pPd4DSDus0EjpouGi5yssHH1VdtV2aAPsGUOfVo=;
        b=qLYJGekLEFa8qBSOWytkpw3zdW8xi4tJzA7mdI3OQRphHVXGmIF2cdiiCQulKxDtWs
         S7mHjTiOFhsMZuefmeZN04IxUkF5q+EyLNsVtEenVOR3Jx8rzH3neIN2PXqRaMUsa7GM
         okDqGppGKHG9dS3lap92+6y/YrRXAsWG7Hh/UGvoao5Pz3uVCfIc4tmA0L46VZpmR6ZZ
         G+roUeVZBqF7z5zLvYCslVyRe6d6os3LfR6F/el4KbO/FSBSiyFC08fVUoMZaQuWzwEF
         QmaA3rl2+OO55qu4ovxp+hL3YDKPnaCuJTUV6UrqFBmp8r3MR9E0XcDlpEMBCg/SeJLA
         Bw8g==
X-Gm-Message-State: AJIora9YLasxlugMzv4f+OIh8+gB9GjYb2rqyL3tgjzXxn3sbRBF2SX+
        GkREf+7ZDiz7qru5CiyZ+1c1vrvdeNpIBQ==
X-Google-Smtp-Source: AGRyM1vb6l/gcuSp4LJtWvR9iz8Z6zjj/oXJS/VzxyFFRqt/hzgIZYnhXdi3mLBrSWkPcukoIELJeQ==
X-Received: by 2002:a7b:cb88:0:b0:39d:16a7:dac7 with SMTP id m8-20020a7bcb88000000b0039d16a7dac7mr305674wmi.128.1655310868963;
        Wed, 15 Jun 2022 09:34:28 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 04/10] io_uring: refactor ctx slow data placement
Date:   Wed, 15 Jun 2022 17:33:50 +0100
Message-Id: <bcaf200298dd469af20787650550efc66d89bef2.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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
index e050c3c4a7ac..94f76256721a 100644
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

