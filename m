Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20902EC0EF
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbhAFQRN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 11:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbhAFQRN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 11:17:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1163C06134D;
        Wed,  6 Jan 2021 08:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ns/8b6WrIA7MMHf4WsPJu0vdjDlHmaHEsY/klE9k97c=; b=FtulGt/Y++hPqKpKQfw990eNW6
        +1fHIgtdIQwFQc+e8/vemTj6Xnzz7cSu6GfFxDfG0RmYcxKKP8nYVqTvjxximQ48CUR/gdkBZsPI1
        K88nN6R3RC3i3VI+3q1cqMC45KubY/8pR0Xp6uhPoDsOqPpRCzSh+P8tPFQTtWsSSG1Uf5p/wYY3T
        NrbXTq0EtOYflTr1SGl4ew7UOf+edfE59XQvnu89tRFZKWGWk94AGLFGuchscqF/RukT6RPjZkDXp
        IMkco9OOiDj5AicdtjJuDPU1iRvRRoLBLHhZZ5vmA6kqTsiB5bc5ARsIyLGB+eco0+8MSAjwxsKe7
        Opf9BHuw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kxBNK-002UTp-0X; Wed, 06 Jan 2021 16:10:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] io_uring: Fix return value from alloc_fixed_file_ref_node
Date:   Wed,  6 Jan 2021 16:09:26 +0000
Message-Id: <20210106160926.593770-1-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

alloc_fixed_file_ref_node() currently returns an ERR_PTR on failure.
io_sqe_files_unregister() expects it to return NULL and since it can only
return -ENOMEM, it makes more sense to change alloc_fixed_file_ref_node()
to behave that way.

Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..d4d3e30331e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7684,12 +7684,12 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 
 	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 	if (!ref_node)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
@@ -7783,9 +7783,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ref_node = alloc_fixed_file_ref_node(ctx);
-	if (IS_ERR(ref_node)) {
+	if (!ref_node) {
 		io_sqe_files_unregister(ctx);
-		return PTR_ERR(ref_node);
+		return -ENOMEM;
 	}
 
 	io_sqe_files_set_node(file_data, ref_node);
@@ -7885,8 +7885,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	ref_node = alloc_fixed_file_ref_node(ctx);
-	if (IS_ERR(ref_node))
-		return PTR_ERR(ref_node);
+	if (!ref_node)
+		return -ENOMEM;
 
 	done = 0;
 	fds = u64_to_user_ptr(up->fds);
-- 
2.29.2

