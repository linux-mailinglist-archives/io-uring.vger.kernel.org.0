Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E716B6E3C
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 04:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCMDyO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 23:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMDxc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 23:53:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19D74484;
        Sun, 12 Mar 2023 20:53:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so43291144edb.10;
        Sun, 12 Mar 2023 20:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678679582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAXACzuXwy+nTr2NR5Tr4Og9P7p6FIxBdXhCQML9Ats=;
        b=IZ5TDNMfqKdo++UkwAeAVgXMHyVDG/OU7Sy/NumRPF7wYgTPJsdHSchETDTTyYqBZx
         Hn/B1KWoNSFKS8m6kw0cQfdgeeFYDnOId9ujYeWoN06TB0Vp/k/tnYJy2X45PMk1YIra
         YgaywJ+UNXNP0S0WZWwHwcsIKzDww1eJigQxFw4iMOsRlFfIdxlxIyzBBxaqPsBlBIjz
         4gugeFyvlI42iGb4jYaGYzGKzxaTm4FXXdWtGBbrnRc9Wb8osaQkSRtikE6wSB+jl0QN
         LDfWFHJCBx6kQhi0//ieVAraoN3tZLCJpPQLIPtq/tqJ7xlSfD7YDiOczJNxkGF69g96
         H6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678679582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAXACzuXwy+nTr2NR5Tr4Og9P7p6FIxBdXhCQML9Ats=;
        b=r8sFDs3/Y33PbY2Y8Qevw9VFRxXaoqr/YAeUXUifLQP314MLaAmknaSa3SwwXpN9D5
         C8HvmT0AQPh3CPUcIo4yix8G1KBj94+ij8Rge8BJBXeqvlzwt7XOuJCBhUNpN6M2TQw6
         CSC2U5feQN6VXMDTCRjM61fM+nYaxwKkcTToYCV7uJmNMMvU6V4jOgHNDrvtXqq7HNJX
         bmQV85tfsT4qesdyfbDK4EfatH2J5tKpKc/lqvEIlAyi+CLNCccnr4JUyvCJ9ZfgGk9+
         vSxpkNp6WWesMOUhrtnKGAJWj4ygo0ICVLVXuL3yJD5/+2wHji3b480VLLlf/NPmlFcD
         OyXg==
X-Gm-Message-State: AO0yUKWeFyyd6qaZaUkd+TUosrWG3rzr3m2oExEAuPkqcNIZzevj8qbl
        QL2cQoVuq/NE1cgDCFhHh99W51ZRnvU=
X-Google-Smtp-Source: AK7set+CEh0S8M23BbeXWSO273z1dJWLETtWbu6S3OvSRUnt1jl4bo3ZuA3auGLKBOU7Z5lPrM4/mg==
X-Received: by 2002:a17:907:94ce:b0:907:183f:328a with SMTP id dn14-20020a17090794ce00b00907183f328amr40902309ejc.65.1678679582442;
        Sun, 12 Mar 2023 20:53:02 -0700 (PDT)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id n20-20020a170906701400b008b17fe9ac6csm2930574ejj.178.2023.03.12.20.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 20:53:02 -0700 (PDT)
Message-ID: <e60ac354-76d6-7073-7b75-0a8ad04b3435@gmail.com>
Date:   Mon, 13 Mar 2023 03:52:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <c81c971e-3e00-0767-3158-d712208f15e9@gmail.com>
 <7bceab46-f4cd-3064-ff9e-1e64b18a901b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7bceab46-f4cd-3064-ff9e-1e64b18a901b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/23 15:31, Jens Axboe wrote:
> On 3/11/23 1:53?PM, Pavel Begunkov wrote:
>> On 3/11/23 20:45, Pavel Begunkov wrote:
>>> On 3/11/23 17:24, Jens Axboe wrote:
>>>> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>>>>> io_uring extensively uses task_work, but when a task is waiting
>>>>> for multiple CQEs it causes lots of rescheduling. This series
>>>>> is an attempt to optimise it and be a base for future improvements.
>>>>>
>>>>> For some zc network tests eventually waiting for a portion of
>>>>> buffers I've got 10x descrease in the number of context switches,
>>>>> which reduced the CPU consumption more than twice (17% -> 8%).
>>>>> It also helps storage cases, while running fio/t/io_uring against
>>>>> a low performant drive it got 2x descrease of the number of context
>>>>> switches for QD8 and ~4 times for QD32.
>>>>>
>>>>> Not for inclusion yet, I want to add an optimisation for when
>>>>> waiting for 1 CQE.
>>>>
>>>> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
>>>> that, and I see context rates of around 8.1-8.3M/sec with the current
>>>> kernel.
>>>>
>>>> Applied the two patches, but didn't see much of a change? Performance is
>>>> about the same, and cx rate ditto. Confused... As you probably know,
>>>> this test waits for 32 ios at the time.
>>>
>>> If I'd to guess it already has perfect batching, for which case
>>> the patch does nothing. Maybe it's due to SSD coalescing +
>>> small ro I/O + consistency and small latencies of Optanes,
>>> or might be on the scheduling and the kernel side to be slow
>>> to react.
>>
>> And if that's that, I have to note that it's quite a sterile
>> case, the last time I asked the usual batching we're currently
>> getting for networking cases is 1-2.
> 
> I can definitely see this being very useful for the more
> non-deterministic cases where "completions" come in more sporadically.
> But for the networking case, if this is eg receives, you'd trigger the
> wakeup anyway to do the actual receive? And then the cqe posting doesn't
> trigger another wakeup.

True, In my case zc send notifications were the culprit.

It's not in the series, it might be better to not wake eagerly recv
poll tw, it'll give time to accumulate more data. I'm a bit afraid
of exhausting recv queues this way, so I don't think it's applicable
by default.

-- 
Pavel Begunkov
