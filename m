Return-Path: <io-uring+bounces-9460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC28AB3BC65
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792423A3C44
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 13:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D8BEEDE;
	Fri, 29 Aug 2025 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuLQ56t9"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52E3043D0
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756473731; cv=none; b=XIn6VXRCl3wtTKK0DYLkKccyxJrQJfjyE3tpe20fjhh5aSYWii0DZ2jjBbSydjJjv88McM1xbxoryRl2Mw7m8r1qIWjKYBfEWotq86WafDngXpfx+YwdFr1JaadZfTsuJvbq3w4m+tJUS1yEbG8kaLik77/XGiAqr8N4PNYHig0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756473731; c=relaxed/simple;
	bh=N+5WFIKkpSCBHcdEkYaqeEr5+8bOiQ8nFMzvcD9Vf3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evyNkx6p3rq+jZYo3njGibycwYtXiUZXeEL2sqgymh2/IAILFsWJnBIO8nzbHCgYfm41v7Ic57xymZXCa2TZeazstzCQbKZli9Lr8em6V9ghJmDYAQ/K+6aIwOFftIZP0axYbwlfKzCMrrdDtSicnS50K9PuJZXP5z0+pwRCD40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuLQ56t9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756473728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aggFKTWIoz3JmsTS53UGUQwfpKwPCT7EHzMCjR4W6Kc=;
	b=UuLQ56t9K9ET2MmcIeYyIW1ZImATJoQ1k+kHzh2cIgfahSMGcQJjlkQ3xqVpnEUZ0FSx2b
	nMhJA3udtBaLTI2Sl89GB/+7soNOGPCYd0PMY1h1kprbkvVlwP2+SUEjHdz65j9Rr9kMQp
	xRwI+bEvrE7xl8Jqfcsf9SsX5eHNwKg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-KnzjlyZ7MfayR2RiFRF9Hg-1; Fri, 29 Aug 2025 09:22:06 -0400
X-MC-Unique: KnzjlyZ7MfayR2RiFRF9Hg-1
X-Mimecast-MFC-AGG-ID: KnzjlyZ7MfayR2RiFRF9Hg_1756473725
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cf12498799so601741f8f.2
        for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 06:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756473725; x=1757078525;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aggFKTWIoz3JmsTS53UGUQwfpKwPCT7EHzMCjR4W6Kc=;
        b=ULkAZ3UJkEzEUeVmNV7HA7okPCPIGqHDBQgPiYFAEwaUS5Z9Qy82PRLcrynb3FU6lm
         dLfcaaVGKch23Lq2d/h/82A+5T0Xu74rq9I411i6QjVP1U17AHvD7aOgdsKvaYSYNYUv
         EjtS1YcvBFVstdthyQ035tG+ibrAQUwwtRozEyTAcXPL7OEPmjZCfd0eDoYSmASpEcLY
         ixfxjxxAuwqdrbTB73CoO/uPM7kk5b2+CwJzkdikT+OMNHDPE7BSzd5f8sjxhenRwTf5
         TPRXs6HKOfEoxU8qIPNrPi9r2Ljrg2mh8v/FERUVtRxVeMsvXuZ/OicgoUJjFw2zi4nX
         pF/w==
X-Forwarded-Encrypted: i=1; AJvYcCXa7Yv/QiqhImDoiXVTanYQqZLNpUlALK1AUevLhSs1IfxzGVmUp+bL1GrbXC/Y+h7XIndTFDF5pA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRYyorAkrAfClHkcG4hbh/UZ5PlhbMu0HaU2QHso4Lx6+SvBNW
	s9pXZkAld2urhgNUFnScV57p/dcI5JPoyOi/3vJS30SOI7mI9JfQEa61XHDOo82cfRfTsZWGKkF
	6tNuCzJrEayBYBtJaWuPJzXLwLyhaqufeHYL81fSPJiy+GcgCz+WzKwRTjVAtTnGzORF7
X-Gm-Gg: ASbGncurSzZ+wTBISRtp34JPRJsf8vfMqEgcpDfwq5HTdgx0JMX6KaVTxWg6qlWvVlX
	MSmUZEjBNVPOOyMGKCrxYgzXfE6NouxvHJExes/PSB2ctgKrlZlys9ZiYyIdJVLYdfDzmqBUxnj
	aHCT7/UeaQguEm2zmPSEnj8737m+cYkrRU3o0FxnIg/0bCAojdjwaU81zDk/cRDlVQOTz747TiU
	IV1K0FM3wpX9h47RhhYuaQ+tYOj1AiSUY20tfEEc/RxLbyQ6vX1246PU1ACpBLqj0vuCU2nf30+
	1VgBaLt6pOLfr76/WM+H/A0SGvcRgs3TwbOuSane0A1BBGh7Hy2fb+y7oCXYxjvBz6kJM3+oP4v
	yHJ6RUXqjLsPFCFtCpfD2jftb1sg0p2zeVOfiH4huj7qal/cVzs87SRCUOE/HJ8BN
X-Received: by 2002:a05:6000:2c0f:b0:3ca:a190:c473 with SMTP id ffacd0b85a97d-3caa190c6ecmr9849827f8f.4.1756473725388;
        Fri, 29 Aug 2025 06:22:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFfrTd/+15/bT4PGZswHLcvGvODyGQLUC+I3pIFqxdvqjEg2cDf44HeYcneQKTQcaMEr0KOA==
X-Received: by 2002:a05:6000:2c0f:b0:3ca:a190:c473 with SMTP id ffacd0b85a97d-3caa190c6ecmr9849784f8f.4.1756473724881;
        Fri, 29 Aug 2025 06:22:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add483sm3368560f8f.37.2025.08.29.06.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:22:04 -0700 (PDT)
Message-ID: <f7f9f535-0bbe-413a-84e4-fcb17a502a40@redhat.com>
Date: Fri, 29 Aug 2025 15:22:01 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 16/36] fs: hugetlbfs: cleanup folio in
 adjust_range_hwpoison()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-17-david@redhat.com>
 <71cf3600-d9cf-4d16-951c-44582b46c0fa@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <71cf3600-d9cf-4d16-951c-44582b46c0fa@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> 
> Lord above.
> 
> Also semantics of 'if bytes == 0, then check first page anyway' which you do
> capture.

Yeah, I think bytes == 0 would not make any sense, though. Staring 
briefly at the single caller, that seems to be the case (bytes != 0).

> 
> OK think I have convinced myself this is right, so hopefully no deeply subtle
> off-by-one issues here :P
> 
> Anyway, LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   fs/hugetlbfs/inode.c | 33 +++++++++++----------------------
>>   1 file changed, 11 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index c5a46d10afaa0..6ca1f6b45c1e5 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -198,31 +198,20 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>>   static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>>   		size_t bytes)
>>   {
>> -	struct page *page;
>> -	size_t n = 0;
>> -	size_t res = 0;
>> -
>> -	/* First page to start the loop. */
>> -	page = folio_page(folio, offset / PAGE_SIZE);
>> -	offset %= PAGE_SIZE;
>> -	while (1) {
>> -		if (is_raw_hwpoison_page_in_hugepage(page))
>> -			break;
>> +	struct page *page = folio_page(folio, offset / PAGE_SIZE);
>> +	size_t safe_bytes;
>> +
>> +	if (is_raw_hwpoison_page_in_hugepage(page))
>> +		return 0;
>> +	/* Safe to read the remaining bytes in this page. */
>> +	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
>> +	page++;
>>
>> -		/* Safe to read n bytes without touching HWPOISON subpage. */
>> -		n = min(bytes, (size_t)PAGE_SIZE - offset);
>> -		res += n;
>> -		bytes -= n;
>> -		if (!bytes || !n)
>> +	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
> 
> OK this is quite subtle - so if safe_bytes == bytes, this means we've confirmed
> that all requested bytes are safe.
> 
> So offset=0, bytes = 4096 would fail this (as safe_bytes == 4096).
> 
> Maybe worth putting something like:
> 
> 	/*
> 	 * Now we check page-by-page in the folio to see if any bytes we don't
> 	 * yet know to be safe are contained within posioned pages or not.
> 	 */
> 
> Above the loop. Or something like this.

"Check each remaining page as long as we are not done yet."

> 
>> +		if (is_raw_hwpoison_page_in_hugepage(page))
>>   			break;
>> -		offset += n;
>> -		if (offset == PAGE_SIZE) {
>> -			page++;
>> -			offset = 0;
>> -		}
>> -	}
>>
>> -	return res;
>> +	return min(safe_bytes, bytes);
> 
> Yeah given above analysis this seems correct.
> 
> You must have torn your hair out over this :)

I could resist the urge to clean that up, yes.

I'll also drop the "The implementation borrows the iteration logic from 
copy_page_to_iter*." part, because I suspect this comment no longer 
makes sense.

Thanks!

-- 
Cheers

David / dhildenb


