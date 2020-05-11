Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D92B1CD83A
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2020 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgEKLZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 May 2020 07:25:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729736AbgEKLZ6 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 11 May 2020 07:25:58 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BA6B1EC8239F9FC32A17;
        Mon, 11 May 2020 19:25:55 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 11 May 2020 19:25:46 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nixiaoming@huawei.com>,
        <wangle6@huawei.com>
Subject: [PATCH] fs:io_uring:Remove duplicate semicolons at the end of line
Date:   Mon, 11 May 2020 19:25:43 +0800
Message-ID: <1589196343-84741-1-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove duplicate semicolons at the end of line in fs/io_uring.c

Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 381d50b..8c543f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5379,7 +5379,7 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	struct fixed_file_table *table;
 
 	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
-	return table->files[index & IORING_FILE_TABLE_MASK];;
+	return table->files[index & IORING_FILE_TABLE_MASK];
 }
 
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
-- 
1.8.5.6

