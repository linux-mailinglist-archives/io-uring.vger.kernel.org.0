Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9733377D129
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbjHORdg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbjHORdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5376E1BD9
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-99bf9252eddso796197666b.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120802; x=1692725602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s21GtQ/YbH9JV5FC5+yZFO7uO9zKtUmbFucfHazoQo=;
        b=jZTePif5hLr7Du/bHC93UhwOSoZToX2ZdWLFZyn+NXRi8IGgAu2K4qBV1rPTaW9EHq
         JD8ym+sAAfTUESy7IQ13hgbeMZouqfuXOuhH9+c/xJZo7KqzkeuXnqfaiX7y1S7fZupn
         tunECETFr+mnxWKUV4VG2iivVSiiqT/kCAcaBc/Imy6AbeC9P6aj9fqJESG4SR2dAT7m
         EoPHExVDynfoiQ09fq4Vy+dZSaiWIdybNYTtAO25X3gIHAFDl7IClCPD6N4MH7E+bFlP
         DpAMy+gW6KBTpoUU+CxXlqtShgrzoBzPslK8/htEKR279l13h9WR5KYQPhe38nZiRLaG
         KUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120802; x=1692725602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s21GtQ/YbH9JV5FC5+yZFO7uO9zKtUmbFucfHazoQo=;
        b=DegOl+TNVIlk8ybHcCsZq6O3mVNmjH3zTZfT6JGikRA9EX1Jk2+GxEtB65RyaFOplQ
         UzqQDfauNSjeEBQhga2+muByebiDcsfUochx1v5KPpYp72PHM6m8/HNc79HSKQg/7h2Y
         MCx07U++84Taey05bI6TvfB+ci4au1+zhEzgf2DPRC3mZthOFXw7OCrCjOhFUNUUnElg
         8vkGuqI94bzREfCsTQMfflisRQP0QeTCqCklrLV9tBPwfD32/pC1ivU/a09GAse6f3V7
         6vN0mZmjQDWN5NC06fzIv42OsH9frlzEpbJTDUKFMsW92li3ny7KDCe3ch9t3URCEYQK
         2kMw==
X-Gm-Message-State: AOJu0Yx+5upZ2BWHRESNwE7u9BOi+oiselkkK9/AlFzp/F1WPIXpeAIo
        HGYNDlS2EzWrKbl7mXHsOO4DszTaeeo=
X-Google-Smtp-Source: AGHT+IGCkifbv7HEhmHNQYJE+b203OiBXropl++EB71u4I4OuXfndg5OQChgfFW+pr1DPooaM9krpw==
X-Received: by 2002:a17:906:217:b0:99d:dc60:7108 with SMTP id 23-20020a170906021700b0099ddc607108mr1007608ejd.63.1692120802596;
        Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 12/16] io_uring: banish non-hot data to end of io_ring_ctx
Date:   Tue, 15 Aug 2023 18:31:41 +0100
Message-ID: <aa1678b46b0c0d85f507b935d31afeac01601be3.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let's move all slow path, setup/init and so on fields to the end of
io_ring_ctx, that makes ctx reorganisation later easier. That includes,
page arrays used only on tear down, CQ overflow list, old provided
buffer caches and used by io-wq poll hashes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 37 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ad87d6074fb2..72e609752323 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -211,20 +211,11 @@ struct io_ring_ctx {
 		unsigned int		drain_disabled: 1;
 		unsigned int		compat: 1;
 
-		enum task_work_notify_mode	notify_method;
+		struct task_struct	*submitter_task;
+		struct io_rings		*rings;
+		struct percpu_ref	refs;
 
-		/*
-		 * If IORING_SETUP_NO_MMAP is used, then the below holds
-		 * the gup'ed pages for the two rings, and the sqes.
-		 */
-		unsigned short		n_ring_pages;
-		unsigned short		n_sqe_pages;
-		struct page		**ring_pages;
-		struct page		**sqe_pages;
-
-		struct io_rings			*rings;
-		struct task_struct		*submitter_task;
-		struct percpu_ref		refs;
+		enum task_work_notify_mode	notify_method;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -262,10 +253,8 @@ struct io_ring_ctx {
 
 		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
-		struct list_head	io_buffers_cache;
 
 		struct io_hash_table	cancel_table_locked;
-		struct list_head	cq_overflow_list;
 		struct io_alloc_cache	apoll_cache;
 		struct io_alloc_cache	netmsg_cache;
 	} ____cacheline_aligned_in_smp;
@@ -298,11 +287,8 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		struct io_wq_work_list	iopoll_list;
-		struct io_hash_table	cancel_table;
 
 		struct llist_head	work_llist;
-
-		struct list_head	io_buffers_comp;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
@@ -318,6 +304,10 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
+	struct list_head	io_buffers_comp;
+	struct list_head	cq_overflow_list;
+	struct io_hash_table	cancel_table;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -332,6 +322,8 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
 
+	struct list_head	io_buffers_cache;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
@@ -375,6 +367,15 @@ struct io_ring_ctx {
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+
+	/*
+	 * If IORING_SETUP_NO_MMAP is used, then the below holds
+	 * the gup'ed pages for the two rings, and the sqes.
+	 */
+	unsigned short			n_ring_pages;
+	unsigned short			n_sqe_pages;
+	struct page			**ring_pages;
+	struct page			**sqe_pages;
 };
 
 struct io_tw_state {
-- 
2.41.0

