Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA152D77C1
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406201AbgLKOYl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 09:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406071AbgLKOYL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 09:24:11 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7325C0613D6;
        Fri, 11 Dec 2020 06:23:30 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id g185so8755629wmf.3;
        Fri, 11 Dec 2020 06:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1UbzRBoNF2xRidzwVWqUFo9sauVQ+nWdev5G/0Ii8k=;
        b=II00RboARgNppCaKmmz9sWOjMMjIPAAWzKwgZuPCiWdq1QTZO/YOocIEhn3mcrWp6Y
         C4vaD5ovWq/NlnZnSOPTPv2pRxWm9n78FQWBNf8UEPzUwx/l+hzxNN6/gdlnasf0sQYD
         YWuBYOO07zmtZStMrFvnHjx8VM7d61AXZb2hXCaSW2nv1cNHuC0ZEhoKxF1dy9bHACSq
         8oorg5Mui+QoYqrg8apdblHqq2V8o5Ful/vaQDv8vBs98rmu+IOTuKUkYIAxpkqpCtwk
         mPLigGvVgY0SgWwyaw+pdM5o3rkCJz2YlMeLSw/0tNAIY+LhiFntDnjYsIFAsBuGAOQa
         q5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=B1UbzRBoNF2xRidzwVWqUFo9sauVQ+nWdev5G/0Ii8k=;
        b=aVRlcF7QRPuGydahB1SCaYF7r21KAJbPfUQWY47KiW+hrxWDSwrEbAgbBhPTr7m6tW
         7NT+DCeCX0B4PDunX9UOhztR4K6HZ0o9sq/AyRKNcx9urav3zP0uaDZHiG7umsr6JM/B
         pMbU5bvkIbSStWVUe5jAbUuoCXN8AiLrWT6snqjMGXVWj9jTjqdmwL0AQLsD8tl8muB9
         mvc6kBmUsFPWAzGRtF0t/vSOGAVwGLX3aEvmM/Ff0C8paFqJv0nvqsXFLJv1kNdjcVCS
         /KhsNL+twZ3S3oZ5xKag8WvCXN5x+nq9lg10coSCKM92DaZ9ShuIA5k6z+SB0xeFMRvp
         oTDw==
X-Gm-Message-State: AOAM531b4gxE3pkJgiMj99jPWuTL/1lV63InvrYCfBYhiHOwj/v6aGa3
        vaygdrt9/+24M8ok6gFbAzlTZXJumtsjaw==
X-Google-Smtp-Source: ABdhPJz1gnjwc1B8MBAXKnPwfnB8Tdq2HRjM9Or5+/Xj9//hiJ8gDku0rH5GcKBtAE4gdt8w/KphBQ==
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr14003472wmi.162.1607696609544;
        Fri, 11 Dec 2020 06:23:29 -0800 (PST)
Received: from [192.168.8.123] ([85.255.234.121])
        by smtp.gmail.com with ESMTPSA id j9sm10330192wrm.14.2020.12.11.06.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 06:23:29 -0800 (PST)
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
 <20201209084005.GC21968@infradead.org> <20201211140622.GA286014@cmpxchg.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] block: no-copy bvec for direct IO
Message-ID: <2404b68a-1569-ce25-c9c4-00d7e42f9e06@gmail.com>
Date:   Fri, 11 Dec 2020 14:20:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201211140622.GA286014@cmpxchg.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/12/2020 14:06, Johannes Weiner wrote:
> On Wed, Dec 09, 2020 at 08:40:05AM +0000, Christoph Hellwig wrote:
>>> +	/*
>>> +	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
>>> +	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
>>> +	 * approximate it by looking at the first page and inducing it to the
>>> +	 * whole bio
>>> +	 */
>>> +	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
>>> +		bio_set_flag(bio, BIO_WORKINGSET);
>>
>> IIRC the feedback was that we do not need to deal with BIO_WORKINGSET
>> at all for direct I/O.
> 
> Yes, this hunk is incorrect. We must not use this flag for direct IO.
> It's only for paging IO, when you bring in the data at page->mapping +
> page->index. Otherwise you tell the pressure accounting code that you
> are paging in a thrashing page, when really you're just reading new
> data into a page frame that happens to be hot.
> 
> (As per the other thread, bio_add_page() currently makes that same
> mistake for direct IO. I'm fixing that.)

I have that stuff fixed, it just didn't go into the RFC. That's basically
removing replacing add_page() with its version without BIO_WORKINGSET
in bio_iov_iter_get_pages() and all __bio_iov_*_{add,get}_pages() +
fix up ./fs/direct-io.c. Should cover all direct cases if I didn't miss
some.

-- 
Pavel Begunkov
