Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06D69DB4F
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 08:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBUHic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 02:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjBUHib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 02:38:31 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77331C178;
        Mon, 20 Feb 2023 23:37:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VcB7gWq_1676965067;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VcB7gWq_1676965067)
          by smtp.aliyun-inc.com;
          Tue, 21 Feb 2023 15:37:51 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH tools/io_uring] tools/io_uring: correctly set "ret" for sq_poll case
Date:   Tue, 21 Feb 2023 15:37:36 +0800
Message-Id: <20230221073736.628851-1-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For sq_poll case, "ret" is not initialized or cleared/set. In this way,
output of this test program is incorrect and we can not even stop this
program by pressing CTRL-C.

Reset "ret" to zero in each submission/completion round, and assign
"ret" to "this_reap".

Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
 tools/io_uring/io_uring-bench.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/io_uring/io_uring-bench.c b/tools/io_uring/io_uring-bench.c
index 7703f0118385..3c0feb48f6f6 100644
--- a/tools/io_uring/io_uring-bench.c
+++ b/tools/io_uring/io_uring-bench.c
@@ -289,6 +289,7 @@ static void *submitter_fn(void *data)
 	do {
 		int to_wait, to_submit, this_reap, to_prep;
 
+		ret = 0;
 		if (!prepped && s->inflight < DEPTH) {
 			to_prep = min(DEPTH - s->inflight, BATCH_SUBMIT);
 			prepped = prep_more_ios(s, to_prep);
@@ -334,6 +335,8 @@ static void *submitter_fn(void *data)
 				this_reap += r;
 		} while (sq_thread_poll && this_reap < to_wait);
 		s->reaps += this_reap;
+		if (sq_thread_poll)
+			ret = this_reap;
 
 		if (ret >= 0) {
 			if (!ret) {
-- 
2.18.4

