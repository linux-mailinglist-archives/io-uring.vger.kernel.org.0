Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CE6251C0
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 04:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiKKDhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 22:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiKKDhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 22:37:31 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2852C3FB97
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 19:37:30 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7knj6kWgzbnfR;
        Fri, 11 Nov 2022 11:33:45 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:37:28 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:37:27 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <wangxiongfeng2@huawei.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH] tools/io_uring/io_uring-cp: fix compile warning in copy_file()
Date:   Fri, 11 Nov 2022 11:56:02 +0800
Message-ID: <20221111035602.9322-1-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Build tools/io_uring emits the following warnings.

io_uring-cp.c: In function ‘copy_file’:
io_uring-cp.c:158:17: warning: comparison of integer expressions of different signedness: ‘int’ and ‘long unsigned int’ [-Wsign-compare]
  158 |   if (had_reads != reads) {
      |                 ^~
io_uring-cp.c:201:24: warning: comparison of integer expressions of different signedness: ‘__s32’ {aka ‘int’} and ‘size_t’ {aka ‘long unsigned int’} [-Wsign-compare]
  201 |    } else if (cqe->res != data->iov.iov_len) {
      |                        ^~

Change the type of 'had_reads' to 'unsigned long' to fix the first
compile warning. For the second warning, cast 'cqe->res' to
'__kernel_size_t' before comparison to fix it.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 tools/io_uring/io_uring-cp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/io_uring/io_uring-cp.c b/tools/io_uring/io_uring-cp.c
index d9bd6f5f8f46..643c226f91ac 100644
--- a/tools/io_uring/io_uring-cp.c
+++ b/tools/io_uring/io_uring-cp.c
@@ -131,7 +131,8 @@ static int copy_file(struct io_uring *ring, off_t insize)
 	writes = reads = offset = 0;
 
 	while (insize || write_left) {
-		int had_reads, got_comp;
+		unsigned long had_reads;
+		int got_comp;
 
 		/*
 		 * Queue up as many reads as we can
@@ -198,7 +199,7 @@ static int copy_file(struct io_uring *ring, off_t insize)
 				fprintf(stderr, "cqe failed: %s\n",
 						strerror(-cqe->res));
 				return 1;
-			} else if (cqe->res != data->iov.iov_len) {
+			} else if ((__kernel_size_t)cqe->res != data->iov.iov_len) {
 				/* Short read/write, adjust and requeue */
 				data->iov.iov_base += cqe->res;
 				data->iov.iov_len -= cqe->res;
-- 
2.20.1

