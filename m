Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A6E164FD7
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 21:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBSU3b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 15:29:31 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44005 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSU3b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 15:29:31 -0500
Received: by mail-wr1-f51.google.com with SMTP id r11so2068998wrq.10
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 12:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DjvDdDQvKCcCx95f1Jn6XuJl7luFA74PtLM2eMCOOdA=;
        b=vIQromgsflTjOMfZT6KZPJTyp767HV76U/OCu/gSmdr45zHMv8cYuc/SC+SIx9HucN
         bs+hEw/yZSi85Qe44tQZdn5Li5L13b+PwmjM0EVGoCKXpWsTX3af9srUQ14NBdU0p/eS
         ZCg0WSMnosn7f8bbbm/Uc2J07ZIezS/np4yTCBK31E9iBXORXbIrqVXjxOsw+3brZ7ce
         AbtmIM7RbhV5QddkfPWONRxcNSQ2XCnjut3HrZsf4SM34OYgIWLQOHOvXWDU4q5hGQMN
         1IIyBzIICnHNGjek5i+si1CI5AdZ2MoFIY1Ooro5p8eaoD2SBgt8dopmgh5uD0D5D8MT
         2NnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DjvDdDQvKCcCx95f1Jn6XuJl7luFA74PtLM2eMCOOdA=;
        b=TP4tjDhmkobin2wgli3/55ZsMY5wYLr/TtZK+47V2Te+mWhf5va/HN/b5dSDeBWbbJ
         Qzd4iqJISAjUp5pyemkiIXx8laSp0iciFbY/nkEgB/XzoI9EaNG/4Y4YGEAfr8Eeoq8Z
         y0zR1Oqw5y81Ne+3q7wmg+Y3ajnXs6sQPYKJCVVPRuKGj+lFTuCsNMCadppyMt0b4MQ+
         dDEB/vSdBT/0mO+e4qoU7hRO596tv9HV85MS6i0uIVLl37uaYBB+IFt86C6UgjqerUNR
         L9RhEr/XFzK+glv5bBUXnM1z3E+ZC6+kGj4hvGweH22F6+AvPCuiX32DZTd6Iwb1CCOn
         ankg==
X-Gm-Message-State: APjAAAUhXhloHGaZ2a4XxE55VnxzgmnuUek6uaetPqIOjC7QMdUkRxhG
        hrQN+v5Is6y4CyUI/RhEbdn0yA==
X-Google-Smtp-Source: APXvYqxRHwAt1gvdQpOSwsRgLfau8ahO1z9Z6wH/eKAG1my0aQ1WUX2BwUmjd0wz3MzjOR6XSRn/pQ==
X-Received: by 2002:adf:b254:: with SMTP id y20mr37094627wra.362.1582144169794;
        Wed, 19 Feb 2020 12:29:29 -0800 (PST)
Received: from tmp.scylladb.com (bzq-79-178-26-168.red.bezeqint.net. [79.178.26.168])
        by smtp.googlemail.com with ESMTPSA id z19sm1102464wmi.43.2020.02.19.12.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 12:29:28 -0800 (PST)
Subject: Re: crash on accept
To:     Glauber Costa <glauber@scylladb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
 <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
 <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com>
Date:   Wed, 19 Feb 2020 22:29:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/20 10:25 PM, Glauber Costa wrote:
> On Wed, Feb 19, 2020 at 3:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/19/20 1:11 PM, Glauber Costa wrote:
>>> On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/19/20 9:23 AM, Glauber Costa wrote:
>>>>> Hi,
>>>>>
>>>>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
>>>> Thanks for testing the new stuff! As always, would really appreciate a
>>>> test case that I can run, makes my job so much easier.
>>> Trigger warning:
>>> It's in C++.
>> As long as it reproduces, I don't really have to look at it :-)
> Instructions:
> 1. clone https://github.com/glommer/seastar.git, branch uring-accept-crash
> 2. git submodule update --recursive --init, because we have a shit-ton
> of submodules because why not.


Actually, seastar has only one submodule (dpdk) and it is optional, so 
you need not clone it.


> 3. install all dependencies with ./install-dependencies.sh
>      note: that does not install liburing yet, you need to have at
> least 0.4 (I trust you do), with the patch I just sent to add the fast
> poll flag. It still fails sometimes in my system if liburing is
> installed in /usr/lib instead of /usr/lib64 because cmake is made by
> the devil.
> 3. ./configure.py --mode=release


--mode dev will compile many times faster


> 4. ninja -C build/release tests/unit/unix_domain_test
> 5. crash your system (hopefully) by executing
> ./build/release/tests/unit/unix_domain_test -- -c1
> --reactor-backend=uring
>
s/release/dev/ in steps 4, 5 if you use dev mode.


>>> I am finishing refactoring some of my code now. It's nothing
>>> substantial so I am positive it will hit again. Once I re-reproduce
>>> I'll send you instructions.
>>>
>>> Reading the code it's not obvious to me how it happens, so it'll be
>>> harder for me to cook up a simple C reproducer ATM.
>> I'll look here as well, as time permits.
>>
>>
>> --
>> Jens Axboe
>>

