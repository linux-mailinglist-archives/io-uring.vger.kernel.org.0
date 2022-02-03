Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238914A9090
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 23:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355750AbiBCWSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 17:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiBCWSE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 17:18:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31B2C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 14:18:03 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so4381521pjb.1
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 14:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CI+TrdL82OQQxeiluz+GiOaNTL5TYAX8y0U9DtiXimQ=;
        b=tcx4lyXHkmXI8kYXLylx8fONteuzxJoULKgubqIec2UYSgXZdnaCQ5vSsNJxdrnaFw
         kh2HQXLTbOHQEziZwax9cnp63U7LX0PfoxyUSCarrDOniCikZp7qJpNutGG+2GJwprVE
         JDiR5XV175E1hQODy/bOyuqgYyRD243YIKFsC93H+IVOm8e2JWPU+vJ8MX9p/5hMNi4A
         JYuSvAj4CkeD6UW5AAE0Hs31+BKBD1OEaotI7S9LEsdE6Xz1axmXxIWvv3PmByB0jTO/
         mYgdvw9ZJwFAhENqS2jrKnK7E2L4X/O/I/Dn8VwnoRpXUhVsW3KK1op5rr5GGmdbs/fU
         s6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CI+TrdL82OQQxeiluz+GiOaNTL5TYAX8y0U9DtiXimQ=;
        b=0C436awdZ98mSngWKALF5QvlTsoRAmlc4h/MCqQw7QTyOb0dujPr2DT05peLLAL3UG
         jsqUpHKGb2mlLXP7M/bbEF6HSZjaeq3twUT3PcU9iSVg0yD6ml73Y4spsGqSI6A1dszy
         ij8PlGRAL/hpF0lPBcqMu2CTjfDyfLuMCW84zDyrqTdUan1ENNAS6np93zUDuXBBFAgp
         ot1FGU7TyW9DWuMPsoK1zjkAN4NB4f6r/AGIpvfuAVTpCYYVyXB3u/yL/WDp8lzi9di5
         NRSdBT47wxq9K3Yy9T8acPbFEzrgHAtDGBfsb1jCbOXd96gsuvpccQTdLj64OOtXHhsb
         eIqA==
X-Gm-Message-State: AOAM533Oc2e+vv0ipNZtPIq+s7w3puHLhZC5+p32Z9cMyUtvaowcAyw+
        nqGqfPImkNxqcRH4bVxFURjDYg==
X-Google-Smtp-Source: ABdhPJwXPgkPlEYDhOLaV+ilqpTCRlmFVIHbATHY+StH+kzmMg/O7EXJ6gXmw0AHbPqAXoh/bCtDSQ==
X-Received: by 2002:a17:90a:f418:: with SMTP id ch24mr21788pjb.154.1643926683237;
        Thu, 03 Feb 2022 14:18:03 -0800 (PST)
Received: from ?IPv6:2600:380:7677:2608:7e4f:2c76:b02e:3fbc? ([2600:380:7677:2608:7e4f:2c76:b02e:3fbc])
        by smtp.gmail.com with ESMTPSA id d12sm31782pgk.29.2022.02.03.14.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:18:02 -0800 (PST)
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
 <fc5a2421-f775-8195-39df-8e4bcda38af1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b06201e7-98dd-a087-cdf4-1a4ea45767f0@kernel.dk>
Date:   Thu, 3 Feb 2022 15:18:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fc5a2421-f775-8195-39df-8e4bcda38af1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 12:43 PM, Pavel Begunkov wrote:
> On 2/3/22 19:06, Jens Axboe wrote:
>> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>>> On 2/3/22 18:29, Jens Axboe wrote:
>>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>>
>>>> They are cheap, but they are still noticeable at high requests/sec
>>>> rates. So would be best to avoid them.
>>>>
>>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>>> notification if it races with registering an eventfd descriptor. But
>>>> that's not really a concern, as if you register with inflight IO
>>>> pending, then that always exists just depending on timing. The only
>>>> thing I care about here is that it's always _safe_. Hence something ala
>>>> what you did below is totally fine, as we're re-evaluating under rcu
>>>> protection.
>>>
>>> Indeed, the patch doesn't have any formal guarantees for propagation
>>> to already inflight requests, so this extra unsynchronised check
>>> doesn't change anything.
>>>
>>> I'm still more сurious why we need RCU and extra complexity when
>>> apparently there is no use case for that. If it's only about
>>> initial initialisation, then as I described there is a much
>>> simpler approach.
>>
>> Would be nice if we could get rid of the quiesce code in general, but I
>> haven't done a check to see what'd be missing after this...
> 
> Ok, I do think full quiesce is worth keeping as don't think all
> registered parts need dynamic update. E.g. zc notification dynamic
> reregistation doesn't make sense and I'd rather rely on existing
> straightforward mechanisms than adding extra bits, even if it's
> rsrc_nodes. That's not mentioning unnecessary extra overhead.
> 
> btw, I wouldn't say this eventfd specific sync is much simpler than
> the whole full quiesce.

It's easier to understand though, as it follows the usual rules of
RCU which are used throughout the kernel.

On quiesce in general, my curiosity was around whether we'd ever
get to the point where all register handlers are marked as not
needing quisce, and it seems it isn't that far off.

-- 
Jens Axboe

