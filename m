Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AC94108E9
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 01:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhIRXVQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 19:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhIRXVQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 19:21:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EC1C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:19:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c21so44526382edj.0
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zp8CrpqQ5t4Qi74WvvnliRlh099/IbWwoyAI6cCfF6Y=;
        b=cIh3Z0KUL6lLIIcCHNpue4xFyDI0J6R/FW/rjhmlT94GhxOvSgtgofNyy3lwHxe6J+
         xqyitVAhAqAm6xus3JH1DhfLRGaEXcmMiWi8WG44+Z1MmiSnL1hGO3hGCExYNjUvuxBL
         GVo1yRa++79Q2qQ2oODB2GUSdYMa6kRlGQoJeE9o7VQiY6VyHaIdn6dmPuoLjixPzrqn
         3mSmueupllaMYAgSGmeilahZGwN5hWWK9reKhbYr8eSoedEAVgW2Z+5QlM6as5k4WuZh
         QATMhG+fxOSCUqT0n7XDCN4+3+LFITrwktBR4u1GT/nnUnMyjKGclL5zCSObgj2HKvWQ
         r0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zp8CrpqQ5t4Qi74WvvnliRlh099/IbWwoyAI6cCfF6Y=;
        b=N5k2kV+ZuDBXM2ESTPkxjVkQJ9PO97OfCC0ad2Sp6pP7JvFsgOwU6I+143bFlCJhTy
         wuIs0waB1ARm8cVUQjTbv/Ryl8UlFd9hHFcIQoVlwzIzfNrsO6EqFLbBjVovKLgfIajG
         yn/1rxsJAMFfTgBXuNEU8WtcyX08He5TQOzkyn98Ofc+JiocIeJFbLmkQoTBvvBEUkL6
         tO4WWFQlZQN45Hqm6gfjK/UJa3Vyfv4mhdgYbaR3T4lnt1tekP/+m/sndIZgsDsLE0R9
         a6j9aGWhWMpDxJmYf/08F1Q50dzoSW3bzXjJFXtWbP5ED2m1mxs4Vl6lBN9/njeoqYXt
         onMQ==
X-Gm-Message-State: AOAM530Lf2tdi8LHytu+geTx6Id51WNsIZKnYQmysI9UpTur6vDmEq+8
        Ehn+O4seJtT18bBQvOIjttCP5K5oLbsKhak0hkqXsGgP38/+6K6Q0dQ=
X-Google-Smtp-Source: ABdhPJw6erEBvMD8UfaOlDBUqJ2h3qk9Ggzs3pnF7JWvgsicoUw/e4p3GNgnpk2TVofgrh+6QJ+MZGa8TlFRaWa9GhY=
X-Received: by 2002:a05:6402:1a53:: with SMTP id bf19mr21019451edb.235.1632007190216;
 Sat, 18 Sep 2021 16:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk> <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk> <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com> <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
In-Reply-To: <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sun, 19 Sep 2021 00:19:39 +0100
Message-ID: <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 18, 2021 at 11:21 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/18/21 3:55 PM, Victor Stewart wrote:
> > On Sat, Sep 18, 2021 at 9:38 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On Sat, Sep 18, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 9/18/21 2:13 PM, Victor Stewart wrote:
> >>>> On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 9/18/21 7:41 AM, Victor Stewart wrote:
> >>>>>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
> >>>>>> file registrations fail with EOPNOTSUPP using liburing 2.0.
> >>>>>>
> >>>>>> static inline struct io_uring ring;
> >>>>>> static inline int *socketfds;
> >>>>>>
> >>>>>> // ...
> >>>>>>
> >>>>>> void enableFD(int fd)
> >>>>>> {
> >>>>>>    int result = io_uring_register_files_update(&ring, fd,
> >>>>>>                       &(socketfds[fd] = fd), 1);
> >>>>>>    printf("enableFD, result = %d\n", result);
> >>>>>> }
> >>>>>>
> >>>>>> maybe this is due to the below and related work that
> >>>>>> occurred at the end of 5.13 and liburing got out of sync?
> >>>>>>
> >>>>>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
> >>>>>>
> >>>>>> and can't use liburing 2.1 because of the api changes since 5.13.
> >>>>>
> >>>>> That's very strange, the -EOPNOTSUPP should only be possible if you
> >>>>> are not passing in the ring fd for the register syscall. You should
> >>>>> be able to mix and match liburing versions just fine, the only exception
> >>>>> is sometimes between releases (of both liburing and the kernel) where we
> >>>>> have the liberty to change the API of something that was added before
> >>>>> release.
> >>>>>
> >>>>> Can you do an strace of it and attach?
> >>>>
> >>>> oh ya the EOPNOTSUPP was my bug introduced trying to debug.
> >>>>
> >>>> here's the real bug...
> >>>>
> >>>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
> >>>> 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> >>>> -1, -1, -1, -1, -1,
> >>>> -1, ...], 32768) = -1 EMFILE (Too many open files)
> >>>>
> >>>> 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
> >>>> 16,000 just to try and same issue.
> >>>>
> >>>> maybe you're not allowed to have pre-filled (aka non negative 1)
> >>>> entries upon the initial io_uring_register_files call anymore?
> >>>>
> >>>> this was working until the 5.13.16 -> 5.13.17 transition.
> >>>
> >>> Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
> >>> registered files are under that protection now too. This is also why it
> >>> was brought back to stable. A bit annoying, but it was needed for the
> >>> direct file support to have some sanity there.
> >>>
> >>> So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
> >>> limit.
> >>
> >
> > perfect got it working with..
> >
> > struct rlimit maxFilesLimit = {N_IOURING_MAX_FIXED_FILES,
> > N_IOURING_MAX_FIXED_FILES};
> > setrlimit(RLIMIT_NOFILE, &maxFilesLimit);
>
> Good!
>
> >> BTW, this could be incorporated into io_uring_register_files and
> >> io_uring_register_files_tags(), might not be a bad idea in general. Just
> >> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
> >> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
> >> failure.
> >
> > the implicit bump sounds like a good idea (at least in theory?).
>
> Can you try current liburing -git? Remove your own RLIMIT_NOFILE and
> just verify that it works. I pushed a change for it.

i don't have a dev box up right now, but i applied the below changes to 2.0
sans the tags bit...

diff --git a/src/register.c b/src/register.c
index 994aaff..495216a 100644
--- a/src/register.c
+++ b/src/register.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
+#include <sys/resource.h>

 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
@@ -14,6 +15,22 @@

 #include "syscall.h"

+static int bump_rlimit_nofile(unsigned nr)
+{
+       struct rlimit rlim;
+
+       if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
+               return -errno;
+       if (rlim.rlim_cur < nr) {
+               if (nr > rlim.rlim_max)
+                       return -EMFILE;
+               rlim.rlim_cur = nr;
+               setrlimit(RLIMIT_NOFILE, &rlim);
+       }
+
+       return 0;
+}
+
 int io_uring_register_buffers(struct io_uring *ring, const struct
iovec *iovecs,
                              unsigned nr_iovecs)
 {
@@ -55,6 +72,10 @@ int io_uring_register_files_update(struct io_uring
*ring, unsigned off,
        };
        int ret;

+       ret = bump_rlimit_nofile(nr_files);
+       if (ret)
+               return ret;
+

and it failed with the same as before...

io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1, -1, -1,
-1, ...], 32768) = -1 EMFILE (Too many open files)

if you want i can debug it for you tomorrow? (in london)

>
> > another thing i think might be a good idea is an io_uring
> > change/migration log that we update with every kernel release covering
> > new features but also new restrictions/requirements/tweaks etc.
>
> Yes, that is a good idea. The man pages do tend to reference what
> version included what, but a highlight per release would be a great idea
> to have without having to dig for it.
>
> > something that would take 1 minute to skim and see if relevant.
> >
> > because at this point to stay fully updated requires reading all of the
> > mailing list or checking pulls on your branch + running to binaries
> > to see if anything breaks.
>
> Question is where to post it? Because I would post it here anyway...

i think a txt file in liburing might be the perfect place given the audience
for it is solely application developers? could start with 5.15 and maintain
it forward.

>
> --
> Jens Axboe
>
