Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4969BB72
	for <lists+io-uring@lfdr.de>; Sat, 18 Feb 2023 19:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBRSnX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Feb 2023 13:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBRSnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Feb 2023 13:43:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C780D12BED
        for <io-uring@vger.kernel.org>; Sat, 18 Feb 2023 10:43:20 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j27so930203wms.3
        for <io-uring@vger.kernel.org>; Sat, 18 Feb 2023 10:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Voh8YMSTHtZzfOucrW8qz+qWP9TlfoNalWbkuhtbr8c=;
        b=VjOLSZrAoYQ/sFOPXUNBQQSTFAbbDk33+ivhj6A2du1n+IT1Q2wTv15KnqAmTsAHFw
         s94Ln1VrxC/5RjqAZPnSaxzotiQVMr5CUEUcXPFmyvWHtn3OqpVvErE2U/dA2ylzn6/e
         cFjax771TJibc4CUxLBKwMoku8JiNubVcz39olFDXVhJMOO/Dkj8AwHnJJYJXtVFDtxf
         UEJLOA6uD3l3hom5aHgqUXTDD0qqN58l7pnrubz0hW+jA9OGgyyZRjdrnNsu4azrqtma
         OADOaBVO+zKFfY0BTi/0Hnw7RJrsx8wkTVGJLFwJz6P/LKux+pwSEW3UbYQ7O2QNrDxg
         07Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Voh8YMSTHtZzfOucrW8qz+qWP9TlfoNalWbkuhtbr8c=;
        b=B5I1aqvjCzxLdYagzq/528iaA7q+k29jhwEiO9Lq1UccDMyHBM54kVXJaQIl0R3gNv
         hTtaKW37PtjaYM/WUDPeaI+4U8g1Gcyuu8yuEilzDcmNn2RCra/bb680u/YgclIoc3A5
         skdlV2fV4JqjkRLYuoGDq1AZOePE1CdDCw0IXWIS4kFvKJQvwFPsmHTK6lajPYPg7PRF
         PkawSYc9HMa9HBRDLAraA87J3p4Gmq3zTnoGSinx1Rk8RWJ3WlaEH6IobX+nBTsAhdHm
         6xuxY8OJtTKooIUhnU2Tl2x3oI45+vwrjOZlLV0zYsySkaSfWGp2qDCmZZ05mHKrWkb7
         hl1Q==
X-Gm-Message-State: AO0yUKWHymbcMnIG25ri3fLGuMbxAU+wGIuR+vA0chGr4RRcOD0Z93cO
        H7r6cOohP0GDF7GWNZP3YuY=
X-Google-Smtp-Source: AK7set9D6FlFVkEu+5jhNESv/MNJCEnSAmxlF6J5f26XXrSoIjH4rf+41URCtAFEVYF17DWLCPrBaQ==
X-Received: by 2002:a05:600c:708:b0:3e0:98c:dd93 with SMTP id i8-20020a05600c070800b003e0098cdd93mr3361131wmn.29.1676745798894;
        Sat, 18 Feb 2023 10:43:18 -0800 (PST)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id p7-20020a05600c1d8700b003dc522dd25esm9478943wms.30.2023.02.18.10.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 10:43:18 -0800 (PST)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH] io_uring: fix size calculation when registering buf ring
Date:   Sat, 18 Feb 2023 18:41:41 +0000
Message-Id: <20230218184141.70891-1-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Using struct_size() to calculate the size of io_uring_buf_ring will sum
the size of the struct and of the bufs array. However, the struct's fields
are overlaid with the array making the calculated size larger than it
should be.

When registering a ring with N * PAGE_SIZE / sizeof(struct io_uring_buf)
entries, i.e. with fully filled pages, the calculated size will span one
more page than it should and io_uring will try to pin the following page.
Depending on how the application allocated the ring, it might succeed
using an unrelated page or fail returning EFAULT.

The size of the ring should be the product of ring_entries and the size
of io_uring_buf, i.e. the size of the bufs array only.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
---
I'll send a liburing test shortly.

 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4a6401080c1f..3002dc827195 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -505,7 +505,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	pages = io_pin_pages(reg.ring_addr,
-			     struct_size(br, bufs, reg.ring_entries),
+			     flex_array_size(br, bufs, reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
 		kfree(free_bl);
-- 
2.30.2

