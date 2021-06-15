Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2058C3A7DEB
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 14:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFOMMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 08:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOMMj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 08:12:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C499DC061574;
        Tue, 15 Jun 2021 05:10:33 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a11so18049799wrt.13;
        Tue, 15 Jun 2021 05:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MnTVDNZDJ8uaspdU4WgOPERRfxkGjiPv5nnzxm+C6TA=;
        b=LJmckYGcNlTBozVh/1wJp7v7AtkT1IyZX+ToQFDeX7Y8FFiYzb/Xh2J/Kd1olwtZU5
         OZDGQKtBxqUhJXU2KrRelOwMY4rq+efzlfgGnNzvC52qVHo9omFkVYuIh0QnM+rf7ys9
         eBfptzCY8AoieVHU9tEj/P7X6NONGeAwtLkxlBJvXa2Baik+IAHs90GfIfJwjznadJ+N
         P1HElj7PCKZ9yvPkD2qeUFbci69ObY9cBkXcBFvhQAOPmVNGSTd4TujEKM62ZsghZBDj
         M6BuOGergg1kKTHxcJeBX+6SRnviDyohNwhtTTdgtRreSAEltH5xE84bQ+5pK3zwvmk3
         VCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MnTVDNZDJ8uaspdU4WgOPERRfxkGjiPv5nnzxm+C6TA=;
        b=OUIiRVkHGOa3o6+WIWf4Nb8mJQ48DUUtqIeFgu2aXH+XMq8JnaiemW78c8FgBf4Umq
         GqtCkpARdmobhkj+DQBZwTwkFRuiyVOKJpvcAAhN/31Ompj/Qbc+y5g92sz6E3XccPAA
         VFtfNFuDGHZuqgj/amcvaXtOkEXX8kNwvGXd+dw9bSTYG4ERaocZEqv72S/OVJP85qbs
         8n2CYxgBURZRTwVdjii8n/e7+SZfmlIdF5h7tXkPKs6+Ed3hYpHiqeZ3L8n1KIHtjdQ3
         HdPKqPtnos9KC0eK1nlrb3ZRlMvaWqXpy/8EnPYZoUMKGOj9suh7mIcYHhxwqWCoJUPv
         ZiMg==
X-Gm-Message-State: AOAM532WpRKsPphKesfMLbGTmwEFRp6Hn3/+y+xlTXko3NNLCtdcrGm3
        TwcN5hEmZBZ7noKkczeq6/b3H0pDVfecPo1R
X-Google-Smtp-Source: ABdhPJyZXEKLPhXtFSgYY9uZGPJHsGgBo/xrw+OXrBn7VrqcLFWGTlyPvv8BaooMhvp/V1FoWPA0Ow==
X-Received: by 2002:a5d:5102:: with SMTP id s2mr24405908wrt.347.1623759032245;
        Tue, 15 Jun 2021 05:10:32 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id i15sm18244039wmq.23.2021.06.15.05.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 05:10:31 -0700 (PDT)
To:     Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615104541.50529-1-colin.king@canonical.com>
 <3dcc6900-8361-d52c-003d-21318aa80156@canonical.com>
 <d606818f-2e13-fbea-970b-eab9080d7f15@gmail.com>
 <067e8830-f6ec-612a-2c8a-8da459f659d1@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH][next] io_uring: Fix incorrect sizeof operator for
 copy_from_user call
Message-ID: <9b2b2cdf-e273-d188-b022-c821b05ce23b@gmail.com>
Date:   Tue, 15 Jun 2021 13:10:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <067e8830-f6ec-612a-2c8a-8da459f659d1@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 12:35 PM, Colin Ian King wrote:
> On 15/06/2021 12:30, Pavel Begunkov wrote:
>> On 6/15/21 11:47 AM, Colin Ian King wrote:
>>> On 15/06/2021 11:45, Colin King wrote:
>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>
>>>> Static analysis is warning that the sizeof being used is should be
>>>> of *data->tags[i] and not data->tags[i]. Although these are the same
>>>> size on 64 bit systems it is not a portable assumption to assume
>>>> this is true for all cases.
>>>>
>>>> Addresses-Coverity: ("Sizeof not portable")
>>>> Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>> ---
>>>>  fs/io_uring.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index d665c9419ad3..6b1a70449749 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -7231,7 +7231,7 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
>>>>  		ret = -EFAULT;
>>>>  		for (i = 0; i < nr; i++) {
>>>>  			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
>>>> -					   sizeof(data->tags[i])))
>>>> +					   sizeof(*data->tags[i])))
>>>>  				goto fail;
>>>>  		}
>>>>  	}
>>>>
>>
> 
> 
>> Yep, thanks Colin. I think `sizeof(io_get_tag_slot(data, i))`
>> would be less confusing. Or
>>
>> u64 *tag_slot = io_get_tag_slot(data, i);
>> copy_from_user(tag_slot, ..., sizeof(*tag_slot));
>>
> BTW, Coverity is complaining about:
> 
> 7220                return -ENOMEM;
> 
> Wrong sizeof argument (SIZEOF_MISMATCH)
> 
> suspicious_sizeof: Passing argument nr * 8UL /* sizeof
> (data->tags[0][0]) */ to function io_alloc_page_table and then casting
> the return value to u64 ** is suspicious.
> 
> 7221        data->tags = (u64 **)io_alloc_page_table(nr *
> sizeof(data->tags[0][0]));

Ah, this one. We want it to be indexed linearly, but can't allocate
as much, so together with io_get_tag_slot() it hides two level
tables from us, providing linear indexing.

> 
> Not sure if that's a false positive or not. This kind of indirection
> makes my brain melt.

So, this one should be a false positive. But agree about the
indirection, it's not the first sizeof bug you found. Any
better ideas how to push it to the type system?

I think something like below would make more sense

#define copy_from_user_typed(from, to) \
    assert(typeof(from) == typeof(to)),
    copy_from_user(from, to, sizeof(*from));

-- 
Pavel Begunkov
