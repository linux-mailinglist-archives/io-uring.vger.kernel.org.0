Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD2952A292
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346753AbiEQNCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 09:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347736AbiEQNBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 09:01:46 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572214EF68
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 06:00:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so1346936wms.3
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 06:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hTDpAt4z3gikC5fIZlVTEXyjKubj5mCSOIyJGV5bOEk=;
        b=TwKRGMXyAsKdMp+OhP41DTK6iodN5iWX+XUimZ2fL7iC4A3XCMFvGEy9/Mu144KfpG
         ExhbJywxtpWcJskyeb2Mm2lB7C5uxBUojTJpZaGgAPUGIx45cd46zP32S9ikVWfUnKZv
         mQ85HvydKtt+14xSujVuxAUGqjzHTG09j3CvUmkV0RfMOomKbiI8KPr+uoQj19+LvLk2
         OW7FcjaiAgTTUZvuZs5zQW8y2Jy/CZP0ysmj0uiHBKc4GLvLHW/RYg30jMRbB8WX6zN7
         cLz2SsEj+UWriGMEZQ2mm9Pkm83vFH99B9l0fIimP8vBRAwncNMpb6uW84WbktUzG/xq
         4A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hTDpAt4z3gikC5fIZlVTEXyjKubj5mCSOIyJGV5bOEk=;
        b=S2uJJSFcnRFfCwZcrNmSaRxlz7Uo7lSOaOM2rNgD+ogVOko31fsXzcjeBNFltjRCPN
         BtlnDEn0OR0VkUCFzmeYVBna2SM4QeSciA8wpZNuxkha/fcf4ZYNOlRUGt2MXf72feF7
         GoGk2CD8LyuOrth1+zktY2TYrzDR/Q171cALrxtFT21aGwDQXyH3ltPv/+jWOK2xft9K
         kHAp+pwsYNVoy+qHyGgy8E3t9mVJ++KPK3MTZ8dhNywEE/gTdEOvmZnX9qZqjIe6gWLR
         5JAYkYBrQmxyWY4/pyC59m6MIzt3lY3ouFdbhj/PtW76IBE8nGqGOCEZUgZ51WhYuyu5
         9z7w==
X-Gm-Message-State: AOAM532dh26MwIo4gPEQJ6y2qlTx8/DvVlrCpBNg1EkYCxDFGWjmUZ9P
        w8WGzaaNTm/egUOyEOx+0lxskw==
X-Google-Smtp-Source: ABdhPJyoKyEE7TB6l8iioIYiAagTloLPeUZ5LPP5lDoTkEkdpgilKO0SgyL71GvVJfAaPAbbNuz4bQ==
X-Received: by 2002:a05:600c:3798:b0:394:454a:df74 with SMTP id o24-20020a05600c379800b00394454adf74mr32307755wmr.174.1652792419769;
        Tue, 17 May 2022 06:00:19 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c500600b00395b809dfd3sm1905650wmr.12.2022.05.17.06.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 06:00:19 -0700 (PDT)
Date:   Tue, 17 May 2022 14:00:17 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoOcYR15Jhkw2XwL@google.com>
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 17 May 2022, Jens Axboe wrote:

> On 5/17/22 6:36 AM, Lee Jones wrote:
> > On Tue, 17 May 2022, Jens Axboe wrote:
> > 
> >> On 5/17/22 6:24 AM, Lee Jones wrote:
> >>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>
> >>>> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>>>> Good afternoon Jens, Pavel, et al.,
> >>>>>
> >>>>> Not sure if you are presently aware, but there appears to be a
> >>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>>>> in Stable v5.10.y.
> >>>>>
> >>>>> The full sysbot report can be seen below [0].
> >>>>>
> >>>>> The C-reproducer has been placed below that [1].
> >>>>>
> >>>>> I had great success running this reproducer in an infinite loop.
> >>>>>
> >>>>> My colleague reverse-bisected the fixing commit to:
> >>>>>
> >>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>>>
> >>>>>        io-wq: have manager wait for all workers to exit
> >>>>>
> >>>>>        Instead of having to wait separately on workers and manager, just have
> >>>>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>>>        number of workers is naturally capped by the allowed nr of processes,
> >>>>>        and that uses an int, there is no risk of overflow.
> >>>>>
> >>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>
> >>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>>>
> >>>> Does this fix it:
> >>>>
> >>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>>>
> >>>>     io-wq: fix race in freeing 'wq' and worker access
> >>>>
> >>>> Looks like it didn't make it into 5.10-stable, but we can certainly
> >>>> rectify that.
> >>>
> >>> Thanks for your quick response Jens.
> >>>
> >>> This patch doesn't apply cleanly to v5.10.y.
> >>
> >> This is probably why it never made it into 5.10-stable :-/
> > 
> > Right.  It doesn't apply at all unfortunately.
> > 
> >>> I'll have a go at back-porting it.  Please bear with me.
> >>
> >> Let me know if you into issues with that and I can help out.
> > 
> > I think the dependency list is too big.
> > 
> > Too much has changed that was never back-ported.
> > 
> > Actually the list of patches pertaining to fs/io-wq.c alone isn't so
> > bad, I did start to back-port them all but some of the big ones have
> > fs/io_uring.c changes incorporated and that list is huge (256 patches
> > from v5.10 to the fixing patch mentioned above).
> 
> The problem is that 5.12 went to the new worker setup, and this patch
> landed after that even though it also applies to the pre-native workers.
> Hence the dependency chain isn't really as long as it seems, probably
> just a few patches backporting the change references and completions.
> 
> I'll take a look this afternoon.

Thanks Jens.  I really appreciate it.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
