Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B91116B7CE
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 03:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgBYCgH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 21:36:07 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:41998 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgBYCgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 21:36:07 -0500
Received: by mail-pf1-f173.google.com with SMTP id 4so6367990pfz.9
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 18:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKkFXvYKuinamllUwTEw/mvFy9z03AMmQbnojrH7THw=;
        b=XDgOeRkhVB26nfYNZajkVsSgzU9R7Lngdsn4su0kFIxNYNxbfxna5vPlvVACLyy6nw
         k5itmTXJOS/A1eZB3m1NQLalUDltdYgdyK+U8+khKpzoWRyQ4Tmp8i6T1h705e5MEY/1
         D2/WI+bOhdeWeJCsl1wB++K/E7z7CDWzVM6AJH7QpmbAuEz2KfxTtnm4RIPEKYIb7O5q
         DtRKPDHCfKWvsUbezQr2cu4Y3rrSZQCjkqEzyErB3qj/CfC2Qpxax4ot5naWGb4v2zPu
         IvpYWzEFFaKI3bbLUpCq9RSAOsVQQilEESUXxawX+awBkllhel8e8WVuFthyI/VKJSEz
         eclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKkFXvYKuinamllUwTEw/mvFy9z03AMmQbnojrH7THw=;
        b=V2PhbBqbhrwq562j6YtgrcBGGo4XvyH/+F48FpVARjhCkWMC+OJ73swp+IO46E+nvo
         huyJdn/YgvjbrPx7SErgeMmp9PxRrV3e7jv+ex1G4hvhHA26w4RJzF2AUjgA41x6theD
         kEcvEe/EsWj7y7k/2gZkTfk34Aj5u3YbFPkzwe4vajSnvbggJGyYgrv23ow4lrpnJf7I
         Z+ZKzUXW+C9yz6XizcPxpfQMsSXNIPowrrs00LsuE/rIQYHqBMI7QfwDm9KN2+eB2yUM
         4o9szFGn13cJJUlaSibDs51FZRN9nAq1go63dg7IOMtNdW81HtAxmo+cxyWVMB9zvlC6
         14SQ==
X-Gm-Message-State: APjAAAVeYKN8jO0qzRt1IuvJ+xnNmkPCuNAqK6ppMDtfB753lr9ZWEYb
        4z7D35cgjRGwt4NcKvU+MrJE1yyBt5s=
X-Google-Smtp-Source: APXvYqyuQh8QZWeWlmjB5AXi+15QN3jwLBa9s1bsLI3aS6gz/zz/5+lUPnQmGjUQYK7dEmUOmTrZRg==
X-Received: by 2002:a63:e5d:: with SMTP id 29mr8868253pgo.124.1582598166178;
        Mon, 24 Feb 2020 18:36:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w26sm14506853pfj.119.2020.02.24.18.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 18:36:05 -0800 (PST)
Subject: Re: [RFC] single cqe per link
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
Date:   Mon, 24 Feb 2020 19:36:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 7:14 PM, Carter Li 李通洲 wrote:
>> 2020年2月25日 上午8:39，Pavel Begunkov <asml.silence@gmail.com> 写道：
>>
>> I've got curious about performance of the idea of having only 1 CQE per link
>> (for the failed or last one). Tested it with a quick dirty patch doing
>> submit-and-reap of a nops-link (patched for inline execution).
>>
>> 1) link size: 100
>> old: 206 ns per nop
>> new: 144 ns per nop
>>
>> 2) link size: 10
>> old: 234 ns per nop
>> new: 181 ns per nop
>>
>> 3) link size: 10, FORCE_ASYNC
>> old: 667 ns per nop
>> new: 569 ns per nop
>>
>>
>> The patch below breaks sequences, linked_timeout and who knows what else.
>> The first one requires synchronisation/atomic, so it's a bit in the way. I've
>> been wondering, whether IOSQE_IO_DRAIN is popular and how much it's used. We can
>> try to find tradeoff or even disable it with this feature.
>
> Hello Pavel,
> 
> I still think flags tagged on sqes could be a better choice, which
> gives users an ability to deside if they want to ignore the cqes, not
> only for links, but also for normal sqes.
> 
> In addition, boxed cqes couldn’t resolve the issue of
> IORING_IO_TIMEOUT.

I would tend to agree, and it'd be trivial to just set the flag on
whatever SQEs in the chain you don't care about. Or even an individual
SQE, though that's probably a bit more of a reach in terms of use case.
Maybe nop with drain + ignore?

In any case it's definitely more flexible.

-- 
Jens Axboe

