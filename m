Return-Path: <io-uring+bounces-9616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 159FBB46998
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 08:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FD827C6D07
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 06:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577B52C21CF;
	Sat,  6 Sep 2025 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/opAs81"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4C12797AD
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757141827; cv=none; b=F0r3JU92dN6tuRotdx3DPq/RYblrxf93mjZVmNfQt4ow38Qz/1VOhYJYBF3RMMMwZi3YU9E/Sj6HsjuN1OV3jaK/s8HQi6Tjot23qc39auIy5JfNnrCW8etQqKhJJJ/qV/llsgDAGTtJhYoEpDSZJF1bV1X28Bys5OWyaMuMMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757141827; c=relaxed/simple;
	bh=H4cboKSHmECFnU5K4/gQjk7rcYgLqRH4rpzK17nUKB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHm+7utDYns1uoXjA3iiUCGBoBknZfXvXVrauk+fIuYW8l/ggt0iP7mhFp5PIhglB49AyaxqE7ddpfZCKgQeSMEEhtd10+aMcNn6hjYvCGCS0Vbm7fsp3vdHaY4LlbHvVRSrtZ9+yDVH8gBxOgYADdYwnVG4dzV1teGMJ76ctHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/opAs81; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757141824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vne0EVwrnVHw6NJLJyd+zZpE6+oJG9x8TCUx1n8W1nw=;
	b=Q/opAs81mNvnQMj8Q4cPbz8HLZbFgJyRRrkPCnoQ3WYG7Tdm6GDgP2Ucj5Fesf/S9Cs8j4
	H6c1lyJVMIQL7Ex0FIfLaYcbht7gQkvOdPTY9JZVxWgKs0l8pZszSlzw1Ni8xzBtzdemSs
	FNqyiNQAVbKbdVyaFg6dBKzMGQvfaMk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-SXvE3KFcMPiKCwZGuj11ew-1; Sat, 06 Sep 2025 02:56:59 -0400
X-MC-Unique: SXvE3KFcMPiKCwZGuj11ew-1
X-Mimecast-MFC-AGG-ID: SXvE3KFcMPiKCwZGuj11ew_1757141819
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e26569a11aso1321742f8f.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 23:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757141819; x=1757746619;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vne0EVwrnVHw6NJLJyd+zZpE6+oJG9x8TCUx1n8W1nw=;
        b=gfHB5ZtMXkvSQL0gXXJ9pUykTv0PzXOx7Io9Zf13T50BOx+hJRyitY1mb1luecneAS
         Jqsc8HvbVqEEeuzFrMGAfom0cq90V0su1IE1R+ukN/JbAr1zCoJxor1uKhuMd0wfkmUC
         aTiBKPO05DmuX/5s6+AxRPq10fBF8twy2gDVtR+7hrFKH0cdq2zJi2qYnJkUtwnrQ4bs
         3Zy1zD004RPZKn4+FZTXoZRkpa37RwleImARzz9hp7rW3QGEaf++euvB+u0woVL6QMaC
         o2sNXmiG3HCvEDK5e58juDko2R8XQdAk0/WyV+5d0zbhlpJI0sM13PLMd0ngLeUhcq2p
         AJLg==
X-Forwarded-Encrypted: i=1; AJvYcCVrE3Es0Aq0kOJcgmCLo1bePSMxj1ps/dfGrm2hQgbu0ySoqE19Xo9CvVUpGrWDhyBZrY+rhgmJhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHyEjSEa8TSqVJMfYYqeugs9bK2FZKNsjAvHw4dBR0QxSxYEiA
	FO5yG56VRoAMbhXFj3J6f3DjuRZVtiH+ZdaAeLUJ8C4vhFSgCgBEYTbv2a8f80imYonYdQbHF5S
	r4n6kZiHwttpII38pqVXZW7XxDAi7sS0Tx7d7/9o98II3vat94KMwpDXMlQMs
X-Gm-Gg: ASbGnctO5T9aHojwHjv2cob05H40RZECyvi73svQqQJLovXOK6SaS1Bg3GRPm7emq6k
	ZLa5D9nCuSmx7UdJHZbWV7Y0ivYochb3w3rtzk6SpIQ5SGzwBsJtDU/WUIX5lXWejVQTp4HkpFq
	VMajrARJvxbSgTv3Pfa9rMuJ+jNnXDaUsDcbFBLJjza/6YyQQnDmozOIlNjOVMEJxf2GkMRwlCp
	AWn+eUaI0T1rAKm80xgsfrMuSXCUgQokURrhK6+9IopuP4V9+yWAP9pBJT17aeo3YrBm8OwxZ3H
	odcWElydJwtU5qZJ59o5JAfo4/7XhAzaXRuTklm1q2tW3dferpyNrLslUeBSudEiaq2ZJhc5pTs
	BdTNXs0+q+hnKvTUWcXmXUHIIL1fe50z6xYMHfpFGiGqv4ssO3JBEI4ogPYRqS2/Mfg8=
X-Received: by 2002:a05:6000:4406:b0:3e7:404f:6b9 with SMTP id ffacd0b85a97d-3e7404f0ad9mr25508f8f.24.1757141818663;
        Fri, 05 Sep 2025 23:56:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTOe1nfTlzU6tKtOOERnuEGL0krwza2F9vwEf5QifLuwYgeR9BVKfnULAEyM/P+fsTi5oZpw==
X-Received: by 2002:a05:6000:4406:b0:3e7:404f:6b9 with SMTP id ffacd0b85a97d-3e7404f0ad9mr25486f8f.24.1757141818148;
        Fri, 05 Sep 2025 23:56:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3df4fd372ccsm11959114f8f.32.2025.09.05.23.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 23:56:53 -0700 (PDT)
Message-ID: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Date: Sat, 6 Sep 2025 08:56:48 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.09.25 03:05, John Hubbard wrote:
> On 9/1/25 8:03 AM, David Hildenbrand wrote:
>> We can just cleanup the code by calculating the #refs earlier,
>> so we can just inline what remains of record_subpages().
>>
>> Calculate the number of references/pages ahead of times, and record them
>> only once all our tests passed.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/gup.c | 25 ++++++++-----------------
>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index c10cd969c1a3b..f0f4d1a68e094 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>>   #ifdef CONFIG_MMU
>>   
>>   #ifdef CONFIG_HAVE_GUP_FAST
>> -static int record_subpages(struct page *page, unsigned long sz,
>> -			   unsigned long addr, unsigned long end,
>> -			   struct page **pages)
>> -{
>> -	int nr;
>> -
>> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>> -		pages[nr] = page++;
>> -
>> -	return nr;
>> -}
>> -
>>   /**
>>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>    * @page:  pointer to page to be grabbed
>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>   	if (pmd_special(orig))
>>   		return 0;
>>   
>> -	page = pmd_page(orig);
>> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>> +	refs = (end - addr) >> PAGE_SHIFT;
>> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>   
>>   	folio = try_grab_folio_fast(page, refs, flags);
>>   	if (!folio)
>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>   	}
>>   
>>   	*nr += refs;
>> +	for (; refs; refs--)
>> +		*(pages++) = page++;
>>   	folio_set_referenced(folio);
>>   	return 1;
>>   }
>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>   	if (pud_special(orig))
>>   		return 0;
>>   
>> -	page = pud_page(orig);
>> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>> +	refs = (end - addr) >> PAGE_SHIFT;
>> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>   
>>   	folio = try_grab_folio_fast(page, refs, flags);
>>   	if (!folio)
>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>   	}
>>   
>>   	*nr += refs;
>> +	for (; refs; refs--)
>> +		*(pages++) = page++;
> 
> Hi David,

Hi!

> 
> Probably a similar sentiment as Lorenzo here...the above diffs make the code
> *worse* to read. In fact, I recall adding record_subpages() here long ago,
> specifically to help clarify what was going on.

Well, there is a lot I dislike about record_subpages() to go back there.
Starting with "as Willy keeps explaining, the concept of subpages do
not exist and ending with "why do we fill out the array even on failure".

:)

> 
> Now it's been returned to it's original, cryptic form.
> 

The code in the caller was so uncryptic that both me and Lorenzo missed
that magical addition. :P

> Just my take on it, for whatever that's worth. :)

As always, appreciated.

I could of course keep the simple loop in some "record_folio_pages"
function and clean up what I dislike about record_subpages().

But I much rather want the call chain to be cleaned up instead, if possible.


Roughly, what I am thinking (limiting it to pte+pmd case) about is the following:


 From d6d6d21dbf435d8030782a627175e36e6c7b2dfb Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Sat, 6 Sep 2025 08:33:42 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 79 ++++++++++++++++++++++++++------------------------------
  1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 22420f2069ee1..98907ead749c0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2845,12 +2845,11 @@ static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
   * also check pmd here to make sure pmd doesn't change (corresponds to
   * pmdp_collapse_flush() in the THP collapse code path).
   */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
  	struct dev_pagemap *pgmap = NULL;
-	int ret = 0;
+	unsigned long nr_pages = 0;
  	pte_t *ptep, *ptem;
  
  	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2908,24 +2907,20 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  		 * details.
  		 */
  		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
+			if (arch_make_folio_accessible(folio)) {
  				gup_put_folio(folio, 1, flags);
  				goto pte_unmap;
  			}
  		}
  		folio_set_referenced(folio);
-		pages[*nr] = page;
-		(*nr)++;
+		pages[nr_pages++] = page;
  	} while (ptep++, addr += PAGE_SIZE, addr != end);
  
-	ret = 1;
-
  pte_unmap:
  	if (pgmap)
  		put_dev_pagemap(pgmap);
  	pte_unmap(ptem);
-	return ret;
+	return nr_pages;
  }
  #else
  
@@ -2938,21 +2933,24 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
   * get_user_pages_fast_only implementation that can pin pages. Thus it's still
   * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
   */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
  	return 0;
  }
  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
  
-static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
+	const unsigned long nr_pages = (end - addr) >> PAGE_SHIFT;
  	struct page *page;
  	struct folio *folio;
-	int refs;
+	unsigned long i;
+
+	/* See gup_fast_pte_range() */
+	if (pmd_protnone(orig))
+		return 0;
  
  	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
  		return 0;
@@ -2960,33 +2958,30 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	if (pmd_special(orig))
  		return 0;
  
-	refs = (end - addr) >> PAGE_SHIFT;
  	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
  
-	folio = try_grab_folio_fast(page, refs, flags);
+	folio = try_grab_folio_fast(page, nr_pages, flags);
  	if (!folio)
  		return 0;
  
  	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  
  	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  
-	pages += *nr;
-	*nr += refs;
-	for (; refs; refs--)
+	for (i = 0; i < nr_pages; i++)
  		*(pages++) = page++;
  	folio_set_referenced(folio);
-	return 1;
+	return nr_pages;
  }
  
  static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
@@ -3033,11 +3028,11 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	return 1;
  }
  
-static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
-	unsigned long next;
+	unsigned long cur_nr_pages, next;
+	unsigned long nr_pages = 0;
  	pmd_t *pmdp;
  
  	pmdp = pmd_offset_lockless(pudp, pud, addr);
@@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
  
  		next = pmd_addr_end(addr, end);
  		if (!pmd_present(pmd))
-			return 0;
+			break;
  
-		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_fast_pte_range() */
-			if (pmd_protnone(pmd))
-				return 0;
+		if (unlikely(pmd_leaf(pmd)))
+			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
+		else
+			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
  
-			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
-				pages, nr))
-				return 0;
+		nr_pages += cur_nr_pages;
+		pages += cur_nr_pages;
  
-		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
-					       pages, nr))
-			return 0;
+		if (nr_pages != (next - addr) >> PAGE_SIZE)
+			break;
  	} while (pmdp++, addr = next, addr != end);
  
-	return 1;
+	return nr_pages;
  }
  
  static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
-- 
2.50.1



Oh, I might even have found a bug moving away from that questionable
"ret==1 means success" handling in gup_fast_pte_range()? Will
have to double-check, but likely the following is the right thing to do.



 From 8f48b25ef93e7ef98611fd58ec89384ad5171782 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Sat, 6 Sep 2025 08:46:45 +0200
Subject: [PATCH] mm/gup: fix handling of errors from
  arch_make_folio_accessible() in follow_page_pte()

In case we call arch_make_folio_accessible() and it fails, we would
incorrectly return a value that is "!= 0" to the caller, indicating that
we pinned all requested pages and that the caller can keep going.

follow_page_pte() is not supposed to return error values, but instead
0 on failure and 1 on success.

That is of course wrong, because the caller will just keep going pinning
more pages. If we happen to pin a page afterwards, we're in trouble,
because we essentially skipped some pages.

Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 22420f2069ee1..cff226ec0ee7d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2908,8 +2908,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  		 * details.
  		 */
  		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
+			if (arch_make_folio_accessible(folio)) {
  				gup_put_folio(folio, 1, flags);
  				goto pte_unmap;
  			}
-- 
2.50.1


-- 
Cheers

David / dhildenb


