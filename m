Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6A787BBD
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbjHXWzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244045AbjHXWzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:37 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8C71FD5
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:29 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-5007616b756so456966e87.3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917728; x=1693522528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s21GtQ/YbH9JV5FC5+yZFO7uO9zKtUmbFucfHazoQo=;
        b=pLy1TmVLumYF+nyn1n/Fl1XwLRtDwHPXsv5LL163gWtzLXcXHq5Vre3/aTynPuxL2U
         Gc6/G59Xn2bVRb/FRoe2J2OCYoR6TXxpKaIUTh5JivX/vTNmAp+Azp15CgnJV0YJlo2P
         OXeZNs49GkL2Fvsu9OMg6rhIxzDW467SXX+HyjBVSAHVpQtAau3GyqJqWoEEkpIWweT7
         6miX7BdI6L+TBxTu6rcnE6CTGRyDCyTlruOkICXmNKgGrevhaKlDlTrVbI6ltzMKReit
         Gim0MUZLS9c++Gf+7GBe0c03Bm16XjP3Uhbu8MucumZAmdror39PgCzz+6K1iKmC9pJ0
         cLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917728; x=1693522528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s21GtQ/YbH9JV5FC5+yZFO7uO9zKtUmbFucfHazoQo=;
        b=a0RLzeCXzPK7MeTPDxY1/2h+pt8HAdRQs58SPbKYKCBsYWM7X7bEDaZHl5Y7IPvNGJ
         Daw2nz+JQBvF6QH6rTPTzZG0+sCS9wSxajlfZY2Md5CUTr0kAsFvcQgl+NYyAtphfkf9
         yvsLze+tVmTxuMlM5I0owMy7KKs2WRsEwHRPQXHhorgFZ5mFMPaS+r3Gczptno/mMt6V
         bjwev6fHvCRvNLfzPaYkLgJ4EwS+mwQnWQzSZqwzVcjuZbUCXu7UNspCpLP1kNDoLqXz
         hUsdYYCS35lFMNXwE74tuvo9Q0xFOFEZsTIFiEFEBozE4FhUd2quMRFugqLw4qNgYesi
         AIOQ==
X-Gm-Message-State: AOJu0YxvFDL+sG593/pRnRJc8eTzg4UBtbCCAfbkgBgOVLaiZqd0anL7
        VLO2mUwQgrakSu5ubzrfAn4SKD1dIao=
X-Google-Smtp-Source: AGHT+IGvRBcloQOORfMKiSYuaM4mwR4+MwGRV26L3QjRScSZ/0DUbC5MDxcFN+5Tka4fVjLeYIIYeQ==
X-Received: by 2002:a05:6512:2354:b0:4ff:a8c6:d1aa with SMTP id p20-20020a056512235400b004ffa8c6d1aamr13547679lfu.48.1692917727651;
        Thu, 24 Aug 2023 15:55:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 12/15] io_uring: banish non-hot data to end of io_ring_ctx
Date:   Thu, 24 Aug 2023 23:53:34 +0100
Message-ID: <fc471b63925a0bf90a34943c4d36163c523cfb43.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

