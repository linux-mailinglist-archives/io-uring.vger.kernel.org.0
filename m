Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98FE535BBC
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 10:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiE0ImL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348426AbiE0ImL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 04:42:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8497A2AC64;
        Fri, 27 May 2022 01:42:09 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D605321AAA;
        Fri, 27 May 2022 08:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653640927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3kR8Rvk9ywh6jthWa6f6W+fh5ln2gc1wOBcFNlUoZo=;
        b=jGTVN/VJ3aSzzuzLCGlGXqp2VGAkPu00h7wV9ZnWD7SUhij0Sx6zjHEASn2lgODJlpPSGL
        lev8mFDaDbK6ok1HMGyWePK8KX6SVj4N+YhmBx3qY4RWc/V+0qPCx1PTQYsPUR+wkaELOX
        9K/jx31qvClXXqCSvgbXcA59TOs/vqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653640927;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3kR8Rvk9ywh6jthWa6f6W+fh5ln2gc1wOBcFNlUoZo=;
        b=Pxxqrkvw7XHONluBWcBzyxmvH2RJ91//IYl9VyNDBu1px+Fb3HIb1DWpWHUvAQPYhCP6Fa
        6NhUNoRZqFwLFwAw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AA8FC2C141;
        Fri, 27 May 2022 08:42:07 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F3BFBA0632; Fri, 27 May 2022 10:42:03 +0200 (CEST)
Date:   Fri, 27 May 2022 10:42:03 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <20220527084203.jzufgln7oqfdghvy@quack3.lan>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
 <20220526223705.GJ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526223705.GJ1098723@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri 27-05-22 08:37:05, Dave Chinner wrote:
> On Thu, May 26, 2022 at 10:38:29AM -0700, Stefan Roesch wrote:
> > This adds async buffered write support to iomap.
> > 
> > This replaces the call to balance_dirty_pages_ratelimited() with the
> > call to balance_dirty_pages_ratelimited_flags. This allows to specify if
> > the write request is async or not.
> > 
> > In addition this also moves the above function call to the beginning of
> > the function. If the function call is at the end of the function and the
> > decision is made to throttle writes, then there is no request that
> > io-uring can wait on. By moving it to the beginning of the function, the
> > write request is not issued, but returns -EAGAIN instead. io-uring will
> > punt the request and process it in the io-worker.
> > 
> > By moving the function call to the beginning of the function, the write
> > throttling will happen one page later.
> 
> Won't it happen one page sooner? I.e. on single page writes we'll
> end up throttling *before* we dirty the page, not *after* we dirty
> the page. IOWs, we can't wait for the page that we just dirtied to
> be cleaned to make progress and so this now makes the loop dependent
> on pages dirtied by other writers being cleaned to guarantee
> forwards progress?
> 
> That seems like a subtle but quite significant change of
> algorithm...

So I'm convinced the difference will be pretty much in the noise because of
how many dirty pages there have to be to even start throttling processes
but some more arguments are:

* we ratelimit calls to balance_dirty_pages() based on number of pages
  dirtied by the current process in balance_dirty_pages_ratelimited()

* balance_dirty_pages() uses number of pages dirtied by the current process
  to decide about the delay.

So the only situation where I could see this making a difference would be
if dirty limit is a handful of pages and even there I have hard time to see
how exactly. So I'm ok with the change and in the case we see it causes
problems somewhere, we'll think how to fix it based on the exact scenario.

I guess the above two points are the reason why Stefan writes about throttling
one page later because we count only number of pages dirtied until this
moment so the page dirtied by this iteration of loop in iomap_write_iter()
will get reflected only by the call to balance_dirty_pages_ratelimited() in
the next iteration (or the next call to iomap_write_iter()).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
