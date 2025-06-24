Return-Path: <io-uring+bounces-8468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E7DAE64B9
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E4E160841
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355AB28136F;
	Tue, 24 Jun 2025 12:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTAqeC12"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64690139E
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750767565; cv=none; b=Gftyq/AGY9CEj6CJh8IEigRwc1NMCgsgYqOJ19pSgbC0i4G5bIlwhXimTAs13eRdL2zhjIYPdP4fuDBluYBFolve4ZtRqGMRY/Xo5APTvTj50NRjupZ9v1yK7rdZsWQGyISyh0Xbc3WNFEXRfyhoX2J8FKbcYZP+6rchZZ5JoXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750767565; c=relaxed/simple;
	bh=f+S8DWH2oimL9m/WpQyh9FpWlsCT7Ly2bT+7ObcUCCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F4sdyNDrIk6jrE0UEn1M59XjVb0Ib9er6vN8ztOg4DzjMPGEvDbKhDusOe9p7cdDyC90irJNTN+57tGAvUwNzXS+zX1tfX1IdPEUOs9W4M5k+hTIeVJRyur5j1yXgRGUSFjZq8W3Smox0eEd+CswfVlxK3mGkwLrkHCNe/Gvkl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTAqeC12; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ade5b8aab41so1088948866b.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750767562; x=1751372362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zebCmG5/TIuOrAqQ8iU3GTeiKOHkUxXkHzDmO1pNjG4=;
        b=UTAqeC12yiSHhcoBA6RqfTwCo/zeAoi+bMu3CXzrzsAMCr046cSPQ+/38ZX5BmjJsk
         E8QFaLbXIhWyfO0VWO8eMoEAczhQ+6pSlCkcPPQdriXZ6qU9qn39RiNJU4bW4B1jfTkI
         fLhMALotvdVxePENXFX2nVlCipVtDOfo3LGWfHzv2HNpWQpMCsDALqD9p//SP0oGilUn
         L6Opo0maclVsMutL67DUZhR4wFhDP5w63qrmPH9ZKjSojKWiYPKFl1ZD5W1d7iQQVr20
         XJuKToHwXZFXzsHl6hfn494vRXY3+gG+NSjHpeQFFNCfSkpez1vasAh7foPk2JJki4J1
         JCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750767562; x=1751372362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zebCmG5/TIuOrAqQ8iU3GTeiKOHkUxXkHzDmO1pNjG4=;
        b=TwJDvKOUSVS5Clo8hFBzA2RfKjSfPOKq6GMNi3qWSfXK89r/GYSRFPeIYh3vTO5yas
         deWnXyJEoR0u86YA1uSERus1q6tg4ycoNNJPPdY6XEuFA0QDqjONmuDbnH7Q5r9C/z8b
         nvmF10JkIlriUHHqfvQ3w38zgInoepOt9vtUroUWsPs7fopmDi9I7Saq1AuDkyYqKR+C
         ajwaIESFZRyTEjej1gFQHY1f8hPyoGFX2a/pFshKItGK6fPq161BPezm3bHL8M7p89Mq
         7YVMtdXb17vt6hOSrA29rTBrY4JfZGwrESS+rnry0T5C2cBrYqmikgCzKKuCUnrmds8D
         vQLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh1nIJgc/8FLSS7oWW879MuSBVWPERO6rH1gVWvzhGIQYpctf9KFv0YJ8d867+SUkFCPAUNZGQlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAQ4qFe4uFDa0CpCBJ6dP7KChrUnIPtDY8DuRvugaKmK0v9q5X
	6G5DL/a0ZUtJn2yuyG9jESA10R3pPz0xl43Xr3yUlTsQYL8tIoD4nPcMcC3uBg==
X-Gm-Gg: ASbGnctWVXMXhA4i0Raupn9sOXyH3x0IRK3vHi8ACFhb3CC1KCLfn6xILji/v2AqwEy
	vpsSgZq13iCOOf7c333qbA9Kwwam+efFxtzUS+Y4DMkScICZQuP4tVv4YW6L4UzjppQQBn4JaEu
	rfK1GM6eZbuJWzQrROvNd0DAtgEDX/O10GncF78Ir39zGLJyAEeWc4W3Fo1tJybpId8L01bvAT8
	HNSX/k2glIh1UoR+xMkYeA6oxaO665e94hs+b8krl6O8QikNLvv4fvQNU3Lq+MDYPiGQCNFi6FN
	JYbfrCXS7eKTWqFJX5WTDdocAdneeL/crahNgtlupy3kbhj0lD2ygSz1tU2AVXpXzouCv9I4lHE
	=
X-Google-Smtp-Source: AGHT+IFHtMwlzv4tEcZQPPPql4IroieEtG5pLqd5A4tN2V3A3hMzU++L1ws3AA92bAiuA3lcL4q2/g==
X-Received: by 2002:a17:906:6a11:b0:ade:44f8:569 with SMTP id a640c23a62f3a-ae057bc80d4mr1497933766b.42.1750767561243;
        Tue, 24 Jun 2025 05:19:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0a4da13fcsm157761666b.20.2025.06.24.05.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:19:20 -0700 (PDT)
Message-ID: <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
Date: Tue, 24 Jun 2025 13:20:46 +0100
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
 <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/25 12:53, David Hildenbrand wrote:
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
>> +    data->first_page_offset <<= PAGE_SHIFT;
> 
> Would that also cover when we have something like
> 
> nr_pages = 4
> pages[0] = folio_page(folio, 1);
> pages[1] = folio_page(folio, 2);
> pages[2] = folio_page(folio2, 1);
> pages[3] = folio_page(folio2, 2);
> 
> Note that we can create all kinds of crazy partially-mapped THP layouts using VMAs.

It'll see that pages[2] is not the first page of folio2
and return that it can't be coalesced

if (/* ... */ || folio_page_idx(folio, page_array[i]) != 0)
	return false;

-- 
Pavel Begunkov


