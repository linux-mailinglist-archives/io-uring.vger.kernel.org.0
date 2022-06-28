Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB40B55EDED
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 21:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiF1TmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 15:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiF1Tlh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 15:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F5D3B009;
        Tue, 28 Jun 2022 12:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614D561C4A;
        Tue, 28 Jun 2022 19:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC0C3411D;
        Tue, 28 Jun 2022 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656444802;
        bh=K3kHQhJPaCS9ujF3pAf7ru9GxwKLPELhJP03Sl6nXKs=;
        h=Date:From:To:Cc:Subject:From;
        b=ZCvhyL/EIvGNIBTLpC0Wg8QISTM8BnjQnTDtEBU2nuijTigalafky7j4ZIRY0fvBn
         Db9Pt0jUQX/DLTbJ37q1svuji4IUDFQPDvw2erR0bMpKaEjl1VMEnClNqj1yIPYoAm
         rpPftR7woTH/NctMi0sXAP8C6H6p0EfDh9C+13gALyyrjJFaCrLTNYqwnShSrOa2a+
         ZysAFNiMzAVRCq/5ewllBmdsjz+0DikK93Du4cehlOWk4Sub4iHoNEmaLmSZx3093f
         PS6fArqhC1jrc3iaw0Yzi7DPj4kkayNI+z6K40pds1UuVNKnMEWqq2Y5Yi7qYLr/Ye
         ufJ4QIakS5ajg==
Date:   Tue, 28 Jun 2022 21:33:20 +0200
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] io_uring: replace zero-length array with
 flexible-array member
Message-ID: <20220628193320.GA52629@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 09e7c3b13d2d..65345848be2f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -492,7 +492,7 @@ struct io_uring_probe {
 	__u8 ops_len;	/* length of ops[] array below */
 	__u16 resv;
 	__u32 resv2[3];
-	struct io_uring_probe_op ops[0];
+	struct io_uring_probe_op ops[];
 };
 
 struct io_uring_restriction {
-- 
2.27.0

