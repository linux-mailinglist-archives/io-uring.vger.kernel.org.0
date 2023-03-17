Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85EC6BC37A
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 02:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCPByW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 21:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPByW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 21:54:22 -0400
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F6901A;
        Wed, 15 Mar 2023 18:54:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id C62901A00AC9;
        Thu, 16 Mar 2023 09:54:19 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jy_PM_FF9VBF; Thu, 16 Mar 2023 09:54:19 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id D666F1A00874;
        Thu, 16 Mar 2023 09:54:18 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [v2 PATCH] io_uring: rsrc: Optimize return value variable 'ret'
Date:   Sat, 18 Mar 2023 02:25:38 +0800
Message-Id: <20230317182538.3027-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_24_48,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The initialization assignment of the variable ret is changed to 0, only
in 'goto fail;' Use the ret variable as the function return value.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 v2: Modify the initialization value of ret variable.

 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 056f40946ff6..09a16d709cb5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -410,7 +410,7 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 				     unsigned nr, struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
-	int ret = -ENOMEM;
+	int ret = 0;
 	unsigned i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
-- 
2.18.2

