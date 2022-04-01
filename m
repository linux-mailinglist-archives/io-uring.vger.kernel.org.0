Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7CD4EE615
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 04:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbiDACgD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 22:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbiDACgC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 22:36:02 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6F866CB5;
        Thu, 31 Mar 2022 19:34:14 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id z8so1503172oix.3;
        Thu, 31 Mar 2022 19:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pK4tyBfA3bEbxgtyBUBSotAlH+ifeflAX1W+Ob8TM00=;
        b=Mt2brRA4775fLEWdpYfxvpvKDDTgy4aNuuCzFnVcSU29F/RTNr6T8WnNggdqbYVogB
         cZcU1nL6X5d7XiYXtnQKr/oAjFLTAgWMAOrj0kUn1yaySiebC5jHuMK5MySQMApOEUqQ
         ar9J+C2MBoGeOmkNN9h5guTko7HZ7wbCt8EA3e0YRENcmvtg29WRcNiqqqRYNmZveCvk
         2MHEF/HcRhtUTGsWM0Ze6RdUT5qkiGbV9aLrZyBNBfIjMZPww5um1ff7NFjJoiMLiTF6
         T08kgYskINDQgvYjetCSqLQka5YFnbnpBI29F3v/lMdZfgQ5U4/yZB5j+z4DrNHvLC0I
         k5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pK4tyBfA3bEbxgtyBUBSotAlH+ifeflAX1W+Ob8TM00=;
        b=EseCDigFrSgzMjOtJuIMzTmGXkpme+Xal9v2zuMDlLXA1gOai5MO8VrU5gbjtN8ztV
         Xfd7UxUhWX5aZFZWkq9+bN2VGzGaN8V961lAiF6hk3TCVTiVw32Yy4PXb+WIpsi41WEy
         E2TG8Uw4JlZsvtjMHhd+hPbp0Mks1UchqUT0Hkv912+K8NvdDzUJAoxVhhX0Iy6NV+p4
         VwhhvYYK01iIpfCmMHn/lSw6sqC7ff7A/IVf2+1QpHtP08Jr1RHjjtYAa+51q9S5f/Rv
         b1xNNJaaoup2Skln3khmV05k1SuGd0F6qiv8anvVibbieLeFSRkRZMFrsGK0NFLne9Q7
         KHoQ==
X-Gm-Message-State: AOAM531Y4UTRHaWyqF5dpMQ72sO/fY5OK/pfKS0k4nMFMVFJvX/2un3N
        vcAqIWpuT2XrWvhpXFiQWUZBFthX8mn90JWJ7aPA0feBSKQ=
X-Google-Smtp-Source: ABdhPJwsuMrJeRG2Xq2Tal7zrithBAIkM9ciuFki8krG7+387XaljgePmf0vfC77RoDc9pO2azGIW8dpokfkuPMuaiA=
X-Received: by 2002:aca:2407:0:b0:2ef:5c86:5a09 with SMTP id
 n7-20020aca2407000000b002ef5c865a09mr3880084oic.160.1648780453322; Thu, 31
 Mar 2022 19:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de> <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
In-Reply-To: <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 1 Apr 2022 08:03:48 +0530
Message-ID: <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
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

On Fri, Apr 1, 2022 at 6:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/30/22 7:14 AM, Kanchan Joshi wrote:
> > On Wed, Mar 30, 2022 at 6:32 PM Christoph Hellwig <hch@lst.de> wrote:
> >>
> >> On Fri, Mar 25, 2022 at 07:09:21PM +0530, Kanchan Joshi wrote:
> >>> Ok. If you are open to take new opcode/struct route, that is all we
> >>> require to pair with big-sqe and have this sorted. How about this -
> >>
> >> I would much, much, much prefer to support a bigger CQE.  Having
> >> a pointer in there just creates a fair amount of overhead and
> >> really does not fit into the model nvme and io_uring use.
> >
> > Sure, will post the code with bigger-cqe first.
>
> I can add the support, should be pretty trivial. And do the liburing
> side as well, so we have a sane base.

 I will post the big-cqe based work today. It works with fio.
 It does not deal with liburing (which seems tricky), but hopefully it
can help us move forward anyway .

> Then I'd suggest to collapse a few of the patches in the series,
> the ones that simply modify or fix gaps in previous ones. Order
> the series so we build the support and then add nvme support
> nicely on top of that.

I think we already did away with patches which were fixing only the
gaps. But yes, patches still add infra for features incrementally.
Do you mean having all io_uring infra (async, plug, poll) squashed
into a single io_uring patch?
On a related note, I was thinking of deferring fixed-buffer and
bio-cache support for now.
