Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DD6787BBE
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbjHXWzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244047AbjHXWzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:37 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA04B1FDA
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:30 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe21e7f3d1so463694e87.3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917729; x=1693522529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvhsasKZJnva2wCI0Nz03kKnyZToCj12NVuapLyWr3E=;
        b=Qpaabl53TVsFlH4ubEcXggqJFVBf3fUOCLwRojsx/crj3sWI0CiegA9RRssNLoqIaO
         yfCC/CbqktBw1yZFfqbHqIOyFs1msY+a9gs/+5L1dzV8hatE+MHTOOXnd9pAFKHMHpLF
         KZBx+bXLMU2LUd/AzE9E6ZN4cUMVDEY9WSO068xQjIsAwWO8503EO3888RP2VV5k7n0W
         DtPY6DpaNHZzKJeAnjig7Y7E1YvIS/hQwFzNsFomaYpP5C8A+d7FKEUVJi1rSAlpqCEE
         6nRrT87n7yNrHhohE1uvUeW7IxvJ97PMUwDFsXasmz5jxvqU0yjj0rxaJQvo6mj55KGB
         d26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917729; x=1693522529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvhsasKZJnva2wCI0Nz03kKnyZToCj12NVuapLyWr3E=;
        b=S8tuQVdbchBqW5LqtXLsFJy91Io0pyd2XNxi5Hm9m0dwrlYvxum33ydqA3MmdXgPs2
         fqzJnOdTiAOj702vXUQnE6Kq4V/WZXTEQ81YDffCPZ4cbgqg6wcFwKh0aoEdZ+a275yu
         iGnpYaV0F4TMVtSCHfPJ5END+Szw7BUPFR/XJyGw5JdHZXNnFlOtUcbB/dvAILgB921e
         6RfbNKgUqS8Lags1fy+H/XFD7MPqaGNZFxX3NdhaSHBjLk0JRQTO2yBnfyjNpriNnjnh
         k5m8PwQBdvGXUbaX7cit2y8LW/eoGCc/L1hAcy/qCpN/DWULLSsojk8cvi63zowUQNAb
         I6ZQ==
X-Gm-Message-State: AOJu0YwCPc09szbv4TLp+QWqMUXjbTeiFdiJuzGiwUw4rObuIqYLk92x
        T7QOsY/ZYlKnAskjgmUObokmrKyVhLs=
X-Google-Smtp-Source: AGHT+IGrj9UpZV3ga84RbF9r2scmGjpDr7xT7aFyBXsUXKkfYnYJfGnrh1f/iV6+Fol08M38yQZ0ZQ==
X-Received: by 2002:a05:6512:1093:b0:4fe:a5c:efa3 with SMTP id j19-20020a056512109300b004fe0a5cefa3mr16546421lfg.62.1692917728587;
        Thu, 24 Aug 2023 15:55:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 13/15] io_uring: separate task_work/waiting cache line
Date:   Thu, 24 Aug 2023 23:53:35 +0100
Message-ID: <b7f3fcb5b6b9cca0238778262c1fdb7ada6286b7.1692916914.git.asml.silence@gmail.com>
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

task_work's are typically queued up from IRQ/softirq potentially by a
random CPU like in case of networking. Batch ctx fields bouncing as this
into a separate cache line.

We also move ->cq_timeouts there because waiters have to read and check
it. We can also conditionally hide ->cq_timeouts in the future from the
CQ wait path as a not really useful rudiment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 72e609752323..5de5dffe29df 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -270,15 +270,25 @@ struct io_ring_ctx {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
 		struct io_ev_fd	__rcu	*io_ev_fd;
-		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 	} ____cacheline_aligned_in_smp;
 
+	/*
+	 * task_work and async notification delivery cacheline. Expected to
+	 * regularly bounce b/w CPUs.
+	 */
+	struct {
+		struct llist_head	work_llist;
+		unsigned long		check_cq;
+		atomic_t		cq_wait_nr;
+		atomic_t		cq_timeouts;
+		struct wait_queue_head	cq_wait;
+	} ____cacheline_aligned_in_smp;
+
 	struct {
 		spinlock_t		completion_lock;
 
 		bool			poll_multi_queue;
-		atomic_t		cq_wait_nr;
 
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
@@ -287,14 +297,11 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		struct io_wq_work_list	iopoll_list;
-
-		struct llist_head	work_llist;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
 	struct {
 		spinlock_t		timeout_lock;
-		atomic_t		cq_timeouts;
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		unsigned		cq_last_tm_flush;
@@ -314,8 +321,6 @@ struct io_ring_ctx {
 	struct wait_queue_head	sqo_sq_wait;
 	struct list_head	sqd_list;
 
-	unsigned long		check_cq;
-
 	unsigned int		file_alloc_start;
 	unsigned int		file_alloc_end;
 
-- 
2.41.0

