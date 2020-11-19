Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6B2B9A10
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 18:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgKSRwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 12:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgKSRwu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 12:52:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1777DC0613CF;
        Thu, 19 Nov 2020 09:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cQkJ8oOJbey+jhde6R1GtaMp6RE8pauahlmMPFtXjZs=; b=hEO4IqYNoc19Blikcdoe2QXwBn
        ybNPIxxCWJWZXd6iQlUNxZUHh79QDprUSf7QQ/mHJLvv1JWsY693pbYp/Pl4ddsj0vuaxUe4OzZFz
        vVXAV0aGpsPDxlRBTDE9GhOSRz9xs6wi3qFy4uLXgUe68l0rfPEkK8CKo2kLMBeEw6ds0Dv7CkXDU
        L5MOnJLTkC/YhEVHADMZKcaMsFfu89FCcPOedkE5dru2/soU3sp4CCVTCfer4o9BK6GiJ6CMhVa/V
        UzZ5x7zdlP1/5DaV3ZyRIr0ZneuehElgdb6dL0clD482W9RfVwxn1j3nt+N7wiGHJRpJmJ8AAylLF
        LrnX29Bw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfo6k-0005fU-SJ; Thu, 19 Nov 2020 17:52:34 +0000
Date:   Thu, 19 Nov 2020 17:52:34 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v4 1/2] block: disable iopoll for split bio
Message-ID: <20201119175234.GA20944@infradead.org>
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117075625.46118-2-jefflexu@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 17, 2020 at 03:56:24PM +0800, Jeffle Xu wrote:
> iopoll is initially for small size, latency sensitive IO. It doesn't
> work well for big IO, especially when it needs to be split to multiple
> bios. In this case, the returned cookie of __submit_bio_noacct_mq() is
> indeed the cookie of the last split bio. The completion of *this* last
> split bio done by iopoll doesn't mean the whole original bio has
> completed. Callers of iopoll still need to wait for completion of other
> split bios.
> 
> Besides bio splitting may cause more trouble for iopoll which isn't
> supposed to be used in case of big IO.
> 
> iopoll for split bio may cause potential race if CPU migration happens
> during bio submission. Since the returned cookie is that of the last
> split bio, polling on the corresponding hardware queue doesn't help
> complete other split bios, if these split bios are enqueued into
> different hardware queues. Since interrupts are disabled for polling
> queues, the completion of these other split bios depends on timeout
> mechanism, thus causing a potential hang.
> 
> iopoll for split bio may also cause hang for sync polling. Currently
> both the blkdev and iomap-based fs (ext4/xfs, etc) support sync polling
> in direct IO routine. These routines will submit bio without REQ_NOWAIT
> flag set, and then start sync polling in current process context. The
> process may hang in blk_mq_get_tag() if the submitted bio has to be
> split into multiple bios and can rapidly exhaust the queue depth. The
> process are waiting for the completion of the previously allocated
> requests, which should be reaped by the following polling, and thus
> causing a deadlock.
> 
> To avoid these subtle trouble described above, just disable iopoll for
> split bio.
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  block/blk-merge.c | 7 +++++++
>  block/blk-mq.c    | 6 ++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index bcf5e4580603..53ad781917a2 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -279,6 +279,13 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  	return NULL;
>  split:
>  	*segs = nsegs;
> +
> +	/*
> +	 * bio splitting may cause subtle trouble such as hang when doing iopoll,

Please capitalize the first character of a multi-line comments.  Also
this adds an overly long line.

> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +	if (hctx->type != HCTX_TYPE_POLL)
> +		return 0;

I think this is good as a sanity check, but shouldn't we be able to
avoid even hitting this patch if we ensure that BLK_QC_T_NONE is
returned after a bio is split?
