Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C0651A3E8
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350874AbiEDPZy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352346AbiEDPYx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 11:24:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBBF43EF5
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 08:21:17 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e24so2488906wrc.9
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRUJunY74POCXY5vjXqe4K267yyLNgnimzx09GHzktg=;
        b=e+i7xA6tLuaAwoB+uhta3Rz0e0WoPi0LCFQiR7uWMRYLr6tcxUu+kIcqZkrdax4a26
         zkN3yEt2a6jny1usVhH4iDnczreIyiCbjLBqMLEvx1ZGt0NTkF1Rir2n6POumfdljnia
         wKMUY2yQy4ze0dxpS1C90mjwB63V0XdxsiEM+hJBV40DxMp04GGh3G3cyJMUhU09lrpS
         87OD5OOySKlV3lpzUfiaig3B+Jqtx0gXQ0xLZds2DxrmmRSosQ1Z1rda/0bAT7J2Plnf
         eb2C1eI95nR74/CBZSpHYaIk0/3FkRNWFEXi4aYZ0B6ptFuYT1wnFe+jZj+/djljSgJn
         WEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRUJunY74POCXY5vjXqe4K267yyLNgnimzx09GHzktg=;
        b=WaKswXp3l0aGsUs2l6DxP72EvZJ6Og934cKA6WLO15wYXEBAonNU+sXD4GiCxaSIvS
         pCmvSRkfNKwO3rBd4ot5Sdw8Y1Q5nDy8CwMOk92wmwPpa8Dr1vTI7GK43y2RXHsDNDGE
         8L5MSwwxfocVEp6RjDKmwHBPOatoyiE1pCjn4c54x9q9GVRlIEitLX16CNdYPz3EuCD1
         N821wVgnhZkq3/R7eGfommMVRcZXwYHBvcjNH6uJ9eVxsI2ke5dJTBeHrBeiimesdVxJ
         c/YSkyv4MBbJF3v34/ZuVeH/cgau5zXu5hbFyW7kLdRbDTA9dhbodJ6hVyoTecunF24U
         +DTQ==
X-Gm-Message-State: AOAM532AyHIHAZNo0otRUS1Q4Y1eHvaRkfsREfsGGSw46kh3R3O1c+X6
        Q+lykIuL95tjxQXEuet6SqOWpvETi+7D8CjsW7deZRiLMLawjg==
X-Google-Smtp-Source: ABdhPJwAAdRfwvHfAtsFJgFWph9TpIzSaMl6TwgPD0ukchkqiuJfdwLOKuUp86tWEdVHfWfO58eCXBNrM6jpOoeKhpk=
X-Received: by 2002:adf:f6c1:0:b0:20a:c408:4aeb with SMTP id
 y1-20020adff6c1000000b0020ac4084aebmr16549170wrp.74.1651677675566; Wed, 04
 May 2022 08:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
In-Reply-To: <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 4 May 2022 18:21:04 +0300
Message-ID: <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
Subject: Re: Short sends returned in IORING
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
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

On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> > Jens:
> >
> > This is related to the previous thread "Fix MSG_WAITALL for
> > IORING_OP_RECV/RECVMSG".
> >
> > We have a similar issue with TCP socket sends. I see short sends
> > regarding of the method (I tried write, writev, send, and sendmsg
> > opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> > make a difference.
> >
> > Most of the time, sends are not short, and I never saw short sends
> > with loopback and my app. But on real network media, I see short
> > sends.
> >
> > This is a real problem, since because of this it is not possible to
> > implement queue size of > 1 on a TCP socket, which limits the benefit
> > of IORING. When we have a short send, the next send in queue will
> > "corrupt" the stream.
> >
> > Can we have complete send before it completes, unless the socket is
> > disconnected?
>
> I'm guessing that this happens because we get a task_work item queued
> after we've processed some of the send, but not all. What kernel are you
> using?
>
> This:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
>
> is queued up for 5.19, would be worth trying.
>
> --
> Jens Axboe
>

Jens:

Thank you for your reply.

The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
the solution in place, I am wondering whether it will be possible to
use multiple uring send IOs on the same socket. I expect that Linux
TCP will serialize multiple send operations on the same socket. I am
not sure it happens with uring (meaning that socket is blocked for
processing a new IO until the pending IO completes). Do I need
IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
because of multiple different sockets in the same uring. While I
already have a workaround in the form of a "software" queue for
streaming data on TCP sockets, I would rather have kernel to do
"native" queueing in sockets layer, and have exrtra CPU cycles
available to the  application.

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
