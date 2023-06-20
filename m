Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C177365FC
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 10:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjFTIWn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 04:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjFTIWm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 04:22:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE22E72;
        Tue, 20 Jun 2023 01:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aY/GHphTzSqrblGLnT2lqkDfbH0+6FyRO/00GzxaGNc=; b=QOftA5ku4YdAvQ3OxFc0cD/U+l
        zweN/cuddeShnRLQxdFLX3nOF8C5cnxqLoq/eqDhM4zfJCMbDRJAipiHnHqzgQ7gK6gPauTTbVO4h
        sg/pu/ifc19KrWxw4V/Tmf1RZV247n/1L1XbdsHBZYhqkfUyGjOn8+EXYtv5HF6GCe2EkI7WjR+ZW
        sHKaWmkZLp0v4G08kRWMAampnpEos7jFIbGIA6FPOooQQD8IZN+N3r53IlavLG/bAJNUFLRE5F+rs
        YnutZi94PLjARBevOA8guq4NxA1dzHU3sLrKy0gSTjxD1Wkie1Qa3YWXr56ZkQaA1sPbcyt7u8S0f
        7N3NTYKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qBWd2-00AYvy-0k;
        Tue, 20 Jun 2023 08:22:20 +0000
Date:   Tue, 20 Jun 2023 01:22:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] block: mark bdev files as FMODE_NOWAIT if underlying
 device supports it
Message-ID: <ZJFhvAYlSQfJmQC2@infradead.org>
References: <20230509151910.183637-1-axboe@kernel.dk>
 <20230509151910.183637-3-axboe@kernel.dk>
 <ZFucWYxUtBvvRJpR@infradead.org>
 <8d5daf0d-c623-5918-d40e-ab3ad1c508ad@kernel.dk>
 <ZJFEz2FKuvIf8aCL@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJFEz2FKuvIf8aCL@infradead.org>
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

On Mon, Jun 19, 2023 at 11:18:55PM -0700, Christoph Hellwig wrote:
> So it turns out this gets into the way of my planned cleanup to move
> all the tatic FMODE_ flags out of this basically full field into a new
> static one in file_operations.  Do you think it is ok to go back to
> always claiming FMODE_NOWAIT for block devices and then just punt for
> the drivers that don't support it like the patch below?

Except that the version I posted if of course completly broken as my
testing rig told me.  This is the version that actually works:

---
From 7916df7434e1570978b9c81c65aa1ec1f3396b13 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Jun 2023 07:53:13 +0200
Subject: block: always set FMODE_NOWAIT

Block devices are the only file_operations that do not set FMODE_NOWAIT
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
index 555b1b9ecd2cb9..58c2f65ae4a57e 100644
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
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !bdev_nowait(bdev))
+		return -EAGAIN;
+
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
 		shorted = iov_iter_count(from) - size;
@@ -585,6 +585,9 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t ret = 0;
 	size_t count;
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !bdev_nowait(bdev))
+		return -EAGAIN;
+
 	if (unlikely(pos + iov_iter_count(to) > size)) {
 		if (pos >= size)
 			return 0;
-- 
2.39.2

