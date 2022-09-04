Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E125AC650
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 22:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiIDURj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 16:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiIDURi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 16:17:38 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9DD29C9C
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 13:17:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l3so6669906plb.10
        for <io-uring@vger.kernel.org>; Sun, 04 Sep 2022 13:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Vfwp8lW+77gEMyxyD1D46nuBw5vb4OcIgiJ5hx7SeT0=;
        b=617Sia/FjjEAki8GGei2Iodf4exUefBYfrA6izFBsw8jtAEmwTX+4EwOwd4Ex54151
         2U26rgFT/dMtdzf91txcSTf1ZtQ5d6GA2jJL0ElfhHvCebpTdulqne2l8Xn4E1GLvRnd
         oIBYRfLsM3bkdtvuvIVSS3VrP3sUF9XgEmY5YC4zhcHwl7Dl1g/8CJuITFFDK/DCYMlS
         Bkc3ShL1lFdqF0ipqr90RE4WWxBVAl3+J90KAWpI0F3bijVKhjfgTDGyMtfgqfpXnBaT
         QrTBaADibiLrTFp/MNnOA585prhViN55rZxQBqUfEtwvyv1um6Ur+jJthIEgMRu8Ck45
         lqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Vfwp8lW+77gEMyxyD1D46nuBw5vb4OcIgiJ5hx7SeT0=;
        b=lf0qKDiG3l1BO3XKyrDHQslaox10/Mb9LHycnwAZPwl8NH30P2i456pXD2Kk5JEglB
         gCsHNqdg0+tMQia8aCmq2YIC3CDYdgCPDjg+AuWM/DK4jT2hZ0ry/kDbUkpNYNGfc1Zb
         ouoWmh7mliT5wsseWDiHFkangBhaA6zGq72TdwHXyLGQ6iyUCjjn/HDpx23zUqkfNrcK
         NNtO/NZ94GPpDmLVoRjN6iG9/ySdxQrxR6sC6ocO/nV88dkRzUjDgqG2lfrD6MfQgz3z
         810+suK9R27VQ9biyosJI0z9Aro7MLeC13rtyJoTDkpAvYbOn1GdN8tlsO1suENLTXLr
         XLbw==
X-Gm-Message-State: ACgBeo1g54DGcvCvOsAmEFVOpzhil2z/G3Om3v07kyRuWUQ2Qp5ZGKV+
        eZ/mJb3NIow6U/octE4iZW6ngZTbkfB8vw==
X-Google-Smtp-Source: AA6agR4FSuFVNP11v6l7kDJCr/nMweBf5YlQyKp5qQjqi0zFZJiMk/xSInhOtczRxRO6HqP2ywCZ5A==
X-Received: by 2002:a17:90b:1bc4:b0:1fd:b913:ef58 with SMTP id oa4-20020a17090b1bc400b001fdb913ef58mr15516198pjb.220.1662322656465;
        Sun, 04 Sep 2022 13:17:36 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0052e6d5ee183sm6030727pfp.129.2022.09.04.13.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Sep 2022 13:17:35 -0700 (PDT)
Message-ID: <7c0fced8-11b0-fcd9-ac47-662af979b207@kernel.dk>
Date:   Sun, 4 Sep 2022 14:17:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
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
 <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
 <20220904170124.GC10536@test-zns>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220904170124.GC10536@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/22 11:01 AM, Kanchan Joshi wrote:
> On Sat, Sep 03, 2022 at 11:00:43AM -0600, Jens Axboe wrote:
>> On 9/2/22 3:25 PM, Jens Axboe wrote:
>>> On 9/2/22 1:32 PM, Jens Axboe wrote:
>>>> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>>>>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>>>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>>>>> nvme passthrough to work with it.
>>>>>>>>
>>>>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>>>>> in my setup.
>>>>>>>>
>>>>>>>> Without fixedbufs
>>>>>>>> *****************
>>>>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>>>>> ^CExiting on signal
>>>>>>>> Maximum IOPS=1.85M
>>>>>>>
>>>>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>>>>
>>>>>>> bdev (non pt)??? 122M IOPS
>>>>>>> irq driven??? 51-52M IOPS
>>>>>>> polled??????? 71M IOPS
>>>>>>> polled+fixed??? 78M IOPS
>>
>> Followup on this, since t/io_uring didn't correctly detect NUMA nodes
>> for passthrough.
>>
>> With the current tree and the patchset I just sent for iopoll and the
>> caching fix that's in the block tree, here's the final score:
>>
>> polled+fixed passthrough??? 105M IOPS
>>
>> which is getting pretty close to the bdev polled fixed path as well.
>> I think that is starting to look pretty good!
> Great! In my setup (single disk/numa-node), current kernel shows-
> 
> Block MIOPS
> ***********
> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -P1 -n1 /dev/nvme0n1
> plain: 1.52
> plain+fb: 1.77
> plain+poll: 2.23
> plain+fb+poll: 2.61
> 
> Passthru MIOPS
> **************
> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -P1 -u1 -n1 /dev/ng0n1
> plain: 1.78
> plain+fb: 2.08
> plain+poll: 2.21
> plain+fb+poll: 2.69

Interesting, here's what I have:

Block MIOPS
============
plain: 2.90
plain+fb: 3.0
plain+poll: 4.04
plain+fb+poll: 5.09	

Passthru MIPS
=============
plain: 2.37
plain+fb: 2.84
plain+poll: 3.65
plain+fb+poll: 4.93

This is a gen2 optane, it maxes out at right around 5.1M IOPS. Note that
I have disabled iostats and merges generally in my runs:

echo 0 > /sys/block/nvme0n1/queue/iostats
echo 2 > /sys/block/nvme0n1/queue/nomerges

which will impact block more than passthru obviously, particularly
the nomerges. iostats should have a similar impact on both of them (but
I haven't tested either of those without those disabled).

-- 
Jens Axboe
