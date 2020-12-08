Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25952D3459
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 21:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLHUh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 15:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgLHUh0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 15:37:26 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE93C0613CF
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 12:36:46 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id dk8so16104366edb.1
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 12:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cPpWN8Xk7Vzve0W1xmYH/WyATA1LO+aqD4n4ah1IqbI=;
        b=YKrAs5KsRW2hRNUo/fp74IpFIjBP3aGTcLhok0/PTaJUTTr3yFA6e8wmL1ypaYi0n6
         Eh6EBzdc11wYLaod9Jkj6PHmMU9SgGV2stSqATozJtZsCGGB9RMeMGUpepdZhL3FDeaS
         +WtW2h6poifBODcNUL/ml4AWdq+nmDG8Xi2McTWWjkAaM/6HdHwa0u4JGyT1zkd75AYL
         ibnZtYQn3oAdE+m7sqbl2g4w8w7jZ47MmqYpWP/vh+KgU4R4vaz1YTBUHapImVv0wpBy
         f9TKnIMpJTPXiA6uYUGjQIFhlBxb3hTA77ree9fAD2RfNoJoCpKhqjYDGCXl9C383jpg
         xEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cPpWN8Xk7Vzve0W1xmYH/WyATA1LO+aqD4n4ah1IqbI=;
        b=hbosYZuCifn0PNs0Y4DL/LGK8NR14nTwfZOsHUztI8IihLNuI62cweQtpLGh0Rt+pO
         OE6hPTdG14T52uRtnTF6vJiLfp4ddw8dtXcaBdD7gy6u8F3PUMlprvTg5gH9sl8rmmzO
         jNJ5WkXUGZLWgbjeJXLCfcKK1XuYxB2FNE8AL0nZYsot0c87Tb1CtgupQDcA9Il1Pl+p
         Q4sKQ/PKjXAHTLAvDEvK+LYLtJiFUZre/RixlSiTGtX3fvjeeLFLTh4HMzb67fqCfTQc
         VgyaCP0KWV9n6SASi6gHQqoDhejzxoonYfMyqfbcir4ZGH9JUC2Vj59KwHgOZtfY0l5e
         tH6Q==
X-Gm-Message-State: AOAM531GONTHEio9KShJ9GyIka1k29vaOkMIGcgRDd/n52bVkUw82MQ/
        RBcX2d7yOR+kwb70WdkM8j7faMIcp5xfIw==
X-Google-Smtp-Source: ABdhPJzKhCH504R83j5Ih3bIFmQFSzDsOue+5gKbTwK3kJDWZSEW5hcGFfYX0JryjDN9tAFL/CetsA==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr23077898wrn.322.1607454932678;
        Tue, 08 Dec 2020 11:15:32 -0800 (PST)
Received: from [192.168.8.116] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id u6sm1278866wrm.90.2020.12.08.11.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:15:32 -0800 (PST)
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
To:     Jens Axboe <axboe@kernel.dk>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
 <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
Date:   Tue, 8 Dec 2020 19:12:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 16:28, Jens Axboe wrote:
> On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>
>> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
>> we'll complete req by calling io_req_complete(), which will hold completion_lock
>> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
>> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
>> access to ctx->defer_list, double free may happen.
>>
>> To fix this bug, we always let io_iopoll_complete() complete polled io.
> 
> This patch is causing hangs with iopoll testing, if you end up getting
> -EAGAIN on request submission. I've dropped it.

I fail to understand without debugging how does it happen, especially since
it shouldn't even get out of the while in io_wq_submit_work(). Is that
something obvious I've missed?

> 
> Reproducible with test/iopoll /dev/somedevice
> 
> where somedevice has a low queue depth and hits request starvation
> during the test.
> 

-- 
Pavel Begunkov
