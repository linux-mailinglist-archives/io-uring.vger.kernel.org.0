Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BEC206986
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 03:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbgFXBcH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 21:32:07 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:38806 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387921AbgFXBcG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 21:32:06 -0400
X-Greylist: delayed 1739 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 21:31:58 EDT
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 2763010B2D4;
        Wed, 24 Jun 2020 11:02:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jntoT-0001jv-FK; Wed, 24 Jun 2020 11:02:53 +1000
Date:   Wed, 24 Jun 2020 11:02:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Add@vger.kernel.org, support@vger.kernel.org, for@vger.kernel.org,
        async@vger.kernel.org, buffered@vger.kernel.org,
        reads@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200624010253.GB5369@dread.disaster.area>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618144355.17324-6-axboe@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=ufHFDILaAAAA:8 a=7-415B0cAAAA:8
        a=WCjB2_pVjg0caHknj34A:9 a=CjuIK1q_8ugA:10 a=ZmIg1sZ3JBWsdXgziEIF:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 18, 2020 at 08:43:45AM -0600, Jens Axboe wrote:
> The read-ahead shouldn't block, so allow it to be done even if
> IOCB_NOWAIT is set in the kiocb.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  mm/filemap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index f0ae9a6308cb..3378d4fca883 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2028,8 +2028,6 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
>  
>  		page = find_get_page(mapping, index);
>  		if (!page) {
> -			if (iocb->ki_flags & IOCB_NOWAIT)
> -				goto would_block;
>  			page_cache_sync_readahead(mapping,
>  					ra, filp,
>  					index, last_index - index);

Doesn't think break preadv2(RWF_NOWAIT) semantics for on buffered
reads? i.e. this can now block on memory allocation for the page
cache, which is something RWF_NOWAIT IO should not do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
