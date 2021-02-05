Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07731153F
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 23:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhBEW0W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 17:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhBEOUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 09:20:10 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91951C061D7D
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 07:57:15 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id w4so6410853wmi.4
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 07:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDjZPYc43U73nfnjxd4Jnrd4c0tAGWjK3ynRT9F7PQg=;
        b=B9OFUHmzL2y0a0MOtWqHxwm9Mrc0fD6s6K2EihtqTUdBugwKVBrzcrdTD4o3b/vAb/
         y8vHc8RH+v1ZOEHC2LiDHTCrmRW7y21AZSgZ33XtxvOwh/CwjN9H+ZpkCGL/6WHl8/Be
         MiRoJkHt4u31HnuanvYR0REiLep7es3qzuEfC562YVOeTBkFb9Lf9L49PPgxYfGwUqoz
         rGbDFDyWNz33klXaqVaPqv18apmtCVQqMiRCgiEk7kYnxPT4uzhfW4chmZrwasSz3UeH
         UKHHc7nWTLGVt2hAy7RvRYfPfDGJrPUKjIvvcVWkLQG151t0jlk1jP9FAAOEmpw6npqE
         GCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDjZPYc43U73nfnjxd4Jnrd4c0tAGWjK3ynRT9F7PQg=;
        b=Bcp5colCqpzBoikpW4LRDF13r+TWdFkxoDrETJwWYTJInZKoVSk03MGGxwriullRB2
         4Swf8qKQy+2rUQtZ+UrEsQA6lYqVy/kTeLiYIu/m7sSeWV95oN0hreVFRmeuzuv8zidc
         6wFbfJiYoaAYZnJdtlGO+ahxmYGjLisCODRf+hOwHgkxvQ4NLA6awXnAG2OYIagWC2XU
         ZQ2Yvi3SEw62udrWq5mjmopVvZ6nFWglN2svotAQde5ZkWIedfCqBJQpeKwA1kOS2I+W
         PGfIkdj9R6OtXf56u08oqvwi40zCT2MCNk7APPbeD+uHV4DdObqXNTpC9r5IdkOPDQY1
         GFrQ==
X-Gm-Message-State: AOAM530gQDHqmDvp6myDapPDVpOsI6Rlb3n2wkWEIH2ospN6EvA+FgAh
        Yd8B47dckpJdmY0boQiDwMvI17TFBtytAg==
X-Google-Smtp-Source: ABdhPJzd62H/oi2VbcmGUI0DYN0v+2vVvXjmMioK7AW/3gvjzBGUNxjcVeEZTuDxjD7ee46vgFR+pw==
X-Received: by 2002:a1c:ab88:: with SMTP id u130mr3993038wme.185.1612537285711;
        Fri, 05 Feb 2021 07:01:25 -0800 (PST)
Received: from [192.168.8.177] ([85.255.234.168])
        by smtp.gmail.com with ESMTPSA id g1sm12028657wrq.30.2021.02.05.07.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 07:01:25 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring@vger.kernel.org
References: <cover.1612486458.git.asml.silence@gmail.com>
 <ac7dc756e811000751c9cc8fba5d03cc73da314a.1612486458.git.asml.silence@gmail.com>
 <e8bb9ad9-d4ad-8215-fdef-2fb136ae5a41@samba.org>
 <3aae2e7d-0405-7f5b-9062-5eca9df13e74@gmail.com>
 <526757c3-49e4-33e6-5295-378a6b8c8df7@samba.org>
 <0cecc53b-aea5-354b-3aff-9bc01b784b04@gmail.com>
 <4330b1c1-4f6b-cd8a-5d1d-63199b27c14e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: refactor sendmsg/recvmsg iov managing
Message-ID: <8dcb62d6-fe6b-9d5b-9d76-5dd3214c1e3b@gmail.com>
Date:   Fri, 5 Feb 2021 14:57:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4330b1c1-4f6b-cd8a-5d1d-63199b27c14e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/02/2021 14:45, Jens Axboe wrote:
> On 2/5/21 3:06 AM, Pavel Begunkov wrote:
>> On 05/02/2021 09:58, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>>>>>  static int io_sendmsg_copy_hdr(struct io_kiocb *req,
>>>>>>  			       struct io_async_msghdr *iomsg)
>>>>>>  {
>>>>>> -	iomsg->iov = iomsg->fast_iov;
>>>>>>  	iomsg->msg.msg_name = &iomsg->addr;
>>>>>> +	iomsg->free_iov = iomsg->fast_iov;
>>>>>
>>>>> Why this? Isn't the idea of this patch that free_iov is never == fast_iov?
>>>>
>>>> That's a part of __import_iovec() and sendmsg_copy_msghdr() API, you pass
>>>> fast_iov as such and get back NULL or a newly allocated one in it.
>>> I think that should at least get a comment to make this clear and
>>> maybe a temporary variable like this:
>>>
>>> tmp_iov = iomsg->fast_iov;
>>> __import_iovec(..., &tmp_iov, ...);
>>> iomsg->free_iov = tmp_iov;
>>
>> I'd rather disagree. It's a well known (ish) API, and I deliberately
>> placed such assignments right before import_iovec/etc.
> 
> Agree on that, it's kind of a weird idiom, but it's used throughout the
> kernel. However:

Maybe someday someone will refactor it and make it accepting inline_vecs
directly...

> 
>>>>> kfree() handles NULL, or is this a hot path and we want to avoid a function call?
>>>>
>>>> Yes, the hot path here is not having iov allocated, and Jens told before
>>>> that he had observed overhead for a similar place in io_[read,write].
>>>
>>> Ok, a comment would also help here...
> 
> I do agree on that one, since otherwise we get patches for it as has
> been proven by the few other spots... I'll add then when queueing this
> up.

I didn't disagree with that, just forgot to throw one to protect ourselves
from static analysis tools. Thanks for fixing up

-- 
Pavel Begunkov
