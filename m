Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE451E860
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 18:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386020AbiEGQFP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 12:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446647AbiEGQFI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 12:05:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63E531360;
        Sat,  7 May 2022 09:01:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so10127086plg.5;
        Sat, 07 May 2022 09:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=aye1ix5SVTRHkbkvpzclUiYs0mNgvEF1ximbjKFn7yk=;
        b=H/boOrj0Z75HUy43EKI76wjboM5zMxKmRUZXrqkEJ2VDM+IlPf5iEdTkKXu4D726Qj
         dQnnEy3qDlQSit88/FVp1USGCAbX2TAN7FoADGe7cUS/KE3VsZAtaLMB0jRS8zp/z5G3
         PHiuaFPYXNhqUrmYsc1w0zW3t9VLc9BWHQ3JFEaHmUIupL/4V0rGg+NUhPHjT8CokSDJ
         +STuYV5k8FkOLWwEPMevxY5wd/udE3thKz9GtcdV5KtmYC52WBRa3uuNS7FjW/4yO/lI
         0j2HABKWp/75rAwfXlopuIwWGtwLtaMNAD3GbJ88QSBrCL0idZnBhZll1NCfdon9GCpn
         Orug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aye1ix5SVTRHkbkvpzclUiYs0mNgvEF1ximbjKFn7yk=;
        b=Vyot7yySDxIBq6TDBsBi79jwhtvyFrktondc04UxWvmKAC1aPxRYAI6fdxFLILdYTu
         1yq0CwhHgHJp5c4jwoL+YUpfnBZT16M6ZaPXVQfmeAGg3tfl2Z1/+ysq7Vxm+MH82+TO
         liF2tYpmLapf+CGvXOB/VhArq5EuItrHqPtBZCXgw9cyEmbLcKzHK2bWX2mYXe+PcQL3
         Dcc0IMdeFPYjUk1F6FG1XmD+fb9Axbwas8ANQnZ8xd4zPiQhICsyW5u4WH1d2jim7bg6
         yZ7Mp9wK51/Pch3ADC+lIOESU0PSflF+lc8LYVTaIvDqqch0iM8i+Z2qEeI5igBGnB9o
         6+Lw==
X-Gm-Message-State: AOAM531/7DuyeiiTZowpU1hfRXQsViubqhm8QvxwVTr9120NXJ6AZjyr
        xmVIrTzSRjhBD4HpBtzrB+M=
X-Google-Smtp-Source: ABdhPJyEgUoXtam7H6IfvFw2KNjf74QhV2UgtLef1Rfhg/iGWl6nDRFYf3pMvYQXqp+Bm4noWWUt6g==
X-Received: by 2002:a17:90a:e7d2:b0:1dc:3762:c72d with SMTP id kb18-20020a17090ae7d200b001dc3762c72dmr18048087pjb.243.1651939280313;
        Sat, 07 May 2022 09:01:20 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id pi7-20020a17090b1e4700b001cd4989ff60sm5613611pjb.39.2022.05.07.09.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 09:01:20 -0700 (PDT)
Message-ID: <d0176b96-9df9-5441-476f-773f4cd777e8@gmail.com>
Date:   Sun, 8 May 2022 00:01:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <9157fe69-b5d4-2478-7a0d-e037b5550168@kernel.dk>
 <08ff00da-b871-2f2a-7b23-c8b2621df9dd@kernel.dk>
 <f38291aa-bc6f-dafe-4765-0785b72e6c53@kernel.dk>
 <5b973074-d566-c5f2-0f8f-4a2d1a02217b@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <5b973074-d566-c5f2-0f8f-4a2d1a02217b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 上午11:08, Jens Axboe 写道:
> On 5/6/22 8:33 PM, Jens Axboe wrote:
>> On 5/6/22 5:26 PM, Jens Axboe wrote:
>>> On 5/6/22 4:23 PM, Jens Axboe wrote:
>>>> On 5/6/22 1:00 AM, Hao Xu wrote:
>>>>> Let multishot support multishot mode, currently only add accept as its
>>>>> first comsumer.
>>>>> theoretical analysis:
>>>>>    1) when connections come in fast
>>>>>      - singleshot:
>>>>>                add accept sqe(userpsace) --> accept inline
>>>>>                                ^                 |
>>>>>                                |-----------------|
>>>>>      - multishot:
>>>>>               add accept sqe(userspace) --> accept inline
>>>>>                                                ^     |
>>>>>                                                |--*--|
>>>>>
>>>>>      we do accept repeatedly in * place until get EAGAIN
>>>>>
>>>>>    2) when connections come in at a low pressure
>>>>>      similar thing like 1), we reduce a lot of userspace-kernel context
>>>>>      switch and useless vfs_poll()
>>>>>
>>>>>
>>>>> tests:
>>>>> Did some tests, which goes in this way:
>>>>>
>>>>>    server    client(multiple)
>>>>>    accept    connect
>>>>>    read      write
>>>>>    write     read
>>>>>    close     close
>>>>>
>>>>> Basically, raise up a number of clients(on same machine with server) to
>>>>> connect to the server, and then write some data to it, the server will
>>>>> write those data back to the client after it receives them, and then
>>>>> close the connection after write return. Then the client will read the
>>>>> data and then close the connection. Here I test 10000 clients connect
>>>>> one server, data size 128 bytes. And each client has a go routine for
>>>>> it, so they come to the server in short time.
>>>>> test 20 times before/after this patchset, time spent:(unit cycle, which
>>>>> is the return value of clock())
>>>>> before:
>>>>>    1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>>>>>    +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>>>>>    +1934226+1914385)/20.0 = 1927633.75
>>>>> after:
>>>>>    1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>>>>>    +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>>>>>    +1871324+1940803)/20.0 = 1894750.45
>>>>>
>>>>> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
>>>>>
>>>>>
>>>>> A liburing test is here:
>>>>> https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c
>>>>
>>>> Wish I had seen that, I wrote my own! But maybe that's good, you tend to
>>>> find other issues through that.
>>>>
>>>> Anyway, works for me in testing, and I can see this being a nice win for
>>>> accept intensive workloads. I pushed a bunch of cleanup patches that
>>>> should just get folded in. Can you fold them into your patches and
>>>> address the other feedback, and post a v3? I pushed the test branch
>>>> here:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/log/?h=fastpoll-mshot
>>>
>>> Quick benchmark here, accepting 10k connections:
>>>
>>> Stock kernel
>>> real	0m0.728s
>>> user	0m0.009s
>>> sys	0m0.192s
>>>
>>> Patched
>>> real	0m0.684s
>>> user	0m0.018s
>>> sys	0m0.102s
>>>
>>> Looks like a nice win for a highly synthetic benchmark. Nothing
>>> scientific, was just curious.
>>
>> One more thought on this - how is it supposed to work with
>> accept-direct? One idea would be to make it incrementally increasing.
>> But we need a good story for that, if it's exclusive to non-direct
>> files, then it's a lot less interesting as the latter is really nice win
>> for lots of files. If we can combine the two, even better.
> 
> Running some quick testing, on an actual test box (previous numbers were
> from a vm on my laptop):
> 
> Testing singleshot, normal files
> Did 10000 accepts
> 
> ________________________________________________________
> Executed in  216.10 millis    fish           external
>     usr time    9.32 millis  150.00 micros    9.17 millis
>     sys time  110.06 millis   67.00 micros  109.99 millis
> 
> Testing multishot, fixed files
> Did 10000 accepts
> 
> ________________________________________________________
> Executed in  189.04 millis    fish           external
>     usr time   11.86 millis  159.00 micros   11.71 millis
>     sys time   93.71 millis   70.00 micros   93.64 millis
> 
> That's about ~19 usec to accept a connection, pretty decent. Using
> singleshot and with fixed files, it shaves about ~8% off, ends at around
> 200msec.
> 
> I think we can get away with using fixed files and multishot, attaching
I'm not following, do you mean we shouldn't do the multishot+fixed file
or we should use multishot+fixed to make the result better?
> the quick patch I did below to test it. We need something better than
Sorry Jens, I didn't see the quick patch, is there anything I misunderstand?
> this, otherwise once the space fills up, we'll likely end up with a
> sparse space and the naive approach of just incrementing the next slot
> won't work at all.

> 

