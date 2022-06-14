Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB654B126
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353854AbiFNMd5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiFNMd3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:29 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351F94B1C9
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:42 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k19so11059011wrd.8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D8sFDmp4NCj8bAwGZ38Oxd60P7D2GVHJ5ZCu/JRHls8=;
        b=Sd2BoO9uPXJfiWiTr5JcFwnY7ytE5K28EVFwgVpjKyK4XlVJUsLRV70zc47dRlZhq3
         FjgqjPkFXE6qV0EOZnI8724xkWHbO3wOBoQT3hvNcKzkaLlDiUNbnOdCdXYb6uxOpofw
         IIalwZlFxcyXDLo7sciHYCIGAlna32x7V9p/TNzvjy1hfD0WMxBMadcOOkuQ7+U/oCW5
         5UCesFYt/zI2yRqC37gUmjMohk+PU+AsaEHzTXSMXKU5kM9mrsl1ijI57EKa/kpsxZ8x
         8uRQNtnqVymDDjDK/iSdSE+c1vUsal4j7lq0T/Mdo8QM28gna+ytkGqkZJsECzPh99/n
         geNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8sFDmp4NCj8bAwGZ38Oxd60P7D2GVHJ5ZCu/JRHls8=;
        b=2y7petXuyTCsH0X/O+26ytXZR+Q9KgC1MOVjinc414q1jSXH1p72gDc/o/zvXb27CG
         AoKgpd+FJypUMgGTa2Smz6xOMvBJW0nQ7u45kgP1lnvxy09UZRMcnySleDAMGNNCZcJ0
         TQ14RzFqZ12OlPBjvM1LIGPzfJsnpAPZLrZFyYvrXPwyDBalXoYWqF+1rFxpvWF19mCk
         VEyUmSjjKjAqZK7Im+CVeXT0axaxieCzQQ8hY/3hYmn37GlcUoPvPdre54mOgjAekZ+R
         BhQsckdt2EddMvwglfpJEQzHeOw3OTKDmrGpsJXNOsakkFKg3rY0oGoGxmvtZHSIWwwG
         W9QA==
X-Gm-Message-State: AJIora//KuunKMRdwwp1uVC60Q7nmJrJoDzHpl+a7knszwNxVKN1rmcU
        1h8A5A2zIujmNSjrsxB006l1XeteaVhJkg==
X-Google-Smtp-Source: AGRyM1sAVWyXUL73oAUOVdxhbmDL+pNKmGw9HuLn/a8zYg7zgzp1GFnqGmPLZxW11DnoMiGE3967fw==
X-Received: by 2002:adf:e5d0:0:b0:210:313a:e4dc with SMTP id a16-20020adfe5d0000000b00210313ae4dcmr4655230wrn.152.1655209839897;
        Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 04/25] io_uring: refactor ctx slow data placement
Date:   Tue, 14 Jun 2022 13:29:42 +0100
Message-Id: <c600cc3615eeea7c876a7c0edd058b880519e175.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

