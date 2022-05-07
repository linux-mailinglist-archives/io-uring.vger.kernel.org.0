Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130D951E39A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 04:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357389AbiEGCho (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 22:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiEGChn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 22:37:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E9339800
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 19:33:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a11so7695531pff.1
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 19:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=LQp91HzWmRXSJ11o4G4YMJUoyWTLsvQZu+m9o4D0PsA=;
        b=iLc7pxx8orRn0pnY4uNUCX2AWIi7WTicgtTkIaT8Wt5Bx9l7GzDARh5eD1mwEwew/n
         AyUdc1Mc1CB3QNBxYePdJbEuGwBKkmfkd0dyw03upy+iSs5WifvLAIvD7JVqSwHl3aTh
         7E45RmN45+vHmFy2UM/2tB/UHzQr+KV1DOiUmAAdvzgcL2Bz7YIxjzr491quZgzOVxft
         m2T5jMBkcy6iu6/809rOsmildG2/HC6SiRrCMv/YJU8IcRvDTnPHsTzBgBiyLP4WZd3p
         37ZVGDLWlIJUw1b8ZGn03PGRT8tMH4leiMoZraRDOKFIwU45SLZ/hhE8Qr/oFj+lLJoN
         hf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=LQp91HzWmRXSJ11o4G4YMJUoyWTLsvQZu+m9o4D0PsA=;
        b=PnDhjqic9qPcqPBPb5fWjt+OwynI3gQpm15t20Tw0/4VfSufpTL/VPPw5Hr6MkzHk9
         t0lAZE/7lgT0zUE+aiCCUW0LQ6V/AwU1fZa1JsDQMyn+RzIKplmSPycMKkB+h7Y8Tgeg
         Eqj3Zi9RFT8iLxW5YPqb4DVeXlM+0kkdalIaz+Nxu6K+DBX5vetcn0wk1RiFnLsnsR6s
         EWqwJ16xwa5lehU+A7gB2068Xb7wqp8sPZRKM2J2WFbxXm1KTQ9UonKsqZTFv0EfjWSJ
         xlfiRvu0C+LaQaT5m0yJBGF0a1c0arvbdcWg0UwhD470UjiJSLB4VkPXQTVh6DPKcAPb
         pZ5Q==
X-Gm-Message-State: AOAM531a52Wc9MM9s9kv2dECqOMd1vM+7JPfwHuFYHN+RAmAKVQRhSG5
        DbhQRd0mp87Fo1pdNYH19Xw4PwhvMLq7vQ==
X-Google-Smtp-Source: ABdhPJyzM2xwc6FKxLVIfj2DpnW/2YMwMAahyeGE2ZoiC3yyBbLrlmwydisovE8Et7+zj1rfJqaueA==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id l14-20020a637c4e000000b003808ae9c975mr5222563pgn.25.1651890837591;
        Fri, 06 May 2022 19:33:57 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v1-20020a622f01000000b0050dc76281c5sm4052720pfv.159.2022.05.06.19.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 19:33:57 -0700 (PDT)
Message-ID: <f38291aa-bc6f-dafe-4765-0785b72e6c53@kernel.dk>
Date:   Fri, 6 May 2022 20:33:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <9157fe69-b5d4-2478-7a0d-e037b5550168@kernel.dk>
 <08ff00da-b871-2f2a-7b23-c8b2621df9dd@kernel.dk>
In-Reply-To: <08ff00da-b871-2f2a-7b23-c8b2621df9dd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 5:26 PM, Jens Axboe wrote:
> On 5/6/22 4:23 PM, Jens Axboe wrote:
>> On 5/6/22 1:00 AM, Hao Xu wrote:
>>> Let multishot support multishot mode, currently only add accept as its
>>> first comsumer.
>>> theoretical analysis:
>>>   1) when connections come in fast
>>>     - singleshot:
>>>               add accept sqe(userpsace) --> accept inline
>>>                               ^                 |
>>>                               |-----------------|
>>>     - multishot:
>>>              add accept sqe(userspace) --> accept inline
>>>                                               ^     |
>>>                                               |--*--|
>>>
>>>     we do accept repeatedly in * place until get EAGAIN
>>>
>>>   2) when connections come in at a low pressure
>>>     similar thing like 1), we reduce a lot of userspace-kernel context
>>>     switch and useless vfs_poll()
>>>
>>>
>>> tests:
>>> Did some tests, which goes in this way:
>>>
>>>   server    client(multiple)
>>>   accept    connect
>>>   read      write
>>>   write     read
>>>   close     close
>>>
>>> Basically, raise up a number of clients(on same machine with server) to
>>> connect to the server, and then write some data to it, the server will
>>> write those data back to the client after it receives them, and then
>>> close the connection after write return. Then the client will read the
>>> data and then close the connection. Here I test 10000 clients connect
>>> one server, data size 128 bytes. And each client has a go routine for
>>> it, so they come to the server in short time.
>>> test 20 times before/after this patchset, time spent:(unit cycle, which
>>> is the return value of clock())
>>> before:
>>>   1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>>>   +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>>>   +1934226+1914385)/20.0 = 1927633.75
>>> after:
>>>   1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>>>   +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>>>   +1871324+1940803)/20.0 = 1894750.45
>>>
>>> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
>>>
>>>
>>> A liburing test is here:
>>> https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c
>>
>> Wish I had seen that, I wrote my own! But maybe that's good, you tend to
>> find other issues through that.
>>
>> Anyway, works for me in testing, and I can see this being a nice win for
>> accept intensive workloads. I pushed a bunch of cleanup patches that
>> should just get folded in. Can you fold them into your patches and
>> address the other feedback, and post a v3? I pushed the test branch
>> here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=fastpoll-mshot
> 
> Quick benchmark here, accepting 10k connections:
> 
> Stock kernel
> real	0m0.728s
> user	0m0.009s
> sys	0m0.192s
> 
> Patched
> real	0m0.684s
> user	0m0.018s
> sys	0m0.102s
> 
> Looks like a nice win for a highly synthetic benchmark. Nothing
> scientific, was just curious.

One more thought on this - how is it supposed to work with
accept-direct? One idea would be to make it incrementally increasing.
But we need a good story for that, if it's exclusive to non-direct
files, then it's a lot less interesting as the latter is really nice win
for lots of files. If we can combine the two, even better.

-- 
Jens Axboe

