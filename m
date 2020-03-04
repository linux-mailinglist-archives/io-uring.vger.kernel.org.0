Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF078179904
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDT2U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:28:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgCDT2U (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 4 Mar 2020 14:28:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF48A21775;
        Wed,  4 Mar 2020 19:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583350100;
        bh=iZwu2E9k7ZjkAu9BFqYnyAxujHs6DuMHGzfs53JpRb4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nmheX9c+eY5sF1EKciehZgHlSUTrC+nFC0i9tXACkJ/YP6kDh+lX59XaIumX+GYCF
         97kppoUHjnOpdTPahRDz9TlYhSkYJWWzWZJ7u4HmGRaLP6QtAfgjsSzeG7bzk6OyWZ
         8vN8BIZhoTiFYTTNqy01B62tRvyeZKxgVuvGGI0s=
Message-ID: <50d459bb4c894b99532d9f56fadceb0c317ab7f0.camel@kernel.org>
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
From:   Jeff Layton <jlayton@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org
Date:   Wed, 04 Mar 2020 14:28:18 -0500
In-Reply-To: <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
         <20200304190341.GB16251@localhost>
         <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2020-03-04 at 12:10 -0700, Jens Axboe wrote:
> On 3/4/20 12:03 PM, Josh Triplett wrote:
> > On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
> > > One of the fabled features with chains has long been the desire to
> > > support things like:
> > > 
> > > <open fileX><read from fileX><close fileX>
> > > 
> > > in a single chain. This currently doesn't work, since the read/close
> > > depends on what file descriptor we get on open.
> > > 
> > > The original attempt at solving this provided a means to pass
> > > descriptors between chains in a link, this version takes a different
> > > route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
> > > what fd value we're going to get out of open (or accept). With that in
> > > place, we don't need to do any magic to make this work. The above chain
> > > then becomes:
> > > 
> > > <open fileX with fd Y><read from fd Y><close fd Y>
> > > 
> > > which is a lot more useful, and allows any sort of weird chains without
> > > needing to nest "last open" file descriptors.
> > > 
> > > Updated the test program to use this approach:
> > > 
> > > https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
> > > 
> > > which forces the use of fd==89 for the open, and then uses that for the
> > > read and close.
> > > 
> > > Outside of this adaptation, fixed a few bugs and cleaned things up.
> > 
> > I posted one comment about an issue in patch 6.
> > 
> > Patches 2-5 look great; for those:
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > Thanks for picking this up and running with it!
> 
> Thanks for doing the prep work! I think it turned out that much better
> for it.
> 
> Are you going to post your series for general review? I just stole
> your 1 patch that was needed for me.
> 

This does seem like a better approach overall.

How should userland programs pick fds to use for this though? Should you
just start with some reasonably high number that you don't expect to
have been used by the current process or is there some more reliable way
to do it?

-- 
Jeff Layton <jlayton@kernel.org>

