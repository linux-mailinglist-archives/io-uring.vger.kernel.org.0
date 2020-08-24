Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6212501CC
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHXQON (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 12:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgHXQOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 12:14:06 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CB0C061574
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:14:05 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id o22so6513093qtt.13
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ALTfOpWD3orwTLHI8ekOhfYNg5FIn4RIxFH6+81yCZM=;
        b=HqZuf18FwaR6mwkQMY78VHu8JXhPdAWulo1RissruiNF8vqdXqbhSqBWb8dZbcum0g
         h/T0K0Vd5sNydRkB703ov5iBbGEUz+8CDLStLxxy/jBcXy1DkM/aYXs7YV9megnzsm5N
         K/pV0e2OeIulECPD/IOxIBr39Zh2GrXTPcgg4VVDDLLynhWL7SLySKx9H5tTCsiO7qnp
         A9TnGNzeCgCY4HR+1SmVP/8iREo5MZt1SlpxsFm32Wu26VmUT/tVt6jhm/JJnSHMoRbT
         Y0b+t8ac/X+R7v5IN3lMBO7cE36gitrdcpCBf2vlBaLCZ6XbGw2FihK4b2aYtgrjfUK0
         jV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ALTfOpWD3orwTLHI8ekOhfYNg5FIn4RIxFH6+81yCZM=;
        b=WQAzOoBUVDzVZomZQ+IuvosHz/Jv/tQiPDPOw0/iIIFj6IBUIS5xviaT/mQulgIWzO
         a8RK4D0tFYkm9F2RIGdI7ROc+3PP401PB/p2jvvx60hlh2GIJQhMAu+e2BtBr8ePoJnL
         Ybqc4NYao66d+aYlfqkg8nqGlt/2VGvMPRcUj9fb7EvslpLtK12+3cSn/bGMGvt1ogZf
         JiDFiZ0LRWZ+EL7zmS5Ins+kmc/p8ODQlPmIm71tIA84u1qXVGtmYOxSPpA4L/Yyfckm
         Dp9Nfv8qwcBVWQCjac89rZPe+QH40W49J9NNjah/5PO+7ocdBxIlTgwY4TfY6KSEzeWs
         29tw==
X-Gm-Message-State: AOAM532qLpLHoGD1qdMGWMoKz5HjLq1Ygs4AAcRFBctwY6IcmfUXS9Ph
        SnLcYCrOleL/gr7sQbcboo89mDl8CRZNEd+XUMM=
X-Google-Smtp-Source: ABdhPJzwDv17LRAm++3SeeQoAqYGICKeH1V+4TQ7QwSGoSMrJmnnT9RrKw6nZ+sepQ3gPGR4Pe0ePeFDbwM8JZwRxqU=
X-Received: by 2002:aed:36c7:: with SMTP id f65mr5564201qtb.39.1598285643751;
 Mon, 24 Aug 2020 09:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk> <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk> <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com> <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
In-Reply-To: <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 24 Aug 2020 19:13:52 +0300
Message-ID: <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nops are used for draining and closing rings at the end of benchmarks.
It also appears in the beginning because of the way golang runs benchmarks...

On Mon, 24 Aug 2020 at 19:10, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/24/20 9:33 AM, Dmitry Shulyak wrote:
> > On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 8/24/20 8:06 AM, Jens Axboe wrote:
> >>> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
> >>>> library that i am using https://github.com/dshulyak/uring
> >>>> It requires golang 1.14, if installed, benchmark can be run with:
> >>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> >>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
> >>>>
> >>>> note that it will setup uring instance per cpu, with shared worker pool.
> >>>> it will take me too much time to implement repro in c, but in general
> >>>> i am simply submitting multiple concurrent
> >>>> read requests and watching read rate.
> >>>
> >>> I'm fine with trying your Go version, but I can into a bit of trouble:
> >>>
> >>> axboe@amd ~/g/go-uring (master)>
> >>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> >>> # github.com/dshulyak/uring/fixed
> >>> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
> >>>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
> >>>       |                                                ^
> >>> FAIL  github.com/dshulyak/uring/fs [build failed]
> >>> FAIL
> >>> axboe@amd ~/g/go-uring (master)> go version
> >>> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
> >>
> >> Alright, got it working. What device are you running this on? And am I
> >> correct in assuming you get short reads, or rather 0 reads? What file
> >> system?
> >
> > Was going to look into this.
> > I am getting 0 reads. This is on some old kingston ssd, ext4.
>
> I can't seem to reproduce this. I do see some cqe->res == 0 completes,
> but those appear to be NOPs. And they trigger at the start and end. I'll
> keep poking.
>
> --
> Jens Axboe
>
