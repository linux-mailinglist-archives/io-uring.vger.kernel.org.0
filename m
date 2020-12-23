Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60C72E1A19
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 09:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgLWIk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 03:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbgLWIk1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 03:40:27 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFF3C0613D3
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 00:39:47 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q137so14406276iod.9
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 00:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6mcDcRfB2nadWbs1w6tWAZrpnQrFec1P/BxszJMgWM=;
        b=pxTJCpmrNR2cD6WCvkFcBzMY2NmE+JC7ThynDagfcVO2WMssF3gzikuyhm8uWvelP8
         XFj7yyVhLUrCnME5T0bHJBDVdrWdDb1i91Nd/mUxXM0o/jInnUGvo2aPn5bgAwTJL1vT
         /Waj287n26oS0ECvkoatkZsaFTgkwulpHAVgVqNVta1Hh3Vu4Qc/NX/5CaKO3GM/KyYC
         9r7ohNqKeNaK/P49tsPfjjo7BTJq0YNGYXOIvY2LHqyLfJNTkwQ9UeZKlNBvxOSkDUyf
         chTYLZqOoe2AJYtaP2x+sObDYtWPzULWaZNGL2EAW6Zce4AZHq5Iw/PFq/znS0b03yAU
         yARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6mcDcRfB2nadWbs1w6tWAZrpnQrFec1P/BxszJMgWM=;
        b=hg2H9fqZDN4Ei4k+JiBLpqxJSeS2u44HROL63RHVlxlZ5ahVOVH1up7aobD0sfFVan
         tdN2XM5YJ/5VBGRmcifPfKMkQyqjVfsIsrdl9diu7OruhflwTNYBvWDDAF0Rg3lEBPwa
         75d6BrFrAinsILJfb1kue1rht8YXVTr4p7zU9jRdsyBXrhEr4esu9DIfJg0ST4Fi75K5
         xZGHrxy9jiPlBzkjAXd5mrig/UcsrYreJ/uIff7u1I2yatccllV7I0wufV9w79XWyJa4
         auaoVlqQ7cpoY7atcsw9k1YlBbNafqpYzhnMfnV67rXmUF5VeRFsNVRdR+VHfdcc7yhe
         E7tw==
X-Gm-Message-State: AOAM5321s7mQK9fWseqQGKnojdqcqseKd/psnrr+NVG3u2hl69RMdo6M
        Rpzg4Bk4XVfQGBMKvBNf5XImfBKadfDlar20s8k=
X-Google-Smtp-Source: ABdhPJytlFQufQym1pFxUCXNloWmJXbM30rJc2eVj+oe6/ij/d4TSLQwLBO8TZVds+N67Zs/Te2vN6dqlzysXCzojEI=
X-Received: by 2002:a6b:8ec9:: with SMTP id q192mr21596365iod.28.1608712786716;
 Wed, 23 Dec 2020 00:39:46 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com> <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com> <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com>
In-Reply-To: <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Dec 2020 15:39:35 +0700
Message-ID: <CAOKbgA5=Z+6Z-GqrYFBV5T_uqkVU0oSqKhf6C37MkruBCKTcow@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 22, 2020 at 11:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 22/12/2020 11:04, Dmitry Kadashev wrote:
> > On Tue, Dec 22, 2020 at 11:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> [...]
> >>> What about smaller rings? Can you check io_uring of what SQ size it can allocate?
> >>> That can be a different program, e.g. modify a bit liburing/test/nop.
> > Unfortunately I've rebooted the box I've used for tests yesterday, so I can't
> > try this there. Also I was not able to come up with an isolated reproducer for
> > this yet.
> >
> > The good news is I've found a relatively easy way to provoke this on a test VM
> > using our software. Our app runs with "admin" user perms (plus some
> > capabilities), it bumps RLIMIT_MEMLOCK to infinity on start. I've also created
> > an user called 'ioutest' to run the check for ring sizes using a different user.
> >
> > I've modified the test program slightly, to show the number of rings
> > successfully
> > created on each iteration and the actual error message (to debug a problem I was
> > having with it, but I've kept this after that). Here is the output:
> >
> > # sudo -u admin bash -c 'ulimit -a' | grep locked
> > max locked memory       (kbytes, -l) 1024
> >
> > # sudo -u ioutest bash -c 'ulimit -a' | grep locked
> > max locked memory       (kbytes, -l) 1024
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
> > # sudo -u ioutest ./iou-test1
> > max size 1024
>
> Then we screw that specific user. Interestingly, if it has CAP_IPC_LOCK
> capability we don't even account locked memory.

We do have some capabilities, but not CAP_IPC_LOCK. Ours are:

CAP_NET_ADMIN, CAP_NET_BIND_SERVICE, CAP_SYS_RESOURCE, CAP_KILL,
CAP_DAC_READ_SEARCH.

The latter was necessary for integration with some third-party thing that we do
not really use anymore, so we can try building without it, but it'd require some
time, mostly because I'm not sure how quickly I'd be able to provoke the issue.

> btw, do you use registered buffers?

No, we do not use neither registered buffers nor registered files (nor anything
else).

Also, I just tried the test program on a real box (this time one instance of our
program is still running - can repeat the check with it dead, but I expect the
results to be pretty much the same, at least after a few more restarts). This
box runs 5.9.5.

# sudo -u admin bash -c 'ulimit -l'
1024

# sudo -u admin ./iou-test1
Failed after 0 rings with 1024 size: Cannot allocate memory
Failed after 0 rings with 512 size: Cannot allocate memory
Failed after 0 rings with 256 size: Cannot allocate memory
Failed after 0 rings with 128 size: Cannot allocate memory
Failed after 0 rings with 64 size: Cannot allocate memory
Failed after 0 rings with 32 size: Cannot allocate memory
Failed after 0 rings with 16 size: Cannot allocate memory
Failed after 0 rings with 8 size: Cannot allocate memory
Failed after 0 rings with 4 size: Cannot allocate memory
Failed after 0 rings with 2 size: Cannot allocate memory
can't allocate 1

# sudo -u dmitry bash -c 'ulimit -l'
1024

# sudo -u dmitry ./iou-test1
max size 1024

-- 
Dmitry Kadashev
