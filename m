Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E92924136C
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 00:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHJW4I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 18:56:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50413 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgHJW4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 18:56:07 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8616D822D55;
        Tue, 11 Aug 2020 08:56:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5Gi1-00085Z-FF; Tue, 11 Aug 2020 08:56:01 +1000
Date:   Tue, 11 Aug 2020 08:56:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200810225601.GE2079@dread.disaster.area>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
 <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
 <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
 <20200624164127.GP21350@casper.infradead.org>
 <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8
        a=eRodIBkOSM2l2XYf1zsA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 24, 2020 at 10:44:21AM -0600, Jens Axboe wrote:
> On 6/24/20 10:41 AM, Matthew Wilcox wrote:
> > On Wed, Jun 24, 2020 at 09:35:19AM -0600, Jens Axboe wrote:
> >> On 6/24/20 9:00 AM, Jens Axboe wrote:
> >>> On 6/23/20 7:46 PM, Matthew Wilcox wrote:
> >>>> I'd be quite happy to add a gfp_t to struct readahead_control.
> >>>> The other thing I've been looking into for other reasons is adding
> >>>> a memalloc_nowait_{save,restore}, which would avoid passing down
> >>>> the gfp_t.
> >>>
> >>> That was my first thought, having the memalloc_foo_save/restore for
> >>> this. I don't think adding a gfp_t to readahead_control is going
> >>> to be super useful, seems like the kind of thing that should be
> >>> non-blocking by default.
> >>
> >> We're already doing memalloc_nofs_save/restore in
> >> page_cache_readahead_unbounded(), so I think all we need is to just do a
> >> noio dance in generic_file_buffered_read() and that should be enough.
> > 
> > I think we can still sleep though, right?  I was thinking more
> > like this:
> > 
> > http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
> 
> Yeah, that's probably better. How do we want to handle this? I've already
> got the other bits queued up. I can either add them to the series, or
> pull a branch that'll go into Linus as well.

Jens, Willy,

Now that this patch has been merged and IOCB_NOWAIT semantics ifor
buffered reads are broken in Linus' tree, what's the plan to get
this regression fixed before 5.9 releases?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
