Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A32DF673
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 19:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgLTSX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 13:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgLTSXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 13:23:55 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB50C061285
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 10:23:15 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id p14so7049766qke.6
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 10:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g+uM/0ILziYZQFaNnKo/HP6n8BOlUwrOzNhu1B0tbR4=;
        b=R7IX+4PyUGBb7uCkf/SN1bVdNGoi7aSf7N9T+QALIZWRQSZjlPWW+gZqhlEPGOVv7t
         ilz7If055CWye10Rt/npAfTTiG+ue536V0l5yFvu6HDV9imn0gItEQHEojDlNhF1fRZC
         JEp4pFB0sfsGbqhTSliSCmibuEe/jPpEjqsFk3qBA4+mHRCrFDb3iWDNruT3f6smdihN
         NjXF/b/JJfj7etbRNb2M0+rl2IdezhTGmdQ6/2i3ChVoclbO0KBYH7pulvyd/ap/j1+6
         5oRm4SCaQhFi6kEEuWhXzlbVhd/B0gdLaaWOTysM0bYJIqEnpMkAp3ACtvfZ1MaBw+l2
         q2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+uM/0ILziYZQFaNnKo/HP6n8BOlUwrOzNhu1B0tbR4=;
        b=omLIU7jzZ3+xtyqDvoh9vnmyM3PQrInbTF6fUGVgnrlX19pFuGEeZpG0sOmlgznF+d
         Mn5xRJB7GVMqEYjlgmVPXsdKkl8yEjo+EOywt9WreafegsCCKdMsA+FaKM9vIad6mj8J
         nQAShZoTQr8CeeFMppNQoPjNm902MEvBHOMyrz3MJdlTyud5vAX4jIO/HsguBLLtHptK
         lgY8m2aAGAD6uDM7DsFR1zhbmxEWqJsSy3Xth9n+igDHzG3WgYqXc/I4FN/FUR6D+Kzf
         z8etsJYaN69v6xHUtlrsg1X3ycTOBUBei4XkibxfAVJdHTIlZud1U0mlQchj0QFa7bt7
         uMBA==
X-Gm-Message-State: AOAM531NrPv7IiLmnppMrj5PAD/QiwguWyCmlB2ZdT9OoUQ7PFa2mx6Q
        IPRvx360z4XKhrmUGV0iy+Hzy3EEuvjDgccnh50=
X-Google-Smtp-Source: ABdhPJw6/GnGhiYsSR+VSU9nhzUulfWC0d/v8Gcc5BeDjack9hJoDfSYaDP8Ju52/LVkz7VuOooUGOOK6N6NYODaha0=
X-Received: by 2002:ae9:eb8b:: with SMTP id b133mr14249390qkg.399.1608488594869;
 Sun, 20 Dec 2020 10:23:14 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com> <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com> <ff816e37-ce0e-79c7-f9bf-9fa94d62484d@kernel.dk>
 <CAAss7+o7_FZtBFs5c2UOS6KSXuDBkDwi=okffh4JRmYieTF3LA@mail.gmail.com>
In-Reply-To: <CAAss7+o7_FZtBFs5c2UOS6KSXuDBkDwi=okffh4JRmYieTF3LA@mail.gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 20 Dec 2020 19:23:03 +0100
Message-ID: <CAAss7+raikmW4jGMYk8vLTqm4Y4X-im6zzWiVZY3ikQ7DifKQA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> It's io_uring-5.11 but I had some patches on top.
> I regenerated it below for up to date Jens' io_uring-5.11

Pavel I just tested your patch, it works :)

On Sun, 20 Dec 2020 at 17:59, Josef <josef.grieb@gmail.com> wrote:
>
> > Just a guess - Josef, is the eventfd for the ring fd itself?
>
> yes via eventfd_write we want to wake up/unblock
> io_uring_enter(IORING_ENTER_GETEVENTS), and the read eventfd event is
> submitted every time
> each ring fd in netty has one eventfd
>
> On Sun, 20 Dec 2020 at 17:14, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 12/20/20 6:00 AM, Pavel Begunkov wrote:
> > > On 20/12/2020 07:13, Josef wrote:
> > >>> Guys, do you share rings between processes? Explicitly like sending
> > >>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
> > >>> (threads), or cloning with copying fd tables (and so taking a ref
> > >>> to a ring).
> > >>
> > >> no in netty we don't share ring between processes
> > >>
> > >>> In other words, if you kill all your io_uring applications, does it
> > >>> go back to normal?
> > >>
> > >> no at all, the io-wq worker thread is still running, I literally have
> > >> to restart the vm to go back to normal(as far as I know is not
> > >> possible to kill kernel threads right?)
> > >>
> > >>> Josef, can you test the patch below instead? Following Jens' idea it
> > >>> cancels more aggressively when a task is killed or exits. It's based
> > >>> on [1] but would probably apply fine to for-next.
> > >>
> > >> it works, I run several tests with eventfd read op async flag enabled,
> > >> thanks a lot :) you are awesome guys :)
> > >
> > > Thanks for testing and confirming! Either we forgot something in
> > > io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
> > > or we have a dependency that prevents release from happening.
> >
> > Just a guess - Josef, is the eventfd for the ring fd itself?
> >
> > BTW, the io_wq_cancel_all() in io_ring_ctx_wait_and_kill() needs to go.
> > We should just use targeted cancelation - that's cleaner, and the
> > cancel all will impact ATTACH_WQ as well. Separate thing to fix, though.
> >
> > --
> > Jens Axboe
> >
>
>
> --
> Josef



-- 
Josef
