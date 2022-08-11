Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7518258F8A9
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiHKH5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKH5F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:57:05 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D05FB1CB29;
        Thu, 11 Aug 2022 00:57:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 3486F1E80D76;
        Thu, 11 Aug 2022 15:55:02 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nH0mPoTT1dVg; Thu, 11 Aug 2022 15:54:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (unknown [219.141.250.2])
        (Authenticated sender: chunchao@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 511BA1E80CE3;
        Thu, 11 Aug 2022 15:54:59 +0800 (CST)
From:   Zhang chunchao <chunchao@nfschina.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@nfschina.com, Zhang chunchao <chunchao@nfschina.com>
Subject: [PATCH] Modify the return value ret to EOPNOTSUPP when initialized to reduce repeated assignment of errno
Date:   Thu, 11 Aug 2022 15:56:38 +0800
Message-Id: <20220811075638.36450-1-chunchao@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove unnecessary initialization assignments.

Signed-off-by: Zhang chunchao <chunchao@nfschina.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b54218da075c..8c267af06401 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3859,14 +3859,13 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
 	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
+	long ret = -EOPNOTSUPP;
 	struct fd f;
 
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
 
-	ret = -EOPNOTSUPP;
 	if (!io_is_uring_fops(f.file))
 		goto out_fput;
 
-- 
2.18.2

