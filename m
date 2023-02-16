Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52889698AA1
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 03:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBPCuj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 21:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBPCui (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 21:50:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA67345F41
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 18:50:36 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i18so688425pli.3
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 18:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4uMjxhxFHjySjL+vxoDs9eO7EP8MX5ZBhdRrrNMScvQ=;
        b=EwI2nujTj7A9kblVuPbWlosvlYwe+tt+EwjeuYqstXX1CBCXyz7CRvgLShLQijRYF2
         q/iEk2rJ+yrv2x9dZTD/CSbHmq/7pFJUHLqu2/E6v07gU53uAGDsZ90+l6jBwbyB9Opn
         svWaL6V7xD4tp4ZpE9AKdLWwQgIZVmbAz4CJX1l65/eD6Z7z0VAqUzatA3coi0V4OIl8
         mvzEWaIM/M3J0jrxq96CxvedJT8zOIcVueOg0tXqgqBSHCafR8HgbDxU3odRHEf4zQ34
         51Mg5cPvp2psdV9CJ7bAx6dLuvLIG6VCvpiZkTFCx2sBesXmf16RR8zpRPVTMNocnOFM
         QxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4uMjxhxFHjySjL+vxoDs9eO7EP8MX5ZBhdRrrNMScvQ=;
        b=i81XJ8ExWoTm6YcCxJM2KdjrbDiogyyflYokR2uiJtmhumTRwrw0BBlXRjadeQdtoC
         /1pqPyYJS7RODa65lRS8YTYozQqiPqgqF6jIsE9cnR3z19TXkIr/ASeQYgCAX8Hvyg0U
         isI4G20OK5ngqPvmX0MWZCnEgHawWE+sBsBjjSrUmgb5HzTpwsdzRJynUUo2yIS7kdyY
         hWHICKxHgYUwh9YKBIuoPpVhAZjYNxYPxuJo3HVWamAUDAowi3sp1H8vFEf/bghjzr7K
         fUavtTAtHsk8ZqSYl4yLbbNy11UNnSR8rggG07/T2n/81rD56AuQUtDbwjMHaBNXPswN
         eGKw==
X-Gm-Message-State: AO0yUKVDSp/yTrT4TwaJe9xRMNPnZPjQGAcBvTBD7egfo4Z49pIZegOK
        uU47RAABnDd9RVlwx/q0i7E8tQ==
X-Google-Smtp-Source: AK7set8AeJ8/Vs+q9RYitAvW8Tb59+OOD/BGvkmWLrNS0dSBVug5J+zEpylQZusrZz4B/5+kuyG4TQ==
X-Received: by 2002:a17:902:ced0:b0:19a:7060:948 with SMTP id d16-20020a170902ced000b0019a70600948mr5031525plg.1.1676515836270;
        Wed, 15 Feb 2023 18:50:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b0019a74841c9bsm46385plb.192.2023.02.15.18.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 18:50:35 -0800 (PST)
Message-ID: <3a7e342c-844e-8071-7dde-86b88bbb2dc4@kernel.dk>
Date:   Wed, 15 Feb 2023 19:50:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
 <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
 <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
 <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
 <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
 <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
 <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
 <1237dc53-2495-a145-37bf-47366ca75e71@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1237dc53-2495-a145-37bf-47366ca75e71@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 7:40 PM, John David Anglin wrote:
> On 2023-02-15 6:02 p.m., Jens Axboe wrote:
>> This is not related to Helge's patch, 6.1-stable is just still missing:
>>
>> commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c
>> Author: Jens Axboe<axboe@kernel.dk>
>> Date:   Fri Jan 27 09:28:13 2023 -0700
>>
>>      io_uring: add a conditional reschedule to the IOPOLL cancelation loop
>>
>> and I'm guessing you're running without preempt.
> With 6.2.0-rc8+, I had a different crash running poll-race-mshot.t:
> 
> Backtrace:
> 
> 
> Kernel Fault: Code=15 (Data TLB miss fault) at addr 0000000000000000
> CPU: 0 PID: 18265 Comm: poll-race-mshot Not tainted 6.2.0-rc8+ #1
> Hardware name: 9000/800/rp3440
> 
>      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> PSW: 00010000001001001001000111110000 Not tainted
> r00-03  00000000102491f0 ffffffffffffffff 000000004020307c ffffffffffffffff
> r04-07  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
> r08-11  ffffffffffffffff 000000000407ef28 000000000407f838 8400000000800000
> r12-15  0000000000000000 0000000040c424e0 0000000040c424e0 0000000040c424e0
> r16-19  000000000407fd68 0000000063f08648 0000000040c424e0 000000000a085000
> r20-23  00000000000d6b44 000000002faf0800 00000000000000ff 0000000000000002
> r24-27  000000000407fa30 000000000407fd68 0000000000000000 0000000040c1e4e0
> r28-31  400000000000de84 0000000000000000 0000000000000000 0000000000000002
> sr00-03  0000000004081000 0000000000000000 0000000000000000 0000000004081de0
> sr04-07  0000000004081000 0000000000000000 0000000000000000 00000000040815a8
> 
> IASQ: 0000000004081000 0000000000000000 IAOQ: 0000000000000000 0000000004081590
>  IIR: 00000000    ISR: 0000000000000000  IOR: 0000000000000000
>  CPU:        0   CR30: 000000004daf5700 CR31: ffffffffffffefff
>  ORIG_R28: 0000000000000000
>  IAOQ[0]: 0x0
>  IAOQ[1]: linear_quiesce+0x0/0x18 [linear]
>  RP(r2): intr_check_sig+0x0/0x3c
> Backtrace:
> 
> Kernel panic - not syncing: Kernel Fault

This means very little to me, is it a NULL pointer deref? And where's
the backtrace?

-- 
Jens Axboe


