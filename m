Return-Path: <io-uring+bounces-5823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C97E4A0A400
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 14:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 890F91883D54
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 13:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15D41AA791;
	Sat, 11 Jan 2025 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0ShpZO2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A24EB661;
	Sat, 11 Jan 2025 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736603878; cv=none; b=Omg6QbUhG90MuyTfW/sGQBMkjyX0ZyOkHcSnOfbuvMJy1GH+R9kuv7mbMZLRJ3xx+2g76gFdy3etuUeZm6YQGBTWHABNdsi0Ullwy3jO7y7LbJLyr04RC81bcO4sCKp4wFPC38UiKuFbmbYm4tishTgNwuBnYvT7Q4ZFtqsGXc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736603878; c=relaxed/simple;
	bh=Nrskngc+WZZv/aDA1pPckLxSKhGfJJEx86Qo24MHWaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJMLmdCp8uFrXgftDjMLwyet9hBelhHV4UKuQGL+Wtdwt5dG/3SsUrDOTqMl7O+5Idc4xc85Luv2/PwlAXMRBmy933jnn6+UvnEjVDxP2Vc5UEWOlQvbEM2Jagp4q8ad+K/Ib2K7Q4In3uhw8GufDHNEzPcZp/asD7q93TJEaQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0ShpZO2; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21675fd60feso66856635ad.2;
        Sat, 11 Jan 2025 05:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736603876; x=1737208676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evMP3Iuq4wTVybnHW6istn3D5kq1R1LLaFoYmPjrl/k=;
        b=g0ShpZO2qxdxmK9mE3cg9kQiXomqInPMxafVxL5UmQlXRL7ffM4FI7Vtz2u8BaO69T
         1Z5S7If6PMI+eq8sh8SN778hxhwjLDOmmM/o+EguzJO7lQ18lvMo+ZvYlRcaNtT3PqCr
         9WdrPwVnNoXdiOrYaTZPNqwO0gzp9b0ANFMWpI4Hu6aHV0T71JlawrY8fjtjEK8DnyQC
         nbx4oo6uAw4JHmXpq9d+KsWV8JfsGlrpFpY/yMjFXDM7xr6DM7BmQRb6dY5Rasr3YD9K
         c6sJJu92knlVW3b+1cTR1Lf8JpC7lDK7z8d9zV0WuD1u33k42f8xjYx+F54e6aBe4jXT
         Wq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736603876; x=1737208676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evMP3Iuq4wTVybnHW6istn3D5kq1R1LLaFoYmPjrl/k=;
        b=bwJgBTu2oX9PnQvW4fq8CPOFhvehnWqPyeXTRPz5/GzrS3wpxLFYPqfjpyAna8pcpX
         9efLlQyjEit0+Wyy08tiJxVbJShCXhfUtLyr7c4CjciiIp2x7TlWd6OkPe1NqKXv+rmO
         M+07HhpBB/MN8I41eHHMVFW2zk+3TFAhn54U3QxX3oXIUsStM+Jk3/Om7bpg4vqyzcae
         rwf7h0xN128tAYRaX6kMXH/3UsRlmLXHAswgs5qQTEPGEOAAXtEzFhIiJzXlkJ/QgNwC
         v3b3vNZtlKIGMC3YlwH07w9iJej6XvQVaRKvi2TvtzzjW3r5BUwn4CTrIShm9qHn7I0G
         D0gg==
X-Forwarded-Encrypted: i=1; AJvYcCVaJ7XzdJSp+8TUJYrzEfozIjMc5XuqxIDr6munB98MlAeX18/WkzL2N9RB3lbkAMx3JeWrj53rXA==@vger.kernel.org, AJvYcCXfCuUVx28l+jl0mmPRdjzasqeYtbWQc5V7fDSZfF6SbiS8IxDZyP58F+LVgJdrGmAPSl5+SajZERAltUEP@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc0lNNupNthBTIEBNeNGZotQScwOGwOor3M8lwk2V1HX09qWjK
	DoNJSDqS8EHB+OfnWmQBcPsJRXZPcK5z79gZomJVXDrmI7HK4qeL
X-Gm-Gg: ASbGncsLjvrETLiUcTx0iRG4HVeLnl5KR6MwwT2GAS0E9Xh3oPNcKmRGaHYVEmJh/XL
	hFBFyD5ViQ83G7g6Dc72i3halt2lFDnTLMOHjpoAvQxh7nxv4G/i+Xo3Bu1j60qV/0pw59esc9i
	bSLDIw0qTMe38LqbADXMLKXTO3J9Ybt8mJOx08vBZdTtwMTYfzZ9lqMtGIHCXEVQa7G9N8bLeMw
	C+/B+m0I/C0vp9OgGDpW0K36iKGvip4ktYelRN0m3P/J9JqM6P5yQuwuKAh1wAuNo0fIkbpj+96
	OQfrYXuBsAP+fRDVuqQN5uvrbK/Y+fRBkxI=
X-Google-Smtp-Source: AGHT+IGIwA9pfPWI+LoSt3sUUYUIbaG/utGvbKr1DJcThvB+Awx9206f0Vdd29j4WIOnWG/2f5prhQ==
X-Received: by 2002:a05:6a21:99a1:b0:1e0:d848:9e8f with SMTP id adf61e73a8af0-1e88d18c5a5mr24498007637.13.1736603876254;
        Sat, 11 Jan 2025 05:57:56 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4c:d5a0:2eb1:5d8b:e496:9cbc? ([2001:ee0:4f4c:d5a0:2eb1:5d8b:e496:9cbc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a319857ae70sm4304205a12.45.2025.01.11.05.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 05:57:55 -0800 (PST)
Message-ID: <524e9337-47af-4433-979d-b02788d41ca6@gmail.com>
Date: Sat, 11 Jan 2025 20:57:52 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: annotate sqd->thread access with data race in
 cancel path
To: Pavel Begunkov <asml.silence@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250111105920.38083-1-minhquangbui99@gmail.com>
 <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/11/25 19:02, Pavel Begunkov wrote:
> On 1/11/25 10:59, Bui Quang Minh wrote:
>> The sqd->thread access in io_uring_cancel_generic is just for debug check
>> so we can safely ignore the data race.
>>
>> The sqd->thread access in io_uring_try_cancel_requests is to check if the
>> caller is the sq threadi with the check ctx->sq_data->thread == 
>> current. In
>> case this is called in a task other than the sq thread, we expect the
>> expression to be false. And in that case, the sq_data->thread read can 
>> race
>> with the NULL write in the sq thread termination. However, the race will
>> still make ctx->sq_data->thread == current be false, so we can safely
>> ignore the data race.
>>
>> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
>> Reported-by: Li Zetao <lizetao1@huawei.com>
>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>> ---
>>   io_uring/io_uring.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ff691f37462c..b1a116620ae1 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3094,9 +3094,18 @@ static __cold bool 
>> io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>           ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
>>       }
>> -    /* SQPOLL thread does its own polling */
>> +    /*
>> +     * SQPOLL thread does its own polling
>> +     *
>> +     * We expect ctx->sq_data->thread == current to be false when
>> +     * this function is called on a task other than the sq thread.
>> +     * In that case, the sq_data->thread read can race with the
>> +     * NULL write in the sq thread termination. However, the race
>> +     * will still make ctx->sq_data->thread == current be false,
>> +     * so we can safely ignore the data race here.
>> +     */
>>       if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>> -        (ctx->sq_data && ctx->sq_data->thread == current)) {
>> +        (ctx->sq_data && data_race(ctx->sq_data->thread) == current)) {
>>           while (!wq_list_empty(&ctx->iopoll_list)) {
>>               io_iopoll_try_reap_events(ctx);
>>               ret = true;
> 
> data_race() is a hammer we don't want to use to just silence warnings,
> it can hide real problems. The fact that it needs 6 lines of comments
> to explain is also not a good sign.
> 
> Instead, you can pass a flag, i.e. io_uring_cancel_generic() will have
> non zero sqd IFF it's the SQPOLL task.

At first, I think of using READ_ONCE here and WRITE_ONCE in the sq 
thread termination to avoid the data race. What do you think about this 
approach?

Your proposed approach sounds good too.

>> @@ -3142,7 +3151,7 @@ __cold void io_uring_cancel_generic(bool 
>> cancel_all, struct io_sq_data *sqd)
>>       s64 inflight;
>>       DEFINE_WAIT(wait);
>> -    WARN_ON_ONCE(sqd && sqd->thread != current);
> 
> It's not racing if it's the same thread, if it's not it'll trigger
> the warning anyway, I don't think we care about this one.
> 
>> +    WARN_ON_ONCE(sqd && data_race(sqd->thread) != current);
>>       if (!current->io_uring)
>>           return;

Oh, thanks. I will remove this.

Thanks,
Quang Minh.


