Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6E6452C8
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 05:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLGEAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 23:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGEAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 23:00:32 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE702D74D
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 20:00:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id b2so11049820eja.7
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 20:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BESs6WI+64Lli61mwHWLMRizimdMH3q/lklV7tIDQ38=;
        b=M9H5KDZu2Ya0XLSzxC4ZyBS9ZA8wT5WQqY2DjP9jKD5qJUuSI/4eAGtZlIC3enpZ30
         GMBTDrTlp+5jTi1RqvEhxOsh1a4/5jiihmFbD21sUgs6MZESqjyvf67A+8DuuFLPkgxW
         leFVC7BD/KFPmFNDBZ1w1Xs9IJZ9JjhqbHLD13oZHN3OgcFhnq/5fn0Glq+RZ4xde3a3
         cE28e4aoyzYIR2ICgOLSEtvC7Dnxbwwqku44062yTCp6fBfzh+qW87ixOdnW8MA0L525
         oG7TFmEtmJM/4tCbkeJBXg/AkADL1NBzfSoYEHCVbfJr/sBBk275qlIUrnJ3yDs7Iosu
         dx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BESs6WI+64Lli61mwHWLMRizimdMH3q/lklV7tIDQ38=;
        b=5tWbDaf7vGhoZiMsAH3QnaBbOwJOeaGH8eWXHzQ/7aeVCj45MxYWYgg59PvpZQA1CO
         pzM/p8ge0b1gn8TfhHccDXwjBJmBnVki2CIbRPiFNMfGCgLKPEm0B3KiPtGPWRBDzpdu
         de1oEmKhZGXQF4JRj5WKoEy2HL79Kmdp3T5jeLPdpbL+PVyKSHC4lHfuaBEhR4sWV+Mc
         abPPIIrtjOMFc9F1zUJvma4PtjpGqwlJojLjQRBvaj/yhSWULATgRAIZpldKPwdSUh5y
         32B7wYtUb552gS4gm8IKDffFkPDd8PhFM3/ydgnDvxBVygsf3e4UNelg0zCj0aRTJmdF
         Z5vw==
X-Gm-Message-State: ANoB5pn1wM5cVykatbfG8o1+1ZAfvPDNp28ZkwRHCxITxs+owzuZu7+9
        W35WMBP7aLh0fjjkm87DEA/YxrbUsp4=
X-Google-Smtp-Source: AA0mqf7Z9qKRP4jLY6p/drToyr+SnTsRL7oW8a471AJPIlEbg1Q3w5j+5NgNwqWceyJoqFiVItM+dQ==
X-Received: by 2002:a17:906:b088:b0:7bd:6295:cdd with SMTP id x8-20020a170906b08800b007bd62950cddmr42850056ejy.534.1670385630015;
        Tue, 06 Dec 2022 20:00:30 -0800 (PST)
Received: from [192.168.8.100] (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id a11-20020aa7d90b000000b00462bd673453sm1704573edr.39.2022.12.06.20.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 20:00:29 -0800 (PST)
Message-ID: <63bd3dc2-b2f6-ea7c-916c-33058f35df2e@gmail.com>
Date:   Wed, 7 Dec 2022 03:59:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
 <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
 <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
 <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
 <03be41e8-fafd-2563-116c-71c52a27409f@gmail.com>
 <4654437d-eb17-2832-ceae-6c45d6458006@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4654437d-eb17-2832-ceae-6c45d6458006@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 16:06, Jens Axboe wrote:
> On 12/6/22 3:42?AM, Pavel Begunkov wrote:
>> On 12/5/22 15:18, Jens Axboe wrote:
>>> On 12/5/22 8:12?AM, Dylan Yudaken wrote:
>>>> On Mon, 2022-12-05 at 04:53 -0700, Jens Axboe wrote:
>>>>> On 12/4/22 7:44?PM, Pavel Begunkov wrote:
>>>>>> We want to limit post_aux_cqe() to the task context when -
>>>>>>> task_complete
>>>>>> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to
>>>>>> another
>>>>>> thread. Instead of trying to invent a new delayed CQE posting
>>>>>> mechanism
>>>>>> push them into the overflow list.
>>>>>
>>>>> This is really the only one out of the series that I'm not a big fan
>>>>> of.
>>>>> If we always rely on overflow for msg_ring, then that basically
>>>>> removes
>>>>> it from being usable in a higher performance setting.
>>>>>
>>>>> The natural way to do this would be to post the cqe via task_work for
>>>>> the target, ring, but we also don't any storage available for that.
>>>>> Might still be better to alloc something ala
>>>>>
>>>>> struct tw_cqe_post {
>>>>> ????????struct task_work work;
>>>>> ????????s32 res;
>>>>> ????????u32 flags;
>>>>> ????????u64 user_data;
>>>>> }
>>>>>
>>>>> and post it with that?
>>
>> What does it change performance wise? I need to add a patch to
>> "try to flush before overflowing", but apart from that it's one
>> additional allocation in both cases but adds additional
>> raw / not-batch task_work.
> 
> It adds alloc+free for each one, and overflow flush needed on the
> recipient side. It also adds a cq lock/unlock, though I don't think that
> part will be a big deal.

And that approach below does 2 tw swings, neither is ideal but
it feels like a bearable price for poking into another ring.

I sent a series with the double tw approach, should be better for
CQ ordering, can you pick it up instead? I don't use io_uring tw
infra of a ring the request doesn't belong to as it seems to me
like shooting yourself in the leg.

-- 
Pavel Begunkov
