Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1DF633BEE
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 12:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiKVL5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 06:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiKVL5p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 06:57:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35C52600
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 03:57:42 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NGjMZ6X35zqSb1;
        Tue, 22 Nov 2022 19:53:46 +0800 (CST)
Received: from kwepemm600014.china.huawei.com (7.193.23.54) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 19:57:41 +0800
Received: from huawei.com (10.90.53.225) by kwepemm600014.china.huawei.com
 (7.193.23.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 22 Nov
 2022 19:57:40 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <axboe@kernel.dk>, <dylany@fb.com>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>
Subject: [PATCH -next] io_uring: Fix build error without CONFIG_EVENTFD
Date:   Tue, 22 Nov 2022 20:02:43 +0800
Message-ID: <20221122120243.76186-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600014.china.huawei.com (7.193.23.54)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If CONFIG_IO_URING=y, CONFIG_EVENTFD=n, bulding fails:

io_uring/io_uring.c: In function ‘io_eventfd_ops’:
io_uring/io_uring.c:498:3: error: implicit declaration of function ‘eventfd_signal_mask’; did you mean ‘eventfd_signal’? [-Werror=implicit-function-declaration]
   eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);

This patch fixes that.

Fixes: 261187e66de3 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 include/linux/eventfd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index e849329ce1a8..6c541c9a2478 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -67,6 +67,12 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
 	return -ENOSYS;
 }
 
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx,
+				       __u64 n, unsigned mask)
+{
+	return -ENOSYS;
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
-- 
2.25.1

