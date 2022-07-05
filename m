Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF05670EA
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiGEOXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiGEOXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:23:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718D7C58;
        Tue,  5 Jul 2022 07:23:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1A887229AA;
        Tue,  5 Jul 2022 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657031020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jcuDAT42MRN08+ai7zVZVZ2mWppuivEezCE/Bu5mhtU=;
        b=owi3RO93Ow5n5L73HHdTiQn2hfqPSvdUleh8KgUxZseP/ZBphU+H2KIcgWp0yOuyd/tPNX
        tA91jLVfbnO4kHORFIEqLMH2ak5lnHc1iKigU1DIvSOghhPNyDORiB3mSrrCg0C5fUSqJp
        ynPIt+3GTWOOn7TKZHxuFbmAfJ6ma0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657031020;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jcuDAT42MRN08+ai7zVZVZ2mWppuivEezCE/Bu5mhtU=;
        b=T6AyjA5QRILuUAb7gk4isa/t+rjA2Qg9uB5wx/oL5bTShCnXOn0HwI9w9azt/RA5Dsn0N5
        jvH/ojhAEBRt/8Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 095FC1339A;
        Tue,  5 Jul 2022 14:23:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MHsBCWlJxGI7fQAAMHmgww
        (envelope-from <rgoldwyn@suse.de>); Tue, 05 Jul 2022 14:23:37 +0000
Date:   Tue, 5 Jul 2022 09:23:34 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Message-ID: <20220705142243.hlevsj4pfpahjcdv@fiona>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com>
 <Yr56ci/IZmN0S9J6@ZenIV>
 <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
 <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
 <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk>
 <Yr83aD0yuEwvJ7tL@magnolia>
 <47dd9e6a-4e08-e562-12ff-5450fc42da77@kernel.dk>
 <YsRA7TGWA7ovZjrF@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsRA7TGWA7ovZjrF@localhost.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On  9:47 05/07, Josef Bacik wrote:
> On Fri, Jul 01, 2022 at 12:14:41PM -0600, Jens Axboe wrote:
> > On 7/1/22 12:05 PM, Darrick J. Wong wrote:
> > > On Fri, Jul 01, 2022 at 08:38:07AM -0600, Jens Axboe wrote:
> > >> On 7/1/22 8:30 AM, Jens Axboe wrote:
> > >>> On 7/1/22 8:19 AM, Jens Axboe wrote:
> > >>>> On 6/30/22 10:39 PM, Al Viro wrote:
> > >>>>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
> > >>>>>> This adds the async buffered write support to XFS. For async buffered
> > >>>>>> write requests, the request will return -EAGAIN if the ilock cannot be
> > >>>>>> obtained immediately.
> > >>>>>
> > >>>>> breaks generic/471...
> > >>>>
> > >>>> That test case is odd, because it makes some weird assumptions about
> > >>>> what RWF_NOWAIT means. Most notably that it makes it mean if we should
> > >>>> instantiate blocks or not. Where did those assumed semantics come from?
> > >>>> On the read side, we have clearly documented that it should "not wait
> > >>>> for data which is not immediately available".
> > >>>>
> > >>>> Now it is possible that we're returning a spurious -EAGAIN here when we
> > >>>> should not be. And that would be a bug imho. I'll dig in and see what's
> > >>>> going on.
> > >>>
> > >>> This is the timestamp update that needs doing which will now return
> > >>> -EAGAIN if IOCB_NOWAIT is set as it may block.
> > >>>
> > >>> I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
> > >>> even on the io_uring side. Either that, or passed in RWF_NOWAIT
> > >>> semantics don't map completely to internal IOCB_NOWAIT semantics. At
> > >>> least in terms of what generic/471 is doing, but I'm not sure who came
> > >>> up with that and if it's established semantics or just some made up ones
> > >>> from whomever wrote that test. I don't think they make any sense, to be
> > >>> honest.
> > >>
> > >> Further support that generic/471 is just randomly made up semantics,
> > >> it needs to special case btrfs with nocow or you'd get -EAGAIN anyway
> > >> for that test.
> > >>
> > >> And it's relying on some random timing to see if this works. I really
> > >> think that test case is just hot garbage, and doesn't test anything
> > >> meaningful.
> > > 
> > > <shrug> I had thought that NOWAIT means "don't wait for *any*thing",
> > > which would include timestamp updates... but then I've never been all
> > > that clear on what specifically NOWAIT will and won't wait for. :/
> > 
> > Agree, at least the read semantics (kind of) make sense, but the ones
> > seemingly made up by generic/471 don't seem to make any sense at all.
> >
> 
> Added Goldwyn to the CC list for this.
> 
> This appears to be just a confusion about what we think NOWAIT should mean.
> Looking at the btrfs code it seems like Goldwyn took it as literally as possible
> so we wouldn't do any NOWAIT IO's unless it was into a NOCOW area, meaning we
> literally wouldn't do anything other than wrap the bio up and fire it off.

When I introduced NOWAIT, it was only meant for writes and for those
which would block on block allocations or locking. Over time it was
included for buffered reads as well.

> 
> The general consensus seems to be that NOWAIT isn't that strict, and that
> BTRFS's definition was too strict.  I wrote initial patches to give to Stefan to
> clean up the Btrfs side to allow us to use NOWAIT under a lot more
> circumstances.

BTRFS COW path would allocate blocks and the reason it returns -EAGAIN.

> 
> Goldwyn, this test seems to be a little specific to our case, and can be flakey
> if the timing isn't just right.  I think we should just remove it?  Especially
> since how we define NOWAIT isn't quite right.  Does that sound reasonable to
> you?

Yes, I agree. It was based on the initial definition and now can be
removed.


-- 
Goldwyn
