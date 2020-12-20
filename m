Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9222DF63E
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgLTRA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 12:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgLTRA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 12:00:56 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDDCC0619D5
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 08:59:30 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id u21so5098798qtw.11
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 08:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GllSV0LAu+7mxAkD2NYV43qofgageyUd2g2vcrO5FlU=;
        b=an7yxPCcmnBwC6U2TOgg7epAEWiYJ9PtYlWvWeEtXErVsIeb50EpiTux8JdfxW6EEu
         myi0ljByKkobE4ip4M4KlZejxydug4c80g+ZoOA87PXGreZW2vXYHIUiyTO3diuIkpbG
         1DLO08RrzKA88BXBts7bmFs/UyQ4ublE+czxxBj9lUfM0B79N7xim9WKCgNHBL77ZWDS
         rdhrSWoWykMWY802LpLvJh54xKqHNAs68/fgkAX7kVmqDMNe74TRDqxElLUsJrYyF4TM
         U3wspXNgbwRsr2gZQgTikKdidmdczEFGSwnBer5ZJJKenfaMR0tTT7kNBo8hx0RiYWZn
         eJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GllSV0LAu+7mxAkD2NYV43qofgageyUd2g2vcrO5FlU=;
        b=QTaa/4jzN5vZOAeb1Jih1+FrmGajawyUQgNnL4pyMFCZ1lfaEPw9t1O3Z5AX/PgfO6
         n7PNeQnitn3hfZMcZ+ymfRsZMbUVSbFaDZu4Xf1Ys5Qwx8FgX1fu8SZQNZCSA89ZkaOh
         +99Ds5HjtCiOi8TNIf+84otAyse9Ux0hq/0HiCe/Ntn1MHGZLWvl5edtuKAMezjcSxph
         QTKvbRyz3RWXZeGXiQCh7Dp+HkCwWlYtWLffi7fk2FoYUk35VEfj5K1hyF1Li+5AF9Cc
         yOH2SVo9SoP0s5xW94IWdWppviPdLgB022K/Ti+Wvpd901T1hug7fTicJR46VJqPJdqo
         bfjw==
X-Gm-Message-State: AOAM5336Uq7XT4o82zpCBks5kUAY0kg+OqD82BJiGpGohdbWVZTQA1KB
        yZMYTFfii2q6Ah6HUUjepJF7GFKHvyPh+z3yi/CQUs4cUQ/BLMgQCmM=
X-Google-Smtp-Source: ABdhPJwdy0NOCP+64Y6KhpHm7XT7IrvadXjZS5s3mN+15pWtjAVv7OCsY9cEJRIdEqBpKDxU7BGSdye2PFcpKeGdb7M=
X-Received: by 2002:ac8:4615:: with SMTP id p21mr12542119qtn.45.1608483569852;
 Sun, 20 Dec 2020 08:59:29 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com> <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com> <ff816e37-ce0e-79c7-f9bf-9fa94d62484d@kernel.dk>
In-Reply-To: <ff816e37-ce0e-79c7-f9bf-9fa94d62484d@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 20 Dec 2020 17:59:18 +0100
Message-ID: <CAAss7+o7_FZtBFs5c2UOS6KSXuDBkDwi=okffh4JRmYieTF3LA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Just a guess - Josef, is the eventfd for the ring fd itself?

yes via eventfd_write we want to wake up/unblock
io_uring_enter(IORING_ENTER_GETEVENTS), and the read eventfd event is
submitted every time
each ring fd in netty has one eventfd

On Sun, 20 Dec 2020 at 17:14, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/20/20 6:00 AM, Pavel Begunkov wrote:
> > On 20/12/2020 07:13, Josef wrote:
> >>> Guys, do you share rings between processes? Explicitly like sending
> >>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
> >>> (threads), or cloning with copying fd tables (and so taking a ref
> >>> to a ring).
> >>
> >> no in netty we don't share ring between processes
> >>
> >>> In other words, if you kill all your io_uring applications, does it
> >>> go back to normal?
> >>
> >> no at all, the io-wq worker thread is still running, I literally have
> >> to restart the vm to go back to normal(as far as I know is not
> >> possible to kill kernel threads right?)
> >>
> >>> Josef, can you test the patch below instead? Following Jens' idea it
> >>> cancels more aggressively when a task is killed or exits. It's based
> >>> on [1] but would probably apply fine to for-next.
> >>
> >> it works, I run several tests with eventfd read op async flag enabled,
> >> thanks a lot :) you are awesome guys :)
> >
> > Thanks for testing and confirming! Either we forgot something in
> > io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
> > or we have a dependency that prevents release from happening.
>
> Just a guess - Josef, is the eventfd for the ring fd itself?
>
> BTW, the io_wq_cancel_all() in io_ring_ctx_wait_and_kill() needs to go.
> We should just use targeted cancelation - that's cleaner, and the
> cancel all will impact ATTACH_WQ as well. Separate thing to fix, though.
>
> --
> Jens Axboe
>


-- 
Josef
