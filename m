Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E0F6F285B
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjD3Jhp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjD3Jhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD4A2693
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f173af665fso7655995e9.3
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847460; x=1685439460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/I+SXBlP5m5skW9dAnqAKLCKy57FKwiqD1z+msHPm2g=;
        b=PMbAC/g+BiMHyF893heaIHe7yxcmuLzyesy22WmK857xvQThW7+Zl7MGtGWcCWbgjo
         VnbMpvOKDf8V6WGOfL0Ed2qnL/xE352VGxFClU09gNDJ7LmDNhm/7B9setToYLjovq3R
         gUgIPO3JO3JOxheCgVnvH4PLhIzb64v7uenLqxZ77xiZ3zHhXFWddZo9NFAaGvVCY6ie
         eKJBxSPDU5MEBkXG/LqzkaZHAAdNh3iKi+I2A0+ubf9hKmYEZOqKgS4EfcX5BJHkQ6oF
         atnGhRtjlbV/zoSr+rSA6xnTfroyYOgd/cWUppbSK9EhoFQ868/Z5pj+E1jmohkjqlYt
         9jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847460; x=1685439460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/I+SXBlP5m5skW9dAnqAKLCKy57FKwiqD1z+msHPm2g=;
        b=SgIh0u0VedMuV9G4QlUWFfiOH3WDEha4zy3hU6rwVOHyYTD1l9Q1NHLDr5pe1ULKd4
         uc/zXI7HHC9Jq7bdCcii8I0U3Oyz1BpH2N/fpWa1ToOWKXDl4EQ/hl1r8v049Lv/Xqct
         AAYWeIpuAdwMcczz17fOuc+IGC3unycakyxxP2955FyOFU2kYDIdNADxPlaU2o0RIopd
         kSKCOg44Koy/yua6wMPJ2fnqJtozNwHNRwkzfJzQRQ/jznhMbgo0YnzuoOEyO0KC3Aw/
         TNS4txN5PajwLSvlb3/bGa3mHYxvLQ2CXAysqItD8tuvpi7pml+QTRZ4YimhjaXo0XIU
         hvfg==
X-Gm-Message-State: AC+VfDxWzzEQtL7Rona0plfGMhlYKWG25jIAzsryYg/bG3UPRIWlC0PM
        pawPOvp00QzAoR98shWmxQFNEnOKEdY=
X-Google-Smtp-Source: ACHHUZ4fs7cxek3ysOf9I8NDt0Gh1fnihK6DstK4skxwa2H//clRrDp6/QffkCCn9q965n7sLTxxJg==
X-Received: by 2002:a7b:c5d9:0:b0:3ed:b048:73f4 with SMTP id n25-20020a7bc5d9000000b003edb04873f4mr7553794wmk.5.1682847459670;
        Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 6/7] io_uring/rsrc: introduce helper installing one buffer
Date:   Sun, 30 Apr 2023 10:35:28 +0100
Message-Id: <cded07f3d553ad0ba737d5149bdad207450db3a7.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
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

Add a new helper called io_install_buffer(), which will be used
later for operations willing to install buffers into the registered
buffer table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 15 +++++++++++++++
 io_uring/rsrc.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3799470fd45e..db4286b42dce 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -517,6 +517,21 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
+int io_install_buffer(struct io_ring_ctx *ctx,
+		      struct io_mapped_ubuf *imu,
+		      unsigned i)
+{
+	if (unlikely(i >= ctx->nr_user_bufs))
+		return -EFAULT;
+
+	i = array_index_nospec(i, ctx->nr_user_bufs);
+	if (unlikely(ctx->user_bufs[i] != ctx->dummy_ubuf))
+		return -EINVAL;
+
+	ctx->user_bufs[i] = imu;
+	return 0;
+}
+
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 29ce9a8a2277..aba95bdd060e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -75,6 +75,9 @@ void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags);
+int io_install_buffer(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu,
+		      unsigned i);
+
 void __io_sqe_files_unregister(struct io_ring_ctx *ctx);
 int io_sqe_files_unregister(struct io_ring_ctx *ctx);
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.40.0

