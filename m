Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A5288939
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbgJIMuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387652AbgJIMuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 08:50:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23003C0613D6;
        Fri,  9 Oct 2020 05:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7axP9yiXbIBjzekHATSTDJCn73ISkOQYhQEErNFr3Ck=; b=tjZ6ghkAmx2/Y/CHk63QZ/eVab
        NF9bGibKmL1w3itMTNgFUILWCgK9kan6J4WvUoHYF7gXwB/ZGFfcwTQiREaHoShwBRs0CLuTdVn88
        z19bgh7rETJxi/gEMBI1vrvM1VyX5ukrDEhPNLgOhIMP4tIitKcvCe0LdyUlj6rMzvje+9Sd2E5bJ
        ujGFdZMHtK10rlwwQvqaCFkndDmcinBsRILunfxXqvOV3WMrtnIVU1eYGx7Vcaz26Aje5XkTc52EO
        jOeW/L8SeSA6v/P8l7Vwqdz3KaEunVFseE9LiXY4bXcvIWt3X/FscOShPh5UhVFedJjp6/3sG1f0L
        1Ga9Q7eA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQrqN-0008IC-GZ; Fri, 09 Oct 2020 12:49:55 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/3] io_uring: Fix XArray usage in io_uring_add_task_file
Date:   Fri,  9 Oct 2020 13:49:52 +0100
Message-Id: <20201009124954.31830-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201009124954.31830-1-willy@infradead.org>
References: <20201009124954.31830-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The xas_store() wasn't paired with an xas_nomem() loop, so if it couldn't
allocate memory using GFP_NOWAIT, it would leak the reference to the file
descriptor.  Also the node pointed to by the xas could be freed between
the call to xas_load() under the rcu_read_lock() and the acquisition of
the xa_lock.

It's easier to just use the normal xa_load/xa_store interface here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2978cc78538a..bcef6210bf67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8586,27 +8586,24 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
  */
 static int io_uring_add_task_file(struct file *file)
 {
-	if (unlikely(!current->io_uring)) {
+	struct io_uring_task *cur_uring = current->io_uring;
+
+	if (unlikely(!cur_uring)) {
 		int ret;
 
 		ret = io_uring_alloc_task_context(current);
 		if (unlikely(ret))
 			return ret;
 	}
-	if (current->io_uring->last != file) {
-		XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-		void *old;
+	if (cur_uring->last != file) {
+		void *old = xa_load(&cur_uring->xa, (unsigned long)file);
 
-		rcu_read_lock();
-		old = xas_load(&xas);
-		if (old != file) {
+		if (!old) {
 			get_file(file);
-			xas_lock(&xas);
-			xas_store(&xas, file);
-			xas_unlock(&xas);
+			xa_store(&cur_uring->xa, (unsigned long)file, file,
+					GFP_KERNEL);
 		}
-		rcu_read_unlock();
-		current->io_uring->last = file;
+		cur_uring->last = file;
 	}
 
 	return 0;
-- 
2.28.0

