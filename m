Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6E250138
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHXPdV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 11:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgHXPdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 11:33:16 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ED3C061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 08:33:15 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id b2so3897849qvp.9
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 08:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GobpPjdLg/JWnf3d+r1qbat1a2WxvEb1wGe1Mt+LEB0=;
        b=eheV2p2Oi8NOI++Zg6Qhoxdpb8Dr+/ih3UsgBtyj0GhJk6pwG+0fL2JbXEQTi00epb
         bjY04aJKX2mAzSuMjJe1QBHcZkCC+SFxLEEOSftUN3Kqoz7r80tK6k0pCkeu14p8iKCp
         OHLCuPiFVkjzYmYLsIPFx7S7H39aXLHS0TfEoEw+RnIziMXUC3d8nXfkHXsm2p3Eo4BH
         iPeEtcDEn7Ya4Y2QFGMbrJYSu2dYd7zN6IPRYIMpV+K8W+OqGQnnO+p6D/gy5VCbLG8/
         q4vjBINYK9Qtlk0zWyMCKr4+/Ez483lhTEf/p9Ukxoo8kSTBC/whkL0LWrapkpEWNaul
         8Q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GobpPjdLg/JWnf3d+r1qbat1a2WxvEb1wGe1Mt+LEB0=;
        b=g3sAKlBafHhr76X0GDIwEJe3zOggR+8L5Y8LX6KjU2howazZ9Onc0ahZd3iHt2Ktvu
         +Vt+CvEHUyGk5jFTG4wbF947DfYIJforGidPcn9V57VB3Hfb59XfPumyyiQigY2bw/J4
         K6WkZEIWqqnK5jdtHaHZGK3A38/Jig+0w/843RryKj8xf+R0SheQui9UW7jNJqCFz21z
         InmOSNQExPYaDyj/tHS6fGvfKHkQHCGBAH2MvuDjFAZ0ADTvsf3g1KiiqS8eWhqWFQ+/
         4FFtyjfboV+y4vH4DOTFkbRPEXeCB0571TnDIrg8VwDuaofJehF+GZa07THESARBcIZG
         PtYQ==
X-Gm-Message-State: AOAM533Vr8QxjE2+1rV8MXjWWp9kkQTHcFJmjr8U8LY3924felYOmznl
        Cn+ewJRDdblUU4DfXtXi2pdpJRZ4LEwxi8HmaBbF9Rh5Hjw=
X-Google-Smtp-Source: ABdhPJzk4A8mxlJ7fQG+mfC79HmnF8ubSwdiy3VwfS6SCkgh+35ptej+DyFBTGxzHLgsKnkvF9IQ/V46oMv1wk+2NcE=
X-Received: by 2002:a0c:f9cd:: with SMTP id j13mr5272651qvo.227.1598283193693;
 Mon, 24 Aug 2020 08:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk> <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk> <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
In-Reply-To: <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 24 Aug 2020 18:33:02 +0300
Message-ID: <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Was going to look into this.
I am getting 0 reads. This is on some old kingston ssd, ext4.

On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/24/20 8:06 AM, Jens Axboe wrote:
> > On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
> >> library that i am using https://github.com/dshulyak/uring
> >> It requires golang 1.14, if installed, benchmark can be run with:
> >> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> >> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
> >>
> >> note that it will setup uring instance per cpu, with shared worker pool.
> >> it will take me too much time to implement repro in c, but in general
> >> i am simply submitting multiple concurrent
> >> read requests and watching read rate.
> >
> > I'm fine with trying your Go version, but I can into a bit of trouble:
> >
> > axboe@amd ~/g/go-uring (master)>
> > go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> > # github.com/dshulyak/uring/fixed
> > fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
> >    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
> >       |                                                ^
> > FAIL  github.com/dshulyak/uring/fs [build failed]
> > FAIL
> > axboe@amd ~/g/go-uring (master)> go version
> > go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
>
> Alright, got it working. What device are you running this on? And am I
> correct in assuming you get short reads, or rather 0 reads? What file
> system?
>
> --
> Jens Axboe
>
