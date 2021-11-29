Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E514460DEF
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 05:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhK2EIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Nov 2021 23:08:49 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31918 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhK2EGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Nov 2021 23:06:49 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J2Wt41YFzzcbYq;
        Mon, 29 Nov 2021 12:03:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 29 Nov
 2021 12:03:29 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next] io_uring: Fix undefined-behaviour in io_issue_sqe if pass large timeout value when call io_timeout_remove_prep
Date:   Mon, 29 Nov 2021 12:15:37 +0800
Message-ID: <20211129041537.1936270-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch fix another scene lead to the issue which
"io_uring: Fix undefined-behaviour in io_issue_sqe" commit descript.
Add check if timeout is legal which user space pass in when call
io_timeout_remove_prep to update timeout value.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39fd7372b324..de913334f22e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6114,6 +6114,8 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 			return -EINVAL;
 		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
 			return -EFAULT;
+		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
+			return -EINVAL;
 	} else if (tr->flags) {
 		/* timeout removal doesn't support flags */
 		return -EINVAL;
-- 
2.31.1

