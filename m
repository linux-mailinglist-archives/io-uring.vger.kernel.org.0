Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9850C2DE05A
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 10:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732912AbgLRJU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 04:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732777AbgLRJU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 04:20:57 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57DEC0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 01:20:16 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id p5so1517510iln.8
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 01:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7x9S522tJTTE2S0GiywzmPG2qGlg0Yr4FPeWLt4AkY=;
        b=ns5YyeKIr93Q15JJwNdawnbawErd1ChW5rVJ+Oz3mh+N/0yp32ht+5wno73nyr7sx4
         LB9n96VijYqM1FZIxasApY3kXAYjc6Ngq/Pc+MmKKf4z/s2WEb1GQlxsC38QviFGHzb2
         PNU6RVF05kZoOaVUhf79SPYdXiAug+WN1WcvuIPUX9Rlb6WVJd0JWB/J8Bjves+PqhLO
         2gP1Y12n1yNQ8Vc8KQ1qH1loyuhils59+3USsWz7iH7TpLZRqI2WbrMYfkBndRDudeBP
         j9yt2O8B4eR5Ohq1rM+4NFW7FjCz6wVb3R8QrbNDVCWi46ByB/nWYrD0gQlasoIPiko4
         wbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7x9S522tJTTE2S0GiywzmPG2qGlg0Yr4FPeWLt4AkY=;
        b=qRr9A2P9/G8zOrbi8bdPCuXYoTTrdSJfygjoVp4NfeJ314Jz1qk89b2IWUnpCiBIxI
         TVTimgPlTR6mBOZb8Zu8eI+RQEvNA4ExsrxFR0NsomI7HHMDBIPLBqqIHOBmelaoJNqt
         wecXIdsRkQoYpZuZ1LFUG2VA00Ls4gn/l02tkDYJ9Wy2UoeGdHlU4FTBGsJheTFYqB5B
         Mi6yvxzIgB/23olj6mMPW8lYn/fsWDkDH/ez/DQ1rwIkEriKBE+SeW0CP+VdGfS7Aw56
         9kiKy5CEplvWQXW/gmtu5VzRaQBzI9S+lGVKdOFKaQPotuurJJL/CqNVDfx9TYGXm9bl
         hxOA==
X-Gm-Message-State: AOAM530lSPVlA115VxNVdZ/IiuBjjmllQKKpVQcnQPKtSNVZB3wSwwrU
        GWuDD5TSruD8oXWF9m0I8Zdw+6BfukZxUeVOGhqexDASMz0tjQ==
X-Google-Smtp-Source: ABdhPJyg9B+avwF9G8Q3KjXJCUHywXeurajDz4gyzwdcPCO2Re7Yrb31yJm/K21+5MUqTmjKXd5xv53gpCKjWbxWXL8=
X-Received: by 2002:a05:6e02:f93:: with SMTP id v19mr2887818ilo.154.1608283215888;
 Fri, 18 Dec 2020 01:20:15 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com> <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
 <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
 <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com>
 <CAOKbgA7ojpGPMEc0vSGhhbyP3nE84pXUf=1E0OY4AQYsm+qgwA@mail.gmail.com> <CAM1kxwhfFvoV_SNyJkH3wPnhKpJGQ1DZ98rRobbrtTrszufsCA@mail.gmail.com>
In-Reply-To: <CAM1kxwhfFvoV_SNyJkH3wPnhKpJGQ1DZ98rRobbrtTrszufsCA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 18 Dec 2020 16:20:04 +0700
Message-ID: <CAOKbgA5g5=eC11JTUtZbZUbFj6rLmS+aVH_C4anB13pBZG+BMA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Victor Stewart <v@nametag.social>
Cc:     Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 8:43 PM Victor Stewart <v@nametag.social> wrote:
>
> On Thu, Dec 17, 2020 at 11:12 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > On Thu, Dec 17, 2020 at 5:38 PM Josef <josef.grieb@gmail.com> wrote:
> > >
> > > > > That is curious. This ticket mentions Shmem though, and in our case it does
> > >  > not look suspicious at all. E.g. on a box that has the problem at the moment:
> > >  > Shmem:  41856 kB. The box has 256GB of RAM.
> > >  >
> > >  > But I'd (given my lack of knowledge) expect the issues to be related anyway.
> > >
> > > what about mapped? mapped is pretty high 1GB on my machine, I'm still
> > > reproduce that in C...however the user process is killed but not the
> > > io_wq_worker kernel processes, that's also the reason why the server
> > > socket still listening(even if the user process is killed), the bug
> > > only occurs(in netty) with a high number of operations and using
> > > eventfd_write to unblock io_uring_enter(IORING_ENTER_GETEVENTS)
> > >
> > > (tested on kernel 5.9 and 5.10)
> >
> > Stats from another box with this problem (still 256G of RAM):
> >
> > Mlocked:           17096 kB
> > Mapped:           171480 kB
> > Shmem:             41880 kB
> >
> > Does not look suspicious at a glance. Number of io_wq* processes is 23-31.
> >
> > Uptime is 27 days, 24 rings per process, process was restarted 4 times, 3 out of
> > these four the old instance was killed with SIGKILL. On the last process start
> > 18 rings failed to initialize, but after that 6 more were initialized
> > successfully. It was before the old instance was killed. Maybe it's related to
> > the load and number of io-wq processes, e.g. some of them exited and a few more
> > rings were initialized successfully.
>
> have you tried using IORING_SETUP_ATTACH_WQ?
>
> https://lkml.org/lkml/2020/1/27/763

No, I have not, but while using that might help to slow down progression of the
issue, it won't fix it - at least if I understand correctly. The problem is not
that those rings can't be created at all - there is no problem with that on a
freshly booted box, but rather that after some (potentially abrupt) owning
process terminations under load kernel gets into a state where - eventually - no
new rings can be created at all. Not a single one. In the above example the
issue just haven't progressed far enough yet.

In other words, there seems to be a leak / accounting problem in the io_uring
code that is triggered by abrupt process termination under load (just no
io_uring_queue_exit?) - this is not a usage problem.

-- 
Dmitry Kadashev
