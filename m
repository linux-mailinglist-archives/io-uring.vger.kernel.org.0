Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D7C705628
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 20:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjEPSlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 14:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjEPSlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 14:41:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144FE6E9D;
        Tue, 16 May 2023 11:41:20 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3063891d61aso13852148f8f.0;
        Tue, 16 May 2023 11:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684262478; x=1686854478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iKwBCRuSJLaIb0+NiC2CH88vuEGa1impYnfIi562zeY=;
        b=AxUn52AI6W+HbtUYhDsxuXBAto4WZJIvnv77Y2foHXUtPW+07kgK2wcJFsnoeYeDCg
         8UaKRwzBkIAM9p4o6CgCtNZQrb2hlOtAWN9/jxBxTXqtTEEZm9tsSrCTuXVgdeBM5hzb
         P0a/fy81d1pJ6F+pK19KBXLJq0SyAFNVjzr4eZBWIeHVNzquu0IiisQoA07W2qatrql3
         p1mTb2t3VDerjB5Cut4AnZkhv8XLG//cOLoXT27Gxsn6L30ABti5xfYNI2oo5YrXAvns
         GvbXn972lcFRVymx3Jrr5YIdtu/QtWpvj00eAJs0NetPQfpqGDCBHcxOBm4AUw2OeAsM
         O34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684262478; x=1686854478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iKwBCRuSJLaIb0+NiC2CH88vuEGa1impYnfIi562zeY=;
        b=gOW1SmIwY+pTdQ22JEjnezmzPM1CostO45aLDS+PeNDdhCI2boOJkQp41jvIYUTmER
         FmRC1LGNFTwJztmF02hOMipU0+5KlQflCNzwtNEkXaeIYYRix91LYAoOcZbQ+u3t5bdw
         NlqwX5TJrfd4Q8oat22duGLz+Gnzj2Fsof6ksje+58kA9Huj8bvRMdPgV9nEkUXF6jnB
         A7ZV4VmFwAmFw5mxn+Te+C3jBquMYX4uvZlQBxdTijGdAC3k8ffyym4s7Bm+OQcyNvkf
         jctBGMu8jEErdi6sSl5xB/0WfoV/gT0ilDwt9VX4XZY5T7jsXlRp7nJa+LZ+KX4kfapm
         EORg==
X-Gm-Message-State: AC+VfDyy0M6aMbks139KdrjmmIXoGnpLWRaQVxT1ucjeVdwt2VWmDGd7
        mQk9kFWN1BhFYfOplLysLbK7v4wQUZA=
X-Google-Smtp-Source: ACHHUZ6oNO3cEdsjaVp/3Gpd20YAISqDHQKN8E49E+uyMz8iG6ZS9lHAvuU5Wj5Z/oIut1Pp7XbIwQ==
X-Received: by 2002:a5d:4d11:0:b0:309:3828:2bde with SMTP id z17-20020a5d4d11000000b0030938282bdemr1884181wrt.60.1684262478275;
        Tue, 16 May 2023 11:41:18 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.10])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b003078354f774sm308887wrv.36.2023.05.16.11.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 11:41:17 -0700 (PDT)
Message-ID: <4013ed1c-8df9-8ef2-0bee-1f208fe302d9@gmail.com>
Date:   Tue, 16 May 2023 19:38:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 0/2] Enable IOU_F_TWQ_LAZY_WAKE for passthrough
Content-Language: en-US
To:     Anuj gupta <anuj1072538@gmail.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, joshi.k@samsung.com
References: <cover.1684154817.git.asml.silence@gmail.com>
 <CACzX3Av9yOkAK16QRJ7npQUVAiTjA-nqLR2Doob9p6nYYYkyOg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3Av9yOkAK16QRJ7npQUVAiTjA-nqLR2Doob9p6nYYYkyOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/23 12:42, Anuj gupta wrote:
> On Mon, May 15, 2023 at 6:29 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Let cmds to use IOU_F_TWQ_LAZY_WAKE and enable it for nvme passthrough.
>>
>> The result should be same as in test to the original IOU_F_TWQ_LAZY_WAKE [1]
>> patchset, but for a quick test I took fio/t/io_uring with 4 threads each
>> reading their own drive and all pinned to the same CPU to make it CPU
>> bound and got +10% throughput improvement.
>>
>> [1] https://lore.kernel.org/all/cover.1680782016.git.asml.silence@gmail.com/
>>
>> Pavel Begunkov (2):
>>    io_uring/cmd: add cmd lazy tw wake helper
>>    nvme: optimise io_uring passthrough completion
>>
>>   drivers/nvme/host/ioctl.c |  4 ++--
>>   include/linux/io_uring.h  | 18 ++++++++++++++++--
>>   io_uring/uring_cmd.c      | 16 ++++++++++++----
>>   3 files changed, 30 insertions(+), 8 deletions(-)
>>
>>
>> base-commit: 9a48d604672220545d209e9996c2a1edbb5637f6
>> --
>> 2.40.0
>>
> 
> I tried to run a few workloads on my setup with your patches applied. However, I
> couldn't see any difference in io passthrough performance. I might have missed
> something. Can you share the workload that you ran which gave you the perf
> improvement. Here is the workload that I ran -

The patch is way to make completion batching more consistent. If you're so
lucky that all IO complete before task_work runs, it'll be perfect batching
and there is nothing to improve. That often happens with high throughput
benchmarks because of how consistent they are: no writes, same size,
everything is issued at the same time and so on. In reality it depends
on your use pattern, timings, nvme coalescing, will also change if you
introduce a second drive, and so on.

With the patch t/io_uring should run task_work once for exactly the
number of cqes the user is waiting for, i.e. -c<N>, regardless of
circumstances.

Just tried it out to confirm,

taskset -c 0 nice -n -20 /t/io_uring -p0 -d4 -b8192 -s4 -c4 -F1 -B1 -R0 -X1 -u1 -O0 /dev/ng0n1

Without:
12:11:10 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
12:11:20 PM    0    2.03    0.00   25.95    0.00    0.00    0.00    0.00    0.00    0.00   72.03
With:
12:12:00 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
12:12:10 PM    0    2.22    0.00   17.39    0.00    0.00    0.00    0.00    0.00    0.00   80.40


Double checking it works:

echo 1 > /sys/kernel/debug/tracing/events/io_uring/io_uring_local_work_run/enable
cat /sys/kernel/debug/tracing/trace_pipe

Without I see

io_uring-4108    [000] .....   653.820369: io_uring_local_work_run: ring 00000000b843f57f, count 1, loops 1
io_uring-4108    [000] .....   653.820371: io_uring_local_work_run: ring 00000000b843f57f, count 1, loops 1
io_uring-4108    [000] .....   653.820382: io_uring_local_work_run: ring 00000000b843f57f, count 2, loops 1
io_uring-4108    [000] .....   653.820383: io_uring_local_work_run: ring 00000000b843f57f, count 1, loops 1
io_uring-4108    [000] .....   653.820386: io_uring_local_work_run: ring 00000000b843f57f, count 1, loops 1
io_uring-4108    [000] .....   653.820398: io_uring_local_work_run: ring 00000000b843f57f, count 2, loops 1
io_uring-4108    [000] .....   653.820398: io_uring_local_work_run: ring 00000000b843f57f, count 1, loops 1

And with patches it's strictly count=4.

Another way would be to add more SSDs to the picture and hope they don't
conspire to complete at the same time


-- 
Pavel Begunkov
