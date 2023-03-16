Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3377C6BD68E
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 18:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCPRAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 13:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCPRAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 13:00:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84273366AC
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 10:00:02 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g6so1072538iov.13
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678986002;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBBhFZ/aMkGHr36TRIUZXK32CB/PbzRxxh6yRdnVqWI=;
        b=TengG2KUAKHy80321gIObzzzeuG19apD+HynIhj7J9VfuLF3R7+wuVS+2Jq5VinB6V
         nuA5xoM3yalnrliv4eht2nR3+1V8q9GDS3iw+URbc3aj46jAUmOTBa1GK/UUNl+HDMWZ
         FSQ+CgM3uqT39bYGDH/NYRsB8qDpvAcrekO4FXWwNJOxNjrteiKf7QZpVLW+YkDfibxt
         pOjLPpunRyuzlR7NuG3iDpmd1E82ICrYT2A+N1KoRgW4x5s0Ya3LefMwlyxKGQWe3+KX
         pyym6936tSuWkwmr/8Y4aHktgwtj4OZoyvIuiM26hOeBqVYExvlYhyKESo42NBg2QPrQ
         X8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678986002;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QBBhFZ/aMkGHr36TRIUZXK32CB/PbzRxxh6yRdnVqWI=;
        b=K52AfHoZDAvmpQTI8xudNy+xxfVdsYOjF5tW1BD4ZJyKOOmvzcQ5mntbBQqsP2K+ii
         ujHqEgxNiUnW9LiPk4G/MNa7mgBkSkmiO1AZ8fkdb5pcAIrhxnZdRJuru3kiOmqzO54S
         2I5NVq0WCf5aehid+ywTZbzpFNS9cXQngGeMWb2BTFd2pUqbpZhKWav4oSlc8nnXu6rB
         Pgm2AeuhPk2m9x/uFFj5JjhuZA46MKxlz+BUH2YKEPCk+ocs/UF3Ebu0RX2Pwa4NUPcg
         neDXYHWjRsD7aRS2kucFV6+BuXrTBi94AUJCguHj6b1XnAEcmvkkMgb9R3QvE1y0xCXx
         YJJg==
X-Gm-Message-State: AO0yUKUxc+bhFmZz33mPoJo+hFrRXXYOUqJXiYNVdyL84ULFZVjf2kT6
        uFEBL8dIAJnqqYIsA+XVy9F4rx6hdbyCdDmBKLUX9w==
X-Google-Smtp-Source: AK7set+qo2FG/V+xLB9x5ZJioYnIBKkZTchhbVLym9S/JcccWKmjfVOCIfxpFFLUbX899Lvb+X8vXg==
X-Received: by 2002:a6b:dd0c:0:b0:74c:99e8:7f44 with SMTP id f12-20020a6bdd0c000000b0074c99e87f44mr1768990ioc.2.1678986001850;
        Thu, 16 Mar 2023 10:00:01 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w29-20020a02cf9d000000b0040619720af8sm1508852jar.35.2023.03.16.10.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:00:01 -0700 (PDT)
Message-ID: <d5ca0c7b-41d5-f0ea-293a-121dc9d5ccc4@kernel.dk>
Date:   Thu, 16 Mar 2023 11:00:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
 <619c16b8-1844-0287-40ee-7efaeea36b09@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <619c16b8-1844-0287-40ee-7efaeea36b09@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 4:18 AM, Helge Deller wrote:
> On 3/15/23 22:18, Jens Axboe wrote:
>> On 3/15/23 2:38 PM, Jens Axboe wrote:
>>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>>> On 3/15/23 21:03, Helge Deller wrote:
>>>>> Hi Jens,
>>>>>
>>>>> Thanks for doing those fixes!
>>>>>
>>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>>> One issue that became apparent when running io_uring code on parisc is
>>>>>> that for data shared between the application and the kernel, we must
>>>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>>>> it useless.
>>>>>>
>>>>>> The first patch in this series is from Helge, and ensures that the
>>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>>>> there.
>>>>>>
>>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>>>> for them and the application mmap() it. This brings these mapped
>>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>>
>>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>>> there are others) are impact to any degree as well...
>>>>>
>>>>> It would be interesting to find out. I'd assume that other arches,
>>>>> e.g. sparc, might have similiar issues.
>>>>> Have you tested your patches on other arches as well?
>>>>
>>>> By the way, I've now tested this series on current git head on an
>>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>>
>>>> Results of liburing testsuite:
>>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>
>>
>> If you update your liburing git copy, switch to the ring-buf-alloc branch,
>> then all of the above should work:
>>
>> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/buf-ring.t
>> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/send_recvmsg.t
>> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/ringbuf-read.t
>> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/poll-race-mshot.t
>> axboe@c8000 ~/g/liburing (ring-buf-alloc)> git describe
>> liburing-2.3-245-g8534193
> 
> Yes, verified. All tests in that branch pass now.

Nice, thanks for re-testing!

-- 
Jens Axboe


