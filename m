Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D19554B119
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbiFNMdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243885AbiFNMdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:18 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAE4B1C0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id e5so4586471wma.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=n7UD8aRnamOC+UGlbr/BPuemAAj9OMj6NsuyC3hj/J+1SP+dwfYw30DfTZdQ/F371I
         hdswDptB/Nd5u/3bHsKzf1bKG0Mst5MuG2vyvuqHUf6pPzwPGTLh/J7fRNfpmoDDnYXy
         +vsoN4CEXQsWbwMeIcHs9+PbTVi4RzzIjTVpags2wkp8Xi+AQz4D9YtF6O4dntxLDRDJ
         jaoM/Izg8zDXfI0g1mX2wderY0HSWvt8vA25qwnTs9HhiJk+K95o95UZFxoDI5G8ze88
         H7QeQ3EjrgRNorge0CTh5VbLPt4zKjqjALHucv1vSE9VXCS1AE+e6o2KgA8xqzznthU+
         KIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORixVfQAPkrUEdbPULkgFBU4hdADQl3LSugR9FT2k0U=;
        b=O8NLVjDTWmflioHpNYRhOacHaHP2iTyVZsXbYL+qHTQPwLgwMYUfl1efiPRe86DQ1Y
         4VnXhMwajgStrFRgVz3U+n5tFpVqJd1cAOnFOPlqV6jJCJn2uttO9huncXGxJV8h0zgM
         IPJXbPbaBPwUoO/aYE2Nz4Bizj7W6XjDPQZfsNIX/UKtEFnKU138f/XPayyMFProHTtk
         4cJQHUjBK5PsJwY6E/klXqm472Dwp6QIYCDQeZuubnJhAqrULSD0+0SrnkqCLQOj351J
         2NLPHH7TpUtSb/NJaiczddsLZWYjO9zeF9iEyIX0sQiJdGqUmx747ti2IYiQ9sSgVGUP
         66KA==
X-Gm-Message-State: AOAM530wMlSsvGwZ4uszCSgdawLoEIljJER0w1r64Y1pdpTxoHS/lFQ1
        asJSBBL9aCvccUq63ufFbzGquellEXO77w==
X-Google-Smtp-Source: ABdhPJzjtV1QJ4fuigd7ZVUU3k8E7D8n1iqlYccE++mDVcHH4IRZhA+t3wISoJxfV16gDyui3lGsmA==
X-Received: by 2002:a1c:4d05:0:b0:39c:5932:d9f1 with SMTP id o5-20020a1c4d05000000b0039c5932d9f1mr3939456wmh.52.1655209835880;
        Tue, 14 Jun 2022 05:30:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 01/25] io_uring: make reg buf init consistent
Date:   Tue, 14 Jun 2022 13:29:39 +0100
Message-Id: <1835f8612fd77ed79712f566778cad6691d41c06.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

The default (i.e. empty) state of register buffer is dummy_ubuf, so set
it to dummy on init instead of NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fef46972c327..fd1323482030 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -567,7 +567,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				io_buffer_unmap(ctx, &imu);
 				break;
 			}
-			ctx->user_bufs[i] = NULL;
+			ctx->user_bufs[i] = ctx->dummy_ubuf;
 			needs_switch = true;
 		}
 
@@ -1200,14 +1200,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	size_t size;
 	int ret, nr_pages, i;
 
-	if (!iov->iov_base) {
-		*pimu = ctx->dummy_ubuf;
+	*pimu = ctx->dummy_ubuf;
+	if (!iov->iov_base)
 		return 0;
-	}
 
-	*pimu = NULL;
 	ret = -ENOMEM;
-
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
 				&nr_pages);
 	if (IS_ERR(pages)) {
-- 
2.36.1

