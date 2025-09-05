Return-Path: <io-uring+bounces-9582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CD1B44E14
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 08:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC5C0A4314F
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 06:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23782C2ACE;
	Fri,  5 Sep 2025 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpW1p9MM"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F43D2C08D9
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757054493; cv=none; b=SlDXOmZTwaq6JSubdPkqNluJdJgfy2J0wzefDpnGmh1PvE4eLNyE6fUVtQVfhfSF7xF1lRsxv8/bQWyANO353a3y8UMLN0q4n8znz+9sI5mLObseVu7cd1TXAV+2PsszXhAs2gqXr6zuETc0HkUedrOi4EFz4oFzmL8WZzrQFz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757054493; c=relaxed/simple;
	bh=5PP9Qy2JI0RylA8NM1X5jhoGp1Vq+k7r7Qo0XW9WsLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1hxt39eYjUbcNyKQIlJKFMcDwAHncCQ3l3EV9fpNqQAUESomE5WT/tF2HR3+yLZEd16tI0Xn94yb5W++H1+84mf0wsrWOdW63ZyuTN4+ld9sMKRZ5dZE5I2mkyAPyyGdQozHJOHcTQlQ9yaypf/5/1ZiSboBXlmOFcxJKUSQ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpW1p9MM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757054490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oF3HN1Q6ZNxZN3c5DymWi4LgFv8yUurotu5FuTflls4=;
	b=EpW1p9MMbSDUi+SxAEcAL7HZbTLcxXjgKuaRcCee2TDI+3yZ8eGcUiDWKX1LvVr1KMVCwy
	T7qi/fNDlIqPoU6ENhlQYJskkfhBCl2fSkz8yo+wadhzWXbqUY27ziyTlMA8I3rIjIU15r
	IVbvW8HRUhpw8oXoa+xYLYjM4qDzqN4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-CzElpbwIM9qvedl9CLnRsA-1; Fri, 05 Sep 2025 02:41:29 -0400
X-MC-Unique: CzElpbwIM9qvedl9CLnRsA-1
X-Mimecast-MFC-AGG-ID: CzElpbwIM9qvedl9CLnRsA_1757054488
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so12845875e9.0
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 23:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757054488; x=1757659288;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF3HN1Q6ZNxZN3c5DymWi4LgFv8yUurotu5FuTflls4=;
        b=Ry9nJTWGBMgWJqZ+FHNjsi6e/ESrj8Ad1f5gyVRJI3xfQLOMY4vVJjSufceyluJ4G9
         9nmSxNDds5i48LkGPZeievGtSrd+c0EAF3MTCzYa7w8y8ZtetdEuXgw+Mdu9JZ97VVMF
         PmiR5iuJysw1OCsuDqMG9ZDZ6jWQU3vQOuwG5oqvddm/MyZCebh1QTJH9mIyIreCEZlt
         EWhuwebdjGb29L07n903AztUgS9EsLrhBTlODcFt3HKiQTiW9UTIfg2i0hNpsxPp8zjH
         UTDHYn53RyXBChdZXu7fxG7FnnhUrTbg8nI+p5RYYYgto84v52/oaISuVyQFQvLolwtQ
         pGSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJDLtwWlZRq0Cck16FQ5017nT5hi20AWx0jR0qE2/Asfa1qww7mgRelJScfjYPeEr4X+f6yyJZ+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQJZiNZjrrYfmN33puN1Y9vMfEX3pzeRqpJuXB+kqOYgks/f8C
	osQBMfA/A8iv8Y0i2h+LAtdxCzIKTrUCim6fLCn+CPpFnssRt+BwOKVlZdCKPZQwLZnA8GZFm0s
	xFf+lAzDZ8YriRq/pRt7sSinJC5S+N2MZg4vWGl2OaVIxmtGT9mc59Q8j4qni
X-Gm-Gg: ASbGncv8qDomyc0xp2x2u5BHG3TcanMJVV1+E3LWgErvfsX5dYbt+bwiRdn3aBsJi1V
	pHpnjbNJt5iJ1pSInEVDbmvmbSql+zpYjqcrvxSGst4etSstNOT0dsVXWPLcetonq0Da9tp9BoY
	+hY8tlXnRIJbDyuk08tejjHJJQOc9wslNUaPss4WPlzwaQ/uGdyJYozuvueN2n4uw9s9T2AN86w
	7ZoqF8rEg6s+HROYgF1NJ/CPdcdSwGT98zYG1lQbwHQFN5OB6Q+Z1rqPJtvMp2J/dQXYFc0KxId
	58lt9Nx0uyunQpbZI9AZSMiQCuw6mHu9iC63gHX72Hu23or2RbUyN2L+/lpy4FRNfcypZzokWSW
	KbTpCGunFiaVhUdqXCrZLZ9Hgxiy3LcgKRIvABz7pN7AONJ4LPLBggKom
X-Received: by 2002:a05:600c:4ec9:b0:45b:7ffa:1bf8 with SMTP id 5b1f17b1804b1-45b934f6a56mr114233075e9.23.1757054487759;
        Thu, 04 Sep 2025 23:41:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEj1Q4ueRZg61r58J+1sq7/RpmSeqvAcWabr/Sq37OcVKAf1elh8/EonCz3Jhepl0SBZP4Cg==
X-Received: by 2002:a05:600c:4ec9:b0:45b:7ffa:1bf8 with SMTP id 5b1f17b1804b1-45b934f6a56mr114232615e9.23.1757054487185;
        Thu, 04 Sep 2025 23:41:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8879cesm316420125e9.12.2025.09.04.23.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 23:41:26 -0700 (PDT)
Message-ID: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Date: Fri, 5 Sep 2025 08:41:23 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>, Jens Axboe <axboe@kernel.dk>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901150359.867252-20-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.09.25 17:03, David Hildenbrand wrote:
> We can just cleanup the code by calculating the #refs earlier,
> so we can just inline what remains of record_subpages().
> 
> Calculate the number of references/pages ahead of times, and record them
> only once all our tests passed.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   mm/gup.c | 25 ++++++++-----------------
>   1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index c10cd969c1a3b..f0f4d1a68e094 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>   #ifdef CONFIG_MMU
>   
>   #ifdef CONFIG_HAVE_GUP_FAST
> -static int record_subpages(struct page *page, unsigned long sz,
> -			   unsigned long addr, unsigned long end,
> -			   struct page **pages)
> -{
> -	int nr;
> -
> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> -		pages[nr] = page++;
> -
> -	return nr;
> -}
> -
>   /**
>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>    * @page:  pointer to page to be grabbed
> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>   	if (pmd_special(orig))
>   		return 0;
>   
> -	page = pmd_page(orig);
> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>   
>   	folio = try_grab_folio_fast(page, refs, flags);
>   	if (!folio)
> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>   	}
>   
>   	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;
>   	folio_set_referenced(folio);
>   	return 1;
>   }
> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>   	if (pud_special(orig))
>   		return 0;
>   
> -	page = pud_page(orig);
> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>   
>   	folio = try_grab_folio_fast(page, refs, flags);
>   	if (!folio)
> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>   	}
>   
>   	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;
>   	folio_set_referenced(folio);
>   	return 1;
>   }

Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
pages pointer, getting rid of the "*nr" parameter.

For the time being, the following should do the trick:

commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
Author: David Hildenbrand <david@redhat.com>
Date:   Fri Sep 5 08:38:43 2025 +0200

     fixup: mm/gup: remove record_subpages()
     
     pages is not adjusted by the caller, but idnexed by existing *nr.
     
     Signed-off-by: David Hildenbrand <david@redhat.com>

diff --git a/mm/gup.c b/mm/gup.c
index 010fe56f6e132..22420f2069ee1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
                 return 0;
         }
  
+       pages += *nr;
         *nr += refs;
         for (; refs; refs--)
                 *(pages++) = page++;
@@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
                 return 0;
         }
  
+       pages += *nr;
         *nr += refs;
         for (; refs; refs--)
                 *(pages++) = page++;


-- 

Cheers

David / dhildenb


