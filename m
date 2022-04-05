Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB314F2537
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 09:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiDEHsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 03:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiDEHsA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 03:48:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D0B257
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 00:45:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bh17so24880293ejb.8
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 00:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03v4lj4HSpAF9fCnROiDd16VnID457BKDulfooU4ntI=;
        b=Tfbbt7ewcD/aTwU7RS9V//gY2bplvX4Rx9q7XGoGP1xV4ZcjPxJhiDTxEoHdTwCLBt
         W0M/UNBaV9uu6mXMXmCxERIs8J+OwmSbHGUvTRjW/fyIlYEhrRGlhxaWhDlfOziPqntN
         iYkSjS2oT0mzabsuSZiwVPyGoRpCW7tgJn8Q0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03v4lj4HSpAF9fCnROiDd16VnID457BKDulfooU4ntI=;
        b=sjwmsVii2u7poU6VP4sSzc5wjYZTv/k0KRdnkId/uFS2zgaY3+W6cOUWCDYl3pEiFM
         GPispy58KNZ/bbtlnNxn5hgKZLPGhBooKPxCdOapkiO565mAS8YHfNgANLs33J+yOGiy
         uQSPNm+xt8Lz86k2D99rTQ5RXDFYVpLsVJhpqscK+N2AKkacgvYObKFQQBsekNmfnP/k
         xrhUh4/fB0oOK5W05vdhoCSlXnQZ7WrVAmZxvQMbltXC40Ihq3JGrD+5va29cqq8NMoA
         i8PDjBXmWBkQpXlpss8YN8Qv8ArGKJHzu/P3UuFALzTzzYwukjoNMPvlun0XaewemYsu
         6KWg==
X-Gm-Message-State: AOAM531XIVxKJMl7Vdd6wBqgMjDogA2aPmbf+9FWiHeHF+sEH2sl/wRC
        b4T0EFyoefaBW3D8eDfWYBG7EbwLe2mYI3bKxX7cc2NLd7U=
X-Google-Smtp-Source: ABdhPJzPnNtW1dO1M4tfGsTxtpk3E+OKG1U/y/C99/nz/g5BBfKDmt7vALOBM4UDtr/BWfjiRolC1QtKolmqllcf1+4=
X-Received: by 2002:a17:906:280b:b0:6ce:f3c7:688f with SMTP id
 r11-20020a170906280b00b006cef3c7688fmr2239604ejc.468.1649144757602; Tue, 05
 Apr 2022 00:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk> <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk> <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk> <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk> <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk> <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk> <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk> <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
In-Reply-To: <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 5 Apr 2022 09:45:46 +0200
Message-ID: <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/1/22 10:21 AM, Jens Axboe wrote:
> > On 4/1/22 10:02 AM, Miklos Szeredi wrote:
> >> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >>> I take it you're continually reusing those slots?
> >>
> >> Yes.
> >>
> >>>  If you have a test
> >>> case that'd be ideal. Agree that it sounds like we just need an
> >>> appropriate breather to allow fput/task_work to run. Or it could be the
> >>> deferral free of the fixed slot.
> >>
> >> Adding a breather could make the worst case latency be large.  I think
> >> doing the fput synchronously would be better in general.
> >
> > fput() isn't sync, it'll just offload to task_work. There are some
> > dependencies there that would need to be checked. But we'll find a way
> > to deal with it.
> >
> >> I test this on an VM with 8G of memory and run the following:
> >>
> >> ./forkbomb 14 &
> >> # wait till 16k processes are forked
> >> for i in `seq 1 100`; do ./procreads u; done
> >>
> >> You can compare performance with plain reads (./procreads p), the
> >> other tests don't work on public kernels.
> >
> > OK, I'll check up on this, but probably won't have time to do so before
> > early next week.
>
> Can you try with this patch? It's not complete yet, there's actually a
> bunch of things we can do to improve the direct descriptor case. But
> this one is easy enough to pull off, and I think it'll fix your OOM
> case. Not a proposed patch, but it'll prove the theory.

Sorry for the delay..

Patch works like charm.

Thanks,
Miklos
