Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90366403B09
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhIHNzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 09:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbhIHNzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 09:55:08 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BE3C061757
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 06:54:00 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a22so3312783iok.12
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 06:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H6uJL7KGmuDRj2+K9SKxii9PESLgjU7iPSWeZSupfsM=;
        b=E78Z0mACMvqVx9d/nDZSIbyo6MypL5fiKNc+eg2oyohrc2HOvlZ4R9cqxpX3m5LS9p
         eiqoM4KyKsC93LoFigtSeqwLOT7zLrMTiQz8n5EyHhzXHblyP8sCigY+C0VTcSSeLUjx
         k+HzzEGH5Tal06dK38SoSd8oPvvJbyTAlmq202E1DtR1laUJIVajuPUQJgS8wzlZUCD0
         QVxLbvfPpI6/CGoDbboc8gxksPx1sS80/Qp7JF9kUa4vjGpb8KWsYhzkYHk4MgxAfsOq
         YwzUMBND+4d626pTysmKpS/t3rAHPHpfW0crrT+PauaKIpmOc2JxsJIcuChWf/FZOGcO
         kiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H6uJL7KGmuDRj2+K9SKxii9PESLgjU7iPSWeZSupfsM=;
        b=Rwh7ZtvsqWrxGv4DOz3kbu68xsvl/nwECajhTJiD4GujUzhItJMlrY4fdjudjcYNvw
         ysTdglj6KPBP2cwaEB+c0s+dvVR0Bk5xxZc58rOvtEQW+wLpRH9GVJKiRG9wT7/ZEI3J
         rLXscKb7eU1LZrowrTI16npFhRf/xax/DgElTrfhtCSdFoZtfPhN3hRz2vMxWzb9TM64
         E19MvPZ0pijvd9ELPLAImq9vhL76HyU2GuoSDj4RHh9J2o5ctV3WqS3EGHNxo1OYnB1l
         x0zi/BNrgfB9hh56CYFdxjboe7JDFrS34YM2Y8VPs3W42LyjnEifSvsYMVHZamRxhvMV
         Xc9w==
X-Gm-Message-State: AOAM531pSveELb3y8j2l8U7+H18IAy/a51wWEQ2icTyftR3F6QYqtwMD
        C34NVEzGDgGXAg9TDXb4GDlMWRvDnFn5LQ==
X-Google-Smtp-Source: ABdhPJz5nHJRsVwTeSBdURkaN0zw22/f2GRsD5sM0vyNeGc9bxwUlb2BHQL/iQNMoY4MVtsbYSYpxw==
X-Received: by 2002:a02:5d42:: with SMTP id w63mr3795653jaa.20.1631109239398;
        Wed, 08 Sep 2021 06:53:59 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i20sm1040796ila.62.2021.09.08.06.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 06:53:59 -0700 (PDT)
Subject: Re: [PATCH] /dev/mem: nowait zero/null ops
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
 <ed21a6b0-be32-e00a-98c3-f25759a44071@kernel.dk>
 <654d5c75-72fa-bfab-dc14-fa923a2a815a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e1142f64-906e-a75e-dd89-501102093761@kernel.dk>
Date:   Wed, 8 Sep 2021 07:53:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <654d5c75-72fa-bfab-dc14-fa923a2a815a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 7:07 AM, Pavel Begunkov wrote:
> On 9/8/21 1:57 PM, Jens Axboe wrote:
>> On 9/8/21 4:06 AM, Pavel Begunkov wrote:
>>> Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
>>> advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
>>> it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
>>> waits and therefore trivially meets the criteria.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  drivers/char/mem.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>>> index 1c596b5cdb27..531f144d7132 100644
>>> --- a/drivers/char/mem.c
>>> +++ b/drivers/char/mem.c
>>> @@ -495,6 +495,8 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
>>>  		written += n;
>>>  		if (signal_pending(current))
>>>  			return written ? written : -ERESTARTSYS;
>>> +		if (iocb->ki_flags & IOCB_NOWAIT)
>>> +			return written ? written : -EAGAIN;
>>>  		cond_resched();
>>>  	}
>>
>> I don't think this part is needed.
> 
> It can be clearing gigabytes in one go. Won't it be too much of a
> delay when nowait is expected?

I guess it can't hurt, but then it should be changed to:

if (!need_resched())
	continue;
if (iocb->ki_flags & IOCB_NOWAIT)
	return written ? written : -EAGAIN;
cond_resched();

to avoid doing -EAGAIN just because there's more than one segment in the
buffer. Even that may be excessive though, but definitely a lot better.

-- 
Jens Axboe

