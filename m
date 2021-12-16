Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472FD476CB8
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhLPJBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLPJBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:01:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBA2C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 01:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hf/5+TD+Y0VvCWN+SHDam5IgywF4cIvkR/kb58toQeQ=; b=tPa45au5dYEhSJvGrUN9XVOyWa
        ARu4jBDDbew22lcQn0lcNQMfCNzegW+D1fF2ZzKvvDLBgh8TrK13vr7xuMUmqvzY8nmfpwPTIn4Z3
        NEDqaX1xE4+dDsa6bqHxe/bdGSp6b0XLRJMNoC2sufq1flcO556iPAkpS0+1JTWlKLJbIxtilsDJr
        AkfoQj5gklkv1ID8UhIR8jv7+Q6DbGH75J994QLbe9jvGHoIH0aQ2k/dxTLRserGJJdAEGUx5cx0L
        KX86UnMV6NW5r8pYByHB+qjj0wX2u8Lnl4hvZh64mAW0L9g4SCq/DImmCPBiUr6mN0EHkZd36rhBD
        fdi9VoNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxmdU-004Fjl-B4; Thu, 16 Dec 2021 09:01:12 +0000
Date:   Thu, 16 Dec 2021 01:01:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/4] block: add mq_ops->queue_rqs hook
Message-ID: <YbsAWGcCPn/3BgzF@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This whole series seems to miss a linux-block cc..

On Wed, Dec 15, 2021 at 09:24:18AM -0700, Jens Axboe wrote:
> If we have a list of requests in our plug list, send it to the driver in
> one go, if possible. The driver must set mq_ops->queue_rqs() to support
> this, if not the usual one-by-one path is used.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq.c         | 26 +++++++++++++++++++++++---
>  include/linux/blk-mq.h |  8 ++++++++
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e02e7017db03..f24394cb2004 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2512,6 +2512,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>  {
>  	struct blk_mq_hw_ctx *this_hctx;
>  	struct blk_mq_ctx *this_ctx;
> +	struct request *rq;
>  	unsigned int depth;
>  	LIST_HEAD(list);
>  
> @@ -2520,7 +2521,28 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>  	plug->rq_count = 0;
>  
>  	if (!plug->multiple_queues && !plug->has_elevator && !from_schedule) {
> +		struct request_queue *q;
> +
> +		rq = rq_list_peek(&plug->mq_list);
> +		q = rq->q;

Nit: I'd just drop the q local variable as it is rather pointless.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
