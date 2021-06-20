Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53D53AE097
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFTVOE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 17:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhFTVOE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 17:14:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FE5C061574;
        Sun, 20 Jun 2021 14:11:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id i94so17279612wri.4;
        Sun, 20 Jun 2021 14:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qnbmwhCwEPzlpvNArWXCmoxqYl+pNWN2Fxh/pQooKJg=;
        b=KDWc8Gwsf5lMFjvxHo5sU4GPXOW20Fxqe9/00DfT7dOkwSb4dlN+3asqe/RgQyP7Vd
         tC7gAz4Xaqzp/OmpCX5tm7HojpLJnDke8gD73ID5F29Jhp/TvS/5yRnMfAOaHD879iH4
         9iLB8Lm8j1jglTiVFrhQOdeojHE+ru1wIrIAcec3LxYDeCS1UFiGhmIpLdgHbMUNy35Q
         EpYmw5fQ76hijyz4Jh0cUP9r83CJ0nsOWbmh1NNJKf/pGUmYkAl6g4NfpCMtC+H8ukP5
         fRYUig4oUSeTRAZnYUDh9YyAa43vBc1rlKPD8q4DC6bkdiB0u7P+o2JkYRbOc/f7pnyo
         yQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qnbmwhCwEPzlpvNArWXCmoxqYl+pNWN2Fxh/pQooKJg=;
        b=jCalJwB6mChqAmuJPJ7/XGKsKCM7Q4FeRBPB3DZN73/ZwM/j4ExOG6VSN4vruppoMj
         n9epSIYPUhPqkdW0sN4Nf8oGHHcfxELOEGGtJswlZZUhzotsVK7Ecw6NSz+bsxNE5IQB
         r7AXqD7dASL6Mdrs5WXEQ1ccFdx7zpz7Y88/VHhZn5LxkMgwFUVtPOlp9ZxHZ17C1sPC
         7/Xy5nQRUDZkfpOF9nckFHSRnR3vgs4L5reNfsttEZcXjr64TmlUcvcD5InPO0gBpcCd
         9ze+QImjYJLOJf5MMA4ddy8zrBcqJXBYiG8ocMSol2hM2js62N/9Zs43Mp1MLnu5vdqc
         9dhQ==
X-Gm-Message-State: AOAM532XFYvvhONVG/w60AcKmVF+tvTH55yz8NaaW+PRS/U4bSlbdI+P
        X1BfuUGkTBKkodOo1iqlJvVJdF3xNuWCfg==
X-Google-Smtp-Source: ABdhPJyzbU4C7XYQlhTq7lDgpu9lFYQ2HjoOnabQl0oeFnwF2AF49DSvkTMM8F2ybsN9hTGbTyUxPQ==
X-Received: by 2002:adf:d1e4:: with SMTP id g4mr24714273wrd.405.1624223508507;
        Sun, 20 Jun 2021 14:11:48 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id e17sm17180727wre.79.2021.06.20.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 14:11:48 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
 <86a768ba44d3d2009c313bd2b7ddf25e2a3f4b5e.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e003861d-f702-24e5-5292-b18d207481d7@gmail.com>
Date:   Sun, 20 Jun 2021 22:11:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <86a768ba44d3d2009c313bd2b7ddf25e2a3f4b5e.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 10:05 PM, Olivier Langlois wrote:
> On Sun, 2021-06-20 at 20:56 +0100, Pavel Begunkov wrote:
>> On 6/20/21 8:05 PM, Olivier Langlois wrote:
>>>
>>>  
>>> -static bool io_arm_poll_handler(struct io_kiocb *req)
>>> +#define IO_ARM_POLL_OK    0
>>> +#define IO_ARM_POLL_ERR   1
>>> +#define IO_ARM_POLL_READY 2
>>
>> Please add a new line here. Can even be moved somewhere
>> to the top, but it's a matter of taste.
> 
> If you let me decide, I prefer to let them close to where they are
> used. There is so much data definitions in the heading section that I
> feel like putting very minor implementation details to it might
> overwhelm newcomers instead of helping them to grasp the big picture.
> 
> but I will add an extra space as you request

btw, it doesn't apply cleanly for me, conflicts
with your trace changes. Can you check that you're
on an up-to-date revision? I.e.

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.14/io_uring

>>
>> Also, how about to rename it to apoll? io_uring internal
>> rw/send/recv polling is often abbreviated as such around
>> io_uring.c
>> IO_APOLL_OK and so on.
> 
> no problem. I will.
>>
>>> +static int io_arm_poll_handler(struct io_kiocb *req)
>>>  {
>>>         const struct io_op_def *def = &io_op_defs[req->opcode];
>>>         struct io_ring_ctx *ctx = req->ctx;
>>> @@ -5153,22 +5156,22 @@ static bool io_arm_poll_handler(struct
>>> io_kiocb *req)
>>>         int rw;
>>>  
>>>         if (!req->file || !file_can_poll(req->file))
>>> -               return false;
>>> +               return IO_ARM_POLL_ERR;
>>
>> It's not really an error. Maybe IO_APOLL_ABORTED or so?
> 
> Ok.
> 
> 

-- 
Pavel Begunkov
