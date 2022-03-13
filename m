Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF94D7288
	for <lists+io-uring@lfdr.de>; Sun, 13 Mar 2022 06:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiCMFL4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Mar 2022 00:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiCMFLz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Mar 2022 00:11:55 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BFB62A24;
        Sat, 12 Mar 2022 21:10:47 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h14so21704748lfk.11;
        Sat, 12 Mar 2022 21:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2a/Y/9RxUg+RQvi15qObMdwkcPWgNkuVkFYsEACDhk=;
        b=dGMG4CGvo7ZEusw/Ld484ohSc3fYw9xqgxsiNBnbP8RjQymD23frQDRtA4TW3JRFVz
         jyAX5CFAD+gbxRCxqPKxnI0UAy07HAt1Y2vEaYJwOB5vjA3P4ANAdITS01kxTKXz8O2D
         +sSzFavIAAfwkUgBVvkMttK1YxbvW+aNqAj+6/2zqODavQLvBpF618r1pqPQcVPiHKqi
         RIH32k+3xmJ/nEgrsm7XoAGIn0j2XfYCxTMYQ5Dx+oqIfQJwENAOnkszZe1FHWBjeUR3
         JqVzOIVmSfHNscDmoynYYFTViaH43dYTwpWhDE1vVrSoNYbMx5rYUTbi9qjH/u9GzdZ9
         kMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2a/Y/9RxUg+RQvi15qObMdwkcPWgNkuVkFYsEACDhk=;
        b=3XlaxNDOtRcvBGpdb/sICxioMF69U8osDt0tsEbaZGd7YysK9fFkpdlrx/We0dmQ5h
         QpeLtITlYsIujUBPypZTtRmYDWTBBphz8WHsV5IKb92WXRU8l5v0+jyE56OEKRXfRyKB
         0zKQwJHDF8uUPZ5HOowfbZ2dNBkSB0+xPsDnklBtWZv/+ngfZNMRoGWRiuGThJFOYv8m
         bnjwYqGi1QBeosXKN4be3kTZ7SKgSqURNbIFQVierH2UsjbF1MGfci6SmnznfyvILEw8
         ByqCA3ka/flyAPNSZJBiYnT5ukE9HlShtK9HrfYgeH7bjDgVTur/r64H4DrjVellYBlF
         tRtg==
X-Gm-Message-State: AOAM5334va/nVGXRMKLvJ1ndzKXJevqWbWhRAtbC/6n64ZOLXVUDxrTy
        6nI127QusMPHp7LUAXzeCLvilqbKSY0UJ6yXl4s=
X-Google-Smtp-Source: ABdhPJyU6aJ5LvlLIm1T0ym3uRSz5wd5N0P5WXOILbF4l1t4ugCeri+GG6bQDZpgXFpiYUZyRYDJV79MInjH6/VIu7A=
X-Received: by 2002:a05:6512:3f99:b0:447:7fc0:8d3 with SMTP id
 x25-20020a0565123f9900b004477fc008d3mr10460588lfa.671.1647148245909; Sat, 12
 Mar 2022 21:10:45 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
 <20220308152105.309618-1-joshi.k@samsung.com> <20220310082926.GA26614@lst.de>
 <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com> <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
In-Reply-To: <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Sun, 13 Mar 2022 10:40:20 +0530
Message-ID: <CA+1E3rKgGgOQonGpjjwdAFc2FAXH5UkGKNXh0RqrBo9_=H6VSQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] io_uring passthru over nvme
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
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

On Fri, Mar 11, 2022 at 10:13 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Thu, Mar 10, 2022 at 03:35:02PM +0530, Kanchan Joshi wrote:
> > On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > What branch is this against?
> > Sorry I missed that in the cover.
> > Two options -
> > (a) https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-big-sqe
> > first patch ("128 byte sqe support") is already there.
> > (b) for-next (linux-block), series will fit on top of commit 9e9d83faa
> > ("io_uring: Remove unneeded test in io_run_task_work_sig")
> >
> > > Do you have a git tree available?
> > Not at the moment.
> >
> > @Jens: Please see if it is possible to move patches to your
> > io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).
>
> Since Jens might be busy, I've put up a tree with all this stuff:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20220311-io-uring-cmd
>
> It is based on option (b) mentioned above, I took linux-block for-next
> and reset the tree to commit "io_uring: Remove unneeded test in
> io_run_task_work_sig" before applying the series.

Thanks for putting this up.

-- 
Joshi
