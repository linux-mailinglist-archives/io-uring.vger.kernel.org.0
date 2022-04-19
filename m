Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97FD506C7B
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiDSMe1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 08:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiDSMe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 08:34:26 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAEA205C6
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:31:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso1648684pjb.5
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Syh1EZ1DQNwigQQy+Ki+L781cGjLlmx5MmyUvLvf1+I=;
        b=CTs/Z3rZ42Wc60nToWiofoL2uixLLWoPBW7livoRW4p6YeDyZJQP7Y4kro/DfTXn4o
         fqRm1B6W0Mtw/mCUojaNdixyMMr9VyuJVYOIpO6Hkz5/9rAPDHA+kPAY2yo2VAEYofSF
         WvbHmm4hNQpSWx6/K732hOKawJFUthpmHETQXgQ84lF5lJeCsy1PUxw/iFuWrgeMEQac
         T5AOXCico3OZq3p6kMGu1/y2T17TzDOQP3PVj9Ix1M0xunBbMv2hpSrB1C51gWY19wLY
         oXyffzheep79mgzDWeyVBQJgmEFJ3GwxBj+dN5ceGku9h/YWItoe0HHlhhnuzu7LG5/n
         Wr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Syh1EZ1DQNwigQQy+Ki+L781cGjLlmx5MmyUvLvf1+I=;
        b=amK7hycn7SYO24+Z7g7LZCEYYRc9MjFZo8jRzdBTcMR48IcD8S1mg5WIiHoBi/P0RD
         j4zaFcw0cXQ5GPRwe818/g+mrT/mcEbG26kj1GEt1pkRy52yj/NEMkLw2KReaqcKwwMq
         CUfvjZ0JT1jHUE3ljMUGMyj9SQgyG2ar06ox1qN39niesegybz/IRXKkQFy6iiZjJL9e
         cs4rzRf71p69VJ5ysIMnzzXrimDn0vN13mWwtk6gHS6JIe5jgoOf4k5ADPaKOh3e2Sm1
         KIheNgV1Y7emsZKtQ10BV6BZQfTJNv4ZAU8ak/NykkFYn3AVd8O50wcm34mDxd8jVefz
         ll9A==
X-Gm-Message-State: AOAM533vfGp2qR4pCf8YvFeFNv8dcSuxP6sIQgtW6bbJD8ZS79QI+Zdj
        6jiiN7RTiB5NrIgeel/sruZvKyORlQ8AMGnl
X-Google-Smtp-Source: ABdhPJx0T8GLvSCqED+2IFEUuDAJpl6iM9WIxTTBScDvrMsYmOtDJmTC0xjaoyaFe0AeY6+dULLF9Q==
X-Received: by 2002:a17:902:b696:b0:156:b63:6bed with SMTP id c22-20020a170902b69600b001560b636bedmr15227249pls.24.1650371503198;
        Tue, 19 Apr 2022 05:31:43 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm16968899pfj.43.2022.04.19.05.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 05:31:42 -0700 (PDT)
Message-ID: <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
Date:   Tue, 19 Apr 2022 06:31:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 6:21 AM, Avi Kivity wrote:
> On 19/04/2022 15.04, Jens Axboe wrote:
>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>
>>>>>
>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>> inline completion vs workqueue completion:
>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>> completions.
>>>
>>> I measured this:
>>>
>>>
>>>
>>>   Performance counter stats for 'system wide':
>>>
>>>           1,273,756 io_uring:io_uring_task_add
>>>
>>>        12.288597765 seconds time elapsed
>>>
>>> Which exactly matches with the number of requests sent. If that's the
>>> wrong counter to measure, I'm happy to try again with the correct
>>> counter.
>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>> expected.
> 
> 
> Ah, and it should be fine. I'll try 'perf diff' again (I ran it but
> didn't reach any conclusive results and assumed non-systemwide runs
> weren't measuring workqueues (and systemwide runs generated too much
> noise on my workstation)).

Might help to run the client from another box? But I did a quick run
just to see if it worked after setting it up, and it seems mostly
dominated by seastar itself. But nothing conclusive, was more of a
"let's see if it works". I'll take an actual look in a bit.

One thing that did stick out is excessive fget/fput, which is usually
solved by using direct descriptors with io_uring. You can use
accept_direct, for example, and then IOSQE_FIXED_FILE with the
send/recv. But it looks like you are just using io_uring for polling,
which also eliminates being able to do that.

You can retain the readiness based model and still use io_uring for the
actual data transfer, at least that would enable you to use some
features that would help reduce overhead.

Note that this is separate from the actual poll being slower. I might
try and write a basic benchmark that is just poll and see what comes up.
Would help do more targeted development and profiling.

>>>> Do you have a test case of sorts?
>>>
>>> Seastar's httpd, running on a single core, against wrk -c 1000 -t 4 http://localhost:10000/.
>>>
>>>
>>> Instructions:
>>>
>>>    git clone --recursive -b io_uring https://github.com/avikivity/seastar
>>>
>>>    cd seastar
>>>
>>>    sudo ./install-dependencies.sh  # after carefully verifying it, of course
>>>
>>>    ./configure.py --mode release
>>>
>>>    ninja -C build/release apps/httpd/httpd
>>>
>>>    ./build/release/apps/httpd/httpd --smp 1 [--reactor-backing io_uring|linux-aio|epoll]

s/backing/backend

>>>> For a performance oriented network setup, I'd normally not consider data
>>>> readiness poll replacements to be that interesting, my recommendation
>>>> would be to use async send/recv for that instead. That's how io_uring is
>>>> supposed to be used, in a completion based model.
>>>>
>>> That's true. Still, an existing system that evolved around poll will
>>> take some time and effort to migrate, and have slower IORING_OP_POLL
>>> means it cannot benefit from io_uring's many other advantages if it
>>> fears a regression from that difference.
>> I'd like to separate the two - should the OP_POLL work as well, most
>> certainly. Do I think it's largely a useless way to run it, also yes :-)
> 
> 
> Agree.
> 
> 
>>
>>> Note that it's not just a matter of converting poll+recvmsg to
>>> IORING_OP_RECVMSG. If you support many connections, one must migrate
>>> to internal buffer selection, otherwise the memory load with a large
>>> number of idle connections is high. The end result is wonderful but
>>> the road there is long.
>>
>> Totally agree. My point is just that to take full advantage of it,
>> you need to be using that kind of model and quick conversions aren't
>> really expected to yield much of a performance win. They are also not
>> supposed to run slower, so that does need some attention if that's
>> the case here.
>>
> 
> We're in agreement, but I'd like to clarify the quick conversion is
> intended to win from other aspects of io_uring, with the deeper change
> coming later.

Ideally, yes.

-- 
Jens Axboe

