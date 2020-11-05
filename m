Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48502A8851
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 21:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgKEUto (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 15:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgKEUtn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 15:49:43 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66274C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 12:49:42 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id z2so2597085ilh.11
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 12:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y88GPjOkmPLmrcQonHP0Jounq5s4KWogxwEEJi2fx+I=;
        b=wR+/4rGd8hSqAt95vxxalBiprKHlQsOE8LIcN8oATiiin3TpoKq4iJUusrpGBVIL1E
         NgvVKfDF1Ms8jWEO2MnLbQyw66I7qZvONp0VjNgSS+lQPppmKWHcjSLqWbgUInx0Km9k
         N593Q/h7J+mdd1B0BzAWihVYPRfCzv5J8JVw41ZOBn48JAuxpY0hLZgGSJKuMy2yVHRs
         BcIrXd4mbgktm1UNJz3tMcWcco30OE9VNxtG4N+9JSv1HTLxGwEdiA8M611uQFbQPrqv
         vDwzhKMECZU/LvdkKw/+McHaJDP2UDUIfg9OlNzmXpLyI9Mq6xjRSz+ONGAKds6Gv/Xx
         6lmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y88GPjOkmPLmrcQonHP0Jounq5s4KWogxwEEJi2fx+I=;
        b=CfTt4dZj3Plg1qHsHfaI/sJQbwA1DJCTqVYJv9DzrzKEZHh/sqZ1ihuYo5pokYgHeD
         qcGhW90QSz5Y8d8ZFzfeHuyTSfcdRVxaHGKScERxCXXuKisrC0RtGJnBWZjd3iowmZ6T
         AFkgBi24YKQhtXqoSCqol6cqw67Lou7LPKhlXm26WD+ZIMnjkgDMhTXB2yuqHKfBgVA4
         lPOJR30IFboeVWY0b/7dKoZZN7t6Jw/WyawlxpFbOXraEK44i5ehzaXFL+mzJLD2ArVa
         gXUS58VAAG7beMySCSufMGzyhbwJalip1nENlNmUrzUKMXY3Qaz+N9ns/hMH8HSwIJa0
         QJXw==
X-Gm-Message-State: AOAM532lwmLQwGWoG9kKlRYPPibiRM4pISbudhWMd520zCTzZjwdONST
        kfF3Xn7A4yXLa27JNyJGOkqw0Yfy+XqoJg==
X-Google-Smtp-Source: ABdhPJwBTaOjbVjCZWVtKuI3bHgiLbbt5epkJ0WT72d+Sc3T8oXlUvu2RHnN4H3RyY8IRSzVlsi53A==
X-Received: by 2002:a05:6e02:f0e:: with SMTP id x14mr3639155ilj.228.1604609381523;
        Thu, 05 Nov 2020 12:49:41 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b70sm1877749ilb.51.2020.11.05.12.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 12:49:41 -0800 (PST)
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
Date:   Thu, 5 Nov 2020 13:49:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 1:35 PM, Pavel Begunkov wrote:
> On 05/11/2020 20:26, Jens Axboe wrote:
>> On 11/5/20 1:04 PM, Pavel Begunkov wrote:
>>> On 05/11/2020 19:37, Jens Axboe wrote:
>>>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
>>>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
>>>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>>>> Hah, basically filename_parentat() returns back the passed in filename if not
>>>>> an error, so @oldname and @from are aliased, then in the end for retry path
>>>>> it does.
>>>>>
>>>>> ```
>>>>> put(from);
>>>>> goto retry;
>>>>> ```
>>>>>
>>>>> And continues to use oldname. The same for to/newname.
>>>>> Looks buggy to me, good catch!
>>>>
>>>> How about we just cleanup the return path? We should only put these names
>>>> when we're done, not for the retry path. Something ala the below - untested,
>>>> I'll double check, test, and see if it's sane.
>>>
>>> Retry should work with a comment below because it uses @oldname
>>> knowing that it aliases to @from, which still have a refcount, but I
>>> don't like this implicit ref passing. If someone would change
>>> filename_parentat() to return a new filename, that would be a nasty
>>> bug.
>>
>> Not a huge fan of how that works either, but I'm not in this to rewrite
>> namei.c...
> 
> There are 6 call sites including do_renameat2(), a separate patch would
> change just ~15-30 lines, doesn't seem like a big rewrite.

It just seems like an utterly pointless exercise to me, something you'd
go through IFF you're changing filename_parentat() to return a _new_
entry instead of just the same one. And given that this isn't the only
callsite, there's precedence there for it working like that. I'd
essentially just be writing useless code.

I can add a comment about it, but again, there are 6 other call sites.

-- 
Jens Axboe

