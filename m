Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0302E1C01
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 12:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgLWLtl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 06:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgLWLtk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 06:49:40 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9637C0613D3
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 03:48:59 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id u12so14821350ilv.3
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 03:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rPDJsyGhJXPPaQyuXtDmb2G0TbioXFnxf8mR9Wt5dSE=;
        b=riTwYK/O6CGq+lGwNB11XMM6k3Jp7n5Z5PEeJ0yd6SPcsFYmeMXadeF/6HvXwtyuLP
         nqPHqE7nodIxG+WEcCCZwLBXV2UEdPyvZakot8rmXjKgWPKaSJbRdmYRJqHV2g9tAgsy
         akLDJWse202zucBWsalflQ317ubGJJS28eDycO4gbgCP/ToD/yLUygK1+kFIh1PgQv6b
         od396eFBK7zbmrgZqnAL8vedRR76afTk1DV7H1NB31i8BrF7bLjzwDd+kWKNpY0eK/F+
         yBHc5uWobD8YtESz824DmQ926ueJ/lcimWmsmWugRFJpdeYiTc61AL7hNKnBREFDnLEt
         GxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPDJsyGhJXPPaQyuXtDmb2G0TbioXFnxf8mR9Wt5dSE=;
        b=HdE2ad1O8SADn15kLyfzV9brvRclcakJz0M/pvX9mujOSmB3qgA0painWrOxnapvtt
         8xEi3lffGzxN3WnIMo9Tf3pPXUXuGAjgp4N6uT/XcF0DJLqkxvjLjdZp6gNcI3nXxEOJ
         vyYpJP9lPIwmkpoDyF6/h5UpKR1kLxg/ItlxxFUcuaqXFuIVrgVwe6orhRQ7HzEiJaBf
         ra0mXDuPWnoFroyCruTQXqG25B6zydvzCq0DmY8DdhVHNdq1K5WJyUWpCyWFoNuEzGF+
         5nFB8piRK27W3dP7OcNnqtRr0SbSeOJu8KcXWfBCOeoW63D110fsQ6hVU8XGTTgRGSrU
         STgw==
X-Gm-Message-State: AOAM531kNkUivfr7Ij1INQO21x6lP7hstdgY9P80kyEMTxUlMejoI794
        QSGMJWuFID/Arbyy1Fxtl60jXtQ5gVYRusjHCTA=
X-Google-Smtp-Source: ABdhPJzGuPRlLoNi8WrsoHwNdcuMx6Amvz3xFUSFkM7JKthyCQnpF+M/7yEyTHfMG3619KUG2t8OsbwdtFSlgz4lcLs=
X-Received: by 2002:a92:2912:: with SMTP id l18mr24902516ilg.173.1608724138487;
 Wed, 23 Dec 2020 03:48:58 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com> <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
 <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com> <CAOKbgA5=Z+6Z-GqrYFBV5T_uqkVU0oSqKhf6C37MkruBCKTcow@mail.gmail.com>
 <CAOKbgA70CtfmM7-yFRcGTzJdgoF41MQt7mLC7L_s8jcnrtkB=Q@mail.gmail.com>
In-Reply-To: <CAOKbgA70CtfmM7-yFRcGTzJdgoF41MQt7mLC7L_s8jcnrtkB=Q@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Dec 2020 18:48:46 +0700
Message-ID: <CAOKbgA4eihm=MyiVZSG03cxjks6=yw5eTr-dCBXmhQWmkK4YEg@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23, 2020 at 4:38 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Wed, Dec 23, 2020 at 3:39 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > On Tue, Dec 22, 2020 at 11:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > >
> > > On 22/12/2020 11:04, Dmitry Kadashev wrote:
> > > > On Tue, Dec 22, 2020 at 11:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > [...]
> > > >>> What about smaller rings? Can you check io_uring of what SQ size it can allocate?
> > > >>> That can be a different program, e.g. modify a bit liburing/test/nop.
> > > > Unfortunately I've rebooted the box I've used for tests yesterday, so I can't
> > > > try this there. Also I was not able to come up with an isolated reproducer for
> > > > this yet.
> > > >
> > > > The good news is I've found a relatively easy way to provoke this on a test VM
> > > > using our software. Our app runs with "admin" user perms (plus some
> > > > capabilities), it bumps RLIMIT_MEMLOCK to infinity on start. I've also created
> > > > an user called 'ioutest' to run the check for ring sizes using a different user.
> > > >
> > > > I've modified the test program slightly, to show the number of rings
> > > > successfully
> > > > created on each iteration and the actual error message (to debug a problem I was
> > > > having with it, but I've kept this after that). Here is the output:
> > > >
> > > > # sudo -u admin bash -c 'ulimit -a' | grep locked
> > > > max locked memory       (kbytes, -l) 1024
> > > >
> > > > # sudo -u ioutest bash -c 'ulimit -a' | grep locked
> > > > max locked memory       (kbytes, -l) 1024
> > > >
> > > > # sudo -u admin ./iou-test1
> > > > Failed after 0 rings with 1024 size: Cannot allocate memory
> > > > Failed after 0 rings with 512 size: Cannot allocate memory
> > > > Failed after 0 rings with 256 size: Cannot allocate memory
> > > > Failed after 0 rings with 128 size: Cannot allocate memory
> > > > Failed after 0 rings with 64 size: Cannot allocate memory
> > > > Failed after 0 rings with 32 size: Cannot allocate memory
> > > > Failed after 0 rings with 16 size: Cannot allocate memory
> > > > Failed after 0 rings with 8 size: Cannot allocate memory
> > > > Failed after 0 rings with 4 size: Cannot allocate memory
> > > > Failed after 0 rings with 2 size: Cannot allocate memory
> > > > can't allocate 1
> > > >
> > > > # sudo -u ioutest ./iou-test1
> > > > max size 1024
> > >
> > > Then we screw that specific user. Interestingly, if it has CAP_IPC_LOCK
> > > capability we don't even account locked memory.
> >
> > We do have some capabilities, but not CAP_IPC_LOCK. Ours are:
> >
> > CAP_NET_ADMIN, CAP_NET_BIND_SERVICE, CAP_SYS_RESOURCE, CAP_KILL,
> > CAP_DAC_READ_SEARCH.
> >
> > The latter was necessary for integration with some third-party thing that we do
> > not really use anymore, so we can try building without it, but it'd require some
> > time, mostly because I'm not sure how quickly I'd be able to provoke the issue.
> >
> > > btw, do you use registered buffers?
> >
> > No, we do not use neither registered buffers nor registered files (nor anything
> > else).
> >
> > Also, I just tried the test program on a real box (this time one instance of our
> > program is still running - can repeat the check with it dead, but I expect the
> > results to be pretty much the same, at least after a few more restarts). This
> > box runs 5.9.5.
> >
> > # sudo -u admin bash -c 'ulimit -l'
> > 1024
> >
> > # sudo -u admin ./iou-test1
> > Failed after 0 rings with 1024 size: Cannot allocate memory
> > Failed after 0 rings with 512 size: Cannot allocate memory
> > Failed after 0 rings with 256 size: Cannot allocate memory
> > Failed after 0 rings with 128 size: Cannot allocate memory
> > Failed after 0 rings with 64 size: Cannot allocate memory
> > Failed after 0 rings with 32 size: Cannot allocate memory
> > Failed after 0 rings with 16 size: Cannot allocate memory
> > Failed after 0 rings with 8 size: Cannot allocate memory
> > Failed after 0 rings with 4 size: Cannot allocate memory
> > Failed after 0 rings with 2 size: Cannot allocate memory
> > can't allocate 1
> >
> > # sudo -u dmitry bash -c 'ulimit -l'
> > 1024
> >
> > # sudo -u dmitry ./iou-test1
> > max size 1024
>
> Please ignore the results from the real box above (5.9.5). The memlock limit
> interfered with this, since our app was running in the background and it had a
> few rings running (most failed to be created, but not all). I'll try to make it
> fully stuck and repeat the test with the app dead.

I've experimented with the 5.9 live boxes that were showing signs of the problem
a bit more, and I'm not entirely sure they get stuck until reboot anymore.

I'm pretty sure it is the case with 5.6, but probably a bug was fixed since
then - the fact that 5.8 in particular had quite a few fixes that seemed
relevant is the reason we've tried 5.9 in the first place.

And on 5.9 we might be seeing fragmentation issues indeed. I shouldn't have been
mixing my kernel versions :) Also, I did not realize a ring of size=1024
requires 16 contiguous pages. We will experiment and observe a bit more, and
meanwhile let's consider the case closed. If the issue surfaces again I'll
update this thread.

Thanks a *lot* Pavel for helping to debug this issue.

And sorry for the false alarm / noise everyone.

-- 
Dmitry Kadashev
