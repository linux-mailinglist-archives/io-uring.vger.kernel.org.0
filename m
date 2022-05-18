Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91352BFF7
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiERQep (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 12:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbiERQen (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 12:34:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489761F8C4B
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 09:34:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s28so3341475wrb.7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xAOohEZien8Q5pI9ff0to291LHxkqtD9uRCi4y7JwVU=;
        b=vNYoWpUDGiiAOtTCwXgIZEAeloWS0FuvvM/74rLIV0eQuZm/F9YQXomV2qYCiDxnho
         AMG5/iE4kmp/Z9zWoud0T0tuvVmkJE31v6zDIe9t/ANQ1tsYoCV1Rgc3Yo+lC4nqfagt
         GU/GAhbGxtVCpYvk4EzSCyir6wPpqhznqLM3etWq96wDvoO/EngdC2E0VoEBp0WuWrCN
         qUbq3fyVSDnTLd3NWws/taceGgDr05YNQy7UXlo3N7bALFHJSZTv++QBgF003akgUVug
         ciWUNkjMlubZh1YX6+dnvFhwP08Q8X/QAM5nv8aq2xt9VhKCv1cicqQYFWGCBjgQpalK
         EDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xAOohEZien8Q5pI9ff0to291LHxkqtD9uRCi4y7JwVU=;
        b=okxCpEvMLAAn+frIkAo0pzcpJiVBRA3jpX7M1XX7fuHIInhqpdm3wi2e/sHRR9PVc6
         DeH2PUQpefY7Pybwf2pMAH2awK5jg5zGUq4iW4o43m28dHBSGCj98VcwF3uZ59htqpCN
         x7i7GIqwQ5jdRDCe0RqVdrcqIU0sNO2AYkGRP7rI1n7zSKhrNZuBVuwQvUh4KNqlgN+q
         7xRm8vuVcUVjB03tjjvB02Uxg2Fa5Jsb44+0tBtAK3Iu+lBHjM5xGUQ34oKeQHnhGd7b
         Fssy2wBa1H1wo7PqzGHO2SUA4O5pwhjUgPRNlhazJqu/o5ghTPSjTGFmpnN0PGTbylwW
         j2wg==
X-Gm-Message-State: AOAM5312eiEsOocx0cs3SatzKIvWkdoypz+8F5IobjMXlZcgr4qcNPDe
        ICHs/IxfA3IPMLxIRWCwV1yxnQ==
X-Google-Smtp-Source: ABdhPJx41CwyvJGgDp3rKk1MqgtoQPkT3q9OpvsPYVWXX1hqWexMZN+Zkvt+lYCFhs4ofl5uyCAxwQ==
X-Received: by 2002:a05:6000:1866:b0:20d:2834:5155 with SMTP id d6-20020a056000186600b0020d28345155mr459637wri.101.1652891680807;
        Wed, 18 May 2022 09:34:40 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id j10-20020adfa78a000000b0020c5253d8fcsm2836584wrc.72.2022.05.18.09.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:34:40 -0700 (PDT)
Date:   Wed, 18 May 2022 17:34:38 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoUgHjHn+UFvj0o1@google.com>
References: <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
 <YoUNQlzU0W4ShA85@google.com>
 <49609b89-f2f0-44b3-d732-dfcb4f73cee1@kernel.dk>
 <YoUTPIVOhLlnIO04@google.com>
 <1e64d20a-42cc-31cd-0fd8-2718dd8b1f31@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e64d20a-42cc-31cd-0fd8-2718dd8b1f31@kernel.dk>
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

> On 5/18/22 09:39, Lee Jones wrote:
> > On Wed, 18 May 2022, Jens Axboe wrote:
> > 
> >> On 5/18/22 9:14 AM, Lee Jones wrote:
> >>> On Wed, 18 May 2022, Jens Axboe wrote:
> >>>
> >>>> On 5/18/22 6:54 AM, Jens Axboe wrote:
> >>>>> On 5/18/22 6:52 AM, Jens Axboe wrote:
> >>>>>> On 5/18/22 6:50 AM, Lee Jones wrote:
> >>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>
> >>>>>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
> >>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>
> >>>>>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
> >>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>>>
> >>>>>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
> >>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>>>>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
> >>>>>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>>>>>>>>>>>>>> in Stable v5.10.y.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> The full sysbot report can be seen below [0].
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> The C-reproducer has been placed below that [1].
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>>>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
> >>>>>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>>>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>>>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
> >>>>>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>>>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Does this fix it:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >>>>>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
> >>>>>>>>>>>>>> rectify that.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Thanks for your quick response Jens.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
> >>>>>>>>>>>>
> >>>>>>>>>>>> This is probably why it never made it into 5.10-stable :-/
> >>>>>>>>>>>
> >>>>>>>>>>> Right.  It doesn't apply at all unfortunately.
> >>>>>>>>>>>
> >>>>>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Let me know if you into issues with that and I can help out.
> >>>>>>>>>>>
> >>>>>>>>>>> I think the dependency list is too big.
> >>>>>>>>>>>
> >>>>>>>>>>> Too much has changed that was never back-ported.
> >>>>>>>>>>>
> >>>>>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
> >>>>>>>>>>> bad, I did start to back-port them all but some of the big ones have
> >>>>>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
> >>>>>>>>>>> from v5.10 to the fixing patch mentioned above).
> >>>>>>>>>>
> >>>>>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
> >>>>>>>>>> landed after that even though it also applies to the pre-native workers.
> >>>>>>>>>> Hence the dependency chain isn't really as long as it seems, probably
> >>>>>>>>>> just a few patches backporting the change references and completions.
> >>>>>>>>>>
> >>>>>>>>>> I'll take a look this afternoon.
> >>>>>>>>>
> >>>>>>>>> Thanks Jens.  I really appreciate it.
> >>>>>>>>
> >>>>>>>> Can you see if this helps? Untested...
> >>>>>>>
> >>>>>>> What base does this apply against please?
> >>>>>>>
> >>>>>>> I tried Mainline and v5.10.116 and both failed.
> >>>>>>
> >>>>>> It's against 5.10.116, so that's puzzling. Let me double check I sent
> >>>>>> the right one...
> >>>>>
> >>>>> Looks like I sent the one from the wrong directory, sorry about that.
> >>>>> This one should be better:
> >>>>
> >>>> Nope, both are the right one. Maybe your mailer is mangling the patch?
> >>>> I'll attach it gzip'ed here in case that helps.
> >>>
> >>> Okay, that applied, thanks.
> >>>
> >>> Unfortunately, I am still able to crash the kernel in the same way.
> >>
> >> Alright, maybe it's not enough. I can't get your reproducer to crash,
> >> unfortunately. I'll try on a different box.
> > 
> > You need to have fuzzing and kasan enabled.
> 
> I do have kasan enabled. What's fuzzing?

CONFIG_KCOV

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
