Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D5736B10
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjFTLdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjFTLdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:33:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91710F8
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ui9RC+SDnLSFPQtKGL043gFzJwOrRieWjY/b9vsqTNM=; b=Pqq+ur9s55XMkaeb/G707/lxbv
        VrdZTsXkDAlbUMQ4OfK9/ktjVnT2JQCPWatdWj1040CXA3wLG4BCU4tp9T0M0UZIRVIsW049F0pTL
        lobancWhU231lY7yQON9NDw1AlZZKifYpZPlsHLHe/SZgnH6hujldnWnYUVU40h/RZkvj8wMMDmsJ
        qqpA55ZayUs5I3IOEIWdHp64IpQhntNN1jPNx6pBsk0b9EjtpIYnIqAb2ipgGEI9LOJ1ejKHmW90V
        Mqv6MyRhOoP8KAleNXT2dVgoHzrT9t7h1QkmremIdWwbiKrJN0NfEli0gjQPTkcel1WeuwkrgPpEO
        wnPM52HQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZba-00B8bl-1S;
        Tue, 20 Jun 2023 11:33:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: use io_file_from_index in io_msg_grab_file
Date:   Tue, 20 Jun 2023 13:32:34 +0200
Message-Id: <20230620113235.920399-8-hch@lst.de>
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
 io_uring/msg_ring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 85fd7ce5f05b85..cd6dcf634ba3cd 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -162,14 +162,12 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = NULL;
-	unsigned long file_ptr;
 	int idx = msg->src_fd;
 
 	io_ring_submit_lock(ctx, issue_flags);
 	if (likely(idx < ctx->nr_user_files)) {
 		idx = array_index_nospec(idx, ctx->nr_user_files);
-		file_ptr = io_fixed_file_slot(&ctx->file_table, idx)->file_ptr;
-		file = (struct file *) (file_ptr & FFS_MASK);
+		file = io_file_from_index(&ctx->file_table, idx);
 		if (file)
 			get_file(file);
 	}
-- 
2.39.2

