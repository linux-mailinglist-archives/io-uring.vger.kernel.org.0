Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19051E3B9
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 05:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445396AbiEGDMZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 23:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiEGDMY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 23:12:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F358B6FA33
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 20:08:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j14so9142782plx.3
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 20:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=YiVtUN9RMC+ccpP3u2sQPE9TYulEOLYR7bwEiku5MgQ=;
        b=09WqyUCy2aNPywAWRLARIJlYaZKXyMWDLLgd6xFHz3YZyQNQe15DpbCgbJTn89WYYf
         ZUrAfXvbpzPs4CVBTl/Mkg5DqdqRn1r6m8DcvDYjrkWw+KF9cPmojkcG4dA5Tq0zmjDZ
         yyzuLoKc7sy2fdHjMElk3ZPel6o6dojYduEhLV4DAbjfR88BoIzCR0+GKLfv7MV4JtZb
         xNa/UjHxcvl5YnBWGTiTy2+Vvrc7EH7R22IiXYSOUDfN5xYU4aCOFnb2xLBoAqccEblH
         JlBY27BOBIXhpXG0GStx/U22d7F0FIXTDOP8vn21skniI47MCq+6SwP20OUtjnMsF8Dg
         8bUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YiVtUN9RMC+ccpP3u2sQPE9TYulEOLYR7bwEiku5MgQ=;
        b=4DgQ/Y13B5mMAFrfT8KUe77hXNZRC2FvYt5pJFUQ0pqMe9E7DtTAaPPHkoIEZzYC9S
         5IV1Q7yskg2BDzOFlSSGzyPaUMOwEo5zogn/DRlEFMOkh2R2A27CVgLs3Yt/AiG0wO2p
         P0gguc0RbigyfiRx1npOMvwC0X8sv6Oho2QIQRPMLAq7+oEVNHHS2jwMtmUo/K/IIL9l
         3jq2EZgZ7Lsw/q34Wio3TxPce8sIqP9Yj67+ViWpHfWs7qqQ2sgqpUzTv4upYmsg1UwK
         DwMZS9eVBhmEdjhLFYBhByT+kH8DGGL6HJr9yWX+88EM2/IAK8yHfi+qE2emSyNUkcNe
         HGrw==
X-Gm-Message-State: AOAM530wRzSQnn4lGOiYO3UB5p/Xv2zZnGox8Tyazk4UX7rCHOQj2jRa
        5fxjBmLwHYL0N2qbYueMExznpw==
X-Google-Smtp-Source: ABdhPJzuXziifH5yrq/umGTx0B3TAq78hCjNwiuVZwicD1SGCLdcNLqtk7C2CK1+UsypRWdnClsEOQ==
X-Received: by 2002:a17:902:e8cd:b0:15e:ee3b:7839 with SMTP id v13-20020a170902e8cd00b0015eee3b7839mr5415909plg.92.1651892918347;
        Fri, 06 May 2022 20:08:38 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i11-20020a63d44b000000b003c5d88886a7sm4038621pgj.75.2022.05.06.20.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 20:08:37 -0700 (PDT)
Message-ID: <5b973074-d566-c5f2-0f8f-4a2d1a02217b@kernel.dk>
Date:   Fri, 6 May 2022 21:08:36 -0600
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
 <f38291aa-bc6f-dafe-4765-0785b72e6c53@kernel.dk>
In-Reply-To: <f38291aa-bc6f-dafe-4765-0785b72e6c53@kernel.dk>
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

On 5/6/22 8:33 PM, Jens Axboe wrote:
> On 5/6/22 5:26 PM, Jens Axboe wrote:
>> On 5/6/22 4:23 PM, Jens Axboe wrote:
>>> On 5/6/22 1:00 AM, Hao Xu wrote:
>>>> Let multishot support multishot mode, currently only add accept as its
>>>> first comsumer.
>>>> theoretical analysis:
>>>>   1) when connections come in fast
>>>>     - singleshot:
>>>>               add accept sqe(userpsace) --> accept inline
>>>>                               ^                 |
>>>>                               |-----------------|
>>>>     - multishot:
>>>>              add accept sqe(userspace) --> accept inline
>>>>                                               ^     |
>>>>                                               |--*--|
>>>>
>>>>     we do accept repeatedly in * place until get EAGAIN
>>>>
>>>>   2) when connections come in at a low pressure
>>>>     similar thing like 1), we reduce a lot of userspace-kernel context
>>>>     switch and useless vfs_poll()
>>>>
>>>>
>>>> tests:
>>>> Did some tests, which goes in this way:
>>>>
>>>>   server    client(multiple)
>>>>   accept    connect
>>>>   read      write
>>>>   write     read
>>>>   close     close
>>>>
>>>> Basically, raise up a number of clients(on same machine with server) to
>>>> connect to the server, and then write some data to it, the server will
>>>> write those data back to the client after it receives them, and then
>>>> close the connection after write return. Then the client will read the
>>>> data and then close the connection. Here I test 10000 clients connect
>>>> one server, data size 128 bytes. And each client has a go routine for
>>>> it, so they come to the server in short time.
>>>> test 20 times before/after this patchset, time spent:(unit cycle, which
>>>> is the return value of clock())
>>>> before:
>>>>   1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>>>>   +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>>>>   +1934226+1914385)/20.0 = 1927633.75
>>>> after:
>>>>   1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>>>>   +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>>>>   +1871324+1940803)/20.0 = 1894750.45
>>>>
>>>> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
>>>>
>>>>
>>>> A liburing test is here:
>>>> https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c
>>>
>>> Wish I had seen that, I wrote my own! But maybe that's good, you tend to
>>> find other issues through that.
>>>
>>> Anyway, works for me in testing, and I can see this being a nice win for
>>> accept intensive workloads. I pushed a bunch of cleanup patches that
>>> should just get folded in. Can you fold them into your patches and
>>> address the other feedback, and post a v3? I pushed the test branch
>>> here:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=fastpoll-mshot
>>
>> Quick benchmark here, accepting 10k connections:
>>
>> Stock kernel
>> real	0m0.728s
>> user	0m0.009s
>> sys	0m0.192s
>>
>> Patched
>> real	0m0.684s
>> user	0m0.018s
>> sys	0m0.102s
>>
>> Looks like a nice win for a highly synthetic benchmark. Nothing
>> scientific, was just curious.
> 
> One more thought on this - how is it supposed to work with
> accept-direct? One idea would be to make it incrementally increasing.
> But we need a good story for that, if it's exclusive to non-direct
> files, then it's a lot less interesting as the latter is really nice win
> for lots of files. If we can combine the two, even better.

Running some quick testing, on an actual test box (previous numbers were
from a vm on my laptop):

Testing singleshot, normal files
Did 10000 accepts

________________________________________________________
Executed in  216.10 millis    fish           external
   usr time    9.32 millis  150.00 micros    9.17 millis
   sys time  110.06 millis   67.00 micros  109.99 millis

Testing multishot, fixed files
Did 10000 accepts

________________________________________________________
Executed in  189.04 millis    fish           external
   usr time   11.86 millis  159.00 micros   11.71 millis
   sys time   93.71 millis   70.00 micros   93.64 millis

That's about ~19 usec to accept a connection, pretty decent. Using
singleshot and with fixed files, it shaves about ~8% off, ends at around
200msec.

I think we can get away with using fixed files and multishot, attaching
the quick patch I did below to test it. We need something better than
this, otherwise once the space fills up, we'll likely end up with a
sparse space and the naive approach of just incrementing the next slot
won't work at all.

-- 
Jens Axboe

