Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB255731B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 08:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiFWG33 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiFWG32 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 02:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004333981C;
        Wed, 22 Jun 2022 23:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BB7613F7;
        Thu, 23 Jun 2022 06:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25C7C3411B;
        Thu, 23 Jun 2022 06:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655965767;
        bh=wUTnbr3HED4pym62QuGzaVUisvnMcXKLi/pNUb52Gv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W19bTbAcd2JoJg59z4uvCaexzpHQkxpK0jUUmL45pXVGCH8XYBN9mOu/B6eSNjdJk
         dSSpgkBYYZBIBxVCntKorhLWuGy9SL6MWAsr/sTSuLNkLW0vN2FUzmIO7OGFEdelmF
         HvjvW9T2Fh8zNwm+GToMrOqwK5hRxBfqUK04ZqCleALbQ2jvOVjC4JUbsHCtCNiQvP
         5Kjv3yvDmADqr2/JQqUEBdEPhVb3BZTUrIisVl8ln6dzGUwaN2nIjGLmHkK+B09eHV
         ZJZ5jygiFgF2twUVdSSG77jMxEBXD7XwfoFtIdh6Ms84LF+RLnUaaIlVuoxRQh+T2Q
         InPAwOozukU3Q==
Date:   Wed, 22 Jun 2022 23:29:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, kernel-team@fb.com, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, shr@fb.com,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org, jack@suse.cz, willy@infradead.org
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Message-ID: <YrQIRpO6kSFdfXZO@magnolia>
References: <20220616212221.2024518-1-shr@fb.com>
 <165593682792.161026.12974983413174964699.b4-ty@kernel.dk>
 <YrO0AP4y3OGUjnXE@magnolia>
 <30b0adb6-a5f2-b295-50d2-e182f9dc9ef0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30b0adb6-a5f2-b295-50d2-e182f9dc9ef0@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 22, 2022 at 06:50:29PM -0600, Jens Axboe wrote:
> On 6/22/22 6:29 PM, Darrick J. Wong wrote:
> > On Wed, Jun 22, 2022 at 04:27:07PM -0600, Jens Axboe wrote:
> >> On Thu, 16 Jun 2022 14:22:07 -0700, Stefan Roesch wrote:
> >>> This patch series adds support for async buffered writes when using both
> >>> xfs and io-uring. Currently io-uring only supports buffered writes in the
> >>> slow path, by processing them in the io workers. With this patch series it is
> >>> now possible to support buffered writes in the fast path. To be able to use
> >>> the fast path the required pages must be in the page cache, the required locks
> >>> in xfs can be granted immediately and no additional blocks need to be read
> >>> form disk.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [01/14] mm: Move starting of background writeback into the main balancing loop
> >>         commit: 29c36351d61fd08a2ed50a8028a7f752401dc88a
> >> [02/14] mm: Move updates of dirty_exceeded into one place
> >>         commit: a3fa4409eec3c094ad632ac1029094e061daf152
> >> [03/14] mm: Add balance_dirty_pages_ratelimited_flags() function
> >>         commit: 407619d2cef3b4d74565999a255a17cf5d559fa4
> >> [04/14] iomap: Add flags parameter to iomap_page_create()
> >>         commit: 49b5cd0830c1e9aa0f9a3717ac11a74ef23b9d4e
> >> [05/14] iomap: Add async buffered write support
> >>         commit: ccb885b4392143cea1bdbd8a0f35f0e6d909b114
> >> [06/14] iomap: Return -EAGAIN from iomap_write_iter()
> >>         commit: f0f9828d64393ea2ce87bd97f033051c8d7a337f
> > 
> > I'm not sure /what/ happened here, but I never received the full V9
> > series, and neither did lore:
> > 
> > https://lore.kernel.org/linux-fsdevel/165593682792.161026.12974983413174964699.b4-ty@kernel.dk/T/#t
> 
> Huh yes, didn't even notice that it's missing a few.
> 
> > As it is, I already have my hands full trying to figure out why
> > generic/522 reports file corruption after 20 minutes of running on
> > vanilla 5.19-rc3, so I don't think I'm going to get to this for a while
> > either.
> > 
> > The v8 series looked all right to me, but ********* I hate how our
> > development process relies on such unreliable **** tooling.  I don't
> 
> Me too, and the fact that email is getting worse and worse is not making
> things any better...
> 
> > think it's a /great/ idea to be pushing new code into -next when both
> > the xfs and pagecache maintainers are too busy to read the whole thing
> > through... but did hch actually RVB the whole thing prior to v9?
> 
> Yes, hch did review the whole thing prior to v9. v9 has been pretty
> quiet, but even v8 didn't have a whole lot. Which is to be expected for
> a v9, this thing has been going for months.

<nod>

> We're only at -rc3 right now, so I think it's fine getting it some -next
> exposure. It's not like it's getting pushed tomorrow, and if actual
> concerns arise, let's just deal with them if that's the case. I'll check
> in with folks before anything gets pushed certainly, I just don't think
> it's fair to keep stalling when there are no real objections. Nothing
> gets pushed unless the vested parties agree, obviously.

Ok.  Would you or Stefan mind sending the whole v9 series again, so I
can have one more look?  Hopefully vger won't just eat the series a
third time... :(

Huh.  Ok.  LWN seems to have gotten the whole thing:
https://lwn.net/ml/linux-mm/20220616212221.2024518-1-shr@fb.com/

I'll go read that in the meantime.  $DEITY I hate email.

--D

> -- 
> Jens Axboe
> 
