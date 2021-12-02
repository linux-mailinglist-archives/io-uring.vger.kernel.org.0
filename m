Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B633B465E4E
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 07:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345240AbhLBGlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 01:41:08 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29144 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344659AbhLBGlG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 01:41:06 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J4R6R513BzQjJj;
        Thu,  2 Dec 2021 14:35:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 2 Dec
 2021 14:37:42 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next] io_uring: use timespec64_valid() to verify time value
Date:   Thu, 2 Dec 2021 14:49:46 +0800
Message-ID: <20211202064946.1424490-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's better to use timespec64_valid() to verify time value.

Fixes: 2087009c74d4("io_uring: validate timespec for timeout removals")
Fixes: f6223ff79966("io_uring: Fix undefined-behaviour in io_issue_sqe")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 568729677e25..929ff732d6dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6151,7 +6151,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 			return -EINVAL;
 		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
 			return -EFAULT;
-		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
+		if (!timespec64_valid(&tr->ts))
 			return -EINVAL;
 	} else if (tr->flags) {
 		/* timeout removal doesn't support flags */
@@ -6238,7 +6238,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
-	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
+	if (!timespec64_valid(&data->ts))
 		return -EINVAL;
 
 	data->mode = io_translate_timeout_mode(flags);
-- 
2.31.1

