Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA552720E
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiENOfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiENOfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712501FCFE
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso13334867pjb.1
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W80cxWimMtKU9cLCoAUv5V568z3O2luN4gMEXQmQSwY=;
        b=WazxNFgjBpAIO3emOaKZsfV7cgSyvsI1+fNL25qkJwFeumBgiycrZKkq6nwERK+eFT
         cuZWPtVZkO2phWTl/hNCecb1TbN6q5kERKDwEZD3E3+5dTo71YltyLZR6DH6boIsdS5P
         GTo1Xw5R6Rt+kikvVc3zOGZUsaX5EnxBdd4z7M8dlgljAuYf4O1rU87NQV119hnLY8ga
         NGCvSb2PqBFeIWznJ8TCga/BqOLrRVNFxYMOBiva05wqa4A1SKtZuKN1c9m5EvKJR4K0
         vS46zcZXnrdeh3Gt98HZC4rUnr8zYk05socXfdnruAD9hON3uKrXP6VHEfZJE/LFqjsM
         d5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W80cxWimMtKU9cLCoAUv5V568z3O2luN4gMEXQmQSwY=;
        b=TmM70Ywbk02zag6hKM9pGLOMwPIpYdkXdaofazcKwC9nIPm0JTyk262RYd+gF5SCWa
         A8Z7JmoNh5HA1y9p038AwXzJKZpLM9S1brchkO/Os2dXL7ObAQXEN2G3GUllu4NuDsTQ
         4IOLYlisFl+7cXSlPKANdlfzUKMlwQ2JfxJeq6dLIZe0RpPVai6fUU3XxRUWKIelYjxX
         gWaMMlP22oDzBxg8A5/L4wL7e2fmS0dy31BSWaamraKNfS6YgbRg1aTnVUgfYutSOaii
         0/wpxNOWZK2Clbps//ndoQfIQfIvbauqSPs9m06UYrD/XquYy/GeC6a68vYTdZf4uLOG
         BKXA==
X-Gm-Message-State: AOAM530St/CtHBBfdT2kSg3NPToxJNK9DXH/mgpm0a1lHM0/Qp8niCeR
        JXg10Ww6AA2XOJkK/zaJvrbxVW4DrQjXvmK+
X-Google-Smtp-Source: ABdhPJzJPbqxSPY2ASxobL/ViJZRRzA9TTFVcsQG+MrUAsFbM8DCZfqSgOdcxmnUPwLZEZgJhEu7mA==
X-Received: by 2002:a17:90a:f48e:b0:1dc:8ed1:f5ae with SMTP id bx14-20020a17090af48e00b001dc8ed1f5aemr10029064pjb.182.1652538921874;
        Sat, 14 May 2022 07:35:21 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:21 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/6] liburing.h: add api to support multishot accept direct
Date:   Sat, 14 May 2022 22:35:31 +0800
Message-Id: <20220514143534.59162-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

This is to support the multishot accept directly to the fixed table, the
file_Index should be set to IORING_FILE_INDEX_ALLOC in this case.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 src/include/liburing.h          | 11 +++++++++++
 src/include/liburing/io_uring.h |  9 +++++++++
 2 files changed, 20 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cf50383c8e63..9065555d39f4 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -512,6 +512,17 @@ static inline void io_uring_prep_multishot_accept(struct io_uring_sqe *sqe,
 	sqe->ioprio |= IORING_ACCEPT_MULTISHOT;
 }
 
+/* multishot accept directly into the fixed file table */
+static inline void io_uring_prep_multishot_accept_direct(struct io_uring_sqe *sqe,
+							 int fd,
+							 struct sockaddr *addr,
+							 socklen_t *addrlen,
+							 int flags)
+{
+	io_uring_prep_multishot_accept(sqe, fd, addr, addrlen, flags);
+	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
+}
+
 static inline void io_uring_prep_cancel(struct io_uring_sqe *sqe,
 					__u64 user_data, int flags)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 46765d2697ba..6260e0d1f4ef 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -67,6 +67,15 @@ struct io_uring_sqe {
 	__u64	__pad2[2];
 };
 
+/*
+ * If sqe->file_index is set to this for opcodes that instantiate a new
+ * direct descriptor (like openat/openat2/accept), then io_uring will allocate
+ * an available direct descriptor instead of having the application pass one
+ * in. The picked direct descriptor will be returned in cqe->res, or -ENFILE
+ * if the space is full.
+ */
+#define IORING_FILE_INDEX_ALLOC         (~0U)
+
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
-- 
2.36.0

