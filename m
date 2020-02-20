Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEDD166346
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgBTQjC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:39:02 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52543 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgBTQjC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:39:02 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep11so1097075pjb.2
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q5Dz/WYlaLI6r28yufBUOa2r4p7AgwX56r3A+yapg0Q=;
        b=GH8xtHVAk+zjakiRUGv4qjvxucNzSDb1qNI5qnqJCv1AAkom1aixxS+gI0uirLtkEV
         QjncLyFlIvp3iiowjlS57ynCuGGpoVV9iHHJEOya3ujuCyrLwy1wM06an7qygs9vzi9R
         UJJ1MchrN555uEvfqVPwUjJKKwlCmlwyrwrXC7V+GrGcB2O1megOAoVcQ/cz4s2/uZm4
         sX+jlnC/8J0S2src3rjJFHSjfxF88CXOpPHXRlpGzKBvwy080gQLEPsZss5buhi1ZC3t
         2dBWvHpebAcTOruz3NgurM3Qze9/HOu7cSWghTluXQ9/I46JgPXKo1xfQun3LV5fKlOe
         mLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5Dz/WYlaLI6r28yufBUOa2r4p7AgwX56r3A+yapg0Q=;
        b=sQY1uaXPxuoHq2opHbda6VwK1P5gujfX1Tn8YTSlvOqYfsLBz5S5sUXoAZtjxoRFqE
         vd8SILeNcm5T9QUP7Cv7dfXZE/NRPBDbUS+jic0xWsdY788IYA0D8sIeVFuSUvswZpO7
         2ESx/SY6WFjqbDPPa7hnOpfxnMgg9EAFH/ib5dZJwG0erSa++wCmugBWjUkhJ8ScukyZ
         4a92NNEIan0ea/l2qBDt/ahyBr4+vhpzAkM8gjcBmFvQDb76KBvYY8NEuWgLZzMCaoml
         ypIPbbnfD7uKnF70ELvztYSSkaSBcnL55i8OJC0FRdi4fpkhjizXw6D8lV0ZctMEY429
         TyDg==
X-Gm-Message-State: APjAAAXRv3vjQThnMty6WVtDqxe6i8wGMDYEdvIioICY3Zl6LgrgcakL
        aP0sxUE8SxZ06OvJucNTnovv2g==
X-Google-Smtp-Source: APXvYqw3PYeX9Rl7v2uf00mXi7ejdJdlqQSsZ/IPMHGtvTPy+8rnBFVFBiB5OhQTCGZ9C2tWbPClUQ==
X-Received: by 2002:a17:902:b110:: with SMTP id q16mr31396045plr.289.1582216741109;
        Thu, 20 Feb 2020 08:39:01 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id k5sm3977905pju.29.2020.02.20.08.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:39:00 -0800 (PST)
Subject: Re: crash on connect
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
 <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
Date:   Thu, 20 Feb 2020 08:38:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 9:34 AM, Glauber Costa wrote:
> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/20/20 9:17 AM, Jens Axboe wrote:
>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
>>>> Hi there, me again
>>>>
>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
>>>>
>>>> This test is easier to explain: it essentially issues a connect and a
>>>> shutdown right away.
>>>>
>>>> It currently fails due to no fault of io_uring. But every now and then
>>>> it crashes (you may have to run more than once to get it to crash)
>>>>
>>>> Instructions are similar to my last test.
>>>> Except the test to build is now "tests/unit/connect_test"
>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
>>>>
>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
>>>> --reactor-backend=uring
>>>>
>>>> Backtrace attached
>>>
>>> Perfect thanks, I'll take a look!
>>
>> Haven't managed to crash it yet, but every run complains:
>>
>> got to shutdown of 10 with refcnt: 2
>> Refs being all dropped, calling forget for 10
>> terminate called after throwing an instance of 'fmt::v6::format_error'
>>   what():  argument index out of range
>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
>>
>> Not sure if that's causing it not to fail here.
> 
> Ok, that means it "passed". (I was in the process of figuring out
> where I got this wrong when I started seeing the crashes)

Can you do, in your kernel dir:

$ gdb vmlinux
[...]
(gdb) l *__io_queue_sqe+0x4a

and see what it says?

-- 
Jens Axboe

