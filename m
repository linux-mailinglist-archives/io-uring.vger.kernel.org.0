Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDF5223DCE
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQOIr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 10:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQOIr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 10:08:47 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2C6C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:08:46 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g13so7678856qtv.8
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjcdUSR4af1mvGiwGEC+DzHohdw7sIDqTz/IjLBiUa0=;
        b=qqbGJP17dWXeVesvHFAcvU7HR4tDBAw7LmEdNQfao7U7Cpl6Hc6MWOzDIQ4Vn+M5/x
         ENxiZSnYz+EFKNRc7Z6wvzXFkS0EcYHy/I2Yd2OT2/VY8sL9sZ8U/Wtgu6IVKfhfJhTc
         INDPoSpF6Qo/BNtoc9TioJ8F0FNk2mBLNd9yl4Xb+kolN2gYkk7H7oMHHsMsDz2rrm0b
         1oDpxwzvel6PKIWwEDK38acbGNCCkUDEDH+DtobnkYs6ZQQ8dfMeR0UvrSXRDj22LPDp
         VkxvxSGCApFdS/eeRaRWabFcV9Nga07vSSoBaX45j+KAtgkCxQrEFA1d+/o7viBWpn3g
         +uFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjcdUSR4af1mvGiwGEC+DzHohdw7sIDqTz/IjLBiUa0=;
        b=G4IjIu5GM+vLJIPs9m2xSGQkTJNQwNeoiKUnxk4IhYNGSovERDy2MLDa9znLhUbr60
         ZrIcO+8cBbQFN1Q9do/b3LNLfCsyQOKOnvFaynsY3iva2t6wRYY2lZfDhFo/JwZq6oAP
         Hj30tM8Qxh0YHqofT9BvYAY+IAX2su+2MRy1r51JTvCvIlHx4K/IFCYODtfmrOsiT/7u
         XPfPdmtvA/iot+aVPXlY0h2ByRUwc8PpleQghLFJzDXii9FuT1lU++kljxo/BqmTD+/a
         vOqr74VnMiy25T0f3X3AxE9j7lNR54s3SBCxGfdCl20sDTchAttSLSmjLYgacp+gC5BJ
         glMQ==
X-Gm-Message-State: AOAM5330PXjK0eZyQQtxujj2+ocxTZ2jq/+uQekT0FeQHPGR2x30ILOD
        +7lZuc5twdyCzu8TLFWt/IgYpAJ+YXQi8tfqQ6B+BA==
X-Google-Smtp-Source: ABdhPJw77RJ4eXTI6h0SR3Q6D7JkLJlyDV94a3/Fs2mw8MZWnXW23/pQDWU8kVVYLLFdXufQB2gEJWEuU77h+KH1a8E=
X-Received: by 2002:ac8:41c7:: with SMTP id o7mr10435550qtm.257.1594994925764;
 Fri, 17 Jul 2020 07:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200711093111.2490946-1-dvyukov@google.com> <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
 <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
 <CACT4Y+bgTCMXi3eU7xV+W0ZZNceZFUWRTkngojdr0G_yuY8w9w@mail.gmail.com> <07129dd4-3ca1-63ad-8045-973532e320d9@kernel.dk>
In-Reply-To: <07129dd4-3ca1-63ad-8045-973532e320d9@kernel.dk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 17 Jul 2020 16:08:34 +0200
Message-ID: <CACT4Y+ZhZ=1pxbBb1kxPnO9mfOmcucDEGyUvKAGpx4ZqxCRQDQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hristo Venev <hristo@venev.name>,
        Necip Fazil Yildiran <necip@google.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 17, 2020 at 4:05 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/17/20 7:48 AM, Dmitry Vyukov wrote:
> > On Sat, Jul 11, 2020 at 6:16 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> >>
> >> On Sat, Jul 11, 2020 at 5:52 PM Hristo Venev <hristo@venev.name> wrote:
> >>>
> >>> On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
> >>>> Looking at the code more, I am not sure how it may not corrupt
> >>>> memory.
> >>>> There definitely should be some combinations where accessing
> >>>> sq_entries*sizeof(u32) more memory won't be OK.
> >>>> May be worth adding a test that allocates all possible sizes for
> >>>> sq/cq
> >>>> and fills both rings.
> >>>
> >>> The layout (after the fix) is roughly as follows:
> >>>
> >>> 1. struct io_rings - ~192 bytes, maybe 256
> >>> 2. cqes - (32 << n) bytes
> >>> 3. sq_array - (4 << n) bytes
> >>>
> >>> The bug was that the sq_array was offset by (4 << n) bytes. I think
> >>> issues can only occur when
> >>>
> >>>     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
> >>>     !=
> >>>     PAGE_ALIGN(192 + (32 << n) + (4 << n))
> >>>
> >>> It looks like this never happens. We got lucky.
> >>
> >> Interesting. CQ entries are larger and we have at least that many of
> >> them as SQ entries. I guess this + power-of-2-pages can make it never
> >> overflow.
> >
> > Hi Jens,
> >
> > I see this patch is in block/for-5.9/io_uring
> > Is this tree merged into linux-next? I don't see it in linux-next yet.
> > Or is it possible to get it into 5.8?
>
> Yes, that tree is in linux-next, and I'm surprised you don't see it there
> as it's been queued up for almost a week. Are you sure?
>
> I'm not going to apply it to both 5.9 and 5.8 trees. The bug has
> been there for a while, but doesn't really impact functionality.
> Hence I just queued it up for 5.9. If this had been a 5.8 commit
> that introduced it, I would have queued it up for 5.8.
>
> > The reason I am asking is that we have an intern (Necip in CC) working
> > on significantly extending io_uring coverage in syzkaller:
> > https://github.com/google/syzkaller/pull/1926
> > Unfortunately we had to hardcode offset computation logic b/c the
> > intended way of using io_uring for normal programs represents an
> > additional obstacle for the fuzzer and the relations between syscalls
> > and writes to shared memory are even hard to express for the fuzzer.
> > We want to hardcode this new updated way of computing offsets, but
> > this means we probably won't get good coverage until the intern term
> > ends (+ may be good to discover some io_uring bugs before the
> > release).
>
> Sounds good
>
> > If it won't get into linux-next/mainline until 5.9, it's not a big
> > deal, but I wanted to ask.
>
> That's the plan, it'll go in as part of the 5.9 merge window.

Thanks.
linux-next is good enough, we test it. And the commit is actually
already there, now that I looked closer.
