Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29E311542
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 23:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhBEW0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 17:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhBEOWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 09:22:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523CC0611C3
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 07:49:34 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id j12so4571203pfj.12
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 07:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZAzLd3Z1jcj0QeYhesWVQU0zmCn6fhcAAw15ybQY4Ec=;
        b=RFB5REeTbKaJChTmgNmE3CnGx55MBZStws8crw7mo1PCdGvbddJJawivZkUro/Nps5
         mU0HEcxGkHwJJfCjEIbk7R5yXvS4tWAET6oMb4AG4hazSKDXotxK9Wcc+dMEoR7oeXsz
         bj0X6QwVxtwbhj/vWbVlFZQnK/JRCRSh9tE1WViNKG+BRa1D/3IPQExzzyfWmZUAut/j
         HU6Wt5IFvKgdGPIQNMaL4Og0vrmtWQyLziXvgijVDz3PYToWX5Qt9Lx+Of2luiNpzgMU
         5wX1t0vFWpNeihhT76oN1Qtu4x614OAzoUiwGSMuolpIuIeJTkC17SI/wDZ6EjTLvAGZ
         jO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZAzLd3Z1jcj0QeYhesWVQU0zmCn6fhcAAw15ybQY4Ec=;
        b=nvA8xBbN4GPPN2N/d154eZCcdAQskv94cyeo1eWnohs9J+enlvnG3Cg9soD0BRAcBw
         os9ndvAiCHBVrWPTmTcIqaH8GJdMat1vxYA6YQNLa+TVhfeZPNBz9rjtpxEdYfI9Is1r
         kIznJHhRqGhnnLCzJPyzAUo0+fc0cZ9U6Yb+iHze9qghtWVbuMMVTIR5MgpF2LhV4A94
         crfLcgm8WOFHf5EV0lcoxcUCQsk7+OVR0bsakMuGr9YTCs8ZgLhvZoXQagD3Z9hXqf4n
         7tZ8PwGMBTlpzJhiMPsf3lKYsoJe3ylYbklPSwQjySMcfmCIZs7KzJKk3TOiuf0YqZ1n
         2kpA==
X-Gm-Message-State: AOAM531g5B1t606hxcR+fpD3y3NqpbeLIC9OvWowBAdQ2GnL48v3qzLB
        I7oDg8k+eYpH0geOBuFMig9qnUaGy/khGZwN
X-Google-Smtp-Source: ABdhPJwTtNYzVOc4Em0MRMLV/Om5AqSvGyozln19TjcV6xK9LFwVYG/KfWWljiMcOaTsfSzX9eX+jA==
X-Received: by 2002:a92:d44b:: with SMTP id r11mr4145905ilm.159.1612536314086;
        Fri, 05 Feb 2021 06:45:14 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s9sm4280932ilt.2.2021.02.05.06.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:45:13 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: refactor sendmsg/recvmsg iov managing
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1612486458.git.asml.silence@gmail.com>
 <ac7dc756e811000751c9cc8fba5d03cc73da314a.1612486458.git.asml.silence@gmail.com>
 <e8bb9ad9-d4ad-8215-fdef-2fb136ae5a41@samba.org>
 <3aae2e7d-0405-7f5b-9062-5eca9df13e74@gmail.com>
 <526757c3-49e4-33e6-5295-378a6b8c8df7@samba.org>
 <0cecc53b-aea5-354b-3aff-9bc01b784b04@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4330b1c1-4f6b-cd8a-5d1d-63199b27c14e@kernel.dk>
Date:   Fri, 5 Feb 2021 07:45:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0cecc53b-aea5-354b-3aff-9bc01b784b04@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/21 3:06 AM, Pavel Begunkov wrote:
> On 05/02/2021 09:58, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>>>>  static int io_sendmsg_copy_hdr(struct io_kiocb *req,
>>>>>  			       struct io_async_msghdr *iomsg)
>>>>>  {
>>>>> -	iomsg->iov = iomsg->fast_iov;
>>>>>  	iomsg->msg.msg_name = &iomsg->addr;
>>>>> +	iomsg->free_iov = iomsg->fast_iov;
>>>>
>>>> Why this? Isn't the idea of this patch that free_iov is never == fast_iov?
>>>
>>> That's a part of __import_iovec() and sendmsg_copy_msghdr() API, you pass
>>> fast_iov as such and get back NULL or a newly allocated one in it.
>> I think that should at least get a comment to make this clear and
>> maybe a temporary variable like this:
>>
>> tmp_iov = iomsg->fast_iov;
>> __import_iovec(..., &tmp_iov, ...);
>> iomsg->free_iov = tmp_iov;
> 
> I'd rather disagree. It's a well known (ish) API, and I deliberately
> placed such assignments right before import_iovec/etc.

Agree on that, it's kind of a weird idiom, but it's used throughout the
kernel. However:

>>>> kfree() handles NULL, or is this a hot path and we want to avoid a function call?
>>>
>>> Yes, the hot path here is not having iov allocated, and Jens told before
>>> that he had observed overhead for a similar place in io_[read,write].
>>
>> Ok, a comment would also help here...

I do agree on that one, since otherwise we get patches for it as has
been proven by the few other spots... I'll add then when queueing this
up.

-- 
Jens Axboe

