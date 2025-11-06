Return-Path: <io-uring+bounces-10400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7A7C3ADB6
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 13:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6C916502ED5
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 12:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFA131A55E;
	Thu,  6 Nov 2025 12:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8YaNfcT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5380530DEA0
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430987; cv=none; b=C+dqiJqT5kKaVgoLc7vHNo6eWzCUTqeEtWQgkaInQYbXi/tOYUp/D+N/nfIXfmg3tO7nYNhfWzcqkfmew0+IQdGdjEwcaLzmPUNvrk9JekPBYwNYs259qIwYzrbDKmnPedQ1YV2NB/ChLoXObtKfoMxBGkDrIBLhzqxh6VK0nvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430987; c=relaxed/simple;
	bh=pvsjETcTtpOJ9bFmdX7YtgPmlVAKmV2NyB/eL3QwTAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yn30z/62KPpjZy/gpOIKYo/OjUlES1bGEB7nBJencWVn2BbY9VjfQZIokvJjAb9DdLP2GLkCVgmLZiLaTBLS5NVf7wGjQmYvh8/9hgz9dQOa5usrD04Z/JoiFmCpMZyvzGN8U2FisOXaqi5SozM2bQkdWI+wIUvcXgG4ZmNl3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8YaNfcT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4711b95226dso10512955e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 04:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762430983; x=1763035783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dH9j70rFd6vTnSTxOKk3ilrxWNeLASxFU+JmRzhJ5bs=;
        b=M8YaNfcTSYV5ISt5VSEDVQcd26FoOgU5ofBJ95fe6ZOlrDnXOgyLvSRqoho2Qlha00
         1m6E0SEDPIAR8LvZsEjHL96iHrOUSjNiMoGKfZcAqZQnsDQWcwSl87Wn8I3QIAXXI+69
         UpMKbAtemGYI0/SN8NogQgLsa79yNEIjDGx+b08BDilmaBqY6aWpQD2IxtkSZctkJ34C
         Zkm1i6pLJ4eMpHvZaCR5pQkWiRYYAsspg/1GQNL8CiBInwK9Cx3u4wm49KDP3tdY2WDQ
         4xNnaE1/rWbu54AJrTwraEgNm9/uH9e/7VtdaGNegNqLaPAxDBG4smD+G+butoF9m0ja
         N4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762430983; x=1763035783;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dH9j70rFd6vTnSTxOKk3ilrxWNeLASxFU+JmRzhJ5bs=;
        b=NuWajcvgsrGArfQJbljou7KYW58/YiJSdTh6AB1ZJxa/qbtaBguLJt3SCXfoPQuMzC
         ODmB2N0RGFAsE4b30ZS7sDJ104e3NDUBXTDNw0BoEwZMpclQY1ZLDHA3z04yeBYDvrRg
         oK694MVaB0evG2mK5mV5lg+iRwA8W0cQektk9/ihWxqM0hSpc+u00DP7U5/grzcmtxrX
         Yf+PCkC3bqFMcyEEc5XqH2jwyLVXjL8y9uMkVMyDhP7cDK029V4KrUxX6/24h6KeIVZw
         I82R2tIdftE9pED1gewW4+eh0/blYgsKUQiMTNrMZeVi+LjtXfxF6QWmTOk5RHFqcXIS
         F49g==
X-Forwarded-Encrypted: i=1; AJvYcCWWeSBt8GSMh/tpZX6TVZ9G1ENSnC8grDTArhnqFqMwUZUcerNEEVjX6jDO7Q3VF8huQVKhyWFtvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzeyrzJ42pbxo2/P2rFv1Dk6HelQnYVgmvkYZ6k0XHPz2/lSJZK
	yVGyh2zth1vSyg6PNu2xAbqe40div0s2JfIW0wNEcpfp1DiMVn2kKXzBN/Wu0w==
X-Gm-Gg: ASbGncsXMZDhlqg92YMUkKwvZ5juZNEc6DmTgoN+Rwp3XriDpJl4V3NxgXBinc8HDp2
	IuCxozL3VzFl5bERElDR74aLEOmdZt1OeZa7mF1fyjR8vcKjZXD2uBRkAQEDJn738A0ABF+Ln7U
	vkC+G8Rf+IudMZwy77jug7/GcseuVGdT2YCX305jJTAfIWa1ngbOA6dw/W8HpMdcdodMngePWWn
	KqW585/V5sDTMi8XwwsmjsqnFTo+1lrADqQ4kSA06r2TB+iTqoiBMdR9tLgbLmQ+g0IFBguVZBO
	y9EkeMJ+xe6jFATOwu6qyDZa2wCRhfwE9//X9vmZMbBpg8qFFirJTIV4ffrDB885KyDexCWLePq
	CAGMSSkevcI5MY97yLb+1M2vTgdm2szzRyBPDTzuOpZ00SkbPC1cvhM4dhVaunTZC62yoGDHH9W
	Eso44GgOZKXrmW2I+Fnyyut0qQvZSZA8Sp/oJcDnAZ/+h0mZ06YJU=
X-Google-Smtp-Source: AGHT+IFpPEPwfPjq/YSu+uWVQPmluwp+P/y5X4sK+g60ZdVxjmDcd/CQVrht39UkJ74vmT9GV7lXxQ==
X-Received: by 2002:a05:600c:828a:b0:477:e66:4077 with SMTP id 5b1f17b1804b1-4775ce2bceamr61127825e9.29.1762430983451;
        Thu, 06 Nov 2025 04:09:43 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477626eb4fdsm43868885e9.17.2025.11.06.04.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 04:09:42 -0800 (PST)
Message-ID: <5db63478-cd4f-4a6c-a694-3c39a5f38571@gmail.com>
Date: Thu, 6 Nov 2025 12:09:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-6.18 1/1] io_uring: fix types for region size
 calulation
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
 <43429045-4443-4e5c-a892-4265de2cd026@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <43429045-4443-4e5c-a892-4265de2cd026@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/25 18:44, Jens Axboe wrote:
> On 11/5/25 8:47 AM, Pavel Begunkov wrote:
>> ->nr_pages is int, it needs type extension before calculating the region
>> size.
>>
>> Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/memmap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
>> index 2e99dffddfc5..fab79c7b3157 100644
>> --- a/io_uring/memmap.c
>> +++ b/io_uring/memmap.c
>> @@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
>>   				struct io_mapped_region *mr,
>>   				struct io_uring_region_desc *reg)
>>   {
>> -	unsigned long size = mr->nr_pages << PAGE_SHIFT;
>> +	unsigned long size = (size_t)mr->nr_pages << PAGE_SHIFT;
>>   	struct page **pages;
>>   	int nr_pages;
> 
> Should probably consistently use a size_t, everywhere else does. Doesn't
> matter here as io_pin_pages() does the right thing anyway.

I have a patch on the topic as I needed it myself, but didn't
include it into the fix.

-- 
Pavel Begunkov


