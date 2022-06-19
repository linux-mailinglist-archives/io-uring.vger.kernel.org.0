Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6293550C1F
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbiFSQi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 12:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiFSQi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 12:38:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A51CE39
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:38:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so8679622pjl.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=aNyX+fgSUloZ95IlRXcbILKvW0e96PXKvdoPhCpa1mc=;
        b=a7nMFzhXd8AHfBeV+5toxT+rhtQZyWJwWzdIP61IyhwPBaHpH20o3Ff5kUgOaR4G8n
         0PYePbs1Xf3J27ANHdkh61lhZATS73cm/tunffFnM4VyRFtYnAkTyqwZusaa66P8Ep/T
         d/bFwvzgi/7quHaj0DVHsZ3VBC1kA9FabgisMgDtA85fI+3fuV/msk10PD4JzDJNe4IZ
         LvbGGHrYRqDPuB3NLFg9suMGxLHRJPSC+/H3OU0maLZglGPwk+AdQipXK+Yb44/0F6Kd
         X6RjPz1VsfihKqe97NqbTtW2ejVluzOqll8B54e+TfOYtUa0oETF0u2qdeL9osmIUtpn
         xaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNyX+fgSUloZ95IlRXcbILKvW0e96PXKvdoPhCpa1mc=;
        b=wio32Leqs8QaC27g/R1qLzrMNa04T+lZ00C8ASIfX61kzQeOxOIC7B+Tm9kr0oRPkc
         Eq6Ln20e3uv7lmmmKopC67z5A6KmQZM1mc3Kw3iOn6/Fq6B5gcMh88ojbOSHp4Z48ffE
         7KUCMdeVmfUQZQ1rNOhcyPKPnq1Kqii4iwzUPre+iUet+kTIHUaHhKqxp8uwGPMDLhSW
         FcWPNEl/DUpQmISr1bjbGg54SI+QzfS6d3gdNrnVr6oKRe1LkZZJHr1zPSFhQaR4Dr3u
         DirCjfKVAjj7etS66LUVgfX2xoxWoq6+du/JVZBxsPZoY4qNCaSufWLoQv4qJ5EnBNeh
         7vjQ==
X-Gm-Message-State: AJIora/YrgNz3sbw4O+5dlv0GWmN/y9rIjdzEhHfNZDI2bqmnB1THV3U
        ujrWgPy/uyd3gKQBjidaRmbR6elkNTNG8g==
X-Google-Smtp-Source: AGRyM1tkrCtN96e0K/MpTpStl2wHnTXme6mxgIisTw+5x21CkDvQPknb4mEps4ynbsC9jSQPcqlauA==
X-Received: by 2002:a17:90a:408f:b0:1e3:23a:2370 with SMTP id l15-20020a17090a408f00b001e3023a2370mr22000343pjg.84.1655656737098;
        Sun, 19 Jun 2022 09:38:57 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id cp26-20020a056a00349a00b005251bea0d53sm1313897pfb.83.2022.06.19.09.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 09:38:56 -0700 (PDT)
Message-ID: <87739ce6-fead-baa1-fd77-bd18dfae7391@kernel.dk>
Date:   Sun, 19 Jun 2022 10:38:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
 <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
 <f42c7b8d-b144-434e-64a0-842209bdf31a@gmail.com>
 <17a15f3e-1257-3cc5-edf7-26876ca2a701@kernel.dk>
 <1b514266-94f5-aa5e-a382-18c28eecb9fc@gmail.com>
 <11f9a9b2-b6fa-cb1e-c4df-cc9201b4e61c@kernel.dk>
 <a34dfabc-69d8-406b-7696-8c3da3e9577a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a34dfabc-69d8-406b-7696-8c3da3e9577a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 10:19 AM, Pavel Begunkov wrote:
> On 6/19/22 17:17, Jens Axboe wrote:
>> On 6/19/22 10:15 AM, Pavel Begunkov wrote:
>>> On 6/19/22 16:52, Jens Axboe wrote:
>>>> On 6/19/22 8:52 AM, Pavel Begunkov wrote:
>>>>> On 6/19/22 14:31, Jens Axboe wrote:
>>>>>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>>>>>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>>>>>>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>>>>>>> high level of concurrency that enables it at least for one CQE, but
>>>>>>> sometimes it doesn't save much because nobody waiting on the CQ.
>>>>>>>
>>>>>>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>>>>>>> normal use case. Note, that there is no spurious eventfd problem with
>>>>>>> that as checks for spuriousness were incorporated into
>>>>>>> io_eventfd_signal().
>>>>>>
>>>>>> Would be note to quantify, which should be pretty easy. Eg run a nop
>>>>>> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
>>>>>> it to the extreme, and I do think it'd be nice to have an understanding
>>>>>> of how big the gap could potentially be.
>>>>>>
>>>>>> With luck, it doesn't really matter. Always nice to kill stuff like
>>>>>> this, if it isn't that impactful.
>>>>>
>>>>> Trying without this patch nops32 (submit 32 nops, complete all, repeat).
>>>>>
>>>>> 1) all CQE_SKIP:
>>>>>       ~51 Mreqs/s
>>>>> 2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
>>>>>       ~49 Mreq/s
>>>>> 3) same as 2) but another task waits on CQ (so we call wake_up_all)
>>>>>       ~36 Mreq/s
>>>>>
>>>>> And that's more or less expected. What is more interesting for me
>>>>> is how often for those using CQE_SKIP it helps to avoid this
>>>>> ev_posted()/etc. They obviously can't just mark all requests
>>>>> with it, and most probably helping only some quite niche cases.
>>>>
>>>> That's not too bad. But I think we disagree on CQE_SKIP being niche,
>>>
>>> I wasn't talking about CQE_SKIP but rather cases where that
>>> ->flush_cqes actually does anything. Consider that when at least
>>> one of the requests queued for inline completion is not CQE_SKIP
>>> ->flush_cqes is effectively disabled.
>>>
>>>> there are several standard cases where it makes sense. Provide buffers
>>>> is one, though that one we have a better solution for now. But also eg
>>>> OP_CLOSE is something that I'd personally use CQE_SKIP with always.
>>>>
>>>> Hence I don't think it's fair or reasonable to call it "quite niche" in
>>>> terms of general usability.
>>>>
>>>> But if this helps in terms of SINGLE_ISSUER, then I think it's worth it
>>>> as we'll likely see more broad appeal from that.
>>>
>>> It neither conflicts with the SINGLE_ISSUER locking optimisations
>>> nor with the meantioned mb() optimisation. So, if there is a good
>>> reason to leave ->flush_cqes alone we can drop the patch.
>>
>> Let me flip that around - is there a good reason NOT to leave the
>> optimization in there then?
> 
> Apart from ifs in the hot path with no understanding whether
> it helps anything, no

Let's just keep the patch. Ratio of skip to non-skip should still be
very tiny.

-- 
Jens Axboe

