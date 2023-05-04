Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EC96F6B04
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 14:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjEDMTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjEDMTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 08:19:07 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE64665AC;
        Thu,  4 May 2023 05:19:06 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-3f4000ec74aso3206235e9.3;
        Thu, 04 May 2023 05:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683202745; x=1685794745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSyb6givsMExpGuHktpWfu+gxOuU871A0uj9kukvqHo=;
        b=fQm+vNQ8MOl+Mi34U+NN9DrZkBQ+jbIkfsV415pPDbx/3mU7Gv41w3henCqYYepesg
         mxmeut48mkp/i+Fi3uK3gs+cQ/8W5S+jQvzAF5rIqORam8BgthSDtk7Kjr0OqzXawNvV
         zQ8ylRVG599RlqjcgJVmBT0Sgi/rnLDBKUSq5U/BenohwPieBIXhKrbPwQVnaW9qKNU/
         nsQBqkGJaeuGrLcG/kDa5P/ycFy63O2dwQvCva3GK0HkDrTPGLqe29cVzlSh6PIYJz/i
         eIP+YNghm2O/sS+eA2XWU2zNsQby3pOqDH643hypmx3rPB3EHuMVwhv+73Ixk6SeCs8o
         OnkA==
X-Gm-Message-State: AC+VfDz4S0doQZ7UorP74oENTPBT1japos5t+M43vIDaHCFfwkmpNC8L
        tYTR9FuGGrtMetxAsxCOXVNhAL/5pTtQfA==
X-Google-Smtp-Source: ACHHUZ6U41Ymc//NQ1NfFRXTc5vZxexdvF5yf/UL7aT819ElkY5jwLddGgqGkL2K4aqY7X/9EkOZQA==
X-Received: by 2002:a1c:f717:0:b0:3f1:8aaa:c20c with SMTP id v23-20020a1cf717000000b003f18aaac20cmr17008034wmh.7.1683202744867;
        Thu, 04 May 2023 05:19:04 -0700 (PDT)
Received: from localhost (fwdproxy-cln-027.fbsv.net. [2a03:2880:31ff:1b::face:b00c])
        by smtp.gmail.com with ESMTPSA id y4-20020a05600c364400b003f175954e71sm4830463wmq.32.2023.05.04.05.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 05:19:04 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
Subject: [PATCH v4 1/3] io_uring: Create a helper to return the SQE size
Date:   Thu,  4 May 2023 05:18:54 -0700
Message-Id: <20230504121856.904491-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504121856.904491-1-leitao@debian.org>
References: <20230504121856.904491-1-leitao@debian.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

