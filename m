Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E077D11E
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbjHORdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238933AbjHORdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51F11BDC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-986d8332f50so765027066b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120803; x=1692725603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvhsasKZJnva2wCI0Nz03kKnyZToCj12NVuapLyWr3E=;
        b=QXOuJsGn0ubTXKg7iFhwp218Gn17b+QOWBWZ7v5Z1Syj9NX/QRiLwKvZj6CGvfB6A+
         dUs+XbfdUd+YmB5oFO/ROlxqsLbhKsig7Cdnm53oq294v2VFLBmpbpbNpx86cQXbB2Rk
         JLcX7oWSDYpwgg/qneeI+VrYjhpb1p8d6jDti0Yxu9mSyVYTM4R8S9f+QOc/QtbwtQkS
         PgWoAOkmVkg7kCpn+x6S1qXN6OG4XhR+MTB7xm/VIIAqUE7Ozqny192lJ+fqnFTCklr2
         mYKM6heVoeuWtUoqU0L6QCFn6UKsobVn5u6K1VGN7Hb7hfwyqwNvUmYFBocj/ZJZWMo1
         7pTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120803; x=1692725603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvhsasKZJnva2wCI0Nz03kKnyZToCj12NVuapLyWr3E=;
        b=TE22TcJfkGDNQhAqXFOdlHt4QGIZTO/m88H+mPxyAhkKJnYsCrKzzttpxHipUTSls+
         3j3mUoNsnMpGdMhEGCxOdG8cQncJDicGCbqWK3HwyoNIElMSO6HADco1wrRf1bzxAfiG
         qoikgMRlZA/lUBIdzBoWvOEcxggfU8u+emzJKB9Lj4L5RHRrAIU76I2XIinm94LCB5Hi
         Y9qqljImG9OW4zny8e/qBy+hOiU4oCZXJ3vEkzU7LiF2mNBAJjaMWfeN3FWt8R7H1G5+
         zPUIrTEgiVcwBvKU0CUfsEgC6RqGhbV9zKw773/RrqCQAlTxZtG7eoUEdBwlMNnnLCPL
         273w==
X-Gm-Message-State: AOJu0YwG6V1ELBzMIwsD7DkRXEiSKiLDLRMOzN2/vw2ZXlPc6xMV83uR
        LdM09ZP1NekWCIkl6lsMyzQ8C0k7VLA=
X-Google-Smtp-Source: AGHT+IEPp/DvW2GuU3r3wzBD04B8ywxjV7YDaoEUK4NouO6zrB1K5n4APRiRVlOa+V+U3ljLX/KUWQ==
X-Received: by 2002:a17:907:2ceb:b0:99c:22e0:ae84 with SMTP id hz11-20020a1709072ceb00b0099c22e0ae84mr10192137ejc.28.1692120802969;
        Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 13/16] io_uring: separate task_work/waiting cache line
Date:   Tue, 15 Aug 2023 18:31:42 +0100
Message-ID: <37c3b2f2563587f531dbc9cb4cf3ad6da1e33a94.1692119257.git.asml.silence@gmail.com>
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

