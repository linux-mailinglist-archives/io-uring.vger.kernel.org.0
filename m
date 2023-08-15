Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0F77D126
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbjHORde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbjHORd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C2710EC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99c353a395cso762350866b.2
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120804; x=1692725604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJ//xnNby4d5jNgpCMvTnltm5MwCd4efW3wW1j315lY=;
        b=gZIxvZlevMC19qRNOEmzIn6U8jdU3xzc36ajRqn9zY/4a1NJQWVNcgiVjPcDycV56Z
         BGc2AwlHyU0dDjNqKnVyuymS0YkJWsxYQTRcWsdLaBFM4Tkt6aLsB7Zycu5ZYY85J2jf
         su7MxjjlP1LJE4WRLkXnn3Ow6o+Jn4NUWyDC4zx5rkEsaq2xWI6ILEANnzmnRyGAQY1f
         Uu8lYHYr0BdEutubYWiKUtSyTca0ppw/R+Mq1IB4a1goNo1H7oMfxtn3oihKR7qG09Rz
         0DyS4c6zmEUyF5E9DzjGzD2LzGFU5c1QGwOfjjNVKTeuDvY35Vjq06eTCT56Gjgxv2uZ
         fvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120804; x=1692725604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJ//xnNby4d5jNgpCMvTnltm5MwCd4efW3wW1j315lY=;
        b=KPqaHs0B73Oppk64hnLWPTRQSK9AgCD+GhTXRqPcYEMSvUyoMIl2X2221UeuPvLIaS
         DasXTJm2QqZe9Ikw02F8dPjUwLuCljBx58THDYV5OhSgmFw3sAcshvWhLIUp4RryzVh1
         KTaQRtMAo3HR9RxVSAiUZwuyW5SuSG8GjJ4wofuB2+wwR67swZj+ubjFzy3TSjUJenxj
         tJCZfjEQCQP1Vb9NsuZhAzcKHCwu9SFWIN0/eLXO/FDkC8NXTrWoyQn0rdgUdTdC/DSa
         KvQJTdru3RKXfWEMiZ31jYWwlSUqbTGEaAXMiWnP6V3hZFdeqWYkkNljzCK/nOw/B2ps
         4p5w==
X-Gm-Message-State: AOJu0YxwoVBQdEaYq2PP/Vx5J95h7iWP4oVHYffOU050TeEgEJe0qGX7
        R2N8N0bjWUdR8wSN7piYfnLdq0EYMVU=
X-Google-Smtp-Source: AGHT+IHI+R9lVtI4m64blK/1qoLBTtpM4x9PBeRjuLDSBd/kcPcA01TbXmzMbUmbDOaXnBTGRO4uBQ==
X-Received: by 2002:a17:906:5a4b:b0:99c:6bc6:3520 with SMTP id my11-20020a1709065a4b00b0099c6bc63520mr9858015ejc.65.1692120804184;
        Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 15/16] io_uring: move iopoll ctx fields around
Date:   Tue, 15 Aug 2023 18:31:44 +0100
Message-ID: <31634a99be3201292182ce2adde05dac1c664b53.1692119257.git.asml.silence@gmail.com>
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

