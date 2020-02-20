Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043251664CD
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBTR2y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 12:28:54 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46126 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbgBTR2y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 12:28:54 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so1792890pll.13
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 09:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E2QrExhAY6QPGDB+R1pKHTRZnYtw1/5HJ63lBrXvee0=;
        b=ymYRk4jnQ9cmynQozkDgdyKPorchTWovVelvgfo98LACoSrQRBHut1fvhOzTyLnpvL
         rjN0YiKBupA1T3QGQyitKcK9vx4PpYDxiONC2kvAP53bMOKL2Bd47+8lFlccKWQG/sta
         9jzf/Ehik52/U4eWWd8gTGOjjr1rQgilADCHoVBYR5PXanGgxpUPr5kIT4BFUS0vFhlP
         /9OsDCy+VxJ0Sv140HVPAIWBMpBX90xYOevAc8WLnmHhTnSB7Fz6/J+StytsXMJBQr5L
         4wBcZWxR6ygtsFsrGCWaQSSb18bUNU/oLX3AkTdUEm/XY6XcyF6EIfumxPACoqlqnUoQ
         43HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2QrExhAY6QPGDB+R1pKHTRZnYtw1/5HJ63lBrXvee0=;
        b=cEzP9XeiNjoYwRjn/WjOwqGWsL72Gbq2u7pLdFDUOFa23CoSWF/+czjDRkoZqEkXOC
         vBRsAzyqz51rHsFeHHTlygTm/h9KZCZLzCr+1Wvqymar0SHLPF8UMk5S+5KW8wwKvWYM
         S6+XRHm4An3i9zUBCrOKzcKrEcAEYkYpgk56VVVIU4uWwZeOjvvnsljjn82eb6NgUfCw
         LqEzhFsE0uAA19En/upL7lMT+kXeZ87H3nSB3j8L6Xgt7+hqCK++JxMsPxQ9DPVO3ipO
         6hn/kwqlSQ1A8OXbVDemNCFIiCMQERLY58YhHjTqEfFV5M9mZSrAEGWLOKBqoEqgB/Bo
         x1KQ==
X-Gm-Message-State: APjAAAVw1VrXtZTpY5DDmoBOSA9ydzEaVc+QoNlAR8rkgjm75IF3Tanm
        uMI33ztAzAXPBQ11NKTfp6ovGJjJcjw=
X-Google-Smtp-Source: APXvYqwD9zg0lLZ2AEhVs+KVJMY5+L50EQGvK3QnetnDzRAWifwLAj9EZ/3GqObzGmEuMxI3HXTo7g==
X-Received: by 2002:a17:90a:1b42:: with SMTP id q60mr4712074pjq.108.1582219732884;
        Thu, 20 Feb 2020 09:28:52 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id i6sm4366050pgm.93.2020.02.20.09.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 09:28:52 -0800 (PST)
Subject: Re: crash on connect
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
 <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
 <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk>
Date:   Thu, 20 Feb 2020 09:28:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 9:52 AM, Glauber Costa wrote:
> On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/20/20 9:34 AM, Glauber Costa wrote:
>>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
>>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
>>>>>> Hi there, me again
>>>>>>
>>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
>>>>>>
>>>>>> This test is easier to explain: it essentially issues a connect and a
>>>>>> shutdown right away.
>>>>>>
>>>>>> It currently fails due to no fault of io_uring. But every now and then
>>>>>> it crashes (you may have to run more than once to get it to crash)
>>>>>>
>>>>>> Instructions are similar to my last test.
>>>>>> Except the test to build is now "tests/unit/connect_test"
>>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
>>>>>>
>>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
>>>>>> --reactor-backend=uring
>>>>>>
>>>>>> Backtrace attached
>>>>>
>>>>> Perfect thanks, I'll take a look!
>>>>
>>>> Haven't managed to crash it yet, but every run complains:
>>>>
>>>> got to shutdown of 10 with refcnt: 2
>>>> Refs being all dropped, calling forget for 10
>>>> terminate called after throwing an instance of 'fmt::v6::format_error'
>>>>   what():  argument index out of range
>>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
>>>>
>>>> Not sure if that's causing it not to fail here.
>>>
>>> Ok, that means it "passed". (I was in the process of figuring out
>>> where I got this wrong when I started seeing the crashes)
>>
>> Can you do, in your kernel dir:
>>
>> $ gdb vmlinux
>> [...]
>> (gdb) l *__io_queue_sqe+0x4a
>>
>> and see what it says?
> 
> 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
> 4809 struct io_kiocb *linked_timeout;
> 4810 struct io_kiocb *nxt = NULL;
> 4811 int ret;
> 4812
> 4813 again:
> 4814 linked_timeout = io_prep_linked_timeout(req);
> 4815
> 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
> 4817
> 4818 /*
> 
> (I am not using timeouts, just async_cancel)

Can't seem to hit it here, went through thousands of iterations...
I'll keep trying.

If you have time, you can try and enable CONFIG_KASAN=y and see if
you can hit it with that.

-- 
Jens Axboe

