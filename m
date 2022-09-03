Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138C05ABFEE
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 19:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiICRAs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 13:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiICRAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 13:00:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AFD33E36
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 10:00:46 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d12so4769146plr.6
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+QQA4kmqlZ35Q9KKy4uiiOptiO8D9lsejYD6WEYmE3s=;
        b=nUIquInPQF+Vuc0kBJcJtkVAOf+0nG29BJiGkM0lyLDfVbz8EUpgyOuG7jp5cJwjrF
         uOO8Bg3yWUJ4o6OGTphq3Cq9UsujyQyNhtugvBJzHc7nPrcr0t68l8W45vOgPn6bsZsa
         wSClzXAMiKXulUR+smYJ/DyhTbE1+Te09RQ1UqRGVh/n/f6pf94sU20k7ZfYSFXSNRRD
         C+uEgVb1mm/zJrWXAR30KlmV8p16uL1nQFjBxWqlPWjF8NVvhjuFKaRUG2CorZ+kvmJw
         Kdvsv9ZZUHpZjCaKMQ+gN86A2FcfShJwjdIHoP4oBsiIfIIXsBzol9hI5rNpK3NpS9r6
         1TMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+QQA4kmqlZ35Q9KKy4uiiOptiO8D9lsejYD6WEYmE3s=;
        b=sVrWSpnucCaW2bj+SYNYQkof5So/nfR0hNYETIYdJlxsoE6J1/26UsUkbIk1qzUDy7
         RIqJuaTMC/4aiNZcUWh1TRj3xUnYkGi5cgH+bRKIDSqUrfxc7Umpgp95+hTRWr+weEas
         03bUXwEvPlhqRKYSCQFOVMazMA1wW0heEz5bfIOztTGRT1MpMMAiIxEjd7ZehiryGDKV
         2WleLK6QWfOOSTw09Jwp7HgwBnyyFiuJLnvqAG95vXhg31Xab88d8bsA8ITwsfz49O4I
         dlfVjsQscp2vxrlAyBuk97QjusC+8V+Uj2/lEP7UDu9Zpyi8wujqLjJymSzuzZdiAK4x
         7Sew==
X-Gm-Message-State: ACgBeo1yvXoy3MAipwXtxp2EamRtbcyETJk1iXtCdlBrxkKwx3aATVRN
        3jHyXsAtCvSaTZXZOQyQOUQVIw==
X-Google-Smtp-Source: AA6agR4TH6UeLZwuJxAnHsCNafpBxYf6GeIod3zTkM8qkV5uPlNKTQxrWMC8VWxUSFUcj2cYFBCPjA==
X-Received: by 2002:a17:903:4043:b0:174:dd99:a589 with SMTP id n3-20020a170903404300b00174dd99a589mr27848171pla.56.1662224445803;
        Sat, 03 Sep 2022 10:00:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w29-20020aa79a1d000000b0052d24402e52sm4159231pfj.79.2022.09.03.10.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 10:00:45 -0700 (PDT)
Message-ID: <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
Date:   Sat, 3 Sep 2022 11:00:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
 <20220902151657.10766-1-joshi.k@samsung.com>
 <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
 <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
 <20220902184608.GA6902@test-zns>
 <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
 <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
In-Reply-To: <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
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

On 9/2/22 3:25 PM, Jens Axboe wrote:
> On 9/2/22 1:32 PM, Jens Axboe wrote:
>> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>>> nvme passthrough to work with it.
>>>>>>
>>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>>> in my setup.
>>>>>>
>>>>>> Without fixedbufs
>>>>>> *****************
>>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>>> ^CExiting on signal
>>>>>> Maximum IOPS=1.85M
>>>>>
>>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>>
>>>>> bdev (non pt)??? 122M IOPS
>>>>> irq driven??? 51-52M IOPS
>>>>> polled??????? 71M IOPS
>>>>> polled+fixed??? 78M IOPS

Followup on this, since t/io_uring didn't correctly detect NUMA nodes
for passthrough.

With the current tree and the patchset I just sent for iopoll and the
caching fix that's in the block tree, here's the final score:

polled+fixed passthrough	105M IOPS

which is getting pretty close to the bdev polled fixed path as well.
I think that is starting to look pretty good!

[...]
submitter=22, tid=4768, file=/dev/ng22n1, node=8
submitter=23, tid=4769, file=/dev/ng23n1, node=8
polled=1, fixedbufs=1/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=102.51M, BW=50.05GiB/s, IOS/call=32/31
IOPS=105.29M, BW=51.41GiB/s, IOS/call=31/32
IOPS=105.34M, BW=51.43GiB/s, IOS/call=32/31
IOPS=105.37M, BW=51.45GiB/s, IOS/call=32/32
IOPS=105.37M, BW=51.45GiB/s, IOS/call=31/31
IOPS=105.38M, BW=51.45GiB/s, IOS/call=31/31
IOPS=105.35M, BW=51.44GiB/s, IOS/call=32/32
IOPS=105.49M, BW=51.51GiB/s, IOS/call=32/31
^CExiting on signal
Maximum IOPS=105.49M


-- 
Jens Axboe


