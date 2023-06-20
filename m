Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9252C736B0A
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjFTLct (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFTLcs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0A3FE
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kx0rflILjnefGz1AIFHCumAr85yYTSMNWuTiLbGBzC0=; b=EJ/+GyohnmQW+q4JsMk65ssfOS
        rj6CbYRk938XsQ9m6dXvFknNAMmybnAW9VuVchJU7PhNz2iMKd+iLJpuybClbsPn9U30QNIqkvxKI
        oIQRT6x6ThyT8NT+OqnHswhMUu6ePi8/VRDQXUEVrEcHx8foII6BMR3sJuIHy+evOc3XR9KB8Yf4k
        fLa9SXHHDztUCV7q7r4FyXTBVwXpUDdtX9mFwCqMgOoNje3pUvG1H1hmUING6dhLZORPaK536NWMg
        UOoBALBwaXngMgod4PxtMJTKwNVBhzR7X1Dd8ZCFa0UHMKlzlmlanFEco0rK8CJI4ROpyp8giVT56
        CisInTAQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbK-00B8Xf-0l;
        Tue, 20 Jun 2023 11:32:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: remove the mode variable in io_file_get_flags
Date:   Tue, 20 Jun 2023 13:32:29 +0200
Message-Id: <20230620113235.920399-3-hch@lst.de>
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

The variable is only once now, so don't bother with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7e735724940f7f..2d13f636de93c7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1773,10 +1773,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
  */
 unsigned int io_file_get_flags(struct file *file)
 {
-	umode_t mode = file_inode(file)->i_mode;
 	unsigned int res = 0;
 
-	if (S_ISREG(mode))
+	if (S_ISREG(file_inode(file)->i_mode))
 		res |= FFS_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
 		res |= FFS_NOWAIT;
-- 
2.39.2

