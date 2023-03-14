Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC456B9CD5
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCNRR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCNRR0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:26 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E9AA4B09
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:07 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j6so4530433ilr.7
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814226; x=1681406226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b3Wq6Txe1YruSA3HHjIHWRJfY4HdWbf9Sp/tXnbhks=;
        b=CA1UGgnmq6QYZ7QCUCN2ZH2MN4mxCLtX0qm2lcEnYe8QL1wE0xRSlKfAIroi8dooSf
         XOGTPqseCq9Em5WeuBBMiSxTsr3x2HBtGHNHqeoj3zt3YOHtGkRJoTIl1in+P5WPpk5Z
         6FA6rJq83JStDDSSWDvFpyzcY+j+7yl33mLMg6QV0Righl1SAwOkQ/Ji+rTfJ6KCZHlA
         GCgQYuI7ljFyEF6KWi5DJ34tEKPUi5IFI2RuNkW3dzzqpEiUkOAjRr6WIBgcRgbEpf3+
         uim6veHdulhq+XZc9BL9FaWC/EupEKy+tqhBfwyQPQ18dHHKaRXabJ7ncUpA+ufh1EwD
         jcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814226; x=1681406226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b3Wq6Txe1YruSA3HHjIHWRJfY4HdWbf9Sp/tXnbhks=;
        b=oL8ElwQ1SLwHky5E932YJicnPL9c9gCcmldf4wjqSf3dGH2Pw3giRaETUWoC1IA34e
         ba5bNviAxDiKuHUBgBwh3Mj4hMJK0InSZWi/cVyRG4Iq3jfzgyPNxOVQjOuDCbVzYDF0
         VOqZt4P2A4MzE9PPFirdFT04rBs6+gFC2kguFkYSb1BMHhUD3FmkzzTZUplBlHPiqg7Q
         cxawWiKx+FFUcxhMGLmTWT06odzcGcTGT0lsK/fo5D/tZnXI6/PR3zVVUV2fiUAhX4uy
         BNyFAtuKyDA+0BfsTzDr/COamvfmUUpOTv6CaRXESyadDBQFggEhapZ18cGfKKtn2vfN
         EJmQ==
X-Gm-Message-State: AO0yUKVtWrio19J+GqtMtuH5lNCq/bTbQll3dZxZh4TzSqMt4HKd9Lj5
        mZc9dLt78dyKtRzsGowByyGpo+WFEM7wWJtvCf5OoQ==
X-Google-Smtp-Source: AK7set8zKtnCVZPMWQDWhohtW9UoO8fsp5tk3VKbnLxInT4wPm6ximciB7KNLQgWG+8LW8X4RYhK+w==
X-Received: by 2002:a92:b11:0:b0:317:94ad:a724 with SMTP id b17-20020a920b11000000b0031794ada724mr306547ilf.2.1678814226192;
        Tue, 14 Mar 2023 10:17:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/kbuf: move pinning of provided buffer ring into helper
Date:   Tue, 14 Mar 2023 11:16:39 -0600
Message-Id: <20230314171641.10542-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for allowing the kernel to allocate the provided buffer
rings and have the application mmap it instead, abstract out the
current method of pinning and mapping the user allocated ring.

No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3002dc827195..3adc08f90e41 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -463,14 +463,32 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
+			    struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br;
-	struct io_uring_buf_reg reg;
-	struct io_buffer_list *bl, *free_bl = NULL;
 	struct page **pages;
 	int nr_pages;
 
+	pages = io_pin_pages(reg->ring_addr,
+			     flex_array_size(br, bufs, reg->ring_entries),
+			     &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	br = page_address(pages[0]);
+	bl->buf_pages = pages;
+	bl->buf_nr_pages = nr_pages;
+	bl->buf_ring = br;
+	return 0;
+}
+
+int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_buf_reg reg;
+	struct io_buffer_list *bl, *free_bl = NULL;
+	int ret;
+
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 
@@ -504,20 +522,15 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 			return -ENOMEM;
 	}
 
-	pages = io_pin_pages(reg.ring_addr,
-			     flex_array_size(br, bufs, reg.ring_entries),
-			     &nr_pages);
-	if (IS_ERR(pages)) {
+	ret = io_pin_pbuf_ring(&reg, bl);
+	if (ret) {
 		kfree(free_bl);
-		return PTR_ERR(pages);
+		return ret;
 	}
 
-	br = page_address(pages[0]);
-	bl->buf_pages = pages;
-	bl->buf_nr_pages = nr_pages;
 	bl->nr_entries = reg.ring_entries;
-	bl->buf_ring = br;
 	bl->mask = reg.ring_entries - 1;
+
 	io_buffer_add_list(ctx, bl, reg.bgid);
 	return 0;
 }
-- 
2.39.2

