Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDF652A1A0
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 14:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiEQMgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 08:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiEQMgt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 08:36:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48DD30F59
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:36:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h14so4917383wrc.6
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yh9KCD3prrmtE3wT14QIp/KiLRwsEOgLjY+dd/br9aM=;
        b=u05Y8niqeoVzLfYO77y8i8hMVDuTewNJJbexl4ODRci2203r1K0fKY9bvVdGOB5mn4
         bVMrP0r7GneRcIBIMgJD1BTN62sLCJoi+oea9YFo/9f+Wk4USFY06kuEH3e0bBcWSvnA
         s5zAgVJ5eW3eI9YDtRlTRW451z/7sZcSTX7FMd0tcr8XF58BIpU+VNjFNNTu1wQKLB8R
         3c7Yz9FfDQENoh9AtnPWRQNEosyPPMP2G4Bg2Il3d3N8HEvGVNvUmNVw7t8EDUjp1flv
         WVslgR3Bi4vqE6pZ7Nvzlkd7Ss/ZlRYMrBXaFsjiqgwKJhD+5LJo09Q723axwUxUqpPa
         AG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yh9KCD3prrmtE3wT14QIp/KiLRwsEOgLjY+dd/br9aM=;
        b=1c7bxjlBTLUa5YLm0RYCvKStEyBgaeFGF3daAy3Z1OOVTeKMPq4fGfgfjYRAZFtypo
         4TfyXdV6+f9w4TS0DgGyL5/eW9Jj2P3j27NZy38v5H+8pbmfA9PJ1gJKrbyve4uGPM+/
         6XHJrJYpkLGZRlSxvTMWnngO5E1KziVD6+ghepyN7j5ziqGfWZ6bCPKE+gPALAv9COO0
         0lIGkUKFQGilaMazSK4zhsRqA8PklaVZvwn8mNVJuRVwMgwK7JavIuIKhLxBuirdo2bD
         oJ/uN/vxNj3Bl7vxr1soAjnQpENS1lXYxathrUa5NAx+NP5DjP4kXnTBMAD/6ieSw13b
         3juQ==
X-Gm-Message-State: AOAM530l9D0zW2vT/QuRoujMpIA3vqIy5Jo02WHM6UvtGlezb5uOprdv
        eWREx7EkocCO5TlcRpKTul6+OQ==
X-Google-Smtp-Source: ABdhPJzKrtC8VWaJvzTf7lZpSvoGPSyOvAwojNTFmifbEtZlEYHySohWNBzK0i2sBlEfWLbMT4VAag==
X-Received: by 2002:a5d:470c:0:b0:20d:135:2fb3 with SMTP id y12-20020a5d470c000000b0020d01352fb3mr12009595wrq.559.1652791005419;
        Tue, 17 May 2022 05:36:45 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id g2-20020adfa482000000b0020c5253d8dfsm12328385wrb.43.2022.05.17.05.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 05:36:44 -0700 (PDT)
Date:   Tue, 17 May 2022 13:36:43 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoOW2+ov8KF1YcYF@google.com>
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
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

> On 5/17/22 6:24 AM, Lee Jones wrote:
> > On Tue, 17 May 2022, Jens Axboe wrote:
> > 
> >> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>> Good afternoon Jens, Pavel, et al.,
> >>>
> >>> Not sure if you are presently aware, but there appears to be a
> >>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>> in Stable v5.10.y.
> >>>
> >>> The full sysbot report can be seen below [0].
> >>>
> >>> The C-reproducer has been placed below that [1].
> >>>
> >>> I had great success running this reproducer in an infinite loop.
> >>>
> >>> My colleague reverse-bisected the fixing commit to:
> >>>
> >>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>
> >>>        io-wq: have manager wait for all workers to exit
> >>>
> >>>        Instead of having to wait separately on workers and manager, just have
> >>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>        number of workers is naturally capped by the allowed nr of processes,
> >>>        and that uses an int, there is no risk of overflow.
> >>>
> >>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>
> >>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>
> >> Does this fix it:
> >>
> >> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >> Author: Jens Axboe <axboe@kernel.dk>
> >> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>
> >>     io-wq: fix race in freeing 'wq' and worker access
> >>
> >> Looks like it didn't make it into 5.10-stable, but we can certainly
> >> rectify that.
> > 
> > Thanks for your quick response Jens.
> > 
> > This patch doesn't apply cleanly to v5.10.y.
> 
> This is probably why it never made it into 5.10-stable :-/

Right.  It doesn't apply at all unfortunately.

> > I'll have a go at back-porting it.  Please bear with me.
> 
> Let me know if you into issues with that and I can help out.

I think the dependency list is too big.

Too much has changed that was never back-ported.

Actually the list of patches pertaining to fs/io-wq.c alone isn't so
bad, I did start to back-port them all but some of the big ones have
fs/io_uring.c changes incorporated and that list is huge (256 patches
from v5.10 to the fixing patch mentioned above).

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
