Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABB550C08
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiFSQRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 12:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiFSQQ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 12:16:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CA564CA
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:16:25 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v14so11611800wra.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=BlWsLrFBUqfxDBbfCymhh9C4Hb3cHgYCHrwmM0/CDSQ=;
        b=i5psAWFyzOCJt66+rAQhtwrbVn8+b137ZM77GdMQImJBPCDpw2Fxpcgsy2Dk5gpdPy
         wVOLwTs945Sdd0cZw9swfAQbUzexgr4Gn5QwprtnIle2dGWxGLU/Z7sO0ROVmsIXOH4d
         0eBkeDphswIZ1NjTQGDJel5HybeDmKxU3Mg5IEyZbOSTCAwOPmeUPRHNg9Plb/H58OvV
         Ip/CEl7XYP/EO6oFZ8XY8s/XtMzThZhnjwGvWp6wKNCp0hL+U8Z3ak0xYvUk8QNL+Gut
         FQ3P+ySj81m3AJ+aRYsyCF2htUDN4V7TiKwxW2gYAdm2P1mDLPxdW51xrUo4ayE2un2b
         c/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BlWsLrFBUqfxDBbfCymhh9C4Hb3cHgYCHrwmM0/CDSQ=;
        b=WKu+fP8+iCUFF81W1IcTHAov1iIzrrY0zpIaduHT3s2wl0nhthE7atyUhY47sTRwMb
         iCjYspx8k5TcHRTGYVqXIpEm/v3WJbcAsvagQwXCXKqv0RCJkvbIAA0pknPZ2615750L
         gWl5a2EBpGX9AmwSXmf0cM9HK3a3g9Tx6NXMB4JHGD6xz4vWHR6hAyH02de6SvgDWEbu
         a12tXBOU9mtn9z0SZjLhEycqvJPMm71w++Ze0jD3bPcRcpAKF1YaPwVu6jKb6FyIbSBc
         D7lzSd3zwU6Hz3s1/uDjk3jk126jfez2xoPnNqf6uCctoX6hScaNOdXvZdDR8ZYVIkp4
         aSNQ==
X-Gm-Message-State: AJIora91evVrq6Icf+Y5CtLk3yt38J6G2USZFjisLmruiCG3y8K+9/C7
        KGW2wvj/+d1CqnqgqL2czdPj0WUhQ2u7Ig==
X-Google-Smtp-Source: AGRyM1sS5PP+DCY+ySmTMxx+fqY1xgeI5NNJtsXbxRsUVAyXvEqOK7YdfYIy8lAozK+b7k/POTRupw==
X-Received: by 2002:adf:e19e:0:b0:211:7169:dfa6 with SMTP id az30-20020adfe19e000000b002117169dfa6mr18757560wrb.654.1655655384089;
        Sun, 19 Jun 2022 09:16:24 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id l8-20020a1ced08000000b0039744bd664esm15690746wmh.13.2022.06.19.09.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 09:16:23 -0700 (PDT)
Message-ID: <1b514266-94f5-aa5e-a382-18c28eecb9fc@gmail.com>
Date:   Sun, 19 Jun 2022 17:15:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
 <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
 <f42c7b8d-b144-434e-64a0-842209bdf31a@gmail.com>
 <17a15f3e-1257-3cc5-edf7-26876ca2a701@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <17a15f3e-1257-3cc5-edf7-26876ca2a701@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 16:52, Jens Axboe wrote:
> On 6/19/22 8:52 AM, Pavel Begunkov wrote:
>> On 6/19/22 14:31, Jens Axboe wrote:
>>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>>>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>>>> high level of concurrency that enables it at least for one CQE, but
>>>> sometimes it doesn't save much because nobody waiting on the CQ.
>>>>
>>>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>>>> normal use case. Note, that there is no spurious eventfd problem with
>>>> that as checks for spuriousness were incorporated into
>>>> io_eventfd_signal().
>>>
>>> Would be note to quantify, which should be pretty easy. Eg run a nop
>>> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
>>> it to the extreme, and I do think it'd be nice to have an understanding
>>> of how big the gap could potentially be.
>>>
>>> With luck, it doesn't really matter. Always nice to kill stuff like
>>> this, if it isn't that impactful.
>>
>> Trying without this patch nops32 (submit 32 nops, complete all, repeat).
>>
>> 1) all CQE_SKIP:
>>      ~51 Mreqs/s
>> 2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
>>      ~49 Mreq/s
>> 3) same as 2) but another task waits on CQ (so we call wake_up_all)
>>      ~36 Mreq/s
>>
>> And that's more or less expected. What is more interesting for me
>> is how often for those using CQE_SKIP it helps to avoid this
>> ev_posted()/etc. They obviously can't just mark all requests
>> with it, and most probably helping only some quite niche cases.
> 
> That's not too bad. But I think we disagree on CQE_SKIP being niche,

I wasn't talking about CQE_SKIP but rather cases where that
->flush_cqes actually does anything. Consider that when at least
one of the requests queued for inline completion is not CQE_SKIP
->flush_cqes is effectively disabled.

> there are several standard cases where it makes sense. Provide buffers
> is one, though that one we have a better solution for now. But also eg
> OP_CLOSE is something that I'd personally use CQE_SKIP with always.
> 
> Hence I don't think it's fair or reasonable to call it "quite niche" in
> terms of general usability.
> 
> But if this helps in terms of SINGLE_ISSUER, then I think it's worth it
> as we'll likely see more broad appeal from that.

It neither conflicts with the SINGLE_ISSUER locking optimisations
nor with the meantioned mb() optimisation. So, if there is a good
reason to leave ->flush_cqes alone we can drop the patch.

-- 
Pavel Begunkov
