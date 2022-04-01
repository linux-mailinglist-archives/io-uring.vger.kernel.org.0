Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE9E4EE837
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 08:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiDAGcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 02:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiDAGcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 02:32:05 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476E5F27F;
        Thu, 31 Mar 2022 23:30:15 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id a7-20020a9d5c87000000b005ad1467cb59so1499179oti.5;
        Thu, 31 Mar 2022 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oY5lxseEYvVi/FJqL+ODr3hkFa+xrcTeRJyj7dlR1ww=;
        b=ArKGrA8IHpSZpGyk7d2dNujVyXNYuBtmPHXI5+93f64a3hkNVDs7C9VdJaglQySAvW
         KrikZDmbySZcRnPeU4o5yIuUsbWqgJ4kHmzYxUWJrvt5s36wtJxPadxTBiCi867wFyJN
         UC+5MDr5YgO5CYJ/xIfPIGx3sO15MXEwzxXfypm9GYZBlwymTlDwoFuKb0dPvwnhlIz5
         Y2+b+wVztK72SxHNRtaBU5hWSRNzGEH0DcnDT1o83yYZbG+yVxx9SOiCHSvEPMR9ws57
         8xpjrbsgioYiZeQuMIPjePThaYagXTafJtHKdr+sN0oxV3h99yBMxZodir/1LwWbqGi8
         3Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oY5lxseEYvVi/FJqL+ODr3hkFa+xrcTeRJyj7dlR1ww=;
        b=ODn86psPmj0GRTknQzBnb2hcpdMzqcIPp7sGnMCXGbq1c6400mnFvalSclk0OleGi2
         ImEJBMNc8zAUsh028G1i7EIgjWkQwpczZNv8r0MYpUE/VsK7bPOTFIA2u802bdI8AvZn
         6vQzFgjhXyZUXwr336BgLnxjlRmUg0I3yzJIL3mPHdCbZAyWizUXioKVdAcQl4cTJ8a4
         dhFo9UVacjYZCV814h5bmtO/B9rxNEvHvoHUJvbhp7BjdP3rLueXkabTuenyg2RfJlKb
         1C4N5ltjkCCP/zV9M7atL3K34GENcrpwY6lUvNb0w9M7uD39Tk5HUHN6EqQdZVAnEZYO
         A99g==
X-Gm-Message-State: AOAM532vqRft6mI7SOB2F+4tfeBgCw3CYKLssBy4605XDGn3aeaSzFGt
        xPLIBsnrjbwEN65JPNGZhR2VT6G9T8KCog3//u0=
X-Google-Smtp-Source: ABdhPJyUj9XIGjZCaZawYpyZ+T0i4GQnMMiMyV1w8XVN5XehPlnlO15JMAguEsmtRTIwsCX5KS8+D2zqe8yny8OcM44=
X-Received: by 2002:a9d:6c8e:0:b0:5af:5113:1bd9 with SMTP id
 c14-20020a9d6c8e000000b005af51131bd9mr7063558otr.86.1648794614797; Thu, 31
 Mar 2022 23:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <910afdf8-ec01-90b2-b7ec-a7644e53259e@kernel.dk>
In-Reply-To: <910afdf8-ec01-90b2-b7ec-a7644e53259e@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 1 Apr 2022 11:59:49 +0530
Message-ID: <CA+1E3r+6BgUCEu_7DYrN-+wnz9MU5x7S1u8-W2H5GwVS1y4Gbg@mail.gmail.com>
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

On Fri, Apr 1, 2022 at 6:52 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/22/22 11:10 AM, Kanchan Joshi wrote:
> >> We need to decouple the
> >> uring cmd properly.  And properly in this case means not to add a
> >> result pointer, but to drop the result from the _input_ structure
> >> entirely, and instead optionally support a larger CQ entry that contains
> >> it, just like the first patch does for the SQ.
> >
> > Creating a large CQE was my thought too. Gave that another stab.
> > Dealing with two types of CQE felt nasty to fit in liburing's api-set
> > (which is cqe-heavy).
> >
> > Jens: Do you already have thoughts (go/no-go) for this route?
>
> Yes, I think we should just add support for 32-byte CQEs as well. Only
> pondering I've done here is if it makes sense to manage them separately,
> or if you should just get both big sqe and cqe support in one setting.
> For passthrough, you'd want both. But eg for zoned writes, you can make
> do with a normal sized sqes and only do larger cqes.

I had the same thought. That we may have other use-cases returning a
second result.
For now I am doing 32-byte cqe with the same big-sqe flag, but an
independent flag can be done easily.

Combinations are:
(a) big-sqe with big-cqe  (for nvme-passthru)
(b) big-sqe without big-cqe (inline submission but not requiring second result)
(c) regular-sqe with big-cqe (for zone-append)
(d) regular-sqe with regular-cqe (for cases when inline submission is
not enough e.g. > 80 bytes of cmd)

At this point (d) seems rare. And the other three can be done with two flags.
