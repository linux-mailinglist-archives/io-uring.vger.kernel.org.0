Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97253690E
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 00:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355061AbiE0Wwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 18:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiE0Wwo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 18:52:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17278126992;
        Fri, 27 May 2022 15:52:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AD254537B91;
        Sat, 28 May 2022 08:52:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuioy-00HBur-8l; Sat, 28 May 2022 08:52:40 +1000
Date:   Sat, 28 May 2022 08:52:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <20220527225240.GV1098723@dread.disaster.area>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
 <20220526223705.GJ1098723@dread.disaster.area>
 <20220527084203.jzufgln7oqfdghvy@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084203.jzufgln7oqfdghvy@quack3.lan>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6291563a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=56L3rgyCVsvNkpJbsA4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 27, 2022 at 10:42:03AM +0200, Jan Kara wrote:
> On Fri 27-05-22 08:37:05, Dave Chinner wrote:
> > On Thu, May 26, 2022 at 10:38:29AM -0700, Stefan Roesch wrote:
> > > This adds async buffered write support to iomap.
> > > 
> > > This replaces the call to balance_dirty_pages_ratelimited() with the
> > > call to balance_dirty_pages_ratelimited_flags. This allows to specify if
> > > the write request is async or not.
> > > 
> > > In addition this also moves the above function call to the beginning of
> > > the function. If the function call is at the end of the function and the
> > > decision is made to throttle writes, then there is no request that
> > > io-uring can wait on. By moving it to the beginning of the function, the
> > > write request is not issued, but returns -EAGAIN instead. io-uring will
> > > punt the request and process it in the io-worker.
> > > 
> > > By moving the function call to the beginning of the function, the write
> > > throttling will happen one page later.
> > 
> > Won't it happen one page sooner? I.e. on single page writes we'll
> > end up throttling *before* we dirty the page, not *after* we dirty
> > the page. IOWs, we can't wait for the page that we just dirtied to
> > be cleaned to make progress and so this now makes the loop dependent
> > on pages dirtied by other writers being cleaned to guarantee
> > forwards progress?
> > 
> > That seems like a subtle but quite significant change of
> > algorithm...
> 
> So I'm convinced the difference will be pretty much in the noise because of
> how many dirty pages there have to be to even start throttling processes
> but some more arguments are:
> 
> * we ratelimit calls to balance_dirty_pages() based on number of pages
>   dirtied by the current process in balance_dirty_pages_ratelimited()
> 
> * balance_dirty_pages() uses number of pages dirtied by the current process
>   to decide about the delay.
> 
> So the only situation where I could see this making a difference would be
> if dirty limit is a handful of pages and even there I have hard time to see
> how exactly.

That's kinda what worries me - we do see people winding the dirty
thresholds way down to work around various niche problems with
dirty page buildup.

We also have small extra accounting overhead for cases where we've
stacked layers to so the lower layers don't dirty throttle before
the higher layer. If the lower layer throttles first, then the
higher layer can't clean pages and we can deadlock.

Those are the sorts of subtle, niche situations where I worry that
the subtle "throttle first, write second" change could manifest...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
