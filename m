Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1469C54677B
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbiFJNlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 09:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbiFJNlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 09:41:44 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ADEA1BF
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 06:41:41 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id d39so25245871vsv.7
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 06:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQNG+RWemvauKv5Tj1j/mYDZmyUAmMkEgeWxy4dTvu4=;
        b=D0vnGVnSjh+bDFvV6cblLmAqoXC70YKsCQTncGEkA9dT+/gQx3T4VU7R+GjONzn7zw
         ZG96EFgqb+1EN6cxOpTo3tggIDCsk0GKDMsEAWk1tGnfv8GQ/X0SG5nt7tE7At55HRdN
         QRGmJYo4ncFr3NdvqqZkOI2e5Ggyb3aHqbQgQ5L6Q1upElJKs6BfODkXdZb4fjztLKqQ
         VUT+y7g5xwsUhYbn4/z14SDn6iLAnKYZU7/IRlKINOorE9ztWFAAHeMDU1fmj+YMfQHS
         SOEH43AtWYwl6a3k2+AJbisVz+SR56GvkPRGcTBslYcGfl05uHeOvrajBJLkQUVZBo0h
         OfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQNG+RWemvauKv5Tj1j/mYDZmyUAmMkEgeWxy4dTvu4=;
        b=b77PlnbXkoLWVbWWoIBY51Zlv9/TliwwtB103Ff8Rf/S0woLXr4lYPlTWPBZXZfsGr
         PVvCQeAkdp+MM809FdYQmf3rTD0X82s1MkfXyMV2sCDPdDR3V0neUyq+vcs5C0d/3bdU
         E8uq3p9vBr2IY1Yvg9evFiD6YWug8M+2ndqY2t68yZ0Z3l0ysz+iSFD0190HEm5O3vvG
         lMy5nj5X4n+WdMXQ6+D9W3WzfHJCxlF6ESnXYIA/obro5xrjFVdVvKrN44XNZlDSd0qi
         ZuGhIpY2GmUJ3VMozRbXA8+2ASovGwIYstMjk5udN/ADw8RexJey4kpzSAOQrGMcruKg
         uRGA==
X-Gm-Message-State: AOAM531cRykpP3XcNVyOxWmVLBqM6mBKd0zmW6hwHQ9BDGXn/YUZcvhD
        GDZljPfbLRLTC2yVtFTIxNHPcMpexQcJYJHMdIBhng==
X-Google-Smtp-Source: ABdhPJyZVFlLRtAtK+koGkRaBUu/KNqlje0OEXFQEHrYfmZwVYxeWfczrilUERCejd8UMtCOVP7C5wyvC3mzkjltv/c=
X-Received: by 2002:a05:6102:30a8:b0:34b:95a7:6feb with SMTP id
 y8-20020a05610230a800b0034b95a76febmr16759646vsd.32.1654868500577; Fri, 10
 Jun 2022 06:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220508234909.224108-1-axboe@kernel.dk> <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
 <ba139690-e223-8b99-4aa3-5d3336f25386@kernel.dk> <50a1fa53-08cd-e7e7-a2da-e628c582e857@gmail.com>
 <4f68ef54-ecc9-402d-9c1f-379451e8fc32@kernel.dk>
In-Reply-To: <4f68ef54-ecc9-402d-9c1f-379451e8fc32@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Fri, 10 Jun 2022 14:41:29 +0100
Message-ID: <CAM1kxwjh0eNNmCsJ=q211g-Vr-hQGD4MeCiiYnk1sFAxOJAtqQ@mail.gmail.com>
Subject: Re: [PATCHSET 0/4] Allow allocated direct descriptors
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hao Xu <haoxu.linux@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 10, 2022 at 1:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/9/22 11:35 PM, Hao Xu wrote:
> > ? 2022/5/9 ??10:49, Jens Axboe ??:
> >> On 5/9/22 7:20 AM, Hao Xu wrote:
> >>> ? 2022/5/9 ??7:49, Jens Axboe ??:
> >>>> Hi,
> >>>>
> >>>> Currently using direct descriptors with open or accept requires the
> >>>> application to manage the descriptor space, picking which slot to use
> >>>> for any given file. However, there are cases where it's useful to just
> >>>> get a direct descriptor and not care about which value it is, instead
> >>>> just return it like a normal open or accept would.
> >>>>
> >>>> This will also be useful for multishot accept support, where allocated
> >>>> direct descriptors are a requirement to make that feature work with
> >>>> these kinds of files.
> >>>>
> >>>> This adds support for allocating a new fixed descriptor. This is chosen
> >>>> by passing in UINT_MAX as the fixed slot, which otherwise has a limit
> >>>> of INT_MAX like any file descriptor does.
> >>>>
> >>>>    fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
> >>>>     1 file changed, 94 insertions(+), 6 deletions(-)
> >>>>
> >>> Hi Jens,
> >>> I've read this idea of leveraging bitmap, it looks great. a small flaw
> >>> of it is that when the file_table is very long, the bitmap searching
> >>> seems to be O({length of table}/BITS_PER_LONG), to make the time
> >>> complexity stable, I did a linked list version, could you have a look
> >>> when you're avalible. totally untested, just to show my idea. Basically
> >>> I use a list to link all the free slots, when we need a slot, just get
> >>> the head of it.
> >>> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v5
> >>>
> >>> (borrowed some commit message from your patches)
> >>
> >> While that's certainly true, I'm skeptical that the list management will
> >> be faster for most cases. It's worth nothing that the regular file
> >> allocator is very much the same thing. A full scan is unlikely unless
> >> you already got -ENFILE. Any clear in between will reset the hint and
> >> it'll be O(1) again. So yes, the pathological case of having no
> >
> > it's not O(1) actually, and a full bitmap is not the only worst case.
> > For instance, the bitmap is like:
> >                              hint
> >                               |
> >    1111111111111111111111111110000
> >
> > then a bit is cleared and hint is updated:
> >      hint
> >       |
> >    1110111111111111111111111110000
> >
> > then next time the complexity is high
>
> Next time it's fine, since the hint is that bit. If you do do, then yes
> the second would be a slower.
>
> > So in this kind of scenario(first allocate many in order, then clear
> > low bit and allocation goes on in turn), it would be slow. And I think
> > these cases are not rare since people usually allocate many fds then
> > free the early used fds from time to time.
>
> It's by no means perfect, but if it's good enough for the normal file
> allocator, then I don't think it'd be wise to over-engineer this one
> until there's a proven need to do so.
>
> The single list items tracking free items is most certainly a LOT slower
> for the common cases, so I don't think that's a good approach at all.
>
> My suggestion would be to stick with the proposed approach until there's
> evidence that the allocator needs improving. I did write a benchmark
> that uses a 500K map and does opens and closes, and I don't see anything
> to worry about in terms of overhead. The bitmap handling doesn't even
> really register, dwarfed by the rest of the open path.

another angle of perspective on this is that we're sacrificing performance to
accommodate ambiguity on behalf of the application.

so another option is to make the bookkeeping an array with index == fd and
require the application to specify a static amount of open files it
supports. that
way exclusion is de facto provided by the choice of fd and we aren't duplicating
it.

this is the pattern i use in my application.

>
> >> If the case of finding a new descriptor is slow for a mostly full space,
> >> in the past I've done something like axmap [1] in fio, where you each
> >> 64-bit entry is representing by a single bit a layer up. That still has
> >> very good space utilization and good cache layout, which the list very
> >> much does not. But given the above, I don't think we need to worry about
> >> that really.
> >>
> >> As a side note, I do think we need to just bump the size of the max
> >> direct descriptors we can have. With the file table potentially being
> >> vmalloc backed, there's no reason to limit it to the current 32K.
> >
> > Agree.
> >
> >>
> >> [1] https://git.kernel.dk/cgit/fio/tree/lib/axmap.c
> >>
> > Cool, I'll have a look.
>
> It can get boiled down to something a bit simpler as the fio
> implementation supports a variety of different use cases. For example, I
> think it should be implemented as a single indexed array that holds all
> the levels, rather than separate is it's done there. In short, it just
> condenses everything down to one qword eventually, and finding a free
> bit is always O(log64(N)).
>
> --
> Jens Axboe
>
