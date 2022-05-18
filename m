Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939DD52BEB3
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiERPQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbiERPOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 11:14:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E01E0106
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 08:14:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s28so3028848wrb.7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 08:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+LQogaNeLDAS97QlCWLMJmUyFddvKMyNGiPi+yDq2F0=;
        b=n5xi3tHdutaDh9rrQj2apRUFkB6OjbZliJwoJ7XQIWlnrUW5F05sPh42Hwf1rzAIuW
         DrAS9zX6HFAMvX6Iy2qQj8RQx9k5H32X8iai7ZKcAcuWhfLvCaYYxA0g9D4o9/mtRHub
         6DsUvK8S7vdORqiMsNa/FGE1H6kw9smloxYwFWsCd2WC8dwdmD8UZAmRJtlnvLjX6hLd
         U5fn3xRN5vF0bf39UvDCNgWWAE6WGFRVrsmLd+ClR1EFvgI1x5rta1xjKDpuWSB+GXHE
         nRmsIj+MddXNS9FoJs3cMF39J982LzjbOixh+vpd1ckXvAVBjBY6c/02qwpkoX2VpOvg
         /q3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+LQogaNeLDAS97QlCWLMJmUyFddvKMyNGiPi+yDq2F0=;
        b=MaVEc75ygc3Tl1otl8zR52/klbvC1DnESeh4+1pD3+5g3BHfxs7boH8tcyr9dJ1eeg
         J+47RPPUJg2SqhkpA5Pg+OSCCOth0TIZ3kQMnZTGzH7FHdSpEjxFTDrVm/CMJoj7Dwny
         ddmoSmGyEdVIJA+kCYRr03TdbqbaA+ZiYYIwUW+/Q05rUKHhs+rthanRJyNPxq5DKLc+
         ZysFYbBODoJvDcFKrmZE973FdIvzPVxH6wmJmVny3wP7gl0z+dWFraPepCfpwc+RZtZ8
         Ucb1q21Q2jvlI2HWv+aLYpdUhnHUwzbmgPKUewti5BAf6fKtcItomz2KjIHAfVDKoOMw
         nWtA==
X-Gm-Message-State: AOAM532X/0uymqwuxMLIOxz28Ukrrt30a8Ut2Tq9Pliav2dOdBmHPoi6
        gMml4Bbw8k2BWizvyjocDPDsag==
X-Google-Smtp-Source: ABdhPJyXcejc46FtV9lcG+iVTF5hR4aDmYrlea0kN4aHfbpAK+gmuRJ4CMZkLDs62u6ZfzkTCUPTWw==
X-Received: by 2002:a5d:620f:0:b0:20c:c1ba:cf8e with SMTP id y15-20020a5d620f000000b0020cc1bacf8emr163475wru.426.1652886852771;
        Wed, 18 May 2022 08:14:12 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p11-20020a5d59ab000000b0020e615bab7bsm2127288wrr.7.2022.05.18.08.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:14:12 -0700 (PDT)
Date:   Wed, 18 May 2022 16:14:10 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoUNQlzU0W4ShA85@google.com>
References: <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 18 May 2022, Jens Axboe wrote:

> On 5/18/22 6:54 AM, Jens Axboe wrote:
> > On 5/18/22 6:52 AM, Jens Axboe wrote:
> >> On 5/18/22 6:50 AM, Lee Jones wrote:
> >>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>
> >>>> On 5/17/22 7:00 AM, Lee Jones wrote:
> >>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>
> >>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
> >>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>
> >>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
> >>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>
> >>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
> >>>>>>>>>>>
> >>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
> >>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>>>>>>>>>> in Stable v5.10.y.
> >>>>>>>>>>>
> >>>>>>>>>>> The full sysbot report can be seen below [0].
> >>>>>>>>>>>
> >>>>>>>>>>> The C-reproducer has been placed below that [1].
> >>>>>>>>>>>
> >>>>>>>>>>> I had great success running this reproducer in an infinite loop.
> >>>>>>>>>>>
> >>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
> >>>>>>>>>>>
> >>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>>>>>>>>>
> >>>>>>>>>>>        io-wq: have manager wait for all workers to exit
> >>>>>>>>>>>
> >>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
> >>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
> >>>>>>>>>>>        and that uses an int, there is no risk of overflow.
> >>>>>>>>>>>
> >>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>
> >>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> Does this fix it:
> >>>>>>>>>>
> >>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>>>>>>>>>
> >>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
> >>>>>>>>>>
> >>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
> >>>>>>>>>> rectify that.
> >>>>>>>>>
> >>>>>>>>> Thanks for your quick response Jens.
> >>>>>>>>>
> >>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
> >>>>>>>>
> >>>>>>>> This is probably why it never made it into 5.10-stable :-/
> >>>>>>>
> >>>>>>> Right.  It doesn't apply at all unfortunately.
> >>>>>>>
> >>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
> >>>>>>>>
> >>>>>>>> Let me know if you into issues with that and I can help out.
> >>>>>>>
> >>>>>>> I think the dependency list is too big.
> >>>>>>>
> >>>>>>> Too much has changed that was never back-ported.
> >>>>>>>
> >>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
> >>>>>>> bad, I did start to back-port them all but some of the big ones have
> >>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
> >>>>>>> from v5.10 to the fixing patch mentioned above).
> >>>>>>
> >>>>>> The problem is that 5.12 went to the new worker setup, and this patch
> >>>>>> landed after that even though it also applies to the pre-native workers.
> >>>>>> Hence the dependency chain isn't really as long as it seems, probably
> >>>>>> just a few patches backporting the change references and completions.
> >>>>>>
> >>>>>> I'll take a look this afternoon.
> >>>>>
> >>>>> Thanks Jens.  I really appreciate it.
> >>>>
> >>>> Can you see if this helps? Untested...
> >>>
> >>> What base does this apply against please?
> >>>
> >>> I tried Mainline and v5.10.116 and both failed.
> >>
> >> It's against 5.10.116, so that's puzzling. Let me double check I sent
> >> the right one...
> > 
> > Looks like I sent the one from the wrong directory, sorry about that.
> > This one should be better:
> 
> Nope, both are the right one. Maybe your mailer is mangling the patch?
> I'll attach it gzip'ed here in case that helps.

Okay, that applied, thanks.

Unfortunately, I am still able to crash the kernel in the same way.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
