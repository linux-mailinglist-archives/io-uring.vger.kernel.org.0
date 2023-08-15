Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B0B77D11D
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbjHORdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbjHORdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9145B1BD1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-5256d74dab9so2392079a12.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120802; x=1692725602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfCDFTGPqPDquTSsf5QwXyrmIi5jQ5+Y+5MLL1cbVZg=;
        b=AiZFS76S8pRRQUUf11IQTf4OJSn83kdnxwdBSSeWhiVRGNv8sXGvjOlnLVMfkiLrrU
         ccF1dHDrAxcD9KK02eAb5DENu0nx1Trvz1V2rS4R6+3gpowK/Z9y/TWi2YLx8mO9gnYs
         eUaMbdVHmUXm7jwUb/lTb6MxFxwUGDVzsmL4V2ywzosykH6gIcjBwztYbDiCNP4B1747
         SoaPjInuy9UWksKonZOs15OEwupsxt9eXWAMVH95ldNI+B71DMoRoetMYc63V9RmwXdZ
         QmL0ryPmvcQgc3GI8ejrL5jLtWaQABPbZIFkGs3Lp9CrHFGYz1BuZsxqV3XefHHkncR0
         GbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120802; x=1692725602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfCDFTGPqPDquTSsf5QwXyrmIi5jQ5+Y+5MLL1cbVZg=;
        b=cvWQgKxd9tufKplZErXncM52J7iqQhfykenK7OOHy/fllP9+EYs2pfJg1u7uUj3Le9
         sn8sOb2/GsTaY/F93ZDxlRtZJut2FCWATh4fsVlOPAg8zXSmIPu4u1UOJIYFZTEAlwZm
         0H5WQo9s25Lxk4hMq0hftQ0b9xQCIfl2ST6+6dxbAm+oLqfOWNfL6C3BYFhdfEThldWW
         7PKuHZm3TcBhQbultR71ztWgAJ0YtB7N4tv8ypZxKPn1M0u8+B8/FYJRKB5nzF7htg77
         ROJF+HO/PrxQAy8RkA112NlHIwSs2MIMqZhPpQF9zFrDXNMGpFAgvXsqLJYNKv12ZqVf
         8LRg==
X-Gm-Message-State: AOJu0YxOCt3rr5TwGhkpdpZD5umrRDSk1xvwrsBYuOT3CWpX2zpVja1L
        8bnUc/DWKEOMmVUx4GtYzxIbA2R2boQ=
X-Google-Smtp-Source: AGHT+IGcsoqvmFp8/PzJdr4/H3FZpRG27YuovQgUBoGUH3IU9c8iIMVmqmgRZpc5/pvk7o+AA+IDpw==
X-Received: by 2002:a17:906:118:b0:99d:dce8:2be5 with SMTP id 24-20020a170906011800b0099ddce82be5mr707264eje.1.1692120801812;
        Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 11/16] io_uring: move non aligned field to the end
Date:   Tue, 15 Aug 2023 18:31:40 +0100
Message-ID: <be7d929fb23516cc5e5b759af9f72591590c2814.1692119257.git.asml.silence@gmail.com>
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

Move not cache aligned fields down in io_ring_ctx, should change
anything, but makes further refactoring easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 608a8e80e881..ad87d6074fb2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -270,24 +270,6 @@ struct io_ring_ctx {
 		struct io_alloc_cache	netmsg_cache;
 	} ____cacheline_aligned_in_smp;
 
-	/* IRQ completion list, under ->completion_lock */
-	struct io_wq_work_list	locked_free_list;
-	unsigned int		locked_free_nr;
-
-	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
-	struct io_sq_data	*sq_data;	/* if using sq thread polling */
-
-	struct wait_queue_head	sqo_sq_wait;
-	struct list_head	sqd_list;
-
-	unsigned long		check_cq;
-
-	unsigned int		file_alloc_start;
-	unsigned int		file_alloc_end;
-
-	struct xarray		personalities;
-	u32			pers_next;
-
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
@@ -332,6 +314,24 @@ struct io_ring_ctx {
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
+	/* IRQ completion list, under ->completion_lock */
+	struct io_wq_work_list	locked_free_list;
+	unsigned int		locked_free_nr;
+
+	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
+	struct io_sq_data	*sq_data;	/* if using sq thread polling */
+
+	struct wait_queue_head	sqo_sq_wait;
+	struct list_head	sqd_list;
+
+	unsigned long		check_cq;
+
+	unsigned int		file_alloc_start;
+	unsigned int		file_alloc_end;
+
+	struct xarray		personalities;
+	u32			pers_next;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
-- 
2.41.0

