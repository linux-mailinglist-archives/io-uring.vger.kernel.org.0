Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C745D396BC5
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 05:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhFADNc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 23:13:32 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:39886 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232503AbhFADNc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 23:13:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UaoGa20_1622517099;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UaoGa20_1622517099)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 11:11:50 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] clarify an edge case of IORING_SETUP_SQ_AFF
Date:   Tue,  1 Jun 2021 11:11:39 +0800
Message-Id: <1622517099-197667-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A container may offen be migrated to different cpu set which causes the
bounded cpu set of sqthread being changed as well. This may not be as
users expected, clarify this situation in man page.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 man/io_uring_setup.2 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 3122313a53fa..cb8eba930b84 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -139,7 +139,10 @@ field of the
 .IR "struct io_uring_params" .
 This flag is only meaningful when
 .B IORING_SETUP_SQPOLL
-is specified.
+is specified. When cgroup setting
+.I cpuset.cpus
+changes (typically in container environment), the bounded cpu set may be
+changed as well.
 .TP
 .B IORING_SETUP_CQSIZE
 Create the completion queue with
-- 
1.8.3.1

