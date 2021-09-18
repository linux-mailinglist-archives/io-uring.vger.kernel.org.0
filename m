Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95EF4108C0
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbhIRV4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 17:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhIRV4m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 17:56:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26338C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 14:55:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z94so44115448ede.8
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 14:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mhfe/ir/ObcOKDbuZYrsrDc6bEmh2UmPFVdLIUnwugU=;
        b=y93X0a3txFG0bKFPklEgWke+2mH/aD6avduO4XwF8pBipNSluMVUi096CMaR1fEu7w
         /w8P0nfsLDVkBpj142t3AK+pQD/Xu5Xs2zE537B6ed63a67UVvbn+zd6bVbT1jnF6p5z
         hgn5145xsmP1aUlrMerJ/gyssExkwqOQAx9zGHbvDhFAJvROIbvbU5KpyRkEZgSdjEGg
         Mve9v7X0hZ1A5+rwzITCa6Yx8ZnTNVc0LfNRl4ohjeacpMt3PyLY++VWyojYPexvT5bn
         XX0o0+H7j3JbCe5OlcUTRqSWdAB+b2z+RtAzyVw5MXuq+0qWqGESU/iub56M+16GMP5f
         xxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mhfe/ir/ObcOKDbuZYrsrDc6bEmh2UmPFVdLIUnwugU=;
        b=PyA0HacO5LD3oNG1nUiWdqJDs1WnEAPavYpyTONwl1tR7sxvfxVYWYKkJcki0jI69B
         OqVSkAZ9rE0A5/QdL+AJ8kZvqmROk33vM7iA9M6lffBEffARU7bju4CQMyqKMtdUh3/y
         JhbtZRUppOib2pZNhh1KszISf5u4BsIItGOH5QLmOlb+qU6ACsoIKgEsPgTvh2E9ankf
         bET2geBdqlsMSg/bmoYqHThyJHID97IzKx42ZQCc05EPB3R4i/cRh3VwGKXcIDA1f8D0
         2LtfvWC/saB3VRKLghRF0kg0kggNsjB8CaX/iidXG4P9Qynwv2M3TwW1PtGBAlEKLOdJ
         ZlNA==
X-Gm-Message-State: AOAM531AursN4Zj3TycYhC00xWbSKl2d+4ZmJbHjPmMpnjLuWvrl9q6z
        VYVMWL3UAgZKJTsQUxHhmGyd+SxAE1tktgf004e3rWBWpLfv3A6tCeI=
X-Google-Smtp-Source: ABdhPJw8Z4CK8/JOrI34D6WEV99AEYVpsi33iN3lwPDwllp/xkCZCdWViBJCWhfTESvZ0UcZMXV5zBLMptYspbRDmlg=
X-Received: by 2002:a50:d80f:: with SMTP id o15mr20586015edj.52.1632002116193;
 Sat, 18 Sep 2021 14:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk> <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk> <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
In-Reply-To: <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 18 Sep 2021 22:55:05 +0100
Message-ID: <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 18, 2021 at 9:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On Sat, Sep 18, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 9/18/21 2:13 PM, Victor Stewart wrote:
> > > On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 9/18/21 7:41 AM, Victor Stewart wrote:
> > >>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
> > >>> file registrations fail with EOPNOTSUPP using liburing 2.0.
> > >>>
> > >>> static inline struct io_uring ring;
> > >>> static inline int *socketfds;
> > >>>
> > >>> // ...
> > >>>
> > >>> void enableFD(int fd)
> > >>> {
> > >>>    int result = io_uring_register_files_update(&ring, fd,
> > >>>                       &(socketfds[fd] = fd), 1);
> > >>>    printf("enableFD, result = %d\n", result);
> > >>> }
> > >>>
> > >>> maybe this is due to the below and related work that
> > >>> occurred at the end of 5.13 and liburing got out of sync?
> > >>>
> > >>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
> > >>>
> > >>> and can't use liburing 2.1 because of the api changes since 5.13.
> > >>
> > >> That's very strange, the -EOPNOTSUPP should only be possible if you
> > >> are not passing in the ring fd for the register syscall. You should
> > >> be able to mix and match liburing versions just fine, the only exception
> > >> is sometimes between releases (of both liburing and the kernel) where we
> > >> have the liberty to change the API of something that was added before
> > >> release.
> > >>
> > >> Can you do an strace of it and attach?
> > >
> > > oh ya the EOPNOTSUPP was my bug introduced trying to debug.
> > >
> > > here's the real bug...
> > >
> > > io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
> > > 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> > > -1, -1, -1, -1, -1,
> > > -1, ...], 32768) = -1 EMFILE (Too many open files)
> > >
> > > 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
> > > 16,000 just to try and same issue.
> > >
> > > maybe you're not allowed to have pre-filled (aka non negative 1)
> > > entries upon the initial io_uring_register_files call anymore?
> > >
> > > this was working until the 5.13.16 -> 5.13.17 transition.
> >
> > Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
> > registered files are under that protection now too. This is also why it
> > was brought back to stable. A bit annoying, but it was needed for the
> > direct file support to have some sanity there.
> >
> > So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
> > limit.
>

perfect got it working with..

struct rlimit maxFilesLimit = {N_IOURING_MAX_FIXED_FILES,
N_IOURING_MAX_FIXED_FILES};
setrlimit(RLIMIT_NOFILE, &maxFilesLimit);

> BTW, this could be incorporated into io_uring_register_files and
> io_uring_register_files_tags(), might not be a bad idea in general. Just
> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
> failure.

the implicit bump sounds like a good idea (at least in theory?).

another thing i think might be a good idea is an io_uring
change/migration log that we update with every kernel release covering
new features but also new restrictions/requirements/tweaks etc.

something that would take 1 minute to skim and see if relevant.

because at this point to stay fully updated requires reading all of the
mailing list or checking pulls on your branch + running to binaries
to see if anything breaks.

>
> --
> Jens Axboe
