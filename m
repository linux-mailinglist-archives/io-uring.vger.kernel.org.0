Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E032337C3
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbgG3RfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgG3RfK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 13:35:10 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B31C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:35:10 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a14so3571031edx.7
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=grtLM2wuFPTIXJb4FkaFlVlU3LSMFApNGIBKPxbNXo8=;
        b=M6+TKw/UJL3UrW6YOGLmaDKBnVV31Ae1/bLUpD01EKIRUupS7OdoodmKfjproAHyTB
         h/E1JdQCQXggd1JYTdRaCpqLpIBghFqeygvIn5LGxGrwLLkdLH84TUiuxVhT5gynq7n4
         B7igXhYo/rUIkXe3ce7bl7FEwruvwbeCid1ZY9+KqBaLi4L0u9mwjYnf9t2mFSB3fOS3
         gBmydeC8o8ME6DgUXK5znvYvB+7fSw0JWhFBMAVoXC8fdQOPUv8m5niOho5pdyb+4uet
         eoof7edU4gqxPcchgz8Dq6RrMoysTo/D9w8EftkffSLIryjMbHH3Bsv8VUzzowCVMfy3
         K/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=grtLM2wuFPTIXJb4FkaFlVlU3LSMFApNGIBKPxbNXo8=;
        b=mgdfCNKrJUqZMEvioE4SoAdi59h7jVY7bl2UzC/5NWTDLOVlA/F93seEjw0LgD4eKH
         3fwfxWlR6qi1bUii7+NbTeyzHxQNk7kLF4ot1oKTGjOe80CHn0HiL08aQeFcaxPYFkyh
         96bx7l1dQbmdy0ylsSFVZ3xJmb1WsiBYHiutRBx1GcqALBgo8Jg95tuSJR4as5oO1yZq
         x88xhXSBVdBMeBItQjHW4KVOfgVHeZAC1OtRKD2n9SU9qTSt9gEr5lUoRx0qVVbpAci3
         tAe4kdZUqaayaBmomNJvs+iocyXanzlTY8uEvVf2YuVHWldH4imm4dNCGV2yBXVmf8lT
         F6HQ==
X-Gm-Message-State: AOAM530/5sE1DwDPFb743qxH8+KnOYxmqflsm9DnnGIyDNm4DD9EOjf/
        +ca0rT4LdxJXLpbi3HAiNM4oqSwB
X-Google-Smtp-Source: ABdhPJyjCZjKUKzq7lMef20qeOGhpOhiTo435l9QHNhtc3ydVC6o0OTMFqLM6WQVyYxqvlEPuU5xPg==
X-Received: by 2002:aa7:c88f:: with SMTP id p15mr63380eds.33.1596130508609;
        Thu, 30 Jul 2020 10:35:08 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d24sm6876731edz.77.2020.07.30.10.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:35:07 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
 <ba9c998d27e8e75467b09d8a2716cf6618b7cd93.1596123376.git.asml.silence@gmail.com>
 <d2347d32-7651-b34b-a7ca-5993b49a2147@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/6] io_uring: fix racy overflow count reporting
Message-ID: <07b1ee0e-72d9-a202-34ac-8095628c72f8@gmail.com>
Date:   Thu, 30 Jul 2020 20:33:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d2347d32-7651-b34b-a7ca-5993b49a2147@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/07/2020 20:18, Jens Axboe wrote:
> On 7/30/20 9:43 AM, Pavel Begunkov wrote:
>> All ->cq_overflow modifications should be under completion_lock,
>> otherwise it can report a wrong number to the userspace. Fix it in
>> io_uring_cancel_files().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 11f4ab87e08f..6e2322525da6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7847,10 +7847,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>>  				clear_bit(0, &ctx->cq_check_overflow);
>>  				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>>  			}
>> -			spin_unlock_irq(&ctx->completion_lock);
>> -
>>  			WRITE_ONCE(ctx->rings->cq_overflow,
>>  				atomic_inc_return(&ctx->cached_cq_overflow));
>> +			spin_unlock_irq(&ctx->completion_lock);
> 
> Torn writes? Not sure I see what the issue here, can you expand?

No, just off-by-one(many). E.g.

let: cached_overflow = 0;

        CPU 1                   |               CPU 2
====================================================================
t = ++cached_overflow // t == 1 |
                                | t2 = ++cached_overflow // t2 == 2
                                | WRITE_ONCE(cq_overflow, t2)
WRITE_ONCE(cq_overflow, t1) 	|


So, ctx->rings->cq_overflow == 1, but ctx->cached_cq_overflow == 2.
A minor problem and easy to fix.

-- 
Pavel Begunkov
