Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BCE4EE83A
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 08:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiDAGed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 02:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiDAGec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 02:34:32 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FE7260C4C;
        Thu, 31 Mar 2022 23:32:43 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 12so1870961oix.12;
        Thu, 31 Mar 2022 23:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gK4aGIYEgAhXDfx1cDepQ0HM6CbjsNwz+Xvd4R4OCLM=;
        b=VTta7BHgoG/FRAGIVOU4RMsh/ihKCZYnDPyCSQVY5CdQUnLvIjZRhVmOrDvdomVR2p
         n9tCXXSnQVgRIlwBgHQLjWdGqBbS1Xk4+TYyYJO/ZfxlNkeFRVPx/dAVMHgCRIn17mGR
         aL+ohpd5ha0c58kJQXvmYvRJ5Y/uOYhtlqRWwQ14Rgy1rfuHzXtNzof2LeCqAd5JPEtX
         cc53yHhZ2GrloGI1tnTHiQF7tuaakavRDOpd1LgJkidyaA2MACVyJFiX5ekHLMSh7IRz
         V/9rYJFDD2ZrzRJYIyFhzJPnL+VziDaUyZCEJAl8lCSeFUWhue6rSINy6m1XFnN07VCf
         oBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gK4aGIYEgAhXDfx1cDepQ0HM6CbjsNwz+Xvd4R4OCLM=;
        b=mvyLFrRsXOnITxUyaDZeUjj1u2ko2QvpEkyFzzPEVLNv3X3k411M6tDTo4N+xk0ead
         SOeOeTUn1QhmImj4ZRXhWCC0HE4p0qyDUz3aDu5R+qZ0cJP7s3FgatqK3w/7ANv3cuk1
         ppmjX6StwSrbanlJmvKPHEYQyOz9pgFO2qvoJu/mTf+L+6Bh+Kcq42cGPTGkeDCeoPzT
         z6jfclyARU1aomEJsaJXz3Gb2X7REVp5egjCzxStwhlpAA6dEb0CTWpJT7Nb7zYDtp9a
         thvSfSmLlL66ppVjR96KkO2HhDtVwAxEjm7kUy4rhONymPGUQeVW0B7lmMQIh54qTzaE
         BUtA==
X-Gm-Message-State: AOAM530v4qm1DcrTsSfekcKA5feux4laZ1iDAOdnVkxk96tJeFk5ZoB3
        edPrbP5S/YOzOnyMGN+pyGmBGKz3heFL6GlDAX4=
X-Google-Smtp-Source: ABdhPJyl6sH5UieKP62jvxcmEFGr5+PCOf1hUKaBxMgKOisnVDIjfo1v3QE5lzXugafhF9mZkkAmfnBk9mN6d5T5aqw=
X-Received: by 2002:aca:2407:0:b0:2ef:5c86:5a09 with SMTP id
 n7-20020aca2407000000b002ef5c865a09mr4154475oic.160.1648794762589; Thu, 31
 Mar 2022 23:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de> <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk> <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
 <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
In-Reply-To: <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 1 Apr 2022 12:02:17 +0530
Message-ID: <CA+1E3rL+=h3enUGGe_4m++-NztfT-t84foiDVK4QZ4AfSxGPfQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 1, 2022 at 8:14 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>> Ok. If you are open to take new opcode/struct route, that is all we
> >>>>> require to pair with big-sqe and have this sorted. How about this -
> >>>>
> >>>> I would much, much, much prefer to support a bigger CQE.  Having
> >>>> a pointer in there just creates a fair amount of overhead and
> >>>> really does not fit into the model nvme and io_uring use.
> >>>
> >>> Sure, will post the code with bigger-cqe first.
> >>
> >> I can add the support, should be pretty trivial. And do the liburing
> >> side as well, so we have a sane base.
> >
> >  I will post the big-cqe based work today. It works with fio.
> >  It does not deal with liburing (which seems tricky), but hopefully it
> > can help us move forward anyway .
>
> Let's compare then, since I just did the support too :-)

:-) awesome

> Some limitations in what I pushed:
>
> 1) Doesn't support the inline completion path. Undecided if this is
> super important or not, the priority here for me was to not pollute the
> general completion path.
>
> 2) Doesn't support overflow. That can certainly be done, only
> complication here is that we need 2x64bit in the io_kiocb for that.
> Perhaps something can get reused for that, not impossible. But figured
> it wasn't important enough for a first run.

We have the handling in my version. But that part is not tested, since
that situation did not occur naturally.
Maybe it requires slowing down completion-reaping (in user-space) to
trigger that.

> I also did the liburing support, but haven't pushed it yet. That's
> another case where some care has to be taken to avoid makig the general
> path slower.
>
> Oh, it's here, usual branch:
>
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-big-sqe
>
> and based on top of the pending 5.18 bits and the current 5.19 bits.
>
> >> Then I'd suggest to collapse a few of the patches in the series,
> >> the ones that simply modify or fix gaps in previous ones. Order
> >> the series so we build the support and then add nvme support
> >> nicely on top of that.
> >
> > I think we already did away with patches which were fixing only the
> > gaps. But yes, patches still add infra for features incrementally.
> > Do you mean having all io_uring infra (async, plug, poll) squashed
> > into a single io_uring patch?
>
> At least async and plug, I'll double check on the poll bit.

Sounds right, the plug should definitely go in the async one.
