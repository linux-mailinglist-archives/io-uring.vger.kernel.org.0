Return-Path: <io-uring+bounces-8189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B302ACB7D4
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 17:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BF9C7AFD75
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0AC184E;
	Mon,  2 Jun 2025 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kbFJcg9O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C78523A
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748878219; cv=none; b=KtjSLRnWRr3YZQ/LkbfzDSy7ZkgNrWRGUH0IpswC2MK7uF7H42BtJDBGUywNgLHtCxwnlxaZNlGyBKoJl4yyvYzrje8nwPZhf5nyLUUFpdd3p33y3zwi+MPtkWe3+e75z74wXR1Gsp5ngmu+oVwoZhTdI2+Y3pkWPcNjceyXbkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748878219; c=relaxed/simple;
	bh=fWR4ruOL3XDlxkWhAO4QkOj3Ysf9l6+d0uCsZgIr2/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NftkULhYLrWqUTrbKPxi3OxjjLOT+EDE8ogROaT334NcLLDq1LAih8L/N0Nhz5NAcc9D1A0T9MjkP4g9LldM1Co8DKp4KOYQiyVjO2coNHb/MWSOjsw9LEV3h0MPvjC864SxuyRxc+sNCE2YVrI7p0+2kA26Xq0DHak/b0JRz3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kbFJcg9O; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-adb2e9fd208so732151266b.3
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 08:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748878215; x=1749483015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qoia2i/FS4RZ5kxgd4aA43JM9rsjIhUYj2NbImBQLEg=;
        b=kbFJcg9OYse1Y+uxNCRrAMIrPGVC+Xi3nd7WbvLWiWvdNUVkRk1Mt/ufBRrFDzGDwF
         PguKzFpyLmPoQcAI/2p8wgHyma28bSof/VNqF4aaBdMBRro7RGp6rJp8QsoTmkVa5z85
         gHHrwaDb6K4FQ9KuzaUK8ZHBZLK7W4YxAXNxB8eyB2emltflRk7s7uq2ytFvZ3gg34It
         ekPN/NrKcs4fBF3pkukEv4VEK2LG8hFIoQVQXlHCUgRsBb0MTRymlHSuq1fR9KcwVdZX
         bzpIM5y4rGX4qxbJKIIaMCO2ocYGMlro5pOEHfM2QlOa3rV4LISXxDJxB+nqzc/oAWOb
         oIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748878215; x=1749483015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qoia2i/FS4RZ5kxgd4aA43JM9rsjIhUYj2NbImBQLEg=;
        b=E23cD4u+JU+r7n97CmhEreIkcQZWirnd3MW+MVwmAzvH4GGk4BzknppKol2FuIeiKw
         9JvdVohgZ97dhyaVQQA/i5lxcTmcme1UuXnI/VLqhY4GBgwVAaqx1DvNYsQdYLtSrvV2
         cTF2Jl9I8GOuoAjY0xBvfjVJyBHs/R/wTE/Z6FHB/TwH3YqGd7uaKUlenljgUUhyI6cH
         eLZjVqME8Sw1Xclz6DVRpyfHh1JH6YThiotS3KrWkqy4BDlHMyqmesTFIAaZJQskAR5M
         b0Fut8NFlfEO11TpYWJTqjt0HoL1SC/dHRJZadcOB+WrssBta9OMipvbi3sjBKobeMJr
         A94w==
X-Forwarded-Encrypted: i=1; AJvYcCX8xv8SI+jwxGMoM7lJSQOFy/4xf2nosiIyuFwimMK1YuhXyNQnQXz250xI8qdWyidYF4VWNpReYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRtywYdJp6I3NZ4zIZI5Z8NTAriKLpsCBdHb5lDNLzlCD5jUSY
	msU+8rCChTSFTyUMWFuvzK4JxuDFRjdlG0HDlEqhMDK4yJNCb+weQBqLcxIJXA==
X-Gm-Gg: ASbGnctId/LXB5R5FDJki0r01IUQABHyGETVrW037bPGatorKpAW+07dOPHALQZzjJP
	OurC7THXrf5wedowkyH9Z7wp8jPVTaSjU0RA5LoF6T2wvDH+NYy+z+spTDsWaV1DKvJ9IQwOVYi
	ecz0aZjcS6x0d2/Ez75o6oQrray8XqZvIka8Qp3NG/Tdc7VDM0ZOv+a7dcFYojalYRlQwT35tul
	r1TkUQa/N6//QeOIJf4/x02MT9lhdqegztwMiPy80zB5byTPalWCZZCkr3pB3k22XLY6shisNou
	Vvv1KbnBZhT7SbCcm2xsv6pHFfnkzSH+DXumEdaofLimnYL5Fzg8tmgSFjO5ZPiH
X-Google-Smtp-Source: AGHT+IHiZklnVt8jsSI+5U0/BAiLrPH1EnHsxXnuVf/dTuaxiJNdj8PjXCJazy1yK1M7+rw0UlIALw==
X-Received: by 2002:a17:906:6a0a:b0:ad5:3a97:8438 with SMTP id a640c23a62f3a-adb3242e81fmr1349776066b.41.1748878214536;
        Mon, 02 Jun 2025 08:30:14 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:8317])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad3ab58sm809057066b.157.2025.06.02.08.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 08:30:13 -0700 (PDT)
Message-ID: <e0e4562a-07e2-4874-b42b-1fa48c02c38d@gmail.com>
Date: Mon, 2 Jun 2025 16:31:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
 <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
 <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
 <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
 <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
 <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
 <b601b46f-d4b5-4ffc-af8a-3c2e58cdd62d@gmail.com>
 <44e37cb0-9a89-4c88-8fa1-2a51abad34f7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <44e37cb0-9a89-4c88-8fa1-2a51abad34f7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 16:19, Jens Axboe wrote:
> On 5/30/25 12:14 PM, Pavel Begunkov wrote:
>> On 5/30/25 16:30, Jens Axboe wrote:
...>>>> The same situation, it's a special TAINT_TEST, and set for a good
>>>> reason. And there is also a case of TAINT_CRAP for staging.
>>>
>>> TAINT is fine, I don't care about that. So we can certainly do that. My
>>
>> Good you changed your mind
> 
> Yes, my main objection was (and is) having nonsensical dependencies.

"I think taint (snip) is over-reaching" says otherwise. Anyway, it's
regrettable you don't take security arguments into consideration, but
that's your choice.

-- 
Pavel Begunkov


