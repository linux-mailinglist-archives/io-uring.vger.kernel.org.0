Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F100509FC6
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384961AbiDUMmL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 08:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiDUMmL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 08:42:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138B22280
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:39:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g13so9789099ejb.4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgPQkuXO7eOUTjfP8JG5Ci4sfQEaaO8ZY8KR6KGiZr4=;
        b=EGAhTGsyJRQugZIVH7cg9rBVod7JDZisV3h3qquKyl+sTRpy83wa9ZzDVio5JG6zlL
         GJzb5XQ8SsWjlzx5MgJ1WNJdV5xUpigW/k6XGtsynrfzb74HPjJJ+yaXp7l3PyIwX9/K
         hsEJcqQtZhvYGtA7qtZGj2s9E00neNlQjHvFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgPQkuXO7eOUTjfP8JG5Ci4sfQEaaO8ZY8KR6KGiZr4=;
        b=ny5lLFda/EqsSVvZhM1iVoCvhEFX/zNQijJh6ZJWbyr9ZP2BNxFF00N98iIE7lkj/g
         h1ZnfBjofGzMEQkTD4EVi3T39cafHaXAf6gjSBmESJl/zR61xdriIuoGYxZGAzGTsNFg
         BqPXaHKSgDngz0/sV2Xl6wek2jFFqK6z0rhn43MLpGQ9QRj9fSTqrwblf+86kJk9XQI5
         PXYEtOHZ2WxPFpGq36nut1fdfX1pDQ+BmdVE3Wb/KdYor5LQ3xh1VHiGUNIwPgGqJLdH
         TGAy2AVLmES5DK2HW6oxbGxWRAIrqd7GCY22/3aRn+4enLpIIPMX8WWEjzOlgX16UaDT
         UPAA==
X-Gm-Message-State: AOAM531BXvvJH2IJZ8kBdD+3mzE+bW82NfOMfFhsNTKi+3KKqB+5zGiN
        03/dW9Wxluz6ZwMO/1u4TVYQhcM/gmnR73dAUPYIbLgqXBnzcQ==
X-Google-Smtp-Source: ABdhPJwet5Zy64DIuHXghWy6t1jF0bEjKlE3HCiJrWFIeLBGBXDlwhJ1NkXrJrqmxzOpEoouwBBXU635U5vBFkJ0Iec=
X-Received: by 2002:a17:906:a05a:b0:6ef:a44d:2f46 with SMTP id
 bg26-20020a170906a05a00b006efa44d2f46mr17778218ejb.192.1650544759161; Thu, 21
 Apr 2022 05:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk> <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk> <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk> <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk> <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk> <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
 <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com>
 <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk> <CAJfpegsa8uza8bc1aMD7hLzrD6n1=wbxAmQH2KEOnrw7Rxkz2A@mail.gmail.com>
 <05c068ed-4af1-f12e-623f-6a9dde73d1c0@kernel.dk>
In-Reply-To: <05c068ed-4af1-f12e-623f-6a9dde73d1c0@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 21 Apr 2022 14:39:07 +0200
Message-ID: <CAJfpegvTPc0DR5z80kB6uq=-nMa=+4uxGUqbxiGcOTUiVrR+wg@mail.gmail.com>
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

On Thu, 21 Apr 2022 at 14:34, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/21/22 6:31 AM, Miklos Szeredi wrote:
> > On Tue, 5 Apr 2022 at 16:44, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/5/22 1:45 AM, Miklos Szeredi wrote:
> >>> On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/1/22 10:21 AM, Jens Axboe wrote:
> >>>>> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
> >>>>>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>>> I take it you're continually reusing those slots?
> >>>>>>
> >>>>>> Yes.
> >>>>>>
> >>>>>>>  If you have a test
> >>>>>>> case that'd be ideal. Agree that it sounds like we just need an
> >>>>>>> appropriate breather to allow fput/task_work to run. Or it could be the
> >>>>>>> deferral free of the fixed slot.
> >>>>>>
> >>>>>> Adding a breather could make the worst case latency be large.  I think
> >>>>>> doing the fput synchronously would be better in general.
> >>>>>
> >>>>> fput() isn't sync, it'll just offload to task_work. There are some
> >>>>> dependencies there that would need to be checked. But we'll find a way
> >>>>> to deal with it.
> >>>>>
> >>>>>> I test this on an VM with 8G of memory and run the following:
> >>>>>>
> >>>>>> ./forkbomb 14 &
> >>>>>> # wait till 16k processes are forked
> >>>>>> for i in `seq 1 100`; do ./procreads u; done
> >>>>>>
> >>>>>> You can compare performance with plain reads (./procreads p), the
> >>>>>> other tests don't work on public kernels.
> >>>>>
> >>>>> OK, I'll check up on this, but probably won't have time to do so before
> >>>>> early next week.
> >>>>
> >>>> Can you try with this patch? It's not complete yet, there's actually a
> >>>> bunch of things we can do to improve the direct descriptor case. But
> >>>> this one is easy enough to pull off, and I think it'll fix your OOM
> >>>> case. Not a proposed patch, but it'll prove the theory.
> >>>
> >>> Sorry for the delay..
> >>>
> >>> Patch works like charm.
> >>
> >> OK good, then it is the issue I suspected. Thanks for testing!
> >
> > Tested with v5.18-rc3 and performance seems significantly worse than
> > with the test patch:
> >
> > test patch:
> >         avg     min     max     stdev
> > real    0.205   0.190   0.266   0.011
> > user    0.017   0.007   0.029   0.004
> > sys     0.374   0.336   0.503   0.022
> >
> > 5.18.0-rc3-00016-gb253435746d9:
> >         avg     min     max     stdev
> > real    0.725   0.200   18.090  2.279
> > user    0.019   0.005   0.046   0.006
> > sys     0.454   0.241   1.022   0.199
>
> It's been a month and I don't remember details of which patches were
> tested, when you say "test patch", which one exactly are you referring
> to and what base was it applied on?

https://lore.kernel.org/all/47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk/

The base is a good question, it was after the basic fixed slot
assignment issues were fixed.

Thanks,
Miklos
