Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5A468823
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 23:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhLDWwd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 17:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhLDWwc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 17:52:32 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB1C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 14:49:06 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d9so13843573wrw.4
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 14:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fer/KQpabEO/c2bmT/QgiGzIEnnynT0Eh+qbXcuJQ1o=;
        b=If4JO4kvXNu1bB5WYVEM2gaiPTRHW1qZxNMwyWv1qVLOABKOC3Ow9HUil6HD4r36bB
         vaXxVgmyZeni6jdV9vWYJwWpCPRLl6F/2mVVeM78OlE5zE9pKMyvedGx05h8CM4AIbuw
         Fm3Z3EMo6Cq0q/0zkluK4r2DgMOoREWcYpjKoIghZoksk+DqaeFNAgBYjLXI7Sb8Po/p
         7jcbPDE4bqfuPnpF3R2pAo1Scu6GdBXNo699mHqtuRJj20i9Ph02JPWLYA8DuUn0fomZ
         kQ90fiUi1n9NWBxyjzJN0IhqXll8KJ4a3D3IKgoHq6x07B8oUipFvjYoz/BVP2BSjcZ6
         Ozzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fer/KQpabEO/c2bmT/QgiGzIEnnynT0Eh+qbXcuJQ1o=;
        b=tRuTgOu7kI+aO4zZ8fbxIBwFE2DTRV83qKL+6unUzVzRnV8dvBbm13EVNbx6bqLnkz
         ONSrMDs5mcfq0L4MUbUx9Sg77eeTwoujSbLUm+fP6l6pVlujngnrXtbfxzZzeTYcIWDH
         hcpQWdaFQye+ROyN5rW2kihluNyV37MnjI87xKSwTxCW4nF6ZZIJzSXlGpSB4Fe3NunI
         2B+hVyJHr4eZZKy4fgvtre5vlL4QVaSRmIpRQ3gSy4jiVrAhiXjcGIUOxorRxLJw9PSu
         3rUzDSYYSL+ZpUl6aET7Zxht3pkwQnuXY7pAQUnZZvLFHy56AGqvC20F3XvxgcpuOo2O
         ZQOw==
X-Gm-Message-State: AOAM533EoHVJGi9J4k6CznHGxrSaSZBNZz2UzU+L28dHpofmLnMnoQNL
        ju26d5wraJFRoZv4Rc/F6f73tN4IjRw=
X-Google-Smtp-Source: ABdhPJz5Ukyfi9MXhnsp0ncEfisLpb5HVQpE0D6Mi0azCgbfRJdIXaV8r7bcitQbGYU4HWaFbpcrgQ==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr31726467wrn.82.1638658145147;
        Sat, 04 Dec 2021 14:49:05 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id d2sm9613234wmb.24.2021.12.04.14.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 14:49:04 -0800 (PST)
Message-ID: <0f24615d-2e03-7754-0285-712168474653@gmail.com>
Date:   Sat, 4 Dec 2021 22:48:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 3/4] io_uring: tweak iopoll return for REQ_F_CQE_SKIP
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1638650836.git.asml.silence@gmail.com>
 <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
 <797fbd8a-ea46-091d-0d26-0103026295f2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <797fbd8a-ea46-091d-0d26-0103026295f2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/21 22:21, Jens Axboe wrote:
> On 12/4/21 1:49 PM, Pavel Begunkov wrote:
>> Currently, IOPOLL returns the number of completed requests, but with
>> REQ_F_CQE_SKIP there are not the same thing anymore. That may be
>> confusing as non-iopoll wait cares only about CQEs, so make io_do_iopoll
>> return the number of posted CQEs.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 64add8260abb..ea7a0daa0b3b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>   		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>>   		if (!smp_load_acquire(&req->iopoll_completed))
>>   			break;
>> +		if (unlikely(req->flags & REQ_F_CQE_SKIP))
>> +			continue;
>>   
>> -		if (!(req->flags & REQ_F_CQE_SKIP))
>> -			__io_fill_cqe(ctx, req->user_data, req->result,
>> -				      io_put_kbuf(req));
>> +		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
>>   		nr_events++;
>>   	}
>>   
> 
> Not sure I follow the logic behind this change. Places like
> io_iopoll_try_reap_events() just need a "did we find anything" return,
> which is independent on whether or not we actually posted CQEs or not.
> Other callers either don't care what the return value is or if it's < 0
> or not (which this change won't affect).
> 
> I feel like I'm missing something here, or that the commit message
> better needs to explain why this change is done.

I was wrong on how I described it, but it means that the problem is in
a different place.

int io_do_iopoll() {
	return nr_events;
}

int io_iopoll_check() {
	do {
		nr_events += io_do_iopoll();
	while (nr_events < min && ...);
}

And "events" there better to be CQEs, otherwise the semantics
of @min + CQE_SKIP is not very clear and mismatches non-IOPOLL.

-- 
Pavel Begunkov
