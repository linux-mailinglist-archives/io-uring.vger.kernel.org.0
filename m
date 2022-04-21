Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976C5509FB4
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384802AbiDUMfH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384790AbiDUMfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 08:35:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01AE3191C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:32:11 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id y10so9687475ejw.8
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lh828Yrhk3RT/O9ogfgnIki+uJ9VN1M1Mm/MjWXiRpE=;
        b=hyhnUTRbWLmvo4mUKjHN65JwSm75vRdjPWbg7TTB/zUXX7lZeSUWcjkDiNJM4ZBTKF
         nYWcoGZuZnkH6JPEYPVL2eOoTBJi+BPFNKoIlyKobRb7D8L2/N0GboJa0rxxp9ynAooU
         pK/PzywgGf4w3nMjULLUb9BIkIDZOTTv/bSp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lh828Yrhk3RT/O9ogfgnIki+uJ9VN1M1Mm/MjWXiRpE=;
        b=PqF0WJndzCaGd0KxjDcueY3HvVcL66bRpJqc9ll4/hhSvrLCLyja5BGeKYaY8TcmSQ
         vSRkilDgUDvsLLFbkNto0IruiCB22QlrOagZnYBi4+HP73eaOVt72gknfhRljHPArcwc
         kfUDvW5jIGsToRqxiQutE4Eh6QJdWGHTZTvjg38WlgdRHW9g0RnOh8BGLwPjdXXbXtre
         rL/qQbWPl/YjKWg2LizzrJ811IGufQVd0Fhh7v7E9b5NiWzRHA2LnjJ6WoAAnzCp3byY
         d+RuIi9l1RLNVgmqTvaG6W2CIJWCDyxlIpNxqvC5kvjV9Ry3y+YmICBK5X7KnFLfMqlA
         smQg==
X-Gm-Message-State: AOAM5308K5ZdDPuL3U/ud8QAXF10imZS0gG1pd8F/XYy7HK1TWtKyjDY
        SS0b59i417HqYDL/izEavyM/ZugoGbJHsOyQo+GMGA==
X-Google-Smtp-Source: ABdhPJwE9jULwzbY0bPzBMu0ZWWz4sAucpNZ/OP8Cu58bY7syvSuie0c4Gn4osXVSqZnpR8CR3kvjVGloBq41NN2MJc=
X-Received: by 2002:a17:906:280b:b0:6ce:f3c7:688f with SMTP id
 r11-20020a170906280b00b006cef3c7688fmr22645761ejc.468.1650544330461; Thu, 21
 Apr 2022 05:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk> <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk> <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk> <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk> <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk> <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk> <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
 <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com> <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk>
In-Reply-To: <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 21 Apr 2022 14:31:58 +0200
Message-ID: <CAJfpegsa8uza8bc1aMD7hLzrD6n1=wbxAmQH2KEOnrw7Rxkz2A@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 5 Apr 2022 at 16:44, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/5/22 1:45 AM, Miklos Szeredi wrote:
> > On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/1/22 10:21 AM, Jens Axboe wrote:
> >>> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
> >>>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>>> I take it you're continually reusing those slots?
> >>>>
> >>>> Yes.
> >>>>
> >>>>>  If you have a test
> >>>>> case that'd be ideal. Agree that it sounds like we just need an
> >>>>> appropriate breather to allow fput/task_work to run. Or it could be the
> >>>>> deferral free of the fixed slot.
> >>>>
> >>>> Adding a breather could make the worst case latency be large.  I think
> >>>> doing the fput synchronously would be better in general.
> >>>
> >>> fput() isn't sync, it'll just offload to task_work. There are some
> >>> dependencies there that would need to be checked. But we'll find a way
> >>> to deal with it.
> >>>
> >>>> I test this on an VM with 8G of memory and run the following:
> >>>>
> >>>> ./forkbomb 14 &
> >>>> # wait till 16k processes are forked
> >>>> for i in `seq 1 100`; do ./procreads u; done
> >>>>
> >>>> You can compare performance with plain reads (./procreads p), the
> >>>> other tests don't work on public kernels.
> >>>
> >>> OK, I'll check up on this, but probably won't have time to do so before
> >>> early next week.
> >>
> >> Can you try with this patch? It's not complete yet, there's actually a
> >> bunch of things we can do to improve the direct descriptor case. But
> >> this one is easy enough to pull off, and I think it'll fix your OOM
> >> case. Not a proposed patch, but it'll prove the theory.
> >
> > Sorry for the delay..
> >
> > Patch works like charm.
>
> OK good, then it is the issue I suspected. Thanks for testing!

Tested with v5.18-rc3 and performance seems significantly worse than
with the test patch:

test patch:
        avg     min     max     stdev
real    0.205   0.190   0.266   0.011
user    0.017   0.007   0.029   0.004
sys     0.374   0.336   0.503   0.022

5.18.0-rc3-00016-gb253435746d9:
        avg     min     max     stdev
real    0.725   0.200   18.090  2.279
user    0.019   0.005   0.046   0.006
sys     0.454   0.241   1.022   0.199

Thanks,
Miklos
