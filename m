Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD42B59A5
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 07:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgKQGRk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 01:17:40 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44271 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgKQGRk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 01:17:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UFfrlDC_1605593844;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFfrlDC_1605593844)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Nov 2020 14:17:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH 5.11 1/2] io_uring: keep a pointer ref_node in io_kiocb
Date:   Tue, 17 Nov 2020 14:17:22 +0800
Message-Id: <20201117061723.18131-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Basically no functional changes in this patch, just a preparation
for later patch.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index edfd7c3b8de6..219609c38e48 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -714,7 +714,7 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct io_kiocb			*link;
-	struct percpu_ref		*fixed_file_refs;
+	struct fixed_file_ref_node      *ref_node;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -1927,7 +1927,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 			  bool fixed)
 {
 	if (fixed)
-		percpu_ref_put(req->fixed_file_refs);
+		percpu_ref_put(&req->ref_node->refs);
 	else
 		fput(file);
 }
@@ -6344,8 +6344,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
 		if (file) {
-			req->fixed_file_refs = &ctx->file_data->node->refs;
-			percpu_ref_get(req->fixed_file_refs);
+			req->ref_node = ctx->file_data->node;
+			percpu_ref_get(&req->ref_node->refs);
 		}
 	} else {
 		trace_io_uring_file_get(ctx, fd);
-- 
2.17.2

