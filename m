Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12A6EA98E
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjDULrA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 07:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDULq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 07:46:59 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A8D1702;
        Fri, 21 Apr 2023 04:46:58 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f1763eea08so17311385e9.2;
        Fri, 21 Apr 2023 04:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682077616; x=1684669616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WN1a9qjYlcYgPTY0hc5IEgjly2tOgQNpSE3+CEiG+wM=;
        b=LKK0Xfyj/8/Ap95n8wMBX6/RfC+klJVvN8ICRAkRGiGExzisHqQfxuvI8Djxnd13qP
         aqpHCNQ/EPLd0UEDiEUA8ImCchkPXT/mnzwYLSA+Ncr7B/47PjOzrVDniBFuttvkEpZ4
         auNQmdce1ooEK/SgxWsqcGdkQXU/5ml367lPx9PuGpqF28g3qOXjkMHUzdL4aMMHZ4dU
         anOUNQqFs5Pce2QkElASRzKcG/QHZ+N+WuLrTOE1MH1hf9hmuhi/llQdzvc2PM3lVwLp
         zJRD6c0KFwUycMQTcjGVKw6bHN2cC1F5mr2ms5z6DzO2tsu+zgLajjlt+AKFQxm8++sj
         WdEQ==
X-Gm-Message-State: AAQBX9f5cHaj2Q97+xShkdA7tQiqEL/jlkR7lwB8AI9O3SItGnp/9Dxt
        8O2kut6JzPKOtzSGzZq9aVo4FjEjtL4RCw==
X-Google-Smtp-Source: AKy350bj/M9uE43aCCFw0bdnZTRDagfpxVwl7LnMkodGWH5LscF60gQsvqBCCMPPMYU9UkrWC1eaJw==
X-Received: by 2002:a05:6000:18c3:b0:2f0:2e3a:cc04 with SMTP id w3-20020a05600018c300b002f02e3acc04mr3478378wrq.8.1682077616595;
        Fri, 21 Apr 2023 04:46:56 -0700 (PDT)
Received: from localhost (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003f1738e64c0sm8052309wmq.20.2023.04.21.04.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 04:46:56 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: [PATCH v2 1/3] io_uring: Create a helper to return the SQE size
Date:   Fri, 21 Apr 2023 04:44:38 -0700
Message-Id: <20230421114440.3343473-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421114440.3343473-1-leitao@debian.org>
References: <20230421114440.3343473-1-leitao@debian.org>
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
 io_uring/io_uring.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..25597a771929 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -394,4 +394,7 @@ static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 	io_req_task_work_add(req);
 }
 
+#define uring_sqe_size(ctx) \
+	((1 + !!(ctx->flags & IORING_SETUP_SQE128)) * sizeof(struct io_uring_sqe))
+
 #endif
-- 
2.34.1

