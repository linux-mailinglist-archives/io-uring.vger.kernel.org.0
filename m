Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8FA1667FA
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBTUIF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:08:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39341 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgBTUIE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:08:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id 84so2448159pfy.6
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a+Ib9Cb743iBlnM14xOc/BH5H3nPwdc5s2nX+U6FU7M=;
        b=oenJGXgsdnpNMCTWoM2RwFPInsgyWYWgtzhkp4iJMLFP/XSoV1nzpX9HXKjMBVu2ap
         vf6AQTCLRv4EgHKw2tcfj92/LDJc2yHtYk/7xbnXUuPYXLTRBKKCP+SfOWk+aGszr2b8
         ohl9zr8vn4g9QkMLcarJjmBqPEPOeSy3IexdooUODla1EgDsiSwLGF4s6pEqEytCN5vX
         dExaQhM5LpyPAiJvNzM5q/9GWg6Io1h3W8qf1D6Q6Pq45ijNKEyh4yCgkDpwy+40jukP
         8w4KMZAdE83tAOkGG6Jo7qyKpLSbXQs5k0uV2RoGZfuczVn1t7/Un3jwPDYzQZ69EDSZ
         sjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a+Ib9Cb743iBlnM14xOc/BH5H3nPwdc5s2nX+U6FU7M=;
        b=n4KnjtwaHiKw4V6TNWxiGrjRcTwGaS715kdMo5hukL9i/29AcuviQG/+FwDQdxdrmC
         zKPDLxt1TNpQF4ncxtjNwgoFCl2+2ONw/0o7AvwiAwGm/LTEvi3HBjSdoEVFTBwuL+Iw
         yYuNmRxcLY8gubDHAnT2jCxm5Nso4nskYtA0BVGYLe0aNx1cBryrH+w8BSZFKmM013FU
         9sfiOkuISZO0aG/vfAOLecDTsbIfv3AUAfLKlco23FOpZXtopWjchCndrylp7nmy/doP
         hJ34jU9XWhkSN0foBeEXIoQh2n4V0nyT/oI8do9uC4BSmglhYqapqe2/O+o4GvFzJj3D
         vfsw==
X-Gm-Message-State: APjAAAWM9nqfHlKVqhA/5Hy3tDQ23FJaCKUZiDYOH1IMO+1C0YJAMyJl
        jcahk4Z3HHuqzislr8aphClUWA==
X-Google-Smtp-Source: APXvYqxGqgkyWqK2feWRCZQZpKyzSxYkF8VxX0F0FeKC6pwuN2fLJrsLkNNFgwm2/nr1wJlTJSqWYQ==
X-Received: by 2002:a62:ab13:: with SMTP id p19mr32946105pff.98.1582229282438;
        Thu, 20 Feb 2020 12:08:02 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id ci5sm289424pjb.5.2020.02.20.12.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 12:08:01 -0800 (PST)
Subject: Re: crash on connect
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
 <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
 <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
 <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk>
 <CAD-J=zbdrZJ2nKgH3Ob=QAAM9Ci439T9DduNxvetK9B_52LDOQ@mail.gmail.com>
 <2be9d30f-bbca-7aa6-3d8c-34e3fcf71067@kernel.dk>
 <CAD-J=zYKg7TZz2jz9O7eWH1gYkYbQV3-smb-XFOmWnp30cC_sQ@mail.gmail.com>
 <CAD-J=zYKcp_NMVC8K3bzen-hcGMN-OuYqMNtD1E8tEyqPhwGMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9868b076-d036-c9ac-8074-6e317ce339c8@kernel.dk>
Date:   Thu, 20 Feb 2020 12:08:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYKcp_NMVC8K3bzen-hcGMN-OuYqMNtD1E8tEyqPhwGMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 12:36 PM, Glauber Costa wrote:
> On Thu, Feb 20, 2020 at 2:19 PM Glauber Costa <glauber@scylladb.com> wrote:
>>
>> On Thu, Feb 20, 2020 at 2:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 2/20/20 11:45 AM, Glauber Costa wrote:
>>>> On Thu, Feb 20, 2020 at 12:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 2/20/20 9:52 AM, Glauber Costa wrote:
>>>>>> On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 2/20/20 9:34 AM, Glauber Costa wrote:
>>>>>>>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>
>>>>>>>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
>>>>>>>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
>>>>>>>>>>> Hi there, me again
>>>>>>>>>>>
>>>>>>>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
>>>>>>>>>>>
>>>>>>>>>>> This test is easier to explain: it essentially issues a connect and a
>>>>>>>>>>> shutdown right away.
>>>>>>>>>>>
>>>>>>>>>>> It currently fails due to no fault of io_uring. But every now and then
>>>>>>>>>>> it crashes (you may have to run more than once to get it to crash)
>>>>>>>>>>>
>>>>>>>>>>> Instructions are similar to my last test.
>>>>>>>>>>> Except the test to build is now "tests/unit/connect_test"
>>>>>>>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
>>>>>>>>>>>
>>>>>>>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
>>>>>>>>>>> --reactor-backend=uring
>>>>>>>>>>>
>>>>>>>>>>> Backtrace attached
>>>>>>>>>>
>>>>>>>>>> Perfect thanks, I'll take a look!
>>>>>>>>>
>>>>>>>>> Haven't managed to crash it yet, but every run complains:
>>>>>>>>>
>>>>>>>>> got to shutdown of 10 with refcnt: 2
>>>>>>>>> Refs being all dropped, calling forget for 10
>>>>>>>>> terminate called after throwing an instance of 'fmt::v6::format_error'
>>>>>>>>>   what():  argument index out of range
>>>>>>>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
>>>>>>>>>
>>>>>>>>> Not sure if that's causing it not to fail here.
>>>>>>>>
>>>>>>>> Ok, that means it "passed". (I was in the process of figuring out
>>>>>>>> where I got this wrong when I started seeing the crashes)
>>>>>>>
>>>>>>> Can you do, in your kernel dir:
>>>>>>>
>>>>>>> $ gdb vmlinux
>>>>>>> [...]
>>>>>>> (gdb) l *__io_queue_sqe+0x4a
>>>>>>>
>>>>>>> and see what it says?
>>>>>>
>>>>>> 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
>>>>>> 4809 struct io_kiocb *linked_timeout;
>>>>>> 4810 struct io_kiocb *nxt = NULL;
>>>>>> 4811 int ret;
>>>>>> 4812
>>>>>> 4813 again:
>>>>>> 4814 linked_timeout = io_prep_linked_timeout(req);
>>>>>> 4815
>>>>>> 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
>>>>>> 4817
>>>>>> 4818 /*
>>>>>>
>>>>>> (I am not using timeouts, just async_cancel)
>>>>>
>>>>> Can't seem to hit it here, went through thousands of iterations...
>>>>> I'll keep trying.
>>>>>
>>>>> If you have time, you can try and enable CONFIG_KASAN=y and see if
>>>>> you can hit it with that.
>>>>
>>>> I can
>>>>
>>>> Attaching full dmesg
>>>
>>> Can you try the latest? It's sha d8154e605f84.
> 
> 10 runs, no crashes.
> 
> Thanks!

Great! Thanks for reporting and the quick testing.

-- 
Jens Axboe

