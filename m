Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77685453A18
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhKPTYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:24:47 -0500
Received: from shells.gnugeneration.com ([66.240.222.126]:48288 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbhKPTYr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 14:24:47 -0500
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 468601A40175; Tue, 16 Nov 2021 11:21:48 -0800 (PST)
Date:   Tue, 16 Nov 2021 11:21:48 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZP6JSd4h45cyvsy@casper.infradead.org>
 <b97f1b15-fbcc-92a4-96ca-e918c2f6c7a3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b97f1b15-fbcc-92a4-96ca-e918c2f6c7a3@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 16, 2021 at 11:55:41AM -0700, Jens Axboe wrote:
> On 11/16/21 11:36 AM, Matthew Wilcox wrote:
> > On Mon, Nov 15, 2021 at 08:35:30PM -0800, Andrew Morton wrote:
> >> I'd also be interested in seeing feedback from the MM developers.
> > [...]
> >> Subject: Increase default MLOCK_LIMIT to 8 MiB
> > 
> > On the one hand, processes can already allocate at least this much
> > memory that is non-swappable, just by doing things like opening a lot of
> > files (allocating struct file & fdtable), using a lot of address space
> > (allocating page tables), so I don't have a problem with it per se.
> > 
> > On the other hand, 64kB is available on anything larger than an IBM XT.
> > Linux will still boot on machines with 4MB of RAM (eg routers).  For
> > someone with a machine with only, say, 32MB of memory, this allows a
> > process to make a quarter of the memory unswappable, and maybe that's
> > not a good idea.  So perhaps this should scale over a certain range?
> > 
> > Is 8MB a generally useful amount of memory for an iouring user anyway?
> > If you're just playing with it, sure, but if you have, oh i don't know,
> > a database, don't you want to pin the entire cache and allow IO to the
> > whole thing?
> 
> 8MB is plenty for most casual use cases, which is exactly the ones that
> we want to "just work" without requiring weird system level
> modifications to increase the memlock limit.
> 

Considering a single fullscreen 32bpp 4K-resolution framebuffer is
~32MiB, I'm not convinced this is really correct in nearly 2022.

If we're going to bump the default at the kernel, I'm with Matthew on
making it autoscale within a sane range, depending on available
memory.

As an upper bound I'd probably look at the highest anticipated
consumer resolutions, and handle a couple fullscreen 32bpp instances
being pinned.

Regards,
Vito Caputo
