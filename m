Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A36924EA
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 18:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjBJR5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 12:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjBJR5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 12:57:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77D24F852
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 09:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4330561E7A
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 17:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DBEC4339E
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676051853;
        bh=EdNikj6ihbS6tmVVKV/Gr8GqPj/IVFRIStn6g5XxS3c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eWC0iXIEBdh8IiJfgucjHSAi41/t4CCSJLtM3N8OQXIMgm0D6a7uAgr+OPd20MJTH
         +E7yRfL1HwGlMizxeYI4yHxetBPf/kQSz+/Dht1eVjH4fbeQ9OuvDOJVbhnFRXgEYy
         QYy1bJy66R7Dn19bRYEhj96Et2i0xDrwZnPfW989bicZxpafG4B64re/6c1z5HRw+0
         70yszsAyseKyHu7CdGfNjtminIlzy0mXqk4meyRPMynQFnVbAtCg804AUAQXGFr3zn
         HQ87TQEqtdO1f2dnSw1rQuKiJaGx9TRK9Smv2mmAwq3jk7R4AnEpk01loDdz/tyjCV
         lfUCZYnwZuoMg==
Received: by mail-ej1-f42.google.com with SMTP id dr8so17905840ejc.12
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 09:57:33 -0800 (PST)
X-Gm-Message-State: AO0yUKULUSe6gTsOgfPSkU0yg7qt7uc6wEsZUTpJap/zlg5xBqaKGNMJ
        OZ2m21tXOIFlgpHBpFzB+msbV1MpoXrSN+2dRQpBoA==
X-Google-Smtp-Source: AK7set9/ve8g5TsJRz3g6ZGdh+faiyXAgVkwQTS2SJlcgdVc+0p1pG34Vabiezx0GXNWG1AspwltN09G6XpRWPRXdvg=
X-Received: by 2002:a17:906:ca04:b0:7c0:f45e:22ff with SMTP id
 jt4-20020a170906ca0400b007c0f45e22ffmr3820111ejb.104.1676051851830; Fri, 10
 Feb 2023 09:57:31 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com> <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
In-Reply-To: <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 10 Feb 2023 09:57:20 -0800
X-Gmail-Original-Message-ID: <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
Message-ID: <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 8:34 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Feb 10, 2023 at 7:15 AM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > Frankly, I really don't like having non-immutable data in a pipe.
>
> That statement is completely nonsensical.

I know what splice() is.  I'm trying to make the point that it may not
be the right API for most (all?) of its use cases, that we can maybe
do better, and that we should maybe even consider deprecating (and
simplifying and the cost of performance) splice in the moderately near
future.  And I think I agree with you on most of what you're saying.

> It was literally designed to be "look, we want zero-copy networking,
> and we could do 'sendfile()' by mmap'ing the file, but mmap - and
> particularly munmap - is too expensive, so we map things into kernel
> buffers instead".

Indeed.  mmap() + sendfile() + munmap() is extraordinarily expensive
and is not the right solution to zero-copy  networking.

>
> So saying "I really don't like having non-immutable data in a pipe" is
> complete nonsense. It's syntactically correct English, but it makes no
> conceptual sense.
>
> You can say "I don't like 'splice()'". That's fine. I used to think
> splice was a really cool concept, but I kind of hate it these days.
> Not liking splice() makes a ton of sense.
>
> But given splice, saying "I don't like non-immutable data" really is
> complete nonsense.

I am saying exactly what I meant.  Obviously mutable data exists.  I'm
saying that *putting it in a pipe* *while it's still mutable* is not
good.  Which implies that I don't think splice() is good.  No offense.

I am *not* saying that the mere existence of mutable data is a problem.

> That's not something specific to "splice()". It's fundamental to the
> whole *concept* of zero-copy. If you don't want copies, and the source
> file changes, then you see those changes.

Of course!  A user program copying data from a file to a network
fundamentally does this:

Step 1: start the process.
Step 2: data goes out to the actual wire or a buffer on the NIC or is
otherwise in a place other than page cache, and the kernel reports
completion.

There are many ways to make this happen.  Step 1 could be starting
read() and step 2 could be send() returning.  Step 1 could be be
sticking something in an io_uring queue and step 2 could be reporting
completion.  Step 1 could be splice()ing to a pipe and step 2 could be
a splice from the pipe to a socket completing (and maybe even later
when the data actually goes out).

*Obviously* any change to the file between steps 1 and 2 may change
the data that goes out the wire.

> So the data lifetime - even just on just one side - can _easily_ be
> "multiple seconds" even when things are normal, and if you have actual
> network connectivity issues we are easily talking minutes.

True.

But splice is extra nasty: step 1 happens potentially arbitrarily long
before step 2, and the kernel doesn't even know which socket the data
is destined for in step 1.  So step 1 can't usefully return
-EWOULDBLOCK, for example.  And it's awkward for the kernel to report
errors, because steps 1 and 2 are so disconnected.  And I'm not
convinced there's any corresponding benefit.


In any case, maybe io_uring gives an opportunity to do much better.
io_uring makes it *efficient* for largish numbers of long-running
operations to all be pending at once.  Would an API like this work
better (very handwavy -- I make absolutely no promises that this is
compatible with existing users -- new opcodes might be needed):

Submit IORING_OP_SPLICE from a *file* to a socket: this tells the
kernel to kindly send data from the file in question to the network.
Writes to the file before submission will be reflected in the data
sent.  Writes after submission may or may not be reflected.  (This is
step 1 above.)

The operation completes (and is reported in the CQ) only after the
kernel knows that the data has been snapshotted (step 2 above).  So
completion can be reported when the data is DMAed out or when it's
checksummed-and-copied or if the kernel decides to copy it for any
other reason *and* the kernel knows that it won't need to read the
data again for possible retransmission.  As you said, this could
easily take minutes, but that seems maybe okay to me.

(And if Samba needs to make sure that future writes don't change the
outgoing data even two seconds later when the data has been sent but
not acked, then maybe a fancy API could be added to help, or maybe
Samba shouldn't be using zero copy IO in the first place!)

If the file is truncated or some other problem happens, the operation can fail.


I don't know how easy or hard this is to implement, but it seems like
it would be quite pleasant to *use* from user code, it ought to be
even faster than splice-to-pipe-then-splice-to-socket (simply because
there is less bookkeeping), and it doesn't seem like any file change
tracking would be needed in the kernel.


If this works and becomes popular enough, splice-from-file-to-pipe
could *maybe* be replaced in the kernel with a plain copy.

--Andy
