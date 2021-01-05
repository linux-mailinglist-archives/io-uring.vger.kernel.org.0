Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76E2EAC16
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 14:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbhAENnD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 08:43:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9956 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbhAENnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jan 2021 08:43:03 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D9DDc6Zlqzj2dT;
        Tue,  5 Jan 2021 21:41:36 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 21:42:14 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] =?UTF-8?q?io=5Furing:=20Delete=20useless=20variable=20?= =?UTF-8?q?=E2=80=98id=E2=80=99=20in=20io=5Fprep=5Fasync=5Fwork?=
Date:   Tue, 5 Jan 2021 21:53:40 +0800
Message-ID: <20210105135340.51287-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix follow warning:
fs/io_uring.c:1523:22: warning: variable ‘id’ set but not used
[-Wunused-but-set-variable]
  struct io_identity *id;
                        ^~
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..7880cfe01e4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1520,10 +1520,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_identity *id;
 
 	io_req_init_async(req);
-	id = req->work.identity;
 
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
-- 
2.16.2.dirty

