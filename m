Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FAA48DB92
	for <lists+io-uring@lfdr.de>; Thu, 13 Jan 2022 17:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiAMQUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jan 2022 11:20:13 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:38733 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbiAMQUN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jan 2022 11:20:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1kH4pu_1642090806;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V1kH4pu_1642090806)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 00:20:11 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring: Remove unused function req_ref_put
Date:   Fri, 14 Jan 2022 00:20:05 +0800
Message-Id: <20220113162005.3011-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix the following clang warnings:

fs/io_uring.c:1195:20: warning: unused function 'req_ref_put'
[-Wunused-function].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de9c9de90655..fa3277844d2e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1192,12 +1192,6 @@ static inline bool req_ref_put_and_test(struct io_kiocb *req)
 	return atomic_dec_and_test(&req->refs);
 }
 
-static inline void req_ref_put(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-	WARN_ON_ONCE(req_ref_put_and_test(req));
-}
-
 static inline void req_ref_get(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-- 
2.20.1.7.g153144c

