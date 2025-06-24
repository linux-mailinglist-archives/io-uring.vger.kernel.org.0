Return-Path: <io-uring+bounces-8470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D192AE64E4
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6592166D42
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0FA28D8F8;
	Tue, 24 Jun 2025 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ep6u1FuT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060CF28F51D
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768141; cv=none; b=o5/nEIOG7chlyAt/0aMtu+UUdobfP6pNjHfc1Y50vxHcy5B4aManygV+EZHkfAlJi+pLUwMNCI680csitWmoEIL8l9lV++lYg3ojFXD6oUiJVWlpYnKZQTvrCczPJEQcJs4JGDxOdqhmOyDuDHKLOkJehTAP6F93LEaPuptnQUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768141; c=relaxed/simple;
	bh=UNwivPyN8svHmonSVNqix6xmk9LDxiRA+DuPqPy3tsU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=s03BtN4/FMq33Cg6I6nyjjkK5ujdSuTVpxjV0zXcWrP3Q53B6fSqUIfHU4wY5v17wTuWOC+LpDmE2j3QfE25yImDTezHvAOGC5M7wtgnM7iH9SGmQi69Mu0Z8qcevNoyvMwtxum4reE/5uqIQdx4j2+MwbfjUY3kvfqxDWbd0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ep6u1FuT; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad1b94382b8so75588766b.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750768138; x=1751372938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbSORQ1gYcSwAut3PbCJ8QkXJFw/G1YqxLbvSrQj1cE=;
        b=Ep6u1FuTg1rbnmI/uNBhTGhP1BxQVeGeU1vOwm2ZGPeFEnaU4Xj7goLWuYQA2OfWO8
         NjVBJk10Xecjial8mfGzXWJeWLDdkL+GHpb/+xTFm+L7K4GhcnzjRgSqnozoJ5Ars2fY
         IXuIJNAE8nWHdpfcgzJpj5dbkICjm/lZFDnh+MwMetZK3zG63Mj+cnfo845OzMEnnLdP
         KgIWPQXxMnxC3/MVE+LE5u5ZssJZPPeN8ovdCklAJw8sW0LYiTAmEztx7PHG0ILVRDbP
         hLqB7/jyQbA5LekF+cCgQVGYj6qy/PpVJrBxl2yDkwKRaio0Klck1MKzeiFLmJX6l+/J
         IAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750768138; x=1751372938;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbSORQ1gYcSwAut3PbCJ8QkXJFw/G1YqxLbvSrQj1cE=;
        b=eQcUlmg+wiBD7l3/yie4O1eEHoeasVTqk+vWa1Y+TXskowljXC1cNi48Y5R9mv1xde
         YyqUM7uKQag31bW9712SWFSGsT90GFbVd6dZNv6APPp/p5NmkZ5vEwVJFlGfnx2Me2Xu
         Fn+eSqmgBQGwMn6j27LA9ciElJsGpGgR+uVlQJkNIto7L3nx77XYlqi/DavlDKs4F+xL
         ++OU8Zb3p2R8ayYvhwdsKAHznCzH62YAURsHvS4nSsSOmAVldWjrMBwfNPm0aROd4qUX
         nT/WDEtfvueLpG+MUzEEsBLv81H9dWReLxQWiNun9GLVHfo5Lk7x2BEQCpUuCuXMnM1s
         Sk2A==
X-Forwarded-Encrypted: i=1; AJvYcCXpU1Ri5jVG6GBbD8dsofx1f6MZc28QfafUHdJHeM42hj9BjsF5c6XwctVzmPj0W2IqwgmdzIIFcg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7gdnqkn0HzwDtv2UZiJT3xiLh52jYw0K9/eqkKzhzNFYajXpt
	yZmKzNAkX0HbZJSukKJQLBYZm5wVD9tcmyz3o1jxl5f9Xv13eZk+7d07rsmJbA==
X-Gm-Gg: ASbGncvC+5aMb6xG6dWZu5jW5kwPexeK+lAEthr1n23mbYt6PcUNiZfBxcsubUDzLEf
	rhOZxBFYyCGUsTwyjJVMys4JzfkhVsWDacvuI2OITFMabPAmaTjgmmgiViNwYp0L9ktdPsi6mwd
	VjD/CnesU/obCyeTo+GoR7ahFkspzkewuMCvmmJHL4DmLu5h6wGb/TP0Ie6tDbutNvG3yVaC4Mq
	az+T59ppgakK/Y+dL0v0E6p4XLXiaxMDnAuTXaWQnV5+TOyG61M6X7F2PBYHEzQ3HFQDuNXFmYF
	QcaYzPzOjDHc5XBwJLEWrGiqbThST68nLXe6HjSj9DDU0+ovna2xet04p3jNj4xYmeMY4Kswg5E
	=
X-Google-Smtp-Source: AGHT+IFNZeOJdhVpdFoVNACvqlaM0/xqxNcGwCQV4LSRkBAE0Zfp7tNGtsYE7OI/yZ4Hv/PcanGKTA==
X-Received: by 2002:a17:906:c142:b0:ade:9fb:b07d with SMTP id a640c23a62f3a-ae057937c50mr1656866366b.4.1750768137926;
        Tue, 24 Jun 2025 05:28:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053ecbee6sm887216166b.52.2025.06.24.05.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:28:57 -0700 (PDT)
Message-ID: <3e57a86c-ff92-4ae9-a0b8-9205545248e2@gmail.com>
Date: Tue, 24 Jun 2025 13:30:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
From: Pavel Begunkov <asml.silence@gmail.com>
To: David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
 <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
 <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
Content-Language: en-US
In-Reply-To: <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/25 13:20, Pavel Begunkov wrote:
> On 6/24/25 12:53, David Hildenbrand wrote:
>> On 24.06.25 12:35, Pavel Begunkov wrote:
>>> There is no guaranteed alignment for user pointers, however the
>>> calculation of an offset of the first page into a folio after
>>> coalescing uses some weird bit mask logic, get rid of it.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: David Hildenbrand <david@redhat.com>
>>> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/rsrc.c | 8 +++++++-
>>>   io_uring/rsrc.h | 1 +
>>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index e83a294c718b..5132f8df600f 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>>>       data->nr_pages_mid = folio_nr_pages(folio);
>>>       data->folio_shift = folio_shift(folio);
>>> +    data->first_page_offset = page_array[0] - compound_head(page_array[0]);
>>> +    data->first_page_offset <<= PAGE_SHIFT;
>>
>> Would that also cover when we have something like
>>
>> nr_pages = 4
>> pages[0] = folio_page(folio, 1);
>> pages[1] = folio_page(folio, 2);
>> pages[2] = folio_page(folio2, 1);
>> pages[3] = folio_page(folio2, 2);
>>
>> Note that we can create all kinds of crazy partially-mapped THP layouts using VMAs.
> 
> It'll see that pages[2] is not the first page of folio2
> and return that it can't be coalesced
> 
> if (/* ... */ || folio_page_idx(folio, page_array[i]) != 0)
>      return false;

To elaborate, we're only coalescing if for all but the first resulting
bvec segment starts from the beginning of its folio, and all but the
last bvec segment ends at the right border of the folio. IOW, all
middle bvecs should fully cover their folios, and the first and the
last bvecs should align by the right and left borders of their folios
correspondingly.

-- 
Pavel Begunkov


