Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7A1F7B17
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFLPuz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 11:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLPuz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 11:50:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD71C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:50:55 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h95so4022514pje.4
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aHm42q82M0WjUZUTXDzWE/eUdxh5II1qSy5d6NA2s28=;
        b=CH+KFts+o1QoVTPhiNDeC1j2yqKZ2XFwyc8keU/b7gpUX1oiVZEL1AqTjmrBTmsER2
         +uwaXHJyaXtEaV82/RrQ0FfPH4JlmtiScWZE68/knKn/YPDiXc68uhLkwP5BKOpNlKBX
         FVvpsXvZnHkqUIh8/dPw61cczhctCFKkV5YY3lL/z4g0hgl80WEXrICoxM6u7gE3MXgH
         rlqDNmDebqIONIv6V2oc6zJP3GbXi8W62WQOnlvtFOiBirQLWW+bomZgZn22KFroJ2fy
         3s8GSEsyzEvBS/V6v3tBn29JOG4mFbiKdmC5VNO0gO0iUmYJpSOjI2SKCv1WrZDNUA3v
         SVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHm42q82M0WjUZUTXDzWE/eUdxh5II1qSy5d6NA2s28=;
        b=mTn5OWl5cxfs2uRCft9RywE1g3fTcbUOmL+dKyQyt/RL3c+47y7v+2CXqvNRoNs6bO
         kFNzub0o24oAnEXyYXbuH1ts63LVokx0XrRSjEN0/rO/Aayh+YK0ccL2I4NKGKcYjQxR
         7Njd/Eb8GQLuNvQ6oEDpDIklKrKZ4z/1WGgWkUk5P0YHS6c5LrlDZ7Fi7+4JyWuDlET9
         ji3va/7FZP9H4vLC+vL0/9BUTNer4Wyg8GXw8i5gIMtXJZdwPix1uH/r4SRYkDssqHHH
         Zr4/8PHxI2DltqENvuiyAogSA9c1eS7cYKgqkFc0fQFZ14LLY8NiauVbNuOYLZVLRt/H
         mFcA==
X-Gm-Message-State: AOAM533ZN0h2H2jaZiID2KXmXe91kidv1Bewb5HgK1luiSj0OW2r0yzo
        pHsUyFJEAzd5/EuR65eipOa4T4YlZSEGmA==
X-Google-Smtp-Source: ABdhPJxqB72vXBOKm4jIF+ci0mqUN96hUR7XbemvV4+fpMh+UokFkG8aKHz5DiwuMpP5f8NAFQ/tJw==
X-Received: by 2002:a17:902:3:: with SMTP id 3mr10939932pla.120.1591977053804;
        Fri, 12 Jun 2020 08:50:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z8sm5768566pgc.80.2020.06.12.08.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 08:50:53 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: report pinned memory usage
From:   Jens Axboe <axboe@kernel.dk>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
 <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
 <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
Message-ID: <8ade3d59-5056-b6ed-37dc-3274822f2815@kernel.dk>
Date:   Fri, 12 Jun 2020 09:50:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 9:19 AM, Jens Axboe wrote:
> On 6/12/20 9:16 AM, Jens Axboe wrote:
>> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>>> Long term, it makes sense to separate reporting and enforcing of pinned
>>> memory usage.
>>>
>>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>>
>>> It is useful to view
>>> ---
>>>  fs/io_uring.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 4248726..cf3acaa 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>  static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>>>  {
>>>  	atomic_long_sub(nr_pages, &user->locked_vm);
>>> +	if (current->mm)
>>> +		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
>>>  }
>>>  
>>>  static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>> @@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>>  			return -ENOMEM;
>>>  	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>>>  					new_pages) != cur_pages);
>>> +	if (current->mm)
>>> +		atomic_long_add(nr_pages, &current->mm->pinned_vm);
>>>  
>>>  	return 0;
>>>  }
>>
>> current->mm should always be valid for these, so I think you can skip the
>> checking of that and just make it unconditional.
> 
> Two other issues with this:
> 
> - It's an atomic64, so seems more appropriate to use the atomic64 helpers
>   for this one.
> - The unaccount could potentially be a different mm, if the ring is shared
>   and one task sets it up while another tears it down. So we'd need something
>   to ensure consistency here.

IOW, this should just use ctx->sqo_mm, as that's grabbed and valid. Just need
to ensure it's done correct in terms of ordering for setup.

-- 
Jens Axboe

