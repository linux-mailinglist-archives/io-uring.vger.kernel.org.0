Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36F2501DF
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgHXQS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 12:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHXQS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 12:18:26 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2847EC061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:18:26 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h4so9254626ioe.5
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XnAcS+ei9avb4RUt9vLWSv0daVJ0+00/gdfFXE7dBLM=;
        b=T3zD71tR05/8oU3cRzVP9HBws52YNxtpc0/RxeIKzEfPE6DmT1kB4TDOGnNFIdErZI
         UifVqGusHRrfpYykVlIchPfTydTIfjyhDA27J3u7Cj0fmA7o+V5yZyZ+4AxBBDmOwkhQ
         dQ9tKGzeYu3AYqkC2TTvvJOXB7VcFj/I6Lz/csO+G6fsW13iR5x+B6w5ZErW3UyvIO9A
         UysRBU6XBc3RewKtJ5aftMjG1Nrlijo324PyIo84gIT4SFFHErH3jazQXdJbsFuhCF+B
         KCnAFn4l7C74va/lNOGRRrr5YnM5OhTO1Pu0YPSQK6euNDmZ+hpAM919+5mgWBEcUgPf
         5jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnAcS+ei9avb4RUt9vLWSv0daVJ0+00/gdfFXE7dBLM=;
        b=ElkXEXFkhPNZ2QLDKGss/aNdZXPufwg7sqqi27LNz9KsRiqdvj9bp/AUdODFFHRMh6
         mEvc5a2Zx4tVr/dIVWgIF9/uEIKioBc3f7y1XWKy1OyJgQeK2hpwxNAZBL0wBip/hbZw
         hZc0G228b42rDcAc+pHni6DWRcUkI3behu1CF+FQ4C8TijdF7QFTjiVUtNPtH8aBJh9k
         Mdx2LOA9MLLMTbNE5ysqVhK/MAmlUKKHRbMwOXppYAIcDqcWfY2FOAniSOeTltKNQJzb
         9JlG1AnKbE6eRE9YldQyuwFgUwvN5j6x7Ov72VH+WTbPT6Y9ZAdMnlManEZW/d5XZYhS
         rhcA==
X-Gm-Message-State: AOAM5328eb4y1kb5uUXzoe5Gb8+F8yd+eb3FRKSiV+9TtTZGAWMh3nHx
        9JqRE8J40Uvgr4H13AQFLA9FLl7GSnNsB+Ri
X-Google-Smtp-Source: ABdhPJyEod/y3dOpl5mlLZTBGIPIAt0Xxv8LgH8jZ+Gbbq2TYC31qr1dGMucdBC7FPAbwJ+nJyiDHw==
X-Received: by 2002:a02:ce:: with SMTP id 197mr6395839jaa.65.1598285901090;
        Mon, 24 Aug 2020 09:18:21 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q23sm6900286ior.47.2020.08.24.09.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 09:18:20 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
 <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
 <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
 <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk>
Date:   Mon, 24 Aug 2020 10:18:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 10:13 AM, Dmitry Shulyak wrote:
> On Mon, 24 Aug 2020 at 19:10, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/24/20 9:33 AM, Dmitry Shulyak wrote:
>>> On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 8/24/20 8:06 AM, Jens Axboe wrote:
>>>>> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
>>>>>> library that i am using https://github.com/dshulyak/uring
>>>>>> It requires golang 1.14, if installed, benchmark can be run with:
>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
>>>>>>
>>>>>> note that it will setup uring instance per cpu, with shared worker pool.
>>>>>> it will take me too much time to implement repro in c, but in general
>>>>>> i am simply submitting multiple concurrent
>>>>>> read requests and watching read rate.
>>>>>
>>>>> I'm fine with trying your Go version, but I can into a bit of trouble:
>>>>>
>>>>> axboe@amd ~/g/go-uring (master)>
>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>>>> # github.com/dshulyak/uring/fixed
>>>>> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
>>>>>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
>>>>>       |                                                ^
>>>>> FAIL  github.com/dshulyak/uring/fs [build failed]
>>>>> FAIL
>>>>> axboe@amd ~/g/go-uring (master)> go version
>>>>> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
>>>>
>>>> Alright, got it working. What device are you running this on? And am I
>>>> correct in assuming you get short reads, or rather 0 reads? What file
>>>> system?
>>>
>>> Was going to look into this.
>>> I am getting 0 reads. This is on some old kingston ssd, ext4.
>>
>> I can't seem to reproduce this. I do see some cqe->res == 0 completes,
>> but those appear to be NOPs. And they trigger at the start and end. I'll
>> keep poking.
>
> Nops are used for draining and closing rings at the end of benchmarks.
> It also appears in the beginning because of the way golang runs
> benchmarks...

OK, just checking if it was expected.

But I can reproduce it now, turns out I was running XFS and that doesn't
trigger it. With ext4, I do see zero sized read completions. I'll keep
poking.

-- 
Jens Axboe

