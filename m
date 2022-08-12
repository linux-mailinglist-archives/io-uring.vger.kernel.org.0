Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A5C590A12
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 04:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiHLCAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 22:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiHLCAQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 22:00:16 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09CD7BAE;
        Thu, 11 Aug 2022 19:00:14 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id F19D81E80D0E;
        Fri, 12 Aug 2022 09:58:04 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UNQzZ4lInD8g; Fri, 12 Aug 2022 09:58:02 +0800 (CST)
Received: from localhost.localdomain.localdomain (unknown [219.141.250.2])
        (Authenticated sender: chunchao@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 3C11F1E80CB7;
        Fri, 12 Aug 2022 09:58:02 +0800 (CST)
From:   Zhang chunchao <chunchao@nfschina.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@nfschina.com, Zhang chunchao <chunchao@nfschina.com>
Subject: [PATCH] io_uring: Optimizing return value
Date:   Fri, 12 Aug 2022 10:00:00 +0800
Message-Id: <20220812020000.3720-1-chunchao@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Delete return value ret Initialize assignment, change return value ret
to EOPNOTSUPP when IO_IS_URING_FOPS failed.

Signed-off-by: Zhang chunchao <chunchao@nfschina.com>
---
 io_uring/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b54218da075c..1b56f3d1a47b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3859,16 +3859,17 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
 	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
+	long ret;
 	struct fd f;
 
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
 
-	ret = -EOPNOTSUPP;
-	if (!io_is_uring_fops(f.file))
+	if (!io_is_uring_fops(f.file)) {
+		ret = -EOPNOTSUPP;
 		goto out_fput;
+	}
 
 	ctx = f.file->private_data;
 
-- 
2.18.2

