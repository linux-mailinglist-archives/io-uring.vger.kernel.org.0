Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23483DEB01
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhHCKfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 06:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbhHCKfG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 06:35:06 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A39EC06179B;
        Tue,  3 Aug 2021 03:34:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h13so11301608wrp.1;
        Tue, 03 Aug 2021 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qSjba3GRro5RRDG9pge8+P3LPvjbrgyCpCyq2IDQSqo=;
        b=gEeYbBhCqyLemWelmTpmYIpipocMHbH1jtOvgqki7decDY/YUiDhGeZsF+9BE6PuH9
         gACrfm5PYBPm1OApQOSBGVgW4fJxoyBey9dlPHE5mb+mlIsKS4j/OY34WqQonwJqPMna
         kVrGk/Dhkgho1vf455nbTbRUdrbIYx5rCaAWsXk03IMsehue2eH2G1fMckLHM9K9EG3p
         EYsWOypPLGyzP6iBxIikrwi4IvJjFBrD5xSEo6uUmjt1lrJdHtAlVy+5UElaScFdUJhf
         gJgaaZxhccXrjA27kjFGXrsSVWlbk/QpchE6D9pknebUxXEpiQ1X3y5qJ6MfN0+Li89e
         zNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qSjba3GRro5RRDG9pge8+P3LPvjbrgyCpCyq2IDQSqo=;
        b=HDT89OKXz6tnI6pRPeTUqdUnqL/GQYc+n25fIzwnJFme3/J3bJ61PppKykc6OizMxn
         W+YwrrkvKX8Ubtc2oWg7Rh2MwsusHzjmZMKYCqQRxSt/NRtztK5AX8z4t2IU1wYyDTkr
         GTaqTrVb7c1GPLyYt22pexfXqsKARaINP7LsK2Z5/2n/pPru9cc6NJxvtMDLpdnxsPkN
         XBfFyIwHGheZW3z1PVtXIWZ9uUDoy9Erx5wmrNRXtG8FI4RQDz+Gm0UP95Wpgdrgx8E8
         vGidrTzB1DeTgGXl4CzBqmNIOU9jXjtJI0YBeqiZGigQJyp9YQdSMXOf+V1hRD5gc9w4
         1HTQ==
X-Gm-Message-State: AOAM5337Lv0FWGwN3SSWyu5F9YxivvNkjTs93jAzNpEjPpkJ7+9FUM9W
        +Fdl+sZ8u8mF/FFODVzEq/bP55gUK1M=
X-Google-Smtp-Source: ABdhPJybxq+wWNJOoYa8i2KdWazctvoFqYCX2NaVvOwxAgRfqzpQnAVY9+b96vdzWuVyKbsGKCnh8g==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr22199901wrv.77.1627986892827;
        Tue, 03 Aug 2021 03:34:52 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.39])
        by smtp.gmail.com with ESMTPSA id h8sm2102051wmb.35.2021.08.03.03.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:34:52 -0700 (PDT)
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
 <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
 <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
 <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com>
 <CADVatmPPnAWyOmyqT3iggeO_hOuPpALF5hqAqbQkrdvCPB5UaQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <98f8ec51-9d84-0e74-4c1c-a463f2d69d9d@gmail.com>
Date:   Tue, 3 Aug 2021 11:34:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CADVatmPPnAWyOmyqT3iggeO_hOuPpALF5hqAqbQkrdvCPB5UaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 8:47 AM, Sudip Mukherjee wrote:
> On Mon, Aug 2, 2021 at 12:55 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 8/1/21 9:28 PM, Sudip Mukherjee wrote:
>>> Hi Pavel,
>>>
>>> On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
>>>>> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
>>>>>> Hi Jens, Pavel,
>>>>>>
>>>>>> We had been running syzkaller on v5.10.y and a "KASAN:
>>>>>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
>>>>>> got some time to check that today and have managed to get a syzkaller
>>>>>> reproducer. I dont have a C reproducer which I can share but I can use
>>>>>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
>>>>>> next-20210730.
>>>>>
>>>>> Can you try out the diff below? Not a full-fledged fix, but need to
>>>>> check a hunch.
>>>>>
>>>>> If that's important, I was using this branch:
>>>>> git://git.kernel.dk/linux-block io_uring-5.14
>>>>
>>>> Or better this one, just in case it ooopses on warnings.
>>>
>>> I tested this one on top of "git://git.kernel.dk/linux-block
>>> io_uring-5.14" and the issue was still seen, but after the BUG trace I
>>> got lots of "truncated wr" message. The trace is:
>>
>> That's interesting, thanks
>> Can you share the syz reproducer?
> 
> Unfortunately I dont have a C reproducer, but this is the reproducer
> for syzkaller:

Thanks. Maybe I'm not perfectly familiar with syz, but were there
any options? Like threaded, collide, etc.?


> 
> r0 = syz_io_uring_setup(0x4d4f, &(0x7f0000000080)={0x0, 0x0, 0x1},
> &(0x7f00000a0000)=nil, &(0x7f0000ffc000/0x1000)=nil,
> &(0x7f0000000000)=<r1=>0x0, &(0x7f0000000140))
> r2 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x46e2, 0x0)
> syz_io_uring_setup(0x1, &(0x7f0000000080),
> &(0x7f0000ffd000/0x2000)=nil, &(0x7f0000ffc000/0x2000)=nil,
> &(0x7f0000000100), &(0x7f0000000140)=<r3=>0x0)
> syz_io_uring_submit(r1, r3, &(0x7f0000000100)=@IORING_OP_WRITE={0x17,
> 0x0, 0x0, @fd=r2, 0x0, &(0x7f0000000200)="e2", 0xffffffffffffff98},
> 0x200)
> io_uring_enter(r0, 0x58ab, 0x0, 0x0, 0x0, 0x0)
> 
> 

-- 
Pavel Begunkov
