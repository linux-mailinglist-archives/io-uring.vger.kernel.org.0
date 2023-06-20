Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E6473637F
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 08:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjFTGS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFTGS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 02:18:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC4010DD;
        Mon, 19 Jun 2023 23:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3i6MMHT2wfzCoDzGYDuUu3+8TyK3uxMMdf1RSnNDHQI=; b=vbdCSE3zP6ZIaL6vPGpUCeSU43
        NY9kswIKvbx4N0gZfxIUNEOzS5MVIXy9PtWlV/3L4DughvrO2t03r0kDpTUCxbcpJg51B0QzKyslI
        EcTd9MtTXBPTiGuQnsd9GOIIoylLjrcqkyZ4aI2PYsLkXI+lOiCE8zylW+0NrlUpjdst3KO3LASg1
        pzenbLFn26DmouZsdoJeDDkmmn9SK0Vbw80yzFC94iDXn8Blh0Oo+cXUs1vFL111cjJbKl31ocYGK
        Kc/qoPrSaVsFPtt0wYFHQAw2de5x3qvej7BAqTaFF0Os/Db+bWddF2/Wm7HKz7BJF14aFABrTxNyo
        d2zMID4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qBUhb-00AGAn-2z;
        Tue, 20 Jun 2023 06:18:55 +0000
Date:   Mon, 19 Jun 2023 23:18:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] block: mark bdev files as FMODE_NOWAIT if underlying
 device supports it
Message-ID: <ZJFEz2FKuvIf8aCL@infradead.org>
References: <20230509151910.183637-1-axboe@kernel.dk>
 <20230509151910.183637-3-axboe@kernel.dk>
 <ZFucWYxUtBvvRJpR@infradead.org>
 <8d5daf0d-c623-5918-d40e-ab3ad1c508ad@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d5daf0d-c623-5918-d40e-ab3ad1c508ad@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So it turns out this gets into the way of my planned cleanup to move
all the tatic FMODE_ flags out of this basically full field into a new
static one in file_operations.  Do you think it is ok to go back to
always claiming FMODE_NOWAIT for block devices and then just punt for
the drivers that don't support it like the patch below?

---
From 05a591ac066d9d2d57c4967bbd49c8bc63b04abf Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Jun 2023 07:53:13 +0200
Subject: block: always set FMODE_NOWAIT

Block devices are the only file_operation that do not set FMODE_NOWAIT
unconditionall in ->open and thus get in the way of a planned cleanup to
move this flags into a static field in file_operations.   Switch to
always set FMODE_NOWAIT and just return -EAGAIN if it isn't actually
supported.  This just affects minor ->submit_bio based drivers as all
blk-mq drivers and the important remappers (dm, md, nvme-multipath)
support nowait I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 555b1b9ecd2cb9..8068d0c85ae75b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -505,7 +505,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	 * during an unstable branch.
 	 */
 	filp->f_flags |= O_LARGEFILE;
-	filp->f_mode |= FMODE_BUF_RASYNC;
+	filp->f_mode |= FMODE_BUF_RASYNC | FMODE_NOWAIT;
 
 	/*
 	 * Use the file private data to store the holder for exclusive openes.
@@ -519,9 +519,6 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	if (bdev_nowait(bdev))
-		filp->f_mode |= FMODE_NOWAIT;
-
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	return 0;
@@ -563,6 +560,9 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
+	if (!bdev_nowait(bdev))
+		return -EAGAIN;
+
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
 		shorted = iov_iter_count(from) - size;
@@ -585,6 +585,9 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t ret = 0;
 	size_t count;
 
+	if (!bdev_nowait(bdev))
+		return -EAGAIN;
+
 	if (unlikely(pos + iov_iter_count(to) > size)) {
 		if (pos >= size)
 			return 0;
-- 
2.39.2

