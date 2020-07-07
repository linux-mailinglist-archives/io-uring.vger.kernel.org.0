Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BBE216BC2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 13:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgGGLiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 07:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgGGLiN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 07:38:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9254BC061755;
        Tue,  7 Jul 2020 04:38:13 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s21so20520121ilk.5;
        Tue, 07 Jul 2020 04:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+9PXsEHC8Tau1MQTySeSJIu15QBhP57I+JN1uapBu0=;
        b=JirTA1RlvJAlDXxssPiBjYAQw8/IAQxOLQXqoDRmUr5Q7eXEI05rN0ZCnBmWsZzbFe
         Fse1fi06L+PCjopdbPPnGNT1QeQojO3coqU1ja8XSjRjF03hlXmzC0GLIWJUCIhcm3yk
         nexkBSFm9tW9pjzicOY0yEmXy+WBwvcexBGHnjSkhPXZDAx3P2pkRwd5xKSEENjE1Alf
         /1Yf7FdVFHCXNGYnUEcg0LUccx2gPlnuBsZkwpRz7lZ661siGnnxrpYu/I5r8bEADam2
         6S/vUj52Ak5EkHTaIEoaCCDdPgdGT6/tL9DFm402FNQaW5itQi11KgZOCG3mUTv8/4uC
         Sehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+9PXsEHC8Tau1MQTySeSJIu15QBhP57I+JN1uapBu0=;
        b=roTmvF9pSzP0C2GBAH1L1L5m5N5ApQJd7NdN2TO0kvX60qIzpg4GmXmBEmgHNMjuVP
         ZIi2ln2QsJSKGzgS+OwpQDFccaB+LJJkK7jmImZ3+AZSArminYMtjgHC+5bolCfsi+5n
         PiK2BwCqDvqz+yxo9M/lBcleKCaXjqkDpcQoQj+gakjzq0TXv9kIuyx+syZFbfS8MGmC
         3EG9CL/B0wKRxTXaHg5ZzXk+qlOw+a36awZyrVAgnCbaiYaxv+ABxFJD/WLW37egz7M5
         kYcKhuxALSJ5RDO2+eftVMJm2ZCy3hJoh/uDCecVAP5DbvexxyxX2us3VKcokZVWM+dB
         Z5vg==
X-Gm-Message-State: AOAM531UH367wOKFaPJXdpKTUFsnErJqOVtlJgISOxupgX455U/er8H5
        HF++VJ4NCCZFNPBUQiB1WJ29bhIml8mMKkhVbh8=
X-Google-Smtp-Source: ABdhPJyLy71kFINoMC1IHKN/W9Wzb6/SH2hqLTyUZVHsX7LIVZCqyVklNgrjn7GmuSwIHTTceD6R3Lnu4FTNFB1XILg=
X-Received: by 2002:a92:c7ab:: with SMTP id f11mr36287094ilk.50.1594121892966;
 Tue, 07 Jul 2020 04:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200618144355.17324-1-axboe@kernel.dk> <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area> <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk> <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
 <20200624164127.GP21350@casper.infradead.org> <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
In-Reply-To: <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Tue, 7 Jul 2020 13:38:01 +0200
Message-ID: <CAHpGcMJsrQXX4OQe6MqjyTt8BOLZw-y1ixdk76p_DsZONyEJcQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am Mi., 24. Juni 2020 um 18:48 Uhr schrieb Jens Axboe <axboe@kernel.dk>:
>
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

Also note my conflicting patch that introduces a IOCB_NOIO flag for
fixing a gfs2 regression:

https://lore.kernel.org/linux-fsdevel/20200703095325.1491832-2-agruenba@redhat.com/

Thanks,
Andreas
