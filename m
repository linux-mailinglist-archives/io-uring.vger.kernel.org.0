Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2685044E1DC
	for <lists+io-uring@lfdr.de>; Fri, 12 Nov 2021 07:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhKLG2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Nov 2021 01:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhKLG2f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Nov 2021 01:28:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C28DC061766
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 22:25:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b15so33364530edd.7
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 22:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHQ5Sp8/x6iR3kK/0kX7N5mvTJWzXJz60g8dpnwBPn4=;
        b=F2/5y0qqSTefPLvjysXboGyFs4mXK3P6c2ULxhmtv48JruK2XADDjvQmbn39tGNXn9
         tRDkVFE1Lbulmyf9GId0JUtsZvrp9x+Y3EBG8dDnIPdxwnzxVAl8lgpxB9ALhvrVZM75
         I3l6zupTm/c+vvhKSizmxmvk4dbqNL4RBS/nQxLoXX1fEJrTVlfvDiaTa3whD17MDy0o
         wRPVHrYtS6e/xCDeP5WCmqXwDi4zGxeH5JC+LC7Iv7QQBWhbSBimeqIKBg83ctsVMIoO
         UwmJ2PHOzyvCdMnNRP8sj5j1mtg7uGgPRUOYUqDwxs8G7T6XM9qvRpFPwl54xYf0mxqz
         xeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHQ5Sp8/x6iR3kK/0kX7N5mvTJWzXJz60g8dpnwBPn4=;
        b=Z51YN5wALdHCxMzetaoGVM+90b/OvEEzgxTcH/KWRnhmKJ2X5wdDyoGaAn3QCFFRHV
         wJcoxbIRHVV1EHucoAuDPrZNmI2moZidxQHeQ1UldU7JWBQo9t73bdxOq0Z044pmi4pm
         5zcyBbpErei2MePQJJEifRinKy7yy1JUR7bWLHpc8fsoFvzGSPm1AvIiJ4L9uc3mlhSs
         zetoSfiY8OidvUnSKD9xQ0x6FjkBFkMWiPtFrrhP0jCDZqqPGtTrVn8pEPVyoAbeiLoc
         hTvFQLaR01NK4whE5V4w1OCUww0x48NwH2kqN6n+Tj37wTesTFvFtTJmUzXnRfX7cPmb
         syYg==
X-Gm-Message-State: AOAM5328Wzdef03rPK0s3G29g2VTfq+7Db1V8DdrpUeZiIK72LiaYq1g
        NHC3kx+kR3Nt3nCI7S2OanR9EH9QT9BILcrphZJ9Jg==
X-Google-Smtp-Source: ABdhPJz3PWtkbbF4v99LHYtuvaJSAAdEQOF/1KHBg2ULyDsbEwjHYLtstU3rsYrnhSdWhRYjFBL7XnaYeYFIkzGFLuo=
X-Received: by 2002:a05:6402:40ce:: with SMTP id z14mr17796621edb.294.1636698343184;
 Thu, 11 Nov 2021 22:25:43 -0800 (PST)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com> <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk> <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk> <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk> <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk> <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
In-Reply-To: <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
From:   Daniel Black <daniel@mariadb.org>
Date:   Fri, 12 Nov 2021 17:25:31 +1100
Message-ID: <CABVffEOEayBow2Oot7_jNHbXL0CQq9SZCWmiWEJjbT6gVC7WKg@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/11/21 10:28 AM, Jens Axboe wrote:
> > On 11/11/21 9:55 AM, Jens Axboe wrote:
> >> On 11/11/21 9:19 AM, Jens Axboe wrote:
> >>> On 11/11/21 8:29 AM, Jens Axboe wrote:
> >>>> On 11/11/21 7:58 AM, Jens Axboe wrote:
> >>>>> On 11/11/21 7:30 AM, Jens Axboe wrote:
> >>>>>> On 11/10/21 11:52 PM, Daniel Black wrote:
> >>>>>>>> Would it be possible to turn this into a full reproducer script?
> >>>>>>>> Something that someone that knows nothing about mysqld/mariadb can just
> >>>>>>>> run and have it reproduce. If I install the 10.6 packages from above,
> >>>>>>>> then it doesn't seem to use io_uring or be linked against liburing.
> >>>>>>>
> >>>>>>> Sorry Jens.
> >>>>>>>
> >>>>>>> Hope containers are ok.
> >>>>>>
> >>>>>> Don't think I have a way to run that, don't even know what podman is
> >>>>>> and nor does my distro. I'll google a bit and see if I can get this
> >>>>>> running.
> >>>>>>
> >>>>>> I'm fine building from source and running from there, as long as I
> >>>>>> know what to do. Would that make it any easier? It definitely would
> >>>>>> for me :-)
> >>>>>
> >>>>> The podman approach seemed to work,

Thanks for bearing with it.

> >>>>> and I was able to run all three
> >>>>> steps. Didn't see any hangs. I'm going to try again dropping down
> >>>>> the innodb pool size (box only has 32G of RAM).
> >>>>>
> >>>>> The storage can do a lot more than 5k IOPS, I'm going to try ramping
> >>>>> that up.

Good.

> >>>>>
> >>>>> Does your reproducer box have multiple NUMA nodes, or is it a single
> >>>>> socket/nod box?

It was NUMA. Pre 5.14.14 I could produce it on a simpler test on a single node.

> >>>>
> >>>> Doesn't seem to reproduce for me on current -git. What file system are
> >>>> you using?

Yes ext4.

> >>>
> >>> I seem to be able to hit it with ext4, guessing it has more cases that
> >>> punt to buffered IO. As I initially suspected, I think this is a race
> >>> with buffered file write hashing. I have a debug patch that just turns
> >>> a regular non-numa box into multi nodes, may or may not be needed be
> >>> needed to hit this, but I definitely can now. Looks like this:
> >>>
> >>> Node7 DUMP
> >>> index=0, nr_w=1, max=128, r=0, f=1, h=0
> >>>   w=ffff8f5e8b8470c0, hashed=1/0, flags=2
> >>>   w=ffff8f5e95a9b8c0, hashed=1/0, flags=2
> >>> index=1, nr_w=0, max=127877, r=0, f=0, h=0
> >>> free_list
> >>>   worker=ffff8f5eaf2e0540
> >>> all_list
> >>>   worker=ffff8f5eaf2e0540
> >>>
> >>> where we seed node7 in this case having two work items pending, but the
> >>> worker state is stalled on hash.
> >>>
> >>> The hash logic was rewritten as part of the io-wq worker threads being
> >>> changed for 5.11 iirc, which is why that was my initial suspicion here.
> >>>
> >>> I'll take a look at this and make a test patch. Looks like you are able
> >>> to test self-built kernels, is that correct?

I've been libreating prebuilt kernels, however on the path to self-built again.

Just searching for the holy penguin pee (from yaboot da(ze|ys)) to
peesign(sic) EFI kernels.
jk, working through docs:
https://docs.fedoraproject.org/en-US/quick-docs/kernel/build-custom-kernel/

> >> Can you try with this patch? It's against -git, but it will apply to
> >> 5.15 as well.
> >
> > I think that one covered one potential gap, but I just managed to
> > reproduce a stall even with it. So hang on testing that one, I'll send
> > you something more complete when I have confidence in it.
>
> Alright, give this one a go if you can. Against -git, but will apply to
> 5.15 as well.

Applied, built, attempting to boot....
