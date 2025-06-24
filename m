Return-Path: <io-uring+bounces-8469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E80EBAE64ED
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BCBB3A3915
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D7C28136F;
	Tue, 24 Jun 2025 12:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+/3M0nr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE527C16A
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768010; cv=none; b=eBawlOtG/o8RULzGAvd0GYFIeUJ7kJ677R/h6gkcP0xLm3zw/gjVqFnh2R0nHJFTABqJvV+9SfquipLuwe9ikM0u1Hj2TmOkTDODKCBhm3N1cNbh0EfDGPWoS8AnLEy52k/y3DKkZ0VgpfS6sfcOMifEXGmbmLeP+olyyUyZivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768010; c=relaxed/simple;
	bh=+m1ocy0+fonIKAt7/QjUY4ShDJnsXvacOZcTOUbAahA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PIlcekdAzQZhACpF/HEZws8i53DXWlH70PGz+JMhbHSvzCBz8vqxB0kqIelAeJWSGskhYdqm/5AL5bCiXp4xFQb7R9vvtTEJSFBGlkyj11hdfa5hQR2H4GukKUge7YIdw3x0VPCLYt7uSwh/w7Syi0w3gZ0V2H/Rc6FhR2aC7+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+/3M0nr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750768007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nvDMoHVJ1hqXjqKhdUPhhGg1FLrWlFkbxqYsHKXa0iw=;
	b=S+/3M0nrCqwvj9O/Tspe9ip3WqkopvChTFB2BDDQ5mWCxs9L1zLsFIdxB1aASISzUb9DHA
	YImJBqzrZ883utMnQKRdP/IP7ZyuGwQvK+fLaNFENKMBe889y2rSxVi/8itqRgBV203iom
	dM1nLIMBzg2zQk1ORr9uq1D8VIZwgoo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-2nqeFjKsO7OlXXdh-snv7A-1; Tue, 24 Jun 2025 08:26:46 -0400
X-MC-Unique: 2nqeFjKsO7OlXXdh-snv7A-1
X-Mimecast-MFC-AGG-ID: 2nqeFjKsO7OlXXdh-snv7A_1750768005
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a6df0c67a6so1837190f8f.3
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750768005; x=1751372805;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvDMoHVJ1hqXjqKhdUPhhGg1FLrWlFkbxqYsHKXa0iw=;
        b=F0kzJUme6u2yiHjmkWBG6zMUR3VZHJCrV3WbNGoBPMMOtuMOprNkt3esQNKrF8+bJl
         Qe6me5dDcL8vBFTTeJxDeZh78wWkfhSXx7G8OWqVDW0oPNYGGGXRUVUCNbV1mrcWqnpj
         Q8Cq+wQJauwB4r9+W/TDBZYBnz0SLwsEKykR5kmBUK0TuWtvFXUfUPn2Hy8ueeoFgHJI
         3WDuKKa4/hF6q6rxEH9EAS0bQKEJID0vFt36ZtAGBdf1C7ZrpAI4wkFi/B4k66/MqDlr
         gJA4Kf3J2GMjiab0D0TxDL1p39zu7W790qnY/4yVPKSTu1x3uK+iHY8Zk/5tXqgcvD9t
         gFJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc6RoO6X8/jGj79oOd0e6N0FpZ05v81chE2dyM6Y6PjzDzWlbZ2fQm51sLFkv2E7bTRcY8g1nNjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxE1Son2h7sQn4zXg+Wo5+HvO/UjAiWasTLvDH8LLyGN3Fm7S5t
	9WpzZMGs97nmAxjOs9Y4COE89jGGlXtDXW1f1eFNHtxOF03A524fXJezAjXR8mjbH74DXozs830
	gqrgZ7ukEd3zMAJs5MeuuW24ituCkQiEwNLWe9ebkr039qs82ULAtutvrjv9h
X-Gm-Gg: ASbGncvwQsazDymrapaRjaXRAv4JpB4A2zwYQ2ID9BljtIcq7sPz90w+tVm9LMhiojI
	n3yPCY1q6SLGd4aLcwwa7dH48oCcfUZ2mj9MgWOaPDRsIuTek3U+CQuJIl9lbEdUuOGdDspkK6i
	0aPkF0+xU0R8ry6vePiSuTfOfDAaPECuDeCpX18YrlGz1YACHWe93zeV1lNVMxs2RilxczboQW7
	Yc57B14kCFQ5XoUA4zx0M/o2KM/AFPdv32NSuEz3IZsZePLlnlYu1pDFji+ZUK7Kejg0wn/SAdg
	gYXTNDIk34iE0Q2UWNTOfdGZOcfNCrv6UPMJqIqkjuVOlsCW+umOODs=
X-Received: by 2002:adf:9cc2:0:b0:3a4:f379:65bc with SMTP id ffacd0b85a97d-3a6d131dd70mr12616734f8f.40.1750768005205;
        Tue, 24 Jun 2025 05:26:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJroB8JIBmvEQVmFTIoXFzZpXaM3rdqx39HbBNTyiBj9nzTfqnzD3CXNMl4GLMIG3RqxjFyQ==
X-Received: by 2002:adf:9cc2:0:b0:3a4:f379:65bc with SMTP id ffacd0b85a97d-3a6d131dd70mr12616713f8f.40.1750768004819;
        Tue, 24 Jun 2025 05:26:44 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eada7adsm177026595e9.35.2025.06.24.05.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:26:44 -0700 (PDT)
Message-ID: <15ea7028-a5f5-4428-b604-b331cf681be3@redhat.com>
Date: Tue, 24 Jun 2025 14:26:43 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
 <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
 <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5dcd8826-697b-46c8-a4e7-d1b9802092e8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.06.25 14:20, Pavel Begunkov wrote:
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
>>>    io_uring/rsrc.c | 8 +++++++-
>>>    io_uring/rsrc.h | 1 +
>>>    2 files changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index e83a294c718b..5132f8df600f 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>>>        data->nr_pages_mid = folio_nr_pages(folio);
>>>        data->folio_shift = folio_shift(folio);
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
> 	return false;

Ah okay, that makes sense.

It might be clearer at some point to coalesce folio ranges (e.g., 
folio,idx,len) instead, representing them in a different temporary 
structure.

-- 
Cheers,

David / dhildenb


