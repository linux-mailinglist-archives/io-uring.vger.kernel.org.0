Return-Path: <io-uring+bounces-8473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A86AE658F
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107D81923989
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE1A29994C;
	Tue, 24 Jun 2025 12:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZoJ9g9y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E1F298CDD
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750769591; cv=none; b=YBdi6jZfGrLuBzA8FzmJWuOhGpyFiuoxo0HKfaeZfWh2em/D+MGKsU9yYJXebOwynr++t41QJCE4GyKiX1AZUy6wJiV9pRGCTaT9TPi1dJ+VyAg5+BTKyS6kPkas3qN7hcyNZ1h0cKyfM91eIu0IsxTeB3yAIowlmzsofWWMOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750769591; c=relaxed/simple;
	bh=OgyUjOCnBdktDm4OCZgpqriny9pkaJHxlVJ2N+D4FEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t2j+I87Edsga9aIjIuNy+eKgtMlQqJOvrmWO5Vugh3pbpVaZ6fHRaZXXPhTwjf+p/3aM6P5YgJn5M7E7HnvHCvv+wKEvD6tF2qVOr0yRCNeuS/sLGQmjnqhBO9cRG5tVo0cDFZoPL9xY0IHLqgR/ni744R0fT1dzl9AKuBwBeho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZoJ9g9y; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso9065882a12.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750769587; x=1751374387; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xCC71xZ5ASlxe+SRhgDNH4aoGiozhhqCtpA/av9u0yA=;
        b=cZoJ9g9yLuQum/jNPXK7nLOo27dmIcIFrAo/HW6y5Mrczk5uNHI2AhFMgotQexOreT
         kiejo+FQEHPkyVcxqeyZyV+TQWe9eBjXSdGcIkvGVCuW4Hfu00HafP0aHh7GomOpfYrc
         nohAzZ65NWTqUcU3qXqdN+z5/80d7VUQSQdLIlzh2EWTARXRee9atzgaBBZvydYhZCVm
         2/5CA3SC9oE/wp2u3KJ7dNcePFsEoaWOEty1YoHwzXzNcTAE2s3ggyXGHxLPhFOnsF07
         9T1Uuh24XF/ctz/Yv0dtLaniHdUzUWmpnn2E621z/Dhk2+i1nEznH4hcHv7XjRFqCDN6
         knzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750769587; x=1751374387;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCC71xZ5ASlxe+SRhgDNH4aoGiozhhqCtpA/av9u0yA=;
        b=s7KtQJeE7VgpFtPfwr7/hZxkBTItlVwrgaLrViz0pQonvjsve+0pzW5GMv495pIXRy
         o3fqidKUa3onMqIKwNZKwTYR/Bp/sxpDpipoHvjDTZrsisXrmwGg+/ejiCdqTMC14A+k
         eaozshVULQ9gjR7XBJ2oXO/GtKnqJz17NeS0r8HBEmwJyeGSYT92nk4LecxoGxObrEKV
         b6L5B0prc12vwEjRh53OypPz2teusLVVVGVIe/aULGZpJNvN6bT7DlJsXnJTMgwyascU
         NmO/mLL38ZtMeuwR0g0FkrjqcULyXhcZ7y4ezQjLLw2PtSvA+W0M49aOXg6+05yADTDu
         NTlA==
X-Forwarded-Encrypted: i=1; AJvYcCVcg8pY57MiAgljwdrV9O/2MPrfIIcacKU1EgNMmSAS5+jsbR8xa8ivEz/yvOa/YZ+2d7p5pR0/Xw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+2HcKLyLZSZKEEwccUtoNrBWOHt//OyPZ4Or9FvyVOGJfETnP
	ewEq6znjSLM3wAFSBvb+MdZzJ+vYmWEbqbdoV0nsr+Dbs2Sm8aIRVslfR2TX5g==
X-Gm-Gg: ASbGncvxVKm5EGDfddgVZjKTuvt1dWO+OM5KGkrJQaDzwcnR4b9EEO8fDNfmdXeWZi4
	ROV2BwXU/9Hfzvy83+fKrUrI9RnnEE+w4XhehQTSxQLDSjnPN27hW5Df2jypZYDrHtifebZD6Q2
	UoLqMw4vOxpg3RrlcpEVPDmnwoTenUa/93vsd8P6O36ZKq+GdVJg8BUuRcd+YxjmhcI9jRaPQem
	/CqTvlXfoLl0w6/Jv9CZtanEzIuAKgW+wkt51xgh2c9xGSe3XzoKxxR9t+VNFLncR3YK758XSXl
	6TK7l0Ig2ezhX6dhOnmwxA9B/jmed3Yc8J13KzWelxSMX0yki0S29gg6jlcO2yEgKXcN24boUQQ
	=
X-Google-Smtp-Source: AGHT+IFW5QDbPAbuViKx6X4lU6hhbNiBoNeQBZxeiEDwQM6D/9Ocm7g+LBCv9cw0+hAqIo4IFLutQg==
X-Received: by 2002:a05:6402:50d4:b0:606:ebd5:9444 with SMTP id 4fb4d7f45d1cf-60a1cd1a367mr15118886a12.2.1750769587384;
        Tue, 24 Jun 2025 05:53:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f482e8csm1018390a12.59.2025.06.24.05.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:53:06 -0700 (PDT)
Message-ID: <9646ddb1-c7c2-4ea6-8357-e9ff38209c73@gmail.com>
Date: Tue, 24 Jun 2025 13:54:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
To: David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
 <8d33d9b2-d0c5-4c71-8381-c70a0a4bb712@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8d33d9b2-d0c5-4c71-8381-c70a0a4bb712@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/25 13:42, David Hildenbrand wrote:
> On 24.06.25 12:35, Pavel Begunkov wrote:
>> There is no guaranteed alignment for user pointers, however the
>> calculation of an offset of the first page into a folio after
>> coalescing uses some weird bit mask logic, get rid of it.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: David Hildenbrand <david@redhat.com>
>> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/rsrc.c | 8 +++++++-
>>   io_uring/rsrc.h | 1 +
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index e83a294c718b..5132f8df600f 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>>       data->nr_pages_mid = folio_nr_pages(folio);
>>       data->folio_shift = folio_shift(folio);
>> +    data->first_page_offset = page_array[0] - compound_head(page_array[0]);
> 
> Note: pointer arithmetic on "struct page" does not work reliably for very large folios (eg., 1 GiB hugetlb) in all configs (!CONFIG_SPARSEMEM_VMEMMAP)
> 
> I assume this can be
> 
> data->first_page_offset = folio_page_idx(folio, page_array[0]);

Yep, already changed it in v2

...>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>> index 0d2138f16322..d823554a8817 100644
>> --- a/io_uring/rsrc.h
>> +++ b/io_uring/rsrc.h
>> @@ -49,6 +49,7 @@ struct io_imu_folio_data {
>>       unsigned int    nr_pages_mid;
>>       unsigned int    folio_shift;
>>       unsigned int    nr_folios;
>> +    unsigned long    first_page_offset;
> 
> Heh, is it actually "first_folio_offset" ?

It's an offset into the folio, or the offset of the page
in the folio, and first_folio_offset can also be interpreted
a wrong way. The usual naming problem

> Alternatively, call it "first_folio_page_idx" or sth like that and leave the shift to the user.

Let's do that

-- 
Pavel Begunkov


