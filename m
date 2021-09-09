Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFA6404760
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 10:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhIIIyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 04:54:23 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9021 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhIIIyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 04:54:23 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H4t6q5gPkzVqZv;
        Thu,  9 Sep 2021 16:52:19 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 9 Sep 2021 16:53:12 +0800
Received: from huawei.com (10.174.28.241) by dggpemm500004.china.huawei.com
 (7.185.36.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 9 Sep 2021
 16:53:12 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <john.wanghui@huawei.com>
Subject: [PATCH -next] io-wq: Fix memory leak in create_io_worker
Date:   Thu, 9 Sep 2021 16:49:19 +0800
Message-ID: <20210909084919.29644-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.28.241]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_should_retry_thread is false, free the worker before goto fails.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
 fs/io-wq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d80e4a735677..036953f334d4 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -759,6 +759,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		kfree(worker);
 		goto fail;
 	} else {
 		INIT_WORK(&worker->work, io_workqueue_create);
-- 
2.17.1

