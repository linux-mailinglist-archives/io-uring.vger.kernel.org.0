Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA99787BBA
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbjHXWzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbjHXWzi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:38 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110251FC3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:32 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2bcd7a207f7so4223861fa.3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917730; x=1693522530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJ//xnNby4d5jNgpCMvTnltm5MwCd4efW3wW1j315lY=;
        b=bVsm1vQVokQCMJ1TZ6GHf4zvfglESqR+K3uKqiU/fX5MkFGwJ8jd+ash5jNH2HV1Vj
         mu9fyUQMOkg9TJyPpY9HFD/BGLYHZPp+z8dBn0aRQuuZrA2lannIchM0pT1hdKbhusfY
         LAfzhy6z+uyPgLcO7kDJOBuR53ojzM3Oc9Bw60fUmibyuXvFpPpX2s5onWYaTlaF9aNy
         rx3vTnzA5GW4fYAAApFv/Z2kwCTsMqt4PyH15tUXbjSAxW7MD85BBDTPRLaPrQJOdBKM
         aMwkrnaeJUzJc2U3HQBqkcGLGtmgzimoBV43OtIcKDKwpdXKpJ0Usb4PUs2DXWVTYqPp
         WNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917730; x=1693522530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJ//xnNby4d5jNgpCMvTnltm5MwCd4efW3wW1j315lY=;
        b=Bsc+2iIjZBBZg7Z1FskYBE9Td5TsrGdygAjRn7EB945aeTnws7cTwRmg8jlsqDs6LC
         FgAUbxye0oVZQTStLkRcxN8jBkEihbWXQkBGlGSstyDbFHH/oFrPnQtU9wJTuOb8WgR8
         PbSDmUVhIy8s7a7bAhWxhjh11Jze5/tVtDUxlBao17WQDhhkwZIjuAIGqURp2Pa73qwy
         lGbeeAV8FwEcgtheE2Fudx/bJbCIqGEpErMZkG7/1CSeAhvoOpNUXcHUhoXPUoCtvNxZ
         KiZ1iVj8nNUHNSYz7VfYezfCsTjjCIMrNg1A2P8EpmOyUnKfRqA6jwcxygxqs4WaWmYE
         3zUg==
X-Gm-Message-State: AOJu0YyhhZz1mz0RRDePocO7KDrNTS4hdLBD03nWhU3dYVCbEIPXK2my
        uvSe2bunBjDexOjqC5ndwMaLC+Qhi+8=
X-Google-Smtp-Source: AGHT+IG1GzITnRPVOSEM5gsTsfoSpU1KTYAwBnsRKseXZI84MjU5hhaivS8TlcEF10J1p7AyQGrnnw==
X-Received: by 2002:a2e:9b58:0:b0:2bc:c1d9:6848 with SMTP id o24-20020a2e9b58000000b002bcc1d96848mr9442048ljj.44.1692917730114;
        Thu, 24 Aug 2023 15:55:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 15/15] io_uring: move iopoll ctx fields around
Date:   Thu, 24 Aug 2023 23:53:37 +0100
Message-ID: <5b03cf7e6652e350e6e70a917eec72ba9f33b97b.1692916914.git.asml.silence@gmail.com>
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

Move poll_multi_queue and iopoll_list to the submission cache line, it
doesn't make much sense to keep them separately, and is better place
for it in general.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 01bdbc223edd..13d19b9be9f4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -256,6 +256,15 @@ struct io_ring_ctx {
 		struct io_hash_table	cancel_table_locked;
 		struct io_alloc_cache	apoll_cache;
 		struct io_alloc_cache	netmsg_cache;
+
+		/*
+		 * ->iopoll_list is protected by the ctx->uring_lock for
+		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
+		 * For SQPOLL, only the single threaded io_sq_thread() will
+		 * manipulate the list, hence no extra locking is needed there.
+		 */
+		struct io_wq_work_list	iopoll_list;
+		bool			poll_multi_queue;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -284,20 +293,6 @@ struct io_ring_ctx {
 		struct wait_queue_head	cq_wait;
 	} ____cacheline_aligned_in_smp;
 
-	struct {
-		spinlock_t		completion_lock;
-
-		bool			poll_multi_queue;
-
-		/*
-		 * ->iopoll_list is protected by the ctx->uring_lock for
-		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
-		 * For SQPOLL, only the single threaded io_sq_thread() will
-		 * manipulate the list, hence no extra locking is needed there.
-		 */
-		struct io_wq_work_list	iopoll_list;
-	} ____cacheline_aligned_in_smp;
-
 	/* timeouts */
 	struct {
 		spinlock_t		timeout_lock;
@@ -308,6 +303,8 @@ struct io_ring_ctx {
 
 	struct io_uring_cqe	completion_cqes[16];
 
+	spinlock_t		completion_lock;
+
 	/* IRQ completion list, under ->completion_lock */
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
-- 
2.41.0

