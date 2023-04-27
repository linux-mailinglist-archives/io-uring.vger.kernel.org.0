Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279EC6F0782
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 16:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjD0Ocl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 10:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbjD0Och (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 10:32:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC7E04C2B;
        Thu, 27 Apr 2023 07:32:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AA702F4;
        Thu, 27 Apr 2023 07:32:48 -0700 (PDT)
Received: from e125637.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DABC3F64C;
        Thu, 27 Apr 2023 07:32:03 -0700 (PDT)
From:   Tudor Cretu <tudor.cretu@arm.com>
To:     io-uring@vger.kernel.org
Cc:     =axboe@kernel.dk, asml.silence@gmail.com, kevin.brodsky@arm.com,
        linux-kernel@vger.kernel.org, Tudor Cretu <tudor.cretu@arm.com>
Subject: [PATCH] io_uring/kbuf: Fix size for shared buffer ring
Date:   Thu, 27 Apr 2023 15:31:42 +0100
Message-Id: <20230427143142.3013020-1-tudor.cretu@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The size of the ring is the product of ring_entries and the size of
struct io_uring_buf. Using struct_size is equivalent to
  (ring_entries + 1) * sizeof(struct io_uring_buf)
and generates an off-by-one error. Fix it by using size_mul directly.

Signed-off-by: Tudor Cretu <tudor.cretu@arm.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4a6401080c1f..9770757c89a0 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -505,7 +505,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	pages = io_pin_pages(reg.ring_addr,
-			     struct_size(br, bufs, reg.ring_entries),
+			     size_mul(sizeof(struct io_uring_buf), reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
 		kfree(free_bl);
-- 
2.34.1

