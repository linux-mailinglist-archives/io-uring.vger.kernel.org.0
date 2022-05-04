Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2BA51A40D
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352160AbiEDPcg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 11:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352501AbiEDPce (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 11:32:34 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAD74505C
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 08:28:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v10so1415156pgl.11
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 08:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WA7Nr4AwSaW3u/AhOO1CxWUlsaMssubHrlnluv3ty7w=;
        b=0ZuHUk6ZX+myFrG/SqP+JZZmybyd/bvbpBZXDTDEfNDNEHRHgg8OgJnfn/aRezSKPO
         FiR4XJicgPHgpwddtZ5WBBfOdf5H+A/Ialj8SNo8QNrvOJ8hLEakeTu9yA2ZUon/tcP+
         DAJCXFg2H/h49QodU5Hl6b/zM37BhospTP+VAgAd3qfauXtHrB5WVhV9KVyMlmFON5Ht
         q4yVE/RMLyEKJcXaDzIGG0Vzo5iWMRb8KuHsVnr0LfPseN85E/G7XgN0UpBE1FiohJjC
         npqUHwi2iSONwvU4ZGEtVXNNyr+knAY0INnlrR9l/6NhOxg7qXKrxHtlpOjF/lOS3cid
         q2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WA7Nr4AwSaW3u/AhOO1CxWUlsaMssubHrlnluv3ty7w=;
        b=C2H9dhL9PnjaIX/buBd28xlnlOXRzkkBYrsbsaYZCJEVckxJ8/0G0rUN47KElAzSdr
         Q4rvAN5Ihj6KU9puP81XybEnflJp4qgBb+eA7qPGUrX32ZuLCtRffSNE7Ijlxk1R47sA
         kBJXQSriDe+U9ftVt+hzvAdHqlgrAcNRlSRN5cN321Q7ZrrvmDn8drW8Qa0dvkMDb9/2
         2MBV3BTWO+dqWXLKijbYALDglF++uGK2IPfsKFs4hnCRH+Rg/oErgfmzxlx52nz60EMd
         GoROwWXMcVhbG8r6jIzmKfszbr3hZmkBcpf5pfguFjdl+u8dIgUN4E2B5baW+vjUjk8O
         TKTw==
X-Gm-Message-State: AOAM531ldXqH7RduYI9x5PfaIarMb4iZ90Hqce8K3jEBAdTxYU5rIQCK
        IfWOLoTfJ3uYyGEa/C4RSannqmKk3oG7ZQ==
X-Google-Smtp-Source: ABdhPJxeCXzbnPK1Dju4YMG/cx90/to369ofy+UF9vukvAwDpYBPBoTeRTpwpQx1Br0gAED1D2W2bA==
X-Received: by 2002:a63:1d7:0:b0:3c5:ecca:534d with SMTP id 206-20020a6301d7000000b003c5ecca534dmr2145596pgb.276.1651678136878;
        Wed, 04 May 2022 08:28:56 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b0050dc7628193sm8423381pfb.109.2022.05.04.08.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 08:28:56 -0700 (PDT)
Message-ID: <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk>
Date:   Wed, 4 May 2022 09:28:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Short sends returned in IORING
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
 <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
>>> Jens:
>>>
>>> This is related to the previous thread "Fix MSG_WAITALL for
>>> IORING_OP_RECV/RECVMSG".
>>>
>>> We have a similar issue with TCP socket sends. I see short sends
>>> regarding of the method (I tried write, writev, send, and sendmsg
>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
>>> make a difference.
>>>
>>> Most of the time, sends are not short, and I never saw short sends
>>> with loopback and my app. But on real network media, I see short
>>> sends.
>>>
>>> This is a real problem, since because of this it is not possible to
>>> implement queue size of > 1 on a TCP socket, which limits the benefit
>>> of IORING. When we have a short send, the next send in queue will
>>> "corrupt" the stream.
>>>
>>> Can we have complete send before it completes, unless the socket is
>>> disconnected?
>>
>> I'm guessing that this happens because we get a task_work item queued
>> after we've processed some of the send, but not all. What kernel are you
>> using?
>>
>> This:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
>>
>> is queued up for 5.19, would be worth trying.
>>
>> --
>> Jens Axboe
>>
> 
> Jens:
> 
> Thank you for your reply.
> 
> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
> the solution in place, I am wondering whether it will be possible to
> use multiple uring send IOs on the same socket. I expect that Linux
> TCP will serialize multiple send operations on the same socket. I am
> not sure it happens with uring (meaning that socket is blocked for
> processing a new IO until the pending IO completes). Do I need
> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
> because of multiple different sockets in the same uring. While I
> already have a workaround in the form of a "software" queue for
> streaming data on TCP sockets, I would rather have kernel to do
> "native" queueing in sockets layer, and have exrtra CPU cycles
> available to the  application.

The patch above will mess with ordering potentially. If the cause is as
I suspect, task_work causing it to think it's signaled, then the better
approach may indeed be to just flush that work and retry without
re-queueing the current one. I can try a patch against 5.18 if you are
willing and able to test?

-- 
Jens Axboe

