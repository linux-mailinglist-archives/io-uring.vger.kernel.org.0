Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C706F293C
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjD3OgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjD3OgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:36:09 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322651BFF;
        Sun, 30 Apr 2023 07:36:08 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f18335a870so8749075e9.0;
        Sun, 30 Apr 2023 07:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865366; x=1685457366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWLOTplCTb15+ItkKDvIHTfyfj/21ATI17iwvK3v1Xg=;
        b=ZcZOzGbkJXF5LW5q/EHlZ8fh89OGtTO7wulkA7CQqXwSKGUhfLtY5ESMCIO5I7ifFH
         CcarFJkAT/EsvvPv62YeGTpCUNaBz1UyPHTt4mUxOGHr3FVnxn+G7Q+Xy53Jsb/nyneO
         7nKjlxgwh1dRZtZIcsnNbPtWL740ZVOGMqSxO46Snd2HoCOOVhYMk8Mafia85JUJNdVB
         snO9RpH1K6w+mIajBzhg8sVQH+nu640kT8/UVKJzoUyYplf3r6RNGYNYwjFdMS05Y19Q
         3kX+RoE1dl09FBRPUi2tYT7ozAOGMXB3X+kYL6DLpKtwiem1JxV4dnAa5ZSSZlm3LLZr
         G0GQ==
X-Gm-Message-State: AC+VfDwgUZxKM6BHcx7co/0sDJeAp4S/tC3QrvTBFfVDUtkYcFthD+X6
        sVTEdrBoK4c4rudaS2rzSqDhARe7yubXTQ==
X-Google-Smtp-Source: ACHHUZ7nz6XoczydLlqmjutbUaDJZ83dYTS13ttqaBxRyVpkSJ5FOOZ5iNuc4pfoojqvCXwlaHRW7w==
X-Received: by 2002:a5d:6a91:0:b0:2ff:460e:bb49 with SMTP id s17-20020a5d6a91000000b002ff460ebb49mr9833275wru.24.1682865365870;
        Sun, 30 Apr 2023 07:36:05 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d6e07000000b003048084a57asm16459222wrz.79.2023.04.30.07.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:36:05 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        hch@lst.de, kbusch@kernel.org
Subject: [PATCH v3 1/4] io_uring: Create a helper to return the SQE size
Date:   Sun, 30 Apr 2023 07:35:29 -0700
Message-Id: <20230430143532.605367-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230430143532.605367-1-leitao@debian.org>
References: <20230430143532.605367-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a simple helper that returns the size of the SQE. The SQE could
have two size, depending of the flags.

If IO_URING_SETUP_SQE128 flag is set, then return a double SQE,
otherwise returns the sizeof of io_uring_sqe (64 bytes).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..259bf798a390 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -394,4 +394,14 @@ static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 	io_req_task_work_add(req);
 }
 
+/*
+ * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for each
+ * slot.
+ */
+static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_SQE128)
+		return 2 * sizeof(struct io_uring_sqe);
+	return sizeof(struct io_uring_sqe);
+}
 #endif
-- 
2.34.1

