Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF56B60BA
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 21:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCKUzE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 15:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCKUzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 15:55:03 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF27D99;
        Sat, 11 Mar 2023 12:54:35 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id j2so8022686wrh.9;
        Sat, 11 Mar 2023 12:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678568074;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t942ByZNbxvopSn42cM++9J8LMBuCwoaB3ouWa4jXWc=;
        b=d0n5rizmSIAYEMvgL08svAHGUZEr9ut//pLcQ+e4xtRyrhah7Mu47SOVzrDlp2mAjs
         q2xzLiwCzqxogUd/Fjln9TMs5nsWV17HebE4s1FMLNP2+1acmfAu7ZdQDpvDqqpR3QLR
         LDxSG5R7N1UFg9mF9dwL+IJkGZAfA9WlwwhQZU1h7fk351zU4yhwinG0MWffeFCcJ8zW
         GMCWeaoOuTclV9j5cIu3rCKxG/kFEMCDy8CuSsXRlLst0O3mLcU4O2E8rOMxCVNo24eO
         eCPIYpyXojPaHT3JFjsOp5RNQ2iFWYT0Kfihlj/rZlDuRfnRyH5rfSycaIh4cY6+EP0H
         ev7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678568074;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t942ByZNbxvopSn42cM++9J8LMBuCwoaB3ouWa4jXWc=;
        b=mi3Ix4Mm7M2tV/tgL6UQv9so6Zi6M+N1Q4JyDWwba4lco2UAmj+WHq6fUHkWiiqB/h
         TXDT67/kq3WFwyCLnapbMxFiDj2/ACABFemNW3DIAt2MADrWxfhZgz29mRW212L9zImV
         8qpmC9MDX9CETkucyy6U5IEsAUgAPRR4vlXAPu7Rt155SqrmpzbcAk2M8jb4fHtZkpkO
         krQdRGpFsG2P/Q34LK5MlXbBv2PkfZ6wMCNtLvEn/b6H7qWXf01RdsRROM0gBrClVnWT
         VAhSwFE6EWM8COY+oGictOTiWxSOjyCQdtz9jBvUEE/shb9Ck+QsiUboJZs/qNq8LiIw
         WQDg==
X-Gm-Message-State: AO0yUKVgR6qaAosdwZY+wYrCnWjKKh2KlxbY6limc+aZByh/osSfW8sX
        xo49Z9MkUVJHfLHppXpVr98=
X-Google-Smtp-Source: AK7set+nWgjCMBBemW9ZU99gC8XocNf5MeKF2VmGBkXYPJe4fUIfMKj8AfYTV2vA4wZg5hv4LfzV5A==
X-Received: by 2002:adf:f311:0:b0:2c9:730c:1439 with SMTP id i17-20020adff311000000b002c9730c1439mr18263132wro.30.1678568074090;
        Sat, 11 Mar 2023 12:54:34 -0800 (PST)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002c559626a50sm3312827wrq.13.2023.03.11.12.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 12:54:33 -0800 (PST)
Message-ID: <c81c971e-3e00-0767-3158-d712208f15e9@gmail.com>
Date:   Sat, 11 Mar 2023 20:53:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
In-Reply-To: <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
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

On 3/11/23 20:45, Pavel Begunkov wrote:
> On 3/11/23 17:24, Jens Axboe wrote:
>> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>>> io_uring extensively uses task_work, but when a task is waiting
>>> for multiple CQEs it causes lots of rescheduling. This series
>>> is an attempt to optimise it and be a base for future improvements.
>>>
>>> For some zc network tests eventually waiting for a portion of
>>> buffers I've got 10x descrease in the number of context switches,
>>> which reduced the CPU consumption more than twice (17% -> 8%).
>>> It also helps storage cases, while running fio/t/io_uring against
>>> a low performant drive it got 2x descrease of the number of context
>>> switches for QD8 and ~4 times for QD32.
>>>
>>> Not for inclusion yet, I want to add an optimisation for when
>>> waiting for 1 CQE.
>>
>> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
>> that, and I see context rates of around 8.1-8.3M/sec with the current
>> kernel.
>>
>> Applied the two patches, but didn't see much of a change? Performance is
>> about the same, and cx rate ditto. Confused... As you probably know,
>> this test waits for 32 ios at the time.
> 
> If I'd to guess it already has perfect batching, for which case
> the patch does nothing. Maybe it's due to SSD coalescing +
> small ro I/O + consistency and small latencies of Optanes,
> or might be on the scheduling and the kernel side to be slow
> to react.

And if that's that, I have to note that it's quite a sterile
case, the last time I asked the usual batching we're currently
getting for networking cases is 1-2.

-- 
Pavel Begunkov
