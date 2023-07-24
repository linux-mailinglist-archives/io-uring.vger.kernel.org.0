Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624A875FB7A
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 18:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjGXQHZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 12:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjGXQHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 12:07:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3AB10F6
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 09:07:16 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-c11e2b31b95so4962318276.3
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 09:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1690214835; x=1690819635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H+9hATyxM1wFvDyiZv4CUg26TjbnT4RKHY7Z6xDG7Qc=;
        b=n4RguLbipIDQE05X2UsocctdpugWflo7O4z8c3gwAfkLynyr8zm5/CVjbVs+tll8O7
         X0Ku/7bnlehb3Ox7SBdt1JsBF51lWhN9JK4rkJEMe0mtYfMYNmhReGcTwTaGi7XrgH6w
         AoqM98jUDwcsem/XlkeUawhQ/Quf5wkpYquBpA2iv6vMPHpiz/M0Efuv1r/EidPG0Cga
         g/AtYUJgSPRocmaMMJ5LbLxrodle3GBgnj/TYbtq4vGuFmT/0T6ZBnSct+p5l8T3d8J5
         iuyr8NvNhfPPNd6gvWBkWI3g9QTKs7q2xbyLTIMfzVy1BOOaCmxvRzGuXAOkGFLAzt4f
         aGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690214835; x=1690819635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H+9hATyxM1wFvDyiZv4CUg26TjbnT4RKHY7Z6xDG7Qc=;
        b=LK8XA9HgP1vtjFc2uLGNldzIg9Q35Hye+A9Mn9BKXsX3f7wy49gpaMW9xAIFXK7ZIG
         JyDEWUxCU9/k3mTRs7eE0srwy6zQsyQANUi2eQWMAfFJ61B8V8UwglJe/MBgbkUt86nT
         timL3ujSRo/AJL6n6yWwoSnQ8rHULLuYP4LMwyFGB+bTyYoEvrgb9/s9+nOgXiFS5fWg
         Nrs5d2B6o+6gO9TYDEoRZVgs9aVCH/DsOl/w7g/F8rq+i/aNU3Gr3NmHetZuhmWr/uQ3
         u3Ewc41GGstmRT6ordmoeARSoGgj73uIEd/IRT8qK6uQ/OvPTTvkwghyP1EOu1D+R5rU
         dBxg==
X-Gm-Message-State: ABy/qLYjLBtb5sKMBeEvNJ5R1CN5tpVSrKmN0EYfxYCVve0K5BROO7bq
        IVBRDABSGX9qq4cs5frFeWsivE7fTIZRFRZRBA00jg==
X-Google-Smtp-Source: APBJJlHCWUTp7P04MApBHJlPyUxUZOvWwilt6qHx3n6q3KAE86ERNTh2oELFuCYqojOuLFYMFtf2PwJIimHh9n9Bbn0=
X-Received: by 2002:a25:ada1:0:b0:d0f:2038:9ca2 with SMTP id
 z33-20020a25ada1000000b00d0f20389ca2mr3639883ybi.51.1690214835437; Mon, 24
 Jul 2023 09:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <2023072438-aftermath-fracture-3dff@gregkh> <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
 <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
In-Reply-To: <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
From:   Phil Elwell <phil@raspberrypi.com>
Date:   Mon, 24 Jul 2023 17:07:04 +0100
Message-ID: <CAMEGJJ3SjWdJFwzB+sz79ojWqAAMULa2CFAas0tv+JJLJMwoGQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, andres@anarazel.de,
        asml.silence@gmail.com, david@fromorbit.com, hch@lst.de,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens, Greg,

On Mon, 24 Jul 2023 at 16:58, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/24/23 9:50?AM, Jens Axboe wrote:
> > On 7/24/23 9:48?AM, Greg KH wrote:
> >> On Mon, Jul 24, 2023 at 04:35:43PM +0100, Phil Elwell wrote:
> >>> Hi Andres,
> >>>
> >>> With this commit applied to the 6.1 and later kernels (others not
> >>> tested) the iowait time ("wa" field in top) in an ARM64 build running
> >>> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
> >>> is permanently blocked on I/O. The change can be observed after
> >>> installing mariadb-server (no configuration or use is required). After
> >>> reverting just this commit, "wa" drops to zero again.
> >>
> >> This has been discussed already:
> >>      https://lore.kernel.org/r/12251678.O9o76ZdvQC@natalenko.name

Sorry - a brief search failed to find that.

> >> It's not a bug, mariadb does have pending I/O, so the report is correct,
> >> but the CPU isn't blocked at all.
> >
> > Indeed - only thing I can think of is perhaps mariadb is having a
> > separate thread waiting on the ring in perpetuity, regardless of whether
> > or not it currently has IO.
> >
> > But yes, this is very much ado about nothing...
>
> Current -git and having mariadb idle:
>
> Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> Average:     all    0.00    0.00    0.04   12.47    0.04    0.00    0.00    0.00    0.00   87.44
> Average:       0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       1    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       2    0.00    0.00    0.00    0.00    0.33    0.00    0.00    0.00    0.00   99.67
> Average:       3    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       4    0.00    0.00    0.33    0.00    0.00    0.00    0.00    0.00    0.00   99.67
> Average:       5    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       6    0.00    0.00    0.00  100.00    0.00    0.00    0.00    0.00    0.00    0.00
> Average:       7    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
>
> which is showing 100% iowait on one cpu, as mariadb has a thread waiting
> on IO. That is obviously a valid use case, if you split submission and
> completion into separate threads. Then you have the latter just always
> waiting on something to process.
>
> With the suggested patch, we do eliminate that case and the iowait on
> that task is gone. Here's current -git with the patch and mariadb also
> running:
>
> 09:53:49 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 09:53:50 AM  all    0.00    0.00    0.00    0.00    0.00    0.75    0.00    0.00    0.00   99.25
> 09:53:50 AM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 09:53:50 AM    1    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    2    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    3    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    4    0.00    0.00    0.00    0.00    0.00    0.99    0.00    0.00    0.00   99.01
> 09:53:50 AM    5    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    6    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 09:53:50 AM    7    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
>
>
> Even though I don't think this is an actual problem, it is a bit
> confusing that you get 100% iowait while waiting without having IO
> pending. So I do think the suggested patch is probably worthwhile
> pursuing. I'll post it and hopefully have Andres test it too, if he's
> available.

If you CC me I'll happily test it for you.

Thanks,

Phil

> --
> Jens Axboe
>
