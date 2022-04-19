Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71300506C35
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 14:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350021AbiDSMYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 08:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiDSMY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 08:24:29 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E4D2A245
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:21:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 21so21066152edv.1
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 05:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=0iHks1QhfYG6sYB9/11P7sMFYjhJTLgxMNrl7+KuuQs=;
        b=A07CNkx7C8qLs4mXALIsmC23EB4SS0odPk3UDY0Mu0H+G/qDiBj38jWMBFIVTVNNJp
         QERIQ8tA/bjshIqym5gpoVVj4aD28IhO2DTMJWgBVs4KLRmj0l8fQdViBilypt2jR7L2
         rKuneyfI7a5F5QhalEkiSkZA3Q5F42kxkrolL8wCTxEAXVuUJDn9d5ejisG9yjyM3GUx
         10AHo1jQF18T9WWs5+AASni8K+Q0YGaki59NX4sgllFUNfG708ThzIDUurSkoOE2moJm
         CpBYXbQK+GFMBaA85eARhEfduG1Bn5GTlDPs0vwAN0xV4QYe2XZrGc7+8D5aEIIyLGh2
         uytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=0iHks1QhfYG6sYB9/11P7sMFYjhJTLgxMNrl7+KuuQs=;
        b=rqWNzt2OYCALWm2FUR1x0Ye9S1lRCEjhhBsFZdLKigtq537QsY7lOSsGRav9wnSy5v
         vZPuZ3uoVTXzQOahX35VE/YwJd90Nd5PS2uRWiOQFNqa6pmKhTmY0BWLoDBtO3PNfHsD
         sDZ4F/1cDXPCczWnd4qDP128YZV7vltdUZS+ALswlSg2rze4Yt71QMeSwTF7DtBnqMju
         t3/yKOsCi3M+iawWGkAUWzkIjw51zkJND1CkEKfjTyiC23exkZe5B8DU2uJwAV9XRNiz
         HcZ21GkNEbgPhmBAZAlKylPSBAzl0cu4/YBsOfOl49QQdP9+wss2w/Gf/U4sKpLl/j+6
         M8zA==
X-Gm-Message-State: AOAM532krkXGR1VmzQwOt74mbrQJ5k+CJLnscSEQN03l0a8+s63hK28n
        kIzGkBKMvx6BEVn6wGUeRh5DPA==
X-Google-Smtp-Source: ABdhPJwE9NRPTHQiQDTMgHa3nluFmevg+63pnwO+kZL3Ib8AXcBe7Q6F3TCzPKpGr6TcTQyEJ8+vEw==
X-Received: by 2002:a05:6402:2809:b0:423:e123:5e40 with SMTP id h9-20020a056402280900b00423e1235e40mr11693339ede.84.1650370904654;
        Tue, 19 Apr 2022 05:21:44 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id h23-20020a0564020e9700b00420fff23180sm7817965eda.41.2022.04.19.05.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 05:21:44 -0700 (PDT)
Message-ID: <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
Date:   Tue, 19 Apr 2022 15:21:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/04/2022 15.04, Jens Axboe wrote:
> On 4/19/22 5:57 AM, Avi Kivity wrote:
>> On 19/04/2022 14.38, Jens Axboe wrote:
>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>
>>>>
>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>> inline completion vs workqueue completion:
>>> I don't think that's it, io_uring never punts to a workqueue for
>>> completions.
>>
>> I measured this:
>>
>>
>>
>>   Performance counter stats for 'system wide':
>>
>>           1,273,756 io_uring:io_uring_task_add
>>
>>        12.288597765 seconds time elapsed
>>
>> Which exactly matches with the number of requests sent. If that's the
>> wrong counter to measure, I'm happy to try again with the correct
>> counter.
> io_uring_task_add() isn't a workqueue, it's task_work. So that is
> expected.


Ah, and it should be fine. I'll try 'perf diff' again (I ran it but 
didn't reach any conclusive results and assumed non-systemwide runs 
weren't measuring workqueues (and systemwide runs generated too much 
noise on my workstation)).


>>> Do you have a test case of sorts?
>>
>> Seastar's httpd, running on a single core, against wrk -c 1000 -t 4 http://localhost:10000/.
>>
>>
>> Instructions:
>>
>>    git clone --recursive -b io_uring https://github.com/avikivity/seastar
>>
>>    cd seastar
>>
>>    sudo ./install-dependencies.sh  # after carefully verifying it, of course
>>
>>    ./configure.py --mode release
>>
>>    ninja -C build/release apps/httpd/httpd
>>
>>    ./build/release/apps/httpd/httpd --smp 1 [--reactor-backing io_uring|linux-aio|epoll]
>>
>>
>> and run wrk againt it.
> Thanks, I'll give that a spin!


Thanks. You may need ./configure --c++-dialect=c++17 if your C++ 
compiler is too old.


>
>>> For a performance oriented network setup, I'd normally not consider data
>>> readiness poll replacements to be that interesting, my recommendation
>>> would be to use async send/recv for that instead. That's how io_uring is
>>> supposed to be used, in a completion based model.
>>>
>> That's true. Still, an existing system that evolved around poll will
>> take some time and effort to migrate, and have slower IORING_OP_POLL
>> means it cannot benefit from io_uring's many other advantages if it
>> fears a regression from that difference.
> I'd like to separate the two - should the OP_POLL work as well, most
> certainly. Do I think it's largely a useless way to run it, also yes :-)


Agree.


>
>> Note that it's not just a matter of converting poll+recvmsg to
>> IORING_OP_RECVMSG. If you support many connections, one must migrate
>> to internal buffer selection, otherwise the memory load with a large
>> number of idle connections is high. The end result is wonderful but
>> the road there is long.
> Totally agree. My point is just that to take full advantage of it, you
> need to be using that kind of model and quick conversions aren't really
> expected to yield much of a performance win. They are also not supposed
> to run slower, so that does need some attention if that's the case here.
>

We're in agreement, but I'd like to clarify the quick conversion is 
intended to win from other aspects of io_uring, with the deeper change 
coming later.


