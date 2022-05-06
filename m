Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21DC51E26B
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 01:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444957AbiEFXab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244289AbiEFXab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 19:30:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2370914
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 16:26:46 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c9so8138892plh.2
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 16:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=sW3k5smHGzAvkGL5s6X2GJ48bk9my2UsxwMn1HoATJ0=;
        b=Fg2juACA7QMx0UVuSbonjHUgroN2TskMKsnVmEe+20M+nYrADe0EO3S9Jz7Fm+kR/k
         Rh6rUvI7XrRG3ZhoOmzUW1WUYFmXZTgiADXmMgBvPIepiWiIqf2Ddxzdlp073yKIRxSa
         NHiED/BdYGXnbs/k0HUBkfAzgWnqSh5INgFHTCzxLe4DE/tyIzHUEklAUwXhCo54vO6H
         Tb95Ay8fvcKWOXmi7eYuhhrn9IdW2acQoTh0n8ZHEZfNvu4hN2uE9HZAT4QP9aS8KzNC
         hghBdFpK8+AXdxMIQrQ8NS1KRg0HsCIj24bKBug3k1P/bGfbyzWFy061LXvwokzB4JS+
         N4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=sW3k5smHGzAvkGL5s6X2GJ48bk9my2UsxwMn1HoATJ0=;
        b=gVkgA55zPTe0UnASGSQSYUEY1oMxqKHBP1PkVFKfCURSd3ynTZCtx3x7lUG2uisT9F
         w8S7Zh+T/CjED92S7GmjdbWbIiQHqo34aWnzrLt3TE92bNpPM9tP+0aM9cnetHe6nIE0
         IdiRsHTDxsZwgTCk0tlWnaAQlANvr6lT3kmsuKQ5rN2/6ZkdntgBFPuinLqB0b4tFmz8
         AFxcNvRgzC7mA70FphNOJxfGotHiQxAD6TX1FoO/aVdhIe2lAZ1qGceMNrv4TfysN0wp
         uVG4Ikybc2GVOSu+ejs2JNtBnBGcEjkRX/Y3h3jfHggSfqqSCv0ftzOlvkdfIxRWnki1
         PP6A==
X-Gm-Message-State: AOAM530dWt0tzi1uEQ4rCabtcCAF+2TRwFq0I5LtFFzxZ3tuo+hA7jjR
        dCCoTBx+GgaV5+Mnq1U2QScfDA==
X-Google-Smtp-Source: ABdhPJxvzQp1YQDLvQpQLWdZFXpY3AH+FJ+68QY2jhYuUaiFgU/LuUiQ/v6LneN9d+3PAdzWairtGA==
X-Received: by 2002:a17:902:ef48:b0:159:51d:f725 with SMTP id e8-20020a170902ef4800b00159051df725mr6182561plx.47.1651879605969;
        Fri, 06 May 2022 16:26:45 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s82-20020a632c55000000b003c619f3d086sm3903501pgs.2.2022.05.06.16.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 16:26:45 -0700 (PDT)
Message-ID: <08ff00da-b871-2f2a-7b23-c8b2621df9dd@kernel.dk>
Date:   Fri, 6 May 2022 17:26:44 -0600
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
In-Reply-To: <9157fe69-b5d4-2478-7a0d-e037b5550168@kernel.dk>
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

On 5/6/22 4:23 PM, Jens Axboe wrote:
> On 5/6/22 1:00 AM, Hao Xu wrote:
>> Let multishot support multishot mode, currently only add accept as its
>> first comsumer.
>> theoretical analysis:
>>   1) when connections come in fast
>>     - singleshot:
>>               add accept sqe(userpsace) --> accept inline
>>                               ^                 |
>>                               |-----------------|
>>     - multishot:
>>              add accept sqe(userspace) --> accept inline
>>                                               ^     |
>>                                               |--*--|
>>
>>     we do accept repeatedly in * place until get EAGAIN
>>
>>   2) when connections come in at a low pressure
>>     similar thing like 1), we reduce a lot of userspace-kernel context
>>     switch and useless vfs_poll()
>>
>>
>> tests:
>> Did some tests, which goes in this way:
>>
>>   server    client(multiple)
>>   accept    connect
>>   read      write
>>   write     read
>>   close     close
>>
>> Basically, raise up a number of clients(on same machine with server) to
>> connect to the server, and then write some data to it, the server will
>> write those data back to the client after it receives them, and then
>> close the connection after write return. Then the client will read the
>> data and then close the connection. Here I test 10000 clients connect
>> one server, data size 128 bytes. And each client has a go routine for
>> it, so they come to the server in short time.
>> test 20 times before/after this patchset, time spent:(unit cycle, which
>> is the return value of clock())
>> before:
>>   1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>>   +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>>   +1934226+1914385)/20.0 = 1927633.75
>> after:
>>   1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>>   +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>>   +1871324+1940803)/20.0 = 1894750.45
>>
>> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
>>
>>
>> A liburing test is here:
>> https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c
> 
> Wish I had seen that, I wrote my own! But maybe that's good, you tend to
> find other issues through that.
> 
> Anyway, works for me in testing, and I can see this being a nice win for
> accept intensive workloads. I pushed a bunch of cleanup patches that
> should just get folded in. Can you fold them into your patches and
> address the other feedback, and post a v3? I pushed the test branch
> here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=fastpoll-mshot

Quick benchmark here, accepting 10k connections:

Stock kernel
real	0m0.728s
user	0m0.009s
sys	0m0.192s

Patched
real	0m0.684s
user	0m0.018s
sys	0m0.102s

Looks like a nice win for a highly synthetic benchmark. Nothing
scientific, was just curious.

-- 
Jens Axboe

