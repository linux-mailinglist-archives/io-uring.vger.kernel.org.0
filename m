Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B000C52A166
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbiEQMYS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 08:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244380AbiEQMYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 08:24:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADD54553F
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:24:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h14so4869836wrc.6
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XbwAA+UV9EPS2eBIxxAE6MtJ2V0j/gU0x4NnduH/tGo=;
        b=Uw5ox4qoK+tiwNJytljXi9S6rvn6HY8q4CA1Z0qKALSZ1b6S0ttNJU4tlRpkJEwsGG
         K5E14DQUPF/n9al3BIk5Wd69mdn7QPzAsOLpKwuDKcQk2tv8n4WlBcaAALxs/wImrs8e
         4fHKxDdBystE6zeabxnsurOqo6FCZs/3H9sQy78x0PW7/U86zvfnqZovupRnoe91hAyF
         /H6aXkNICjxT1qH3CeU1CHrl2OLwYWeZQEyRNoGAEG3NOcy1dys7BEMSjVukbpur+CZM
         OmA2xNqPaw7Ymp+GPDC3R3jATTNIDqwJkuEgxLev0w1q3uuR8ovmAgwO0Spp3GvsdaGX
         i1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XbwAA+UV9EPS2eBIxxAE6MtJ2V0j/gU0x4NnduH/tGo=;
        b=hs4T5AC3feWUKkVAAo9/j5YwYc2ZxRlI5MeVCujqILtEYpFvSQqrddXS8ud0GAnciZ
         kgRNuCv+WAclX/7K89LVwUG/2qbd20pssURAg31iUyOYcUqAw7yDBb4aJ2pPlBrFc3Bx
         pxVmapSNWrep3qK6lhwXjW5R5Rw/ijVI33Xj0YQYSwDzl3CSNVKJAteiBMcNtlgx57xc
         1wsJMKApkFxqjBPK2FKSmY/jM8ZjuTbYoEfnx9Zcc4pjMULw9oAAVSZiZDDDQ6HP0jsP
         GE/pXB2wFHyaP3cIAnOxyiGFrmj2YihucSQ5NTgHdDCgY7YZDrAp8YCIU8ZCtU42sdoC
         fLbQ==
X-Gm-Message-State: AOAM532wCmQ9vwiiwRUzgfI169Wb8MJLJeQR30CtXs/zg7pS/naNNXbw
        GeG19Dz9G8hwTDsGaHDpGST6fA==
X-Google-Smtp-Source: ABdhPJz3x4PcIUtrHZDqnJVsGT3wJ9Nwu7VL4rnRukDmvPuwtIJOPqQH5SIYg1EKT+hP9pMFgOmZKw==
X-Received: by 2002:adf:f787:0:b0:20d:8e3:9439 with SMTP id q7-20020adff787000000b0020d08e39439mr8257040wrp.425.1652790254379;
        Tue, 17 May 2022 05:24:14 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p26-20020adfa21a000000b0020c61af5e1fsm11917542wra.51.2022.05.17.05.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 05:24:14 -0700 (PDT)
Date:   Tue, 17 May 2022 13:24:12 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoOT7Cyobsed5IE3@google.com>
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 17 May 2022, Jens Axboe wrote:

> On 5/17/22 5:41 AM, Lee Jones wrote:
> > Good afternoon Jens, Pavel, et al.,
> > 
> > Not sure if you are presently aware, but there appears to be a
> > use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> > in Stable v5.10.y.
> > 
> > The full sysbot report can be seen below [0].
> > 
> > The C-reproducer has been placed below that [1].
> > 
> > I had great success running this reproducer in an infinite loop.
> > 
> > My colleague reverse-bisected the fixing commit to:
> > 
> >   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >   Author: Jens Axboe <axboe@kernel.dk>
> >   Date:   Fri Feb 26 09:47:20 2021 -0700
> > 
> >        io-wq: have manager wait for all workers to exit
> > 
> >        Instead of having to wait separately on workers and manager, just have
> >        the manager wait on the workers. We use an atomic_t for the reference
> >        here, as we need to start at 0 and allow increment from that. Since the
> >        number of workers is naturally capped by the allowed nr of processes,
> >        and that uses an int, there is no risk of overflow.
> > 
> >        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> >     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >     1 file changed, 22 insertions(+), 8 deletions(-)
> 
> Does this fix it:
> 
> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Mar 5 12:59:30 2021 -0700
> 
>     io-wq: fix race in freeing 'wq' and worker access
> 
> Looks like it didn't make it into 5.10-stable, but we can certainly
> rectify that.

Thanks for your quick response Jens.

This patch doesn't apply cleanly to v5.10.y.

I'll have a go at back-porting it.  Please bear with me.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
