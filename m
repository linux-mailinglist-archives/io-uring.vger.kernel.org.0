Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824C536D9DB
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbhD1Ove (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbhD1Ove (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:51:34 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD61C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:50:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x7so63336827wrw.10
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dh5ckp8n+u6qBmnpGEGckS49JVJHMUi4/W5BBxbSje0=;
        b=t9ca4VjgkMmxzGlws0gf+NCXXEbUyWbww7hdziEcUxaCm0FEv79iTIwhy7o/LC5ca7
         iO9sLl42yBZQXwnEQtgaLR3sqZQ7HwMT4HohPwY15tTIibJA4MIdxpeVp7UEr8b1zxkT
         1Bumy5fclT9ivA/egWa2xtOv91owE3tTHjK7y/OrZoYOnFzBL9NLkj3m2BmhAbL+cYjX
         zFDxAZTHgs93d8h/epHEMJ6kufZox5exu2Xnil3H6XhCfgbOfGk66CXv/BiX1fKzKFsP
         U6fA55Po/TFlGkNK02zkf2UKxUAEnORVPZomuEPuLpxPmsPBRNr5wICc7X/BuPT42qEY
         8goA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dh5ckp8n+u6qBmnpGEGckS49JVJHMUi4/W5BBxbSje0=;
        b=QLj2bwZ2NzhzD1gDAdfC6J/0X2u+fOdZhRqqadnXkGYYoCib6DI+a0lGd9LE8xZrNr
         VADhX4zCUPBuiXjGH1SYP4oBsZHNBygqXdoYjOwKfE4bw6RRrmfPcSEeyzB7JKnvdA/1
         enCxy83Ze5xNihjlRmZ506WYOF/YYxAJI0v2u1bXM4yUQo6vFow/ejI3QvpAe1DMVfpz
         +kijlMlMDfUkzkX3TKeG6BNNGa3bMU+cBw0lqBmjVl/ZYQ3y34YcKoKYgo1yAhn/23Xn
         7B+uWCA3N1KhueZM7Fs+dZ6WjJ2IZz2qpBVYIT9m00+0l22ITrrc1mjzyi4uAdHMVtOQ
         r1UA==
X-Gm-Message-State: AOAM531RmgOsiBHfJv9xMMYiiCSpwmsjxRCzEtJO61J1qhJDpYmKc5ou
        99jHNiSX3MWn8FD+p9gNPaw=
X-Google-Smtp-Source: ABdhPJxZytvPRqOM5DflP/IilGnd7W59W/j1hgT0KnW6iuHsoGL8zt2WIMmSKJyHB96q8Nh2GKlvXw==
X-Received: by 2002:a5d:6607:: with SMTP id n7mr37753827wru.146.1619621447809;
        Wed, 28 Apr 2021 07:50:47 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id 3sm3995620wms.30.2021.04.28.07.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:50:47 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <093a196a-1925-4f0d-aa2f-0cc1d46484c8@gmail.com>
Date:   Wed, 28 Apr 2021 15:50:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 3:39 PM, Jens Axboe wrote:
> On 4/28/21 8:34 AM, Pavel Begunkov wrote:
>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>> sqes are submitted by sqthread when it is leveraged, which means there
>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>> number of sqes in the original task context.
>>> Tests result below:
>>
>> Frankly, it can be a nest of corner cases if not now then in the future,
>> leading to a high maintenance burden. Hence, if we consider the change,
>> I'd rather want to limit the userspace exposure, so it can be removed
>> if needed.
>>
>> A noticeable change of behaviour here, as Hao recently asked, is that
>> the ring can be passed to a task from a completely another thread group,
>> and so the feature would execute from that context, not from the
>> original/sqpoll one.
>>
>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>> ignored if the previous point is addressed.
> 
> I mostly agree on that. The problem I see is that for most use cases,
> the "submit from task itself if we need to enter the kernel" is
> perfectly fine, and would probably be preferable. But there are also
> uses cases that absolutely do not want to spend any extra cycles doing
> submit, they are isolating the submission to sqpoll exclusively and that
> is part of the win there. Based on that, I don't think it can be an
> automatic kind of feature.

Reasonable. 
 
> I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
> would likely be better, or maybe even more verbose as
> IORING_ENTER_SQ_SUBMIT_ON_IDLE.
> 
> On top of that, I don't think an extra submit flag is a huge deal, I
> don't imagine we'll end up with a ton of them. In fact, two have been
> added related to sqpoll since the inception, out of the 3 total added
> flags.

I don't care about the flag itself, nor about performance as it's
nicely under the SQPOLL check, but I rather want to leave a way to
ignore the feature if we would (ever) need to disable it, either
with flag or without it.

> This is all independent of implementation detail and needed fixes to the
> patch.
> 

-- 
Pavel Begunkov
