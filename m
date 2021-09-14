Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C540B3BB
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhINPwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhINPwd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:52:33 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0290DC061764
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:50:50 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b7so17700275iob.4
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oriGLzbsQZPAQ6mlFkN1AzmZM2eIt0iO/zdegJX9EmU=;
        b=BU9nUGsJx/4lbsk3toZqeG2j6szfDJp40nLnSi6zADCGfmBzpOMz9cL1YLKXKqybH6
         slzJ4lu+Qi1Qcc+p/17kSLOEyhAD5Sp7+yZHTqUQunrVicFhl389aAeQRe13pHpORZ73
         QZfzbK9FEY2iAFqA4eDHKw6h7LTMTst3eW/oGRMJytJG6P7VShdCFikp/1WGky+tuK1J
         LzRqqInVrXD8z4f2Vg1NBkQY/fle52tXleEfqj+zQxh4fRBC4TF7DweUJH1L039Urnc1
         pUglhocn1oK5gpjRJOapbU3bFhKk0kfAwKogvQdS+NQ1LLjt12qtZiC/QCu3otFObu1+
         UDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oriGLzbsQZPAQ6mlFkN1AzmZM2eIt0iO/zdegJX9EmU=;
        b=YKQuLqsMekuh/6tmgOQORbWaT9cpEzLF4KgFV+ybuHB0+GmG4FeAhBcCHJlVUSCOYB
         PQATNiaqP7bQXzam8NPiCiew8/BQZ4RO2kM5f28u1hbSbWiUzj5KZGnrUaGXDNpZSAiI
         TLox//bRwfXSucOcZFk33uOnJgCZZYExIzlCzNDl6ptghz0u08UMfGdyEFFU7DVosITk
         3GPnZCF2aTzE9z6aJ9qbN1pp21Hn/1U3eIBG+Pfa5CJHTrHxi5Fy5/+uAaEjAktRKiRv
         bFmNKlYt/Tin8Tfn3naQvAFSje0fwNDDc0vHfJLBj0gMvECPA5dcAMMdI/uaI5IPNOo8
         MJtA==
X-Gm-Message-State: AOAM533Ct2Iq5e3hyF/GOPl4eF7hNwRzFXfy9zeINaOECE6mUTKpHI2k
        e+ZVwOtn839XP44kdmnupjeKJg==
X-Google-Smtp-Source: ABdhPJzMEFkOW+gKoW6Nu7TExRhEL3ZZsyFBaNr/R3NILq0E+So4/DGsmCc3VZHAlItiatIkX9Yq/w==
X-Received: by 2002:a5d:9e49:: with SMTP id i9mr14020523ioi.125.1631634649245;
        Tue, 14 Sep 2021 08:50:49 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r18sm6783987ioa.13.2021.09.14.08.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 08:50:48 -0700 (PDT)
Subject: Re: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
 <997aadc0-0b8d-e42b-242d-670cccd0b59c@kernel.dk>
 <7581ec11-315d-f459-2ee4-652426192807@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ba709c00-f644-7abb-7c45-99fa08ecb1e7@kernel.dk>
Date:   Tue, 14 Sep 2021 09:50:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7581ec11-315d-f459-2ee4-652426192807@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 9:48 AM, Pavel Begunkov wrote:
> On 9/14/21 4:36 PM, Jens Axboe wrote:
>> On 9/14/21 9:12 AM, Pavel Begunkov wrote:
>>> It might be inconvenient that direct open/accept deviates from the
>>> update semantics and fails if the slot is taken instead of removing a
>>> file sitting there. Implement this auto-removal.
>>>
>>> Note that removal might need to allocate and so may fail. However, if an
>>> empty slot is specified, it's guaraneed to not fail on the fd
>>> installation side for valid userspace programs. It's needed for users
>>> who can't tolerate such failures, e.g. accept where the other end
>>> never retries.
>>>
>>> Suggested-by: Franz-B. Tuneke <franz-bernhard.tuneke@tu-dortmund.de>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> v2: simplify io_rsrc_node_switch_start() handling
>>>
>>>  fs/io_uring.c | 52 +++++++++++++++++++++++++++++++++------------------
>>>  1 file changed, 34 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index a864a94364c6..58c0cbfdd128 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -8287,11 +8287,27 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
>>>  #endif
>>>  }
>>>  
>>> +static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
>>> +				 struct io_rsrc_node *node, void *rsrc)
>>> +{
>>> +	struct io_rsrc_put *prsrc;
>>> +
>>> +	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
>>> +	if (!prsrc)
>>> +		return -ENOMEM;
>>> +
>>> +	prsrc->tag = *io_get_tag_slot(data, idx);
>>> +	prsrc->rsrc = rsrc;
>>> +	list_add(&prsrc->list, &node->rsrc_list);
>>> +	return 0;
>>> +}
>>
>> I know this code is just being moved, but I tend to like making the
>> expected/fast path inline:
> 
> I think it's more natural as now, as we always have
> 
> ret = do_something();
> if (ret)
>     return ret;
> ret = do_something2();
> if (ret)
>     goto err;
> 
> 
> And I remember you telling once "... I tend to like to do the error
> path like that unless it's a hot path ...". So maybe just add
> unlikely()?

Yeah doesn't matter too much for a non-fast path, and unlikely() here
won't matter as well. Let's just use it as-is.

-- 
Jens Axboe

