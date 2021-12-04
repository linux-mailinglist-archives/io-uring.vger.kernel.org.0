Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8AC468839
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 00:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhLDXXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 18:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhLDXXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 18:23:30 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C95C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 15:20:04 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y16so8466834ioc.8
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 15:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=31kur7pGRgWKpvxagcXlpcQgwLnLidQRLnELSzQovQM=;
        b=gu4dC0uKRzChU9MuEsFnrcAFsiZNAKJXqQVI+iK7rTf8IQh/m8yAT81rjH6SQRzcKW
         2WawJ40hg4Bomd/dV6UDYFU2ZuIo3M8cLnVtboKEorlfkMQqyBzUm0rOydR8b2rJ7rxp
         H9fEDtszze5DhCIsrNX9ucJE35ueGzfq8l9+GSIV30W1skOPm7yirTwIH0sAvYp13ofv
         I5xHknwhEVndcKJPKKeIEAacodr9U13PH09FLhsnvEgr795L/NQ1/PwiflTos8GeyD7H
         yqw3blbunG3p0Y6SvY8K909VJteVYDcS2UgeU7Z2UKSGAmvB+q23EVDkEXQzOx6hbABx
         2RBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=31kur7pGRgWKpvxagcXlpcQgwLnLidQRLnELSzQovQM=;
        b=XgOecz9IE123exjuEjr+VP/SOde0AlxCsWkUQJVFS0aKKmMoB8yIUIrisblM8NYRI0
         xtKoBVaJewtJEkeK8aCFz5JGpwlKnuMoxdoOA4ReSPPzH3oHzo6tZgH1u8nScfdcud37
         PzFHV6Ey6ejw2FuhhFsepTNaGIiHuEPIvfNpK9ROwY4lTjahch+q+I2OaX2CrR/tx6Zo
         8NtvNVTP3k69+b7Cbnbod/i9BbP9An3L7BmxD4f+yZDci23cBbwL45V6xWl29neyyvdb
         +PoohGlPK+88hHNoIf+Nua4kswsUEZ6RuKfqtV/amPHuvWBiQQAtjk+/dzPVZZWa2FI4
         mMSw==
X-Gm-Message-State: AOAM531EUYsRJX6QpMbooqZy8CzRU1+b9uHR6e/L3scv+ipxlV+ZKHu3
        zBvydpSKqsnncKSVz9nglKqUTpCw/ASqcyVt
X-Google-Smtp-Source: ABdhPJydjlVOo4Z4S36av3ZOXPgRDT+k8T7+quiaWghdsqbTIx7eriT/7u0CSKPJGpR1/ebc3HUXLA==
X-Received: by 2002:a6b:d904:: with SMTP id r4mr25837792ioc.52.1638660002972;
        Sat, 04 Dec 2021 15:20:02 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h1sm4728726iow.31.2021.12.04.15.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 15:20:02 -0800 (PST)
Subject: Re: [PATCH 3/4] io_uring: tweak iopoll return for REQ_F_CQE_SKIP
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1638650836.git.asml.silence@gmail.com>
 <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
 <797fbd8a-ea46-091d-0d26-0103026295f2@kernel.dk>
 <0f24615d-2e03-7754-0285-712168474653@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d6ac675f-5651-6d85-113a-31a84a11cbcc@kernel.dk>
Date:   Sat, 4 Dec 2021 16:20:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0f24615d-2e03-7754-0285-712168474653@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/21 3:48 PM, Pavel Begunkov wrote:
> On 12/4/21 22:21, Jens Axboe wrote:
>> On 12/4/21 1:49 PM, Pavel Begunkov wrote:
>>> Currently, IOPOLL returns the number of completed requests, but with
>>> REQ_F_CQE_SKIP there are not the same thing anymore. That may be
>>> confusing as non-iopoll wait cares only about CQEs, so make io_do_iopoll
>>> return the number of posted CQEs.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   fs/io_uring.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 64add8260abb..ea7a0daa0b3b 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>>   		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>>>   		if (!smp_load_acquire(&req->iopoll_completed))
>>>   			break;
>>> +		if (unlikely(req->flags & REQ_F_CQE_SKIP))
>>> +			continue;
>>>   
>>> -		if (!(req->flags & REQ_F_CQE_SKIP))
>>> -			__io_fill_cqe(ctx, req->user_data, req->result,
>>> -				      io_put_kbuf(req));
>>> +		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
>>>   		nr_events++;
>>>   	}
>>>   
>>
>> Not sure I follow the logic behind this change. Places like
>> io_iopoll_try_reap_events() just need a "did we find anything" return,
>> which is independent on whether or not we actually posted CQEs or not.
>> Other callers either don't care what the return value is or if it's < 0
>> or not (which this change won't affect).
>>
>> I feel like I'm missing something here, or that the commit message
>> better needs to explain why this change is done.
> 
> I was wrong on how I described it, but it means that the problem is in
> a different place.
> 
> int io_do_iopoll() {
> 	return nr_events;
> }
> 
> int io_iopoll_check() {
> 	do {
> 		nr_events += io_do_iopoll();
> 	while (nr_events < min && ...);
> }
> 
> And "events" there better to be CQEs, otherwise the semantics
> of @min + CQE_SKIP is not very clear and mismatches non-IOPOLL.

Can you do a v2 of this patch? Rest of them look good to me.

-- 
Jens Axboe

