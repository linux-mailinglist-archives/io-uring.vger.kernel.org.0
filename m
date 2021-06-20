Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A13AE094
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFTVLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 17:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhFTVLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 17:11:43 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE419C061574;
        Sun, 20 Jun 2021 14:09:28 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m18so17293943wrv.2;
        Sun, 20 Jun 2021 14:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yuMnEoDUuOTckzcXivtQUZteWoUXGNSY/C5eVvPO3XE=;
        b=SlzEx2e+hbPPYCdoQC7Gj0KLypTQ/iyBIjU3cOON6cD93m3qkW1kxUeYXBO0aml5Ai
         1xQndXA77ElmZFC7QvljqqrTd0+Q9xqQfGni8Qxef6WN4qM403LPmM6Cu+qE0aPvMYbG
         T6xS1fsRv2WlqAHFw+xZ5UjNG82NwOx9+rwm/TksTf+Bkio0QjzBSkSHdny7NZzqX2p8
         8/Fym+9TmMM5QUAP2pTNBe8cg/JQyTHUTJUP0UrWGBjpXI0DI5edkF/C4GnbJmA56umZ
         hkZ+FEWJ51u7ElaJZpBr80R/pUCtZSqZEGZQulcEDIei2yx3myZoKdr9ux/BwbNLl9X/
         JeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuMnEoDUuOTckzcXivtQUZteWoUXGNSY/C5eVvPO3XE=;
        b=HxIC9a8B+rvs/Vd6bFCoe0Ck+tgqEBO4/hqX3ys2ye/zSGzX3GBRf5CHOktCDombGn
         kNqTi8aRlVY29dEfDKBIL34CfkShiivHKy2Ux5STMshCvJSogPxIDKqiWHgaiC90GFcP
         8ahBSeqzkD0OxhH7RokcUGHZchiTWrebitLwPbk3w7Dl+Zbc1HakvPaSw8v55mPGAcXj
         //6aGlixAqcLjLlr4l0kxos2tpSSWY59hD8VgRADciEdgF7//VmtMN43EpbRpzkGdYKX
         YTImdGjpkSBcrqK6m/AuECo0T3zNC58POqCNSigjco6758PVK8wkdrPsZN0sTgEc8IEd
         B3hw==
X-Gm-Message-State: AOAM53065RdKidxFo8K2HBnECcDa7Kbgsr3vUK2uSS3AueDbVByYap9j
        0FnYx8ec93XyxcbCyP74PmfcAwIBUBQAWw==
X-Google-Smtp-Source: ABdhPJwPDzis5qDZabVcJP4RchHAYe2I2+rywRDZjUsgeU5zil+eHxPJelDi6L7mjDiLL1sfYe6w/A==
X-Received: by 2002:adf:f40c:: with SMTP id g12mr24773846wro.20.1624223367364;
        Sun, 20 Jun 2021 14:09:27 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm12779468wrp.14.2021.06.20.14.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 14:09:26 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
 <86a768ba44d3d2009c313bd2b7ddf25e2a3f4b5e.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <812e6da7-70cf-d42e-800c-1ea1f6bd33b7@gmail.com>
Date:   Sun, 20 Jun 2021 22:09:12 +0100
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

Oh yeah, I think any is fine. And there are others
happily living in this style, like FFS_ASYNC_READ

> but I will add an extra space as you request
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
