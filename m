Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68052736B0E
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjFTLdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFTLdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:33:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7205E130
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q88bOLkv1vZXWuiPW58K2AE3L23Zp9g+dU/2Q7O5Q9k=; b=r0J4tlO3/n1id2C2BVg1lwHzXr
        AA6l5TojjS+gRarIc0H0RqngeqohICuoqVwCIwTZijFVRKzl0nly5hcaTHgTtp16aoMyRlY9LlRvK
        G7BqRTVNLXRVYBoN4wc2RngHm+NZMUvdjBGsC9wXbltN8YSj0ctAo14DbaMsBKKZofyqDpiebm1IT
        KedXjx0Myl9Aq/hAeCcB6OUmvbvguMFK6wdt6BlEj8zafMnM5bLKijD1WHdgaO/g+Eb+qBWwyNfrk
        SP3QPgnKdV145jzOkLO5LaA2wpLdkicOeaGu+OOYrz1g3XT1DqotJBInodYgRAqngaRfSrmdkBYFd
        vNrBnuQg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbX-00B8ap-0S;
        Tue, 20 Jun 2023 11:32:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: use io_file_from_index in __io_sync_cancel
Date:   Tue, 20 Jun 2023 13:32:33 +0200
Message-Id: <20230620113235.920399-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use io_file_from_index instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/cancel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index b4f5dfacc0c31d..58c46c852bdd9a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -216,13 +216,10 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 	/* fixed must be grabbed every time since we drop the uring_lock */
 	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
-		unsigned long file_ptr;
-
 		if (unlikely(fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
-		file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
-		cd->file = (struct file *) (file_ptr & FFS_MASK);
+		cd->file = io_file_from_index(&ctx->file_table, fd);
 		if (!cd->file)
 			return -EBADF;
 	}
-- 
2.39.2

