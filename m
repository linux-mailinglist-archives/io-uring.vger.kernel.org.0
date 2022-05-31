Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A70538C4C
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244647AbiEaHzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244654AbiEaHzp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:55:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D3F6CF5B;
        Tue, 31 May 2022 00:55:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F354421BF2;
        Tue, 31 May 2022 07:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653983742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PswY31FHbVOwds2z63DtKhwt0E5jVJXSOd7VzyxUuTY=;
        b=PiiO74VpExAHtyAE1UtiGsrZi1RFfxQ88hMlK52YfNv2Q+Ocqvt7Ih3M9aEZ1hNBP4M1s4
        MjBv6hDkwMp7MxsYbfpGBtmlWP7mFv5huy7PkunQ0Qkf4yWXo6ULL0SahYZ29WaWenlZc6
        laamMwxwZ9Aq/yBtt8kvJmxv8MqkZ3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653983742;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PswY31FHbVOwds2z63DtKhwt0E5jVJXSOd7VzyxUuTY=;
        b=pZ2WUUJ79BbjWszc5KRQe3eC831iokT0PAe2YB50+b7eHjaWToA4x/x04ylZif11NPi53r
        E6ODJrDfJmobqMAw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DF0542C141;
        Tue, 31 May 2022 07:55:41 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 92009A0633; Tue, 31 May 2022 09:55:41 +0200 (CEST)
Date:   Tue, 31 May 2022 09:55:41 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <20220531075541.jezkoc6kgikdzk6w@quack3.lan>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
 <20220526223705.GJ1098723@dread.disaster.area>
 <20220527084203.jzufgln7oqfdghvy@quack3.lan>
 <20220527225240.GV1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527225240.GV1098723@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat 28-05-22 08:52:40, Dave Chinner wrote:
> On Fri, May 27, 2022 at 10:42:03AM +0200, Jan Kara wrote:
> > On Fri 27-05-22 08:37:05, Dave Chinner wrote:
> > > On Thu, May 26, 2022 at 10:38:29AM -0700, Stefan Roesch wrote:
> > > > This adds async buffered write support to iomap.
> > > > 
> > > > This replaces the call to balance_dirty_pages_ratelimited() with the
> > > > call to balance_dirty_pages_ratelimited_flags. This allows to specify if
> > > > the write request is async or not.
> > > > 
> > > > In addition this also moves the above function call to the beginning of
> > > > the function. If the function call is at the end of the function and the
> > > > decision is made to throttle writes, then there is no request that
> > > > io-uring can wait on. By moving it to the beginning of the function, the
> > > > write request is not issued, but returns -EAGAIN instead. io-uring will
> > > > punt the request and process it in the io-worker.
> > > > 
> > > > By moving the function call to the beginning of the function, the write
> > > > throttling will happen one page later.
> > > 
> > > Won't it happen one page sooner? I.e. on single page writes we'll
> > > end up throttling *before* we dirty the page, not *after* we dirty
> > > the page. IOWs, we can't wait for the page that we just dirtied to
> > > be cleaned to make progress and so this now makes the loop dependent
> > > on pages dirtied by other writers being cleaned to guarantee
> > > forwards progress?
> > > 
> > > That seems like a subtle but quite significant change of
> > > algorithm...
> > 
> > So I'm convinced the difference will be pretty much in the noise because of
> > how many dirty pages there have to be to even start throttling processes
> > but some more arguments are:
> > 
> > * we ratelimit calls to balance_dirty_pages() based on number of pages
> >   dirtied by the current process in balance_dirty_pages_ratelimited()
> > 
> > * balance_dirty_pages() uses number of pages dirtied by the current process
> >   to decide about the delay.
> > 
> > So the only situation where I could see this making a difference would be
> > if dirty limit is a handful of pages and even there I have hard time to see
> > how exactly.
> 
> That's kinda what worries me - we do see people winding the dirty
> thresholds way down to work around various niche problems with
> dirty page buildup.
> 
> We also have small extra accounting overhead for cases where we've
> stacked layers to so the lower layers don't dirty throttle before
> the higher layer. If the lower layer throttles first, then the
> higher layer can't clean pages and we can deadlock.
> 
> Those are the sorts of subtle, niche situations where I worry that
> the subtle "throttle first, write second" change could manifest...

Well, I'd think about the change more as "write first, throttle on next
write" because balance_dirty_pages_ratelimited() throttles based on the
number of pages dirtied until the moment it is called. So first invocation
of balance_dirty_pages_ratelimited() will not do anything because
current->nr_dirtied will be zero. So effectively we always let the process
run longer than before the change before we throttle it. But number of
dirtied pages until we throttle should be the same for both cases.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
