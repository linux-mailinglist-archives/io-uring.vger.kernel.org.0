Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980182D3E32
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 10:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgLIJH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 04:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgLIJH3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 04:07:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5465C0613D6;
        Wed,  9 Dec 2020 01:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MNMpVWDVu1xKs8I0T0Bns+VkPimcOASCojWukxDS8ng=; b=IpPbZN2f78dxphMHqQpYHqe58S
        vw4NwnQ+Xz59+sElzQ/B5L3eRJkdnRh6BnNVuFZ5y34CD+z1GqrWUYj06V+i7uo3q/XpaDl+cG884
        drRT2Fl5JdUamqqF/e3c5FVm4cZdv6ufagIWq3l2FmDBRTe88w+7D76jqPZ+a/1/2aZbc/Kq3RR8b
        AW1FVBy6gWIDlGSu1r/dQhnWUKxtmBmSBD63N8Y1uTWHiW0k+fHm0hzv4digf/kQigNWvUXpNwcCN
        p7YE1vjhW3f9nlvBiwMKeZthCUjMehbPAaFYLfvK5cVKrRzzP+XOPQDrNS+A5UhEbrU/2s3/fcJsv
        mt+CWOYQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmvQs-00089J-7s; Wed, 09 Dec 2020 09:06:46 +0000
Date:   Wed, 9 Dec 2020 09:06:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <20201209090646.GA28832@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209083645.GB21968@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 08:36:45AM +0000, Christoph Hellwig wrote:
> This is making the iter type even more of a mess than it already is.
> I think we at least need placeholders for 0/1 here and an explicit
> flags namespace, preferably after the types.
> 
> Then again I'd much prefer if we didn't even add the flag or at best
> just add it for a short-term transition and move everyone over to the
> new scheme.  Otherwise the amount of different interfaces and supporting
> code keeps exploding.

Note that the only other callers that use iov_iter_bvec and asynchronous
read/write are loop, target and nvme-target, so this should actually
be pretty simple.  Out of these only target needs something like this
trivial change to keep the bvec available over the duration of the I/O,
the other two should be fine already:

---
From 581a8eabbb1759e3dcfee4b1d2e419f814a8cb80 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 9 Dec 2020 10:05:04 +0100
Subject: target/file: allocate the bvec array as part of struct target_core_file_cmd

This saves one memory allocation, and ensures the bvecs aren't freed
before the AIO completion.  This will allow the lower level code to be
optimized so that it can avoid allocating another bvec array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7143d03f0e027e..ed0c39a1f7c649 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,6 +241,7 @@ struct target_core_file_cmd {
 	unsigned long	len;
 	struct se_cmd	*cmd;
 	struct kiocb	iocb;
+	struct bio_vec	bvecs[];
 };
 
 static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
@@ -268,29 +269,22 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct target_core_file_cmd *aio_cmd;
 	struct iov_iter iter = {};
 	struct scatterlist *sg;
-	struct bio_vec *bvec;
 	ssize_t len = 0;
 	int ret = 0, i;
 
-	aio_cmd = kmalloc(sizeof(struct target_core_file_cmd), GFP_KERNEL);
+	aio_cmd = kmalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
 	if (!aio_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvec) {
-		kfree(aio_cmd);
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
-
 	for_each_sg(sgl, sg, sgl_nents, i) {
-		bvec[i].bv_page = sg_page(sg);
-		bvec[i].bv_len = sg->length;
-		bvec[i].bv_offset = sg->offset;
+		aio_cmd->bvecs[i].bv_page = sg_page(sg);
+		aio_cmd->bvecs[i].bv_len = sg->length;
+		aio_cmd->bvecs[i].bv_offset = sg->offset;
 
 		len += sg->length;
 	}
 
-	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
+	iov_iter_bvec(&iter, is_write, aio_cmd->bvecs, sgl_nents, len);
 
 	aio_cmd->cmd = cmd;
 	aio_cmd->len = len;
@@ -307,8 +301,6 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	else
 		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
 
-	kfree(bvec);
-
 	if (ret != -EIOCBQUEUED)
 		cmd_rw_aio_complete(&aio_cmd->iocb, ret, 0);
 
-- 
2.29.2

