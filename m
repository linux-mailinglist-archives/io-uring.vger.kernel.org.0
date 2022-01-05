Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB848510E
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 11:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiAEKVT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 05:21:19 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.226]:37797 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239406AbiAEKVS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 05:21:18 -0500
HMM_SOURCE_IP: 172.18.0.218:48684.1571331312
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.92 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 6225E2800AA;
        Wed,  5 Jan 2022 18:13:07 +0800 (CST)
X-189-SAVE-TO-SEND: +zhenggy@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 97814b44f502412390feeacc96d5d9cd for axboe@kernel.dk;
        Wed, 05 Jan 2022 18:13:09 CST
X-Transaction-ID: 97814b44f502412390feeacc96d5d9cd
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: zhenggy@chinatelecom.cn
From:   GuoYong Zheng <zhenggy@chinatelecom.cn>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        GuoYong Zheng <zhenggy@chinatelecom.cn>
Subject: [PATCH] io_uring: remove redundant tap space
Date:   Wed,  5 Jan 2022 18:13:05 +0800
Message-Id: <1641377585-1891-1-git-send-email-zhenggy@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When show fdinfo, SqMask follow two tap space, Inconsistent with
other paras, remove one.

Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6fb1bb..78a6181 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10553,7 +10553,7 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	 * and sq_tail and cq_head are changed by userspace. But it's ok since
 	 * we usually use these info when it is stuck.
 	 */
-	seq_printf(m, "SqMask:\t\t0x%x\n", sq_mask);
+	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
 	seq_printf(m, "SqHead:\t%u\n", sq_head);
 	seq_printf(m, "SqTail:\t%u\n", sq_tail);
 	seq_printf(m, "CachedSqHead:\t%u\n", ctx->cached_sq_head);
-- 
1.8.3.1

