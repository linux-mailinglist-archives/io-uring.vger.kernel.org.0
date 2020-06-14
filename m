Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A6F1F8996
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2020 17:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgFNP5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 11:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgFNP5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 11:57:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35514C05BD43
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:57:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h95so5982281pje.4
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qT/miUWWuMQRzc1/z9S2VM6uHFz6aFpRfMYT77iUa8Y=;
        b=XH0rEhuRBnh9XWLBQiZ/3Qh4OpjM/lJmOjxExNjzOmb2lTQf+iNlkw+WA60V1f6ry5
         LmwyaUKG0JT6GLHWrFYSXYS2FMy9ihJ2FpaTDs+DwonOwgU78i0usisK5zzgZq8sn5x8
         3y4fMJtbb1mm5T/336XODZUd3ZehZOEAlwwzDVS2su4tcj6nsPt929Qdvvu2G7gsAl+n
         3Ge0F0Arwihy8gcbeZFrW74X2cdhq0y3WcLesGJDLiXvNdVRvAWBxxAfnv2whM6qlaul
         Quj7a0LRLOSER7M5YrWBog7lQ6i5+jTJ4ixUARz5+iC5HqsjXCWEPuBV51ud2WZLwAxZ
         01HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qT/miUWWuMQRzc1/z9S2VM6uHFz6aFpRfMYT77iUa8Y=;
        b=bayzNyIJMM2g5fYdhQ0WEWOWcKZiqM0chcyAYeFKZGQJR596sgLTImQ7wQkqR6soAi
         r20iV84N/p03uQU9OgOpwXwXfwYdrRcTf0ACUpcbTWhif3gotO8QxZzy45Gr9h6RQvTn
         hggGv3ZkqRG5qeFgYhb6wxnPvTQ4YwD76Bba4PEj9SHfubbtBWX4mRePOMsGSVnqDWdl
         Ys7e1Eq1o4Y9K1TAyCI/rPpwjR3wr/dJdKG7I1hvzyqd0Sf65alytWxk+f4lyzvnhTE2
         4PIOCdBzfNO4OtyHhQsSAOxg5kJy46XvFPo0WHPpjZeAjpEUAqPKaYY1h81GF/h4w03d
         vN1g==
X-Gm-Message-State: AOAM532uVgrRA6Leai2FE3l+7PHTSjto08eXykM1jiwIFjWJw8zEWZvz
        5ngHN6AMhPSXcBiIBRjwaPlZAMAd4mvz8Q==
X-Google-Smtp-Source: ABdhPJyTjoU4GqyYqW8/iEsH9Be/xDIEdIAyZMRcHWKTZdjCgzsO0LunlkcNbNVLVws8h3YfH7EQFg==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr8226403pjs.82.1592150262515;
        Sun, 14 Jun 2020 08:57:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i14sm10213470pju.24.2020.06.14.08.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 08:57:41 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: report pinned memory usage
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
 <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
 <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
 <32054e77-0ee4-ebab-d2c3-fef92261eecf@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87ca7d67-95ab-2d91-8dd3-beb6dcd56e93@kernel.dk>
Date:   Sun, 14 Jun 2020 09:57:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <32054e77-0ee4-ebab-d2c3-fef92261eecf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 10:43 PM, Bijan Mottahedeh wrote:
> On 6/12/2020 8:19 AM, Jens Axboe wrote:
>> On 6/12/20 9:16 AM, Jens Axboe wrote:
>>> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>>>> Long term, it makes sense to separate reporting and enforcing of pinned
>>>> memory usage.
>>>>
>>>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>>>
>>>> It is useful to view
>>>> ---
>>>>   fs/io_uring.c | 4 ++++
>>>>   1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 4248726..cf3acaa 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>>   static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>>>>   {
>>>>   	atomic_long_sub(nr_pages, &user->locked_vm);
>>>> +	if (current->mm)
>>>> +		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
>>>>   }
>>>>   
>>>>   static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>>> @@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>>>   			return -ENOMEM;
>>>>   	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>>>>   					new_pages) != cur_pages);
>>>> +	if (current->mm)
>>>> +		atomic_long_add(nr_pages, &current->mm->pinned_vm);
>>>>   
>>>>   	return 0;
>>>>   }
>>> current->mm should always be valid for these, so I think you can skip the
>>> checking of that and just make it unconditional.
>> Two other issues with this:
>>
>> - It's an atomic64, so seems more appropriate to use the atomic64 helpers
>>    for this one.
>> - The unaccount could potentially be a different mm, if the ring is shared
>>    and one task sets it up while another tears it down. So we'd need something
>>    to ensure consistency here.
>>
> Are you referring to a case where one process creates a ring and sends 
> the ring fd to another process?

Or a simpler case, where someone has submissions and completions running
on separate threads, and it just so happens that the completion side is
the one to exit the ring.

-- 
Jens Axboe

