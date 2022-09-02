Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587C15AB8E0
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiIBTca (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 15:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiIBTc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 15:32:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B8D106D84
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 12:32:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j9-20020a17090a3e0900b001fd9568b117so3071346pjc.3
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 12:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ry9qz4Ug3drArxnbcnODIH8HPoQFI54s25GygjQ0sKo=;
        b=a0ajXOH9mNVz1/N39f8ZJF3YF5bhV30o5rq0H70STqonqeujYUpv8MdBDfAieLFM31
         D5ICdUml4P3QyjlTxszdCBv//G/JfLZ/s7AhMVFbKt9jSuIJsxPOjaZNKGGfg5zmxZ53
         ZGnL69DW31DvDxV1thYJzfYbcore8G5fXx/boUVbY9xwQ2jADEFMU8U21aJJVoYbE0+r
         oUwVmDrABBHjBMxSs28k/bVcg7pMegIvipgJC3798fzaTSaR5lZWP3QUz9WUD9lJ6SWa
         kpV8X6vf2/ndocxO9Op+ScnK0aAwtWA+zC32sTb2c8zXgcS8Mo6dfjx0k7FkLeFPm4Eu
         qPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ry9qz4Ug3drArxnbcnODIH8HPoQFI54s25GygjQ0sKo=;
        b=1UD9qBnRKI9fb6sKhZ81umFUCLZ9SGzKBi5JzTa4BXdqCAfwBaLxBsjbyWZn023cbT
         F7N61pdu5X/Tx4pukMxZ/ndurF6BGJ3NJ1IviTSIREJz2Vx4kkMC7kddByXzCnS34jnx
         dzai3gCOho1H0848XpmkiUyHhlh5Ty9ym2Y/AL6jSBnq9VwpyQCe0OoxAng7fst4lGdw
         JAmqCDPWLGG0zujlM+0w4/kZl3K///2CkUvcAdTMx+DBhdJYTb4MKCng0xg0mdsgh1/9
         FT8fvhV69QT58YLpLgY9A+EtHlE9FMJplxQq2IR56Uf5f/vW8awFITf6R+r8t7caZXEH
         6U/A==
X-Gm-Message-State: ACgBeo3gD/LzLVcuZOM0PqDF8bwzqRbxTvHJyD7w56ish9lXuT25LXBt
        8fhW49vMTz/7lPW/p0leKlzFRQ==
X-Google-Smtp-Source: AA6agR7Usv6PTE2jWCD39oaTpKAjmsJJNSWV0Z5hO6DIhiMc6IBH89jSLLrfTK3l0y2fIOTnHoozyg==
X-Received: by 2002:a17:90b:3e86:b0:1f5:2b4f:7460 with SMTP id rj6-20020a17090b3e8600b001f52b4f7460mr6509336pjb.97.1662147147188;
        Fri, 02 Sep 2022 12:32:27 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a62d446000000b00537f7d04fb3sm2244296pfl.145.2022.09.02.12.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 12:32:26 -0700 (PDT)
Message-ID: <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
Date:   Fri, 2 Sep 2022 13:32:24 -0600
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
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902184608.GA6902@test-zns>
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

On 9/2/22 12:46 PM, Kanchan Joshi wrote:
> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>> Hi,
>>>>
>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>> nvme passthrough to work with it.
>>>>
>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>> in my setup.
>>>>
>>>> Without fixedbufs
>>>> *****************
>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>> ^CExiting on signal
>>>> Maximum IOPS=1.85M
>>>
>>> With the poll support queued up, I ran this one as well. tldr is:
>>>
>>> bdev (non pt)??? 122M IOPS
>>> irq driven??? 51-52M IOPS
>>> polled??????? 71M IOPS
>>> polled+fixed??? 78M IOPS
> 
> except first one, rest three entries are for passthru? somehow I didn't
> see that big of a gap. I will try to align my setup in coming days.

Right, sorry it was badly labeled. First one is bdev with polling,
registered buffers, etc. The others are all the passthrough mode. polled
goes to 74M with the caching fix, so it's about a 74M -> 82M bump using
registered buffers with passthrough and polling.

>> polled+fixed??? 82M
>>
>> I suspect the remainder is due to the lack of batching on the request
>> freeing side, at least some of it. Haven't really looked deeper yet.
>>
>> One issue I saw - try and use passthrough polling without having any
>> poll queues defined and it'll stall just spinning on completions. You
>> need to ensure that these are processed as well - look at how the
>> non-passthrough io_uring poll path handles it.
> 
> Had tested this earlier, and it used to run fine. And it does not now.
> I see that io are getting completed, irq-completion is arriving in nvme
> and it is triggering task-work based completion (by calling
> io_uring_cmd_complete_in_task). But task-work never got called and
> therefore no completion happened.
> 
> io_uring_cmd_complete_in_task -> io_req_task_work_add -> __io_req_task_work_add
> 
> Seems task work did not get added. Something about newly added
> IORING_SETUP_DEFER_TASKRUN changes the scenario.
> 
> static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
> {
> ?????? struct io_uring_task *tctx = req->task->io_uring;
> ?????? struct io_ring_ctx *ctx = req->ctx;
> ?????? struct llist_node *node;
> 
> ?????? if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> ?????????????? io_req_local_work_add(req);
> ?????????????? return;
> ?????? }
> ????....
> 
> To confirm, I commented that in t/io_uring and it runs fine.
> Please see if that changes anything for you? I will try to find the
> actual fix tomorow.

Ah gotcha, yes that actually makes a lot of sense. I wonder if regular
polling is then also broken without poll queues if
IORING_SETUP_DEFER_TASKRUN is set. It should be, I'll check into
io_iopoll_check().

-- 
Jens Axboe
