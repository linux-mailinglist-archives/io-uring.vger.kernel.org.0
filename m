Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03C6506BD3
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 14:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349915AbiDSMKt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 08:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352087AbiDSMIS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 08:08:18 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AF0655A
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:04:03 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k29so23301339pgm.12
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qHLp+tiB7pkS894xxfLH2jMGbzBO3e+tE7CvKHY7z9Q=;
        b=vE6EV8xkbu+3/BXwIx0dvdnUDmosEymT70lTlED2851fhRDJmR6dHMjZe1Nm0Svz4f
         9z/8aTdii3ZTx3qK7E2TFx4CeGWHHf2KatuJKwNLtC2nl9mAui6NB/u6zhkCB26lkUvV
         9BevPM4Asgl+KogGi1PLdqu2naP6suA1yuLbvSuQ3pqPYvUhaDEzGZ6ORxIzxiEpGP6F
         TuhoMBzyGUvAnQ5K28dpir4F/4FEyc49UMmR2Q1S/3gaWRK14jEDPZ/Fmokub9nPTgwO
         YgLNEqkm7EImkLa1Uuq9ZVCDvdeiABMJ2ybOH7eBWG8XLTR8B7nC9ClOR+AZeUPYS9yY
         8J0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qHLp+tiB7pkS894xxfLH2jMGbzBO3e+tE7CvKHY7z9Q=;
        b=hsqNJ5Tr5UMk2yOJk42gHbipO0LpsdM/ZPeXSp9lcS9Jzhpt98Kygo3aFTzCA2vpaF
         av0ysA8uKx7X/0KZofhXIsgQp8dveK8hlHUIDCWZ8y8kAljJiu98pQnn9zu3e4Zn9NsO
         FYTgw1LYlcsJisjs+NjdgCxLgq2eGcsb1SNCzuETDeCNjCO/h3wydm7nf0nL/9qLRsjh
         iQ7Tusgd9kNqIv8htvPf1vldcDTWdaTH6DhFNMSsKQPAnZLa8w9zgEoxRf+3QERP9cCc
         3pJwQFFM/F/gDeE43h7KAnGzvTXyY/R+LyRJ19Y8dHDJJIr61qXoYNlqmNWPknu3qp/O
         nrNA==
X-Gm-Message-State: AOAM532HfnUPZ05FbDXLkWHrEfW7kYZ1NXO02iVPtfgpJmskQTx4aDL5
        Rhtsm3k0GmxyLFSuzhZNmW7kIT5lovydBy4b
X-Google-Smtp-Source: ABdhPJwULNOEi3afV6Uor0x4jd20bIZfFUYNspB0GMMeDFR6m5ufp6qnQ5i4ohN7YV3ZmPa29kjqiw==
X-Received: by 2002:a63:5a01:0:b0:3a8:9ab7:3382 with SMTP id o1-20020a635a01000000b003a89ab73382mr11652074pgb.272.1650369842601;
        Tue, 19 Apr 2022 05:04:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 81-20020a621754000000b005082073f62dsm16900613pfx.12.2022.04.19.05.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 05:04:02 -0700 (PDT)
Message-ID: <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
Date:   Tue, 19 Apr 2022 06:04:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
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

On 4/19/22 5:57 AM, Avi Kivity wrote:
> 
> On 19/04/2022 14.38, Jens Axboe wrote:
>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>
>>>
>>> I expect the loss is due to an optimization that io_uring lacks -
>>> inline completion vs workqueue completion:
>> I don't think that's it, io_uring never punts to a workqueue for
>> completions.
> 
> 
> I measured this:
> 
> 
> 
>  Performance counter stats for 'system wide':
> 
>          1,273,756 io_uring:io_uring_task_add
> 
>       12.288597765 seconds time elapsed
> 
> Which exactly matches with the number of requests sent. If that's the
> wrong counter to measure, I'm happy to try again with the correct
> counter.

io_uring_task_add() isn't a workqueue, it's task_work. So that is
expected.

>>   The aio inline completions is more of a hack because it
>> needs to do that, as always using a workqueue would lead to bad
>> performance and higher overhead.
>>
>> So if there's a difference in performance, it's something else and we
>> need to look at that. But your report is pretty lacking! What kernel are
>> you running?
> 
> 
> 5.17.2-300.fc36.x86_64

OK, that sounds fine.

>> Do you have a test case of sorts?
> 
> 
> Seastar's httpd, running on a single core, against wrk -c 1000 -t 4 http://localhost:10000/.
> 
> 
> Instructions:
> 
>   git clone --recursive -b io_uring https://github.com/avikivity/seastar
> 
>   cd seastar
> 
>   sudo ./install-dependencies.sh  # after carefully verifying it, of course
> 
>   ./configure.py --mode release
> 
>   ninja -C build/release apps/httpd/httpd
> 
>   ./build/release/apps/httpd/httpd --smp 1 [--reactor-backing io_uring|linux-aio|epoll]
> 
> 
> and run wrk againt it.

Thanks, I'll give that a spin!

>> For a performance oriented network setup, I'd normally not consider data
>> readiness poll replacements to be that interesting, my recommendation
>> would be to use async send/recv for that instead. That's how io_uring is
>> supposed to be used, in a completion based model.
>>
> 
> That's true. Still, an existing system that evolved around poll will
> take some time and effort to migrate, and have slower IORING_OP_POLL
> means it cannot benefit from io_uring's many other advantages if it
> fears a regression from that difference.

I'd like to separate the two - should the OP_POLL work as well, most
certainly. Do I think it's largely a useless way to run it, also yes :-)

> Note that it's not just a matter of converting poll+recvmsg to
> IORING_OP_RECVMSG. If you support many connections, one must migrate
> to internal buffer selection, otherwise the memory load with a large
> number of idle connections is high. The end result is wonderful but
> the road there is long.

Totally agree. My point is just that to take full advantage of it, you
need to be using that kind of model and quick conversions aren't really
expected to yield much of a performance win. They are also not supposed
to run slower, so that does need some attention if that's the case here.

-- 
Jens Axboe

