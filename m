Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733E82DD258
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 14:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLQNny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 08:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQNnx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 08:43:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3CAC0617A7
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 05:43:13 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r5so28643350eda.12
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 05:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+pPCEYcHnghzEra7bfIhw6hraOvUhlY/tPtV+CjtGaY=;
        b=uXWLuHjCSIx2gkSXgHnTkGTciPHMT/N4cRgWyy1VAvv2/JTk6GrSYrpyOtK97QJ1xC
         gFdqYGM3HO8mdSAHKk7ePSVHTW3t9UIEBX0UCKKMR471sFWNf18V7xsL8WZTX6Zqvmos
         3h8FbWO7eW5xyLSUlyrZnOZCuBWuZF2/dgD6RX6sB611p6JhD5lNqeyUZcdFz5166zrz
         3HH3IWIWgb6R0IwYwY+CarEkkS/Q+7hiiyfjZ3nSBxOKCl7D3lAoLpaqmRi9SFHzAMh8
         6hPNLxgdSO7Jcz+qI+bns5Mf+T9AhoQ5e0eD34cswdVQJZ7zm+qImQgCNUYldlIuwTjz
         5Yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+pPCEYcHnghzEra7bfIhw6hraOvUhlY/tPtV+CjtGaY=;
        b=quES55uMyb7Ig28bzz5AeGP9ROAF6obYs/yuZIDwBVyTG3nvlwSQl8+NMv6kgOkVCb
         RQZB01XOFIRd4lQ8HwuNeQrv7XTf+BTAX0iQD864NRgMzeNM091oYJ2pGExjvYXOH5AS
         vhlPJ3KaoXIQGaIfNOAisaHPlAc/F9Tb5yRA5q7zH/b60d48OHrUMMEfN9STAyAnMZX7
         6keqml9IrUC3sOVjBp3IcGNClLHVgQj1e8Me7F2XwqSna42ZVEDOQGwTnfSM4rof4EAe
         IzG0boGeNcJc/7HlKskQVmtErrQhssK3HthQSpHgrdL53pMHWUO66C0/GgQisSt+d32O
         JaZw==
X-Gm-Message-State: AOAM532SiVq/EQ8IrasuF2eJa6WyPNf926Tr9byr5sF71AJtsXDOdwgm
        r08e3AFv2leZbJ7Razq4CX3DGPfWZldOo1a6Tm5soA==
X-Google-Smtp-Source: ABdhPJwWkmvA3uPvF9Aul2JBscjPJoGpDlXrj+RtP7rN9wFJOCI2wRTljP3d7E2IXHezf0pmh2e2pJH0KcyDaokZHPk=
X-Received: by 2002:a05:6402:171a:: with SMTP id y26mr39520853edu.371.1608212591816;
 Thu, 17 Dec 2020 05:43:11 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com> <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
 <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
 <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com> <CAOKbgA7ojpGPMEc0vSGhhbyP3nE84pXUf=1E0OY4AQYsm+qgwA@mail.gmail.com>
In-Reply-To: <CAOKbgA7ojpGPMEc0vSGhhbyP3nE84pXUf=1E0OY4AQYsm+qgwA@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Thu, 17 Dec 2020 13:43:01 +0000
Message-ID: <CAM1kxwhfFvoV_SNyJkH3wPnhKpJGQ1DZ98rRobbrtTrszufsCA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 11:12 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 5:38 PM Josef <josef.grieb@gmail.com> wrote:
> >
> > > > That is curious. This ticket mentions Shmem though, and in our case it does
> >  > not look suspicious at all. E.g. on a box that has the problem at the moment:
> >  > Shmem:  41856 kB. The box has 256GB of RAM.
> >  >
> >  > But I'd (given my lack of knowledge) expect the issues to be related anyway.
> >
> > what about mapped? mapped is pretty high 1GB on my machine, I'm still
> > reproduce that in C...however the user process is killed but not the
> > io_wq_worker kernel processes, that's also the reason why the server
> > socket still listening(even if the user process is killed), the bug
> > only occurs(in netty) with a high number of operations and using
> > eventfd_write to unblock io_uring_enter(IORING_ENTER_GETEVENTS)
> >
> > (tested on kernel 5.9 and 5.10)
>
> Stats from another box with this problem (still 256G of RAM):
>
> Mlocked:           17096 kB
> Mapped:           171480 kB
> Shmem:             41880 kB
>
> Does not look suspicious at a glance. Number of io_wq* processes is 23-31.
>
> Uptime is 27 days, 24 rings per process, process was restarted 4 times, 3 out of
> these four the old instance was killed with SIGKILL. On the last process start
> 18 rings failed to initialize, but after that 6 more were initialized
> successfully. It was before the old instance was killed. Maybe it's related to
> the load and number of io-wq processes, e.g. some of them exited and a few more
> rings were initialized successfully.

have you tried using IORING_SETUP_ATTACH_WQ?

https://lkml.org/lkml/2020/1/27/763

>
> --
> Dmitry Kadashev
