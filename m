Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4E628893D
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387684AbgJIMuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387651AbgJIMt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 08:49:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F818C0613D5;
        Fri,  9 Oct 2020 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bfmHnr+67smDeFgVvxSeiLOBplKDiUuPntx8EbzVRZM=; b=iUdLIFHChKHOwSPWz/wb0g8M8l
        Mk7+6y7NEjJPP5ijadO5xNc8o1Gtp1y2+zymKn2ios/6maR5VguK9ZpCvQ/XjkLBsZuCMM3b/wzOc
        NR9K85q2iXVvecJnJnJm/ncDJU6eTZqXcBVi2sqAjkfsfrUqBCKbnorQd/tKn+/B1A7MvGQuSbSKQ
        dhOBIWJ8MjjgNcPAF0MIWvmwM3hciz4CzT3t/B0nW+FBwbK0LnKsn8kbEe58LunG4g3E4+eCYXz2n
        00nEEUHI8FbwYMTTI8CfBv3LjhED+aRQzCT+U+UAXPIF8V3LxBHlUU1SxT9LPSBRL89R3DVi/UwkE
        7K1vCKAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQrqN-0008IG-O2; Fri, 09 Oct 2020 12:49:55 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/3] io_uring: Convert advanced XArray uses to the normal API
Date:   Fri,  9 Oct 2020 13:49:53 +0100
Message-Id: <20201009124954.31830-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201009124954.31830-1-willy@infradead.org>
References: <20201009124954.31830-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are no bugs here that I've spotted, it's just easier to use the
normal API and there are no performance advantages to using the more
verbose advanced API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/io_uring.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcef6210bf67..1a894df526da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8615,27 +8615,17 @@ static int io_uring_add_task_file(struct file *file)
 static void io_uring_del_task_file(struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, (unsigned long) file);
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-
-	xas_lock(&xas);
-	file = xas_store(&xas, NULL);
-	xas_unlock(&xas);
-
+	file = xa_erase(&tctx->xa, (unsigned long)file);
 	if (file)
 		fput(file);
 }
 
 static void __io_uring_attempt_task_drop(struct file *file)
 {
-	XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-	struct file *old;
-
-	rcu_read_lock();
-	old = xas_load(&xas);
-	rcu_read_unlock();
+	struct file *old = xa_load(&current->io_uring->xa, (unsigned long)file);
 
 	if (old == file)
 		io_uring_del_task_file(file);
-- 
2.28.0

