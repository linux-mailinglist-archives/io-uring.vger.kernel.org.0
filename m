Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36ECB250013
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 16:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHXOpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 10:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXOpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 10:45:11 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986BFC061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 07:45:10 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id 77so7445608ilc.5
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=omlf4XnG8vtvi6QZ+wBmKWnZwxm9lsyVf3BvIi/YgC0=;
        b=ERDCwo+27pmwSKVk3S+/uXAXVsG5bADkYO7wW/djBPUbjmsRh+IMZtrrxZyCmJVUAq
         IbZa6LxFaVoRi/a1TphWh7X29Gwe5+yqpW9ZmsWg3H+FQ7zb70WaOE6AqBw/UcZsJDFK
         5DWa1G5PE0n7c0Aj6DxmOLf1nwOBmvLpnnKkBxMTWf7fGtCk7M1CtwlX4ub9mj8XWrbr
         7bG0Sgo7tkc8nJ40M2E/K+L9wY+PE/E92K6nGxhoy8rdnKN94zHCT2s39/Tp1OGYiObd
         rnSDlPfToBe/GSA8nwtFBhrDhft7XMmuKTlIo7rclSNnk2UIL5JahYJyfLHNTL6xk8jo
         H1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=omlf4XnG8vtvi6QZ+wBmKWnZwxm9lsyVf3BvIi/YgC0=;
        b=FQtC/7y6GqJm/yvlFLco0hhzQx6DmnT9DDLp89kdEa8V3nM/9vveUkZ+78TQvFRAvz
         OL7F5a0FGM0cEd9MdPUnMi6x/VwRGw8Ry2SZKtxR6XkrYaklFIh4vp3RLTloIECey++Q
         JqAAXVnJqbhReaj3KOXJpAaduUPS/tf0x3Y/6stwVmhZKXbDU9N0OQoSZDJQaWG/SeAQ
         3huzqdud6KoVHnYE6C7nzRhhhuknms38XZ0JWXnh84Tc1bo/XKOQtRjsR2pFwEO2+wjL
         Q8ahCpSFGBYD5JBW0YiCWE5z6D6UucQSlIxhee0sJEqJ3DdCswyfKfGOHLrA6IBdL2vl
         /G7A==
X-Gm-Message-State: AOAM532L1FIodtsT4w3FavT/DDvfTVnFriPIkHc+ih5iUDSoW0U5BIka
        armfrY/aebYyE9iIKR2ej9Kx/gWUjFmkC44h
X-Google-Smtp-Source: ABdhPJxXf+7u9rZ9dsp82yy2sZjSAMAzn/QPjXgT/uAXJWg3tlPCKpxC/pJD+k8txZbZpxe2QMiFOw==
X-Received: by 2002:a92:8556:: with SMTP id f83mr5126515ilh.135.1598280309629;
        Mon, 24 Aug 2020 07:45:09 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b5sm7290663ilr.58.2020.08.24.07.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 07:45:09 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
From:   Jens Axboe <axboe@kernel.dk>
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
Message-ID: <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
Date:   Mon, 24 Aug 2020 08:45:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 8:06 AM, Jens Axboe wrote:
> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
>> library that i am using https://github.com/dshulyak/uring
>> It requires golang 1.14, if installed, benchmark can be run with:
>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
>>
>> note that it will setup uring instance per cpu, with shared worker pool.
>> it will take me too much time to implement repro in c, but in general
>> i am simply submitting multiple concurrent
>> read requests and watching read rate.
> 
> I'm fine with trying your Go version, but I can into a bit of trouble:
> 
> axboe@amd ~/g/go-uring (master)> 
> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> # github.com/dshulyak/uring/fixed
> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
>       |                                                ^
> FAIL	github.com/dshulyak/uring/fs [build failed]
> FAIL
> axboe@amd ~/g/go-uring (master)> go version
> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64

Alright, got it working. What device are you running this on? And am I
correct in assuming you get short reads, or rather 0 reads? What file
system?

-- 
Jens Axboe

