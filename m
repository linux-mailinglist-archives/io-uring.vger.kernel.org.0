Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D26526D5
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 20:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLTTNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 14:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiLTTNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 14:13:35 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2653F13D2D
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 11:13:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i7so12717377wrv.8
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 11:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x66fFEVIiFImCSChANwsxu+9ZBeZP9uG5f14SyL/Yes=;
        b=hgLz1qJHoQDArGVXVXe1wS/4yZUPfUlVjp9hc5C+XSnAucHd+/y9urWMvIt/Qjrpdn
         3RP5oa9LzB1z3kavM7gVCj9loGMUpqdzbVEtW1VeBORinipO2IWccOdS0teO3++Le4iu
         HqoMd87E3p+7yn0AFy13FxcIbz63AT9kRZaxNldT52uhH0KSTCvXMFfSTnati7nTJHSY
         gH8oDnmTJWG/I3dgTvTpAr31qxFCw/Pm8jPVqqQydW/7iMzPcaOZo5k6ci9u9S/Nj9c2
         UBpGorg4KDDjoWAHeYR0eKaMOd3xRJp0sd80m+RzEAaHbVzPXYrl0dIolNb4I9vg/esJ
         wKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x66fFEVIiFImCSChANwsxu+9ZBeZP9uG5f14SyL/Yes=;
        b=Co+h+utkO+J0KVekjkF2Aw4jtQu9t0MNeYV2dILyzr968ZjB0orLfwehh7NBXlFbH6
         nuf+1dCt4/nX3xWBLfILmMZIqd/qRwgq/Y8eO5muuknNdd2KNGCxtNsgjUsopckSH97c
         fREi9og7McGk9W0WgMrjxTTrWB+/2qqCQlOQGziIXNUkcr/NTDQBwmSpleRLEILQ5367
         5pPl3jpR3bVdfFrBa36yTV8JssHVNn0Lrhmf/woJfUH2uje8spEd6UZrHJYaOsxwSqT/
         Oh3LRIWEX9JsK9sa+vpCT/lnCrzUTkeAgRIMSiiJm+LzN+3SvGoqU3GOch9U/sCU66P1
         RELw==
X-Gm-Message-State: ANoB5plV46QMGWSiZPAKGcprYFeK9zsksROZQZpAZ0GO5fnvMpjf2da6
        wgms+8DbYA+AdJxE+f7vtdk7+lC2mq0=
X-Google-Smtp-Source: AA0mqf6tHm1Pd1GzD6DYZ3RnhFEtvhZwCDQyzudfY3RdeL0oun3JO27xjFfB/gm7a8UB/oqx9n200Q==
X-Received: by 2002:a5d:5b1b:0:b0:242:814c:2cff with SMTP id bx27-20020a5d5b1b000000b00242814c2cffmr22945455wrb.26.1671563613671;
        Tue, 20 Dec 2022 11:13:33 -0800 (PST)
Received: from [192.168.8.100] (188.28.109.17.threembb.co.uk. [188.28.109.17])
        by smtp.gmail.com with ESMTPSA id u1-20020a5d6ac1000000b00241cfe6e286sm13381695wrw.98.2022.12.20.11.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 11:13:33 -0800 (PST)
Message-ID: <a65ff942-1a67-d761-d3d6-4321107808fd@gmail.com>
Date:   Tue, 20 Dec 2022 19:12:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] io_uring: wake up optimisations
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
 <7e983688-5fcf-a1fd-3422-4baed6a0cb89@gmail.com>
 <626cbdac-78a0-d8d9-b574-8617792542ac@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <626cbdac-78a0-d8d9-b574-8617792542ac@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/22 18:10, Jens Axboe wrote:
> On 12/20/22 11:06 AM, Pavel Begunkov wrote:
>> On 12/20/22 17:58, Pavel Begunkov wrote:
>>> NOT FOR INCLUSION, needs some ring poll workarounds
>>>
>>> Flush completions is done either from the submit syscall or by the
>>> task_work, both are in the context of the submitter task, and when it
>>> goes for a single threaded rings like implied by ->task_complete, there
>>> won't be any waiters on ->cq_wait but the master task. That means that
>>> there can be no tasks sleeping on cq_wait while we run
>>> __io_submit_flush_completions() and so waking up can be skipped.
>>
>> Not trivial to benchmark as we need something to emulate a task_work
>> coming in the middle of waiting. I used the diff below to complete nops
>> in tw and removed preliminary tw runs for the "in the middle of waiting"
>> part. IORING_SETUP_SKIP_CQWAKE controls whether we use optimisation or
>> not.
>>
>> It gets around 15% more IOPS (6769526 -> 7803304), which correlates
>> to 10% of wakeup cost in profiles. Another interesting part is that
>> waitqueues are excessive for our purposes and we can replace cq_wait
>> with something less heavier, e.g. atomic bit set
> 
> I was thinking something like that the other day, for most purposes
> the wait infra is too heavy handed for our case. If we exclude poll
> for a second, everything else is internal and eg doesn't need IRQ
> safe locking at all. That's just one part of it. But I didn't have

Ring polling? We can move it to a separate waitqueue, probably with
some tricks to remove extra ifs from the hot path, which I'm
planning to add in v2.

> a good idea for the poll() side of things, which would be required
> to make some progress there.

I'll play with replacing waitqueues with a bitops, should save some
extra ~5% with the benchmark I used.

-- 
Pavel Begunkov
