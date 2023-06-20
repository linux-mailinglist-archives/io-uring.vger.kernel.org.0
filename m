Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45359736B0B
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjFTLcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFTLcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B010A10F3
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TUSVxYaytrTe3oUKDr6xrBrOzikkQ3pHL+E+pAfVEjM=; b=yLeVZ4Xn6aGauUb0aua5GXYmri
        VOT7k8A9FChh4F2lTcbYkVZAEBn9EbDPJ1Am0SNJdsmiDS49FxMcMEz7XC3sdZnJA3Y/m9kB1UoDf
        32iVmPEpYWwCZS7xohMh71iHhNUuulocj2p1k6J/LSYU+MG4k6e3dJkTou9Ae6ucvalSvAvk5IANr
        apauzTom31F1/SMwYza4MEQvsmmzMk/wSBbyjNkFGiWlnZ+1Y89Rrqu7kbksZhgGdauh89vDkDcmg
        1WCfAcynxY6wvOQbE0lDnhsny0IrinjfX4dsMMW+4ZAyxH8T7wMsOauTnaWV8naOfvLZRkfSXP0EN
        2D1ag6wQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbN-00B8Ye-1R;
        Tue, 20 Jun 2023 11:32:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: remove a confusing comment above io_file_get_flags
Date:   Tue, 20 Jun 2023 13:32:30 +0200
Message-Id: <20230620113235.920399-4-hch@lst.de>
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

The SCM inflight mechanism has nothing to do with the fact that a file
might be a regular file or not and if it supports non-blocking
operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2d13f636de93c7..79f3cabec5b934 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1766,11 +1766,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-/*
- * If we tracked the file through the SCM inflight mechanism, we could support
- * any file. For now, just ensure that anything potentially problematic is done
- * inline.
- */
 unsigned int io_file_get_flags(struct file *file)
 {
 	unsigned int res = 0;
-- 
2.39.2

