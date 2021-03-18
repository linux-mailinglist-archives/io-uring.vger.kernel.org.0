Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1753F340068
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 08:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCRHsY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 03:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhCRHsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 03:48:21 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73ACC06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 00:48:20 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo2720857wmq.4
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 00:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TG7YlWDsVFQll45rVCenXqdxqCRGUryVl0R9Q9CGIEE=;
        b=tS4qDC4ZQ5pPfJwDVXyCedaUhR1HKjXliuwPA0dgHMkQLPhlwuS05d0cuzyF6HWIzn
         i8DdBxUH9KhTLpoy4ytcBKlpwDK980x7Y7gVLNRiI6sOwsG0tFhOQbu7Jx78byt8MbJq
         zL4I2G7tUSWglNejAZ4WHP0k76AMuxlODA8o6AALsBByodxG/jNxMsxohpp0WafR2u5W
         4/eYyKuboT9Uj3x4yiXO/BVWbxIMB2vxvQuTsax5q07XHS5H8ufa0fytEFdw8+i3nivi
         5BK2dUj9ia6dRm+5XTpSxwoZO0c5+q/OD/IgYrY76KZeaHSrtLrU7r0hVLNPef9SVQu6
         uhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TG7YlWDsVFQll45rVCenXqdxqCRGUryVl0R9Q9CGIEE=;
        b=aLYRUZzMGaII2ERkOntoePi2k3dmWArv97fa8YMuUDGGQiCH9bWDQNwpj4KiXid3wL
         1WlXQRW9ZZ5lnk7ZtwAguJgrOwr/K8prkpGDWC58PBnkaO196RPUZdRK0FWrZH5HxB8w
         BmfRHpG8BUOpe2GoPXEkj8FSt4FSR5lLdxP0qMqllaid4/igZil4sIwPejfOxFKfsWp6
         WR9xp+52wiysmb6HxmzHNdKJq6zQ5QW++pUk0LMEfWII6aLUY/zM4v8WHdbFZnmTUpHH
         2OVBMHevo1LNBzUskKsVJzlVnPXwce/JTRyB+MvcUAJFy2j9Tcfj6CsNGhL+JJcLRStm
         qrvA==
X-Gm-Message-State: AOAM533tQ/mLhaqAdnbJ70m8vR56q7vtsG1Iokv3eT3fvU2ke1LFnr6L
        8FHCdF4sqoYW2pl5kQQeIPTlbvoNEb4s6t4SdUTrEDMCKBXZig==
X-Google-Smtp-Source: ABdhPJzfXm9JgoR6BcOdccwdmN0b1PPTp0RUszAvhDYTkb4OcnL/bD1xb+yTieB+Uugq6/qgpIs6q9S9Nba9ta5I31Y=
X-Received: by 2002:a05:600c:4fc2:: with SMTP id o2mr2220575wmq.25.1616053699300;
 Thu, 18 Mar 2021 00:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210316140229epcas5p23d68a4c9694bbf7759b5901115a4309b@epcas5p2.samsung.com>
 <20210316140126.24900-1-joshi.k@samsung.com> <b5476c77-813a-6416-d317-38e8537b83cb@kernel.dk>
 <CA+1E3rLOOaggA0p5wr5ndTWx42zjebCeEm5XzfOq7QcH6oP=wA@mail.gmail.com> <63a127c2-e2ed-ad5f-a6d3-8d56e3e95380@kernel.dk>
In-Reply-To: <63a127c2-e2ed-ad5f-a6d3-8d56e3e95380@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 18 Mar 2021 13:17:52 +0530
Message-ID: <CA+1E3r+_rNmDBgL2cabxboG4GDaRx=XRt=SiNPt3hnvOuTYd5A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Async nvme passthrough over io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 7:28 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/17/21 3:31 AM, Kanchan Joshi wrote:
> > On Tue, Mar 16, 2021 at 9:31 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/16/21 8:01 AM, Kanchan Joshi wrote:
> >>> This series adds async passthrough capability for nvme block-dev over
> >>> iouring_cmd. The patches are on top of Jens uring-cmd branch:
> >>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3
> >>>
> >>> Application is expected to allocate passthrough command structure, set
> >>> it up traditionally, and pass its address via "block_uring_cmd->addr".
> >>> On completion, CQE is posted with completion-status after any ioctl
> >>> specific buffer/field update.
> >>
> >> Do you have a test app? I'd be curious to try and add support for this
> >> to t/io_uring from fio just to run some perf numbers.
> >
> > Yes Jens. Need to do a couple of things to make it public, will post it today.

Please see if this is accessible to you -
https://github.com/joshkan/fio/commit/6c18653bc87015213a18c23d56518d4daf21b191

I run it on nvme device with the extra option "-uring_cmd=1". And pit
passthru read/write against regular uring read/write.
While write perf looks fine, I notice higher-qd reads going tad-bit
low which is puzzling.
But I need to test more to see if this is about my test-env (including
the added test-code) itself.

It will be great if you could, at some point in future, have a look at
this test or spin off what you already had in mind.

> Sounds good! I commented on 1/3, I think it can be simplified and
> cleaned up quite a bit, which is great. Then let's base it on top of v4
> that I posted, let me know if you run into any issues with that.

Yes, will move to V4,  thanks!
