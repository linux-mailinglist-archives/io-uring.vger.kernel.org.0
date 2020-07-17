Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E151223D42
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgGQNsq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGQNsp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 09:48:45 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F91C061755
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 06:48:45 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g13so7623022qtv.8
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4giYETviNoNUsmg3cBiT3s440yGEv6zpT6J/XtmyIU=;
        b=fbTh7O5vHuLJeaECDxcaWikuRQGU/kcWeHb7/+M3wgD5fHQSrVOX8KV/yvOmT0DV/F
         XU4EueYE9IIM28r6IQpAQtQ5vGpPVxH2ZHoJV2emRWf210etXiH114lvPLpkU9lFKkzY
         FtEDpKEH+31hNPmoyAUHU8uv5sEfucSj4/tKgTDPg3okIZh8UZyzLj1BA4scjxJoLDZp
         XXtLwkElp/MiphA8gmTXoQ5NVUW3DsWm4HXDfWdq2ES44tqeaWI/NomOA2jOVVgmxb2g
         0IMWEQctIcoOpXsgSXdb4rVVkX7z5A83cUwnc3J82qaWnZFTN5/MDT4kM8XFBl2GR9kz
         Q2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4giYETviNoNUsmg3cBiT3s440yGEv6zpT6J/XtmyIU=;
        b=L1EV5Wo6p8LvSfAtfWo6C0NV2LfaogDu9wYOzNxT3VoV7MhlCRa5ZGuxVr6fx5vqpE
         yg6SmN6FRJSDXdSf2hGDj520Z3nkuPM8Zyl6+3ulJqUAQayklH9bSsmeqWVAHZscQT0d
         +hCrtBh3dj0Pby6DQ6/3NbrEjiitj5dOp+Pz7IFNPcsjm+6o9yDegfiPrFKmEtw6orth
         IRgJOTgXEdeQ4RVHe2M7XuhjE0a388F7PC6pucMRMQgb6jpVJvUEvKVfj05ZgBMeyj7W
         OPMWlqFpVrAZ/Kr83JvfDoXCQISnMXLZOrliULFYY2r6eOaeXaI877CRIlewiR5jVAxl
         TIfA==
X-Gm-Message-State: AOAM532NUT/22d+jgi6RKk0xO/y/UEgXSD9p+iZaIR5CMgiwu/d0HKIc
        CmsZ1A6fvuB1SVwN/muKK5eGQRWM/FJNZVZLFIoQcg==
X-Google-Smtp-Source: ABdhPJyToV0340nvsXFqVLTvR+BKw6z5gwRUQgs0tINK53XC5X/KWRDmCVu9gmeRbvQ5eVnhH7BpsAXzXiGrgBD6dkg=
X-Received: by 2002:ac8:6989:: with SMTP id o9mr10822857qtq.50.1594993724123;
 Fri, 17 Jul 2020 06:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200711093111.2490946-1-dvyukov@google.com> <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name> <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
In-Reply-To: <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 17 Jul 2020 15:48:32 +0200
Message-ID: <CACT4Y+bgTCMXi3eU7xV+W0ZZNceZFUWRTkngojdr0G_yuY8w9w@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Hristo Venev <hristo@venev.name>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Necip Fazil Yildiran <necip@google.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 11, 2020 at 6:16 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Jul 11, 2020 at 5:52 PM Hristo Venev <hristo@venev.name> wrote:
> >
> > On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
> > > Looking at the code more, I am not sure how it may not corrupt
> > > memory.
> > > There definitely should be some combinations where accessing
> > > sq_entries*sizeof(u32) more memory won't be OK.
> > > May be worth adding a test that allocates all possible sizes for
> > > sq/cq
> > > and fills both rings.
> >
> > The layout (after the fix) is roughly as follows:
> >
> > 1. struct io_rings - ~192 bytes, maybe 256
> > 2. cqes - (32 << n) bytes
> > 3. sq_array - (4 << n) bytes
> >
> > The bug was that the sq_array was offset by (4 << n) bytes. I think
> > issues can only occur when
> >
> >     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
> >     !=
> >     PAGE_ALIGN(192 + (32 << n) + (4 << n))
> >
> > It looks like this never happens. We got lucky.
>
> Interesting. CQ entries are larger and we have at least that many of
> them as SQ entries. I guess this + power-of-2-pages can make it never
> overflow.

Hi Jens,

I see this patch is in block/for-5.9/io_uring
Is this tree merged into linux-next? I don't see it in linux-next yet.
Or is it possible to get it into 5.8?

The reason I am asking is that we have an intern (Necip in CC) working
on significantly extending io_uring coverage in syzkaller:
https://github.com/google/syzkaller/pull/1926
Unfortunately we had to hardcode offset computation logic b/c the
intended way of using io_uring for normal programs represents an
additional obstacle for the fuzzer and the relations between syscalls
and writes to shared memory are even hard to express for the fuzzer.
We want to hardcode this new updated way of computing offsets, but
this means we probably won't get good coverage until the intern term
ends (+ may be good to discover some io_uring bugs before the
release).

If it won't get into linux-next/mainline until 5.9, it's not a big
deal, but I wanted to ask.
