Return-Path: <io-uring+bounces-9618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30730B469B8
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 09:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF3CB1CC79AB
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 07:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153452C2343;
	Sat,  6 Sep 2025 07:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGpHYhHx"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292E9286D49
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 07:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757142065; cv=none; b=b+fQhBVpbar7RZT74zMxlVYPygwI/3RfXN67kjiE+S9nbPELbw3F3yrrPL/sVKQ2FV46XKr6zRZR73GWSGLtwwUAIeVbtO8XAY/wJFEfITOtFKVS124NjHIqTnJibUKtjqsMnQGpdwKtRtHyNLXzXs22EqFVoNITvaUR3wbTZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757142065; c=relaxed/simple;
	bh=IG++ZkBD59wzKHu12fgNu7jyIoQUxrPSNiCWC9IyrGQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YqXhYAFs/3yzy/PBhkcs5LRJ0X6Tvy0m/xk4hnI/j5aO3zsFDlasyXjIZuk0wubnaRRLKg4qD2kN77Xe900csbtqXedveiqaMt/i9m5AiQBZ9EzofhYpsq1mJk1GM+ARcxYz/wZLovjCyjBJgM4Y1sNtlmREj0wW6d+/UNyea90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGpHYhHx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757142061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
	b=KGpHYhHxiD+7YN+3JLfySWCD7JyAQN3s8PfW4RiZZ9qT9dRIHfry+6iURcKqBrBPRxXdWb
	rXSxYNYPeWOMiXtxXanJGit9pBd2MNdqtU4X89wcEcOUuSM+qI+s3tcka3S09glBbgvt0y
	QDjNdBfQd+6hmiwdej2bcPn8MaAjUPI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-CU2D-4vyOOyUbf478OLU5Q-1; Sat, 06 Sep 2025 03:00:59 -0400
X-MC-Unique: CU2D-4vyOOyUbf478OLU5Q-1
X-Mimecast-MFC-AGG-ID: CU2D-4vyOOyUbf478OLU5Q_1757142058
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3da4c617a95so2803236f8f.0
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 00:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757142058; x=1757746858;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
        b=FEcNiitQXnp1b9vbS1GbeIkaP4hFtemlANlOeo+qqUeOTSon+q4Vik9Ir1HulgLHEl
         qR5meY1ZhJqYJeOuDO/Ci8pxQqujXkLuBEy8Q09KmoFq4WsfIDuVeXs/7Mq3G/cm83Pl
         B3e/6zPgpOupFwFqpdT602lL4c0l0hnI8qH2SCBXV6yKvnuFobnHsPwyIEleRpCCQ8Da
         NR7FvYM5fZ6Q38bdBfaKJpHQHdtiCZ5SnQm+Ct8+/DvD9rwjiob0jhlkDDfXRMnZQTLc
         Ccg9QhyiHB4GZY1RgwJJr2k18kZt9xMeYWT68UO050GNLuEIqwDQiobB8xmbkRp/SKKI
         yWUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCA8YZ5S+/rNYHYwes/eZUngXyxTLaV27m5ZWDLnZUgwKZWElphnde0uwwSI3JMjWAQKup8WuRYg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyll6fvBtvwVdIW6d/91vlC4Ki56J8Kmbj9GfjSdETf17PH9OzH
	R9+YPN67TuIsXh467UjMGSa6yNi49Jqk55l88oTTx5YlwNBVFbHSzKY30QTLGDDlxhq7RL/z8lv
	1kHT+XmcFuvKHR8wgL+QuWxRpkA6wJ3SVOdKBZdEeIfbGoD549zzkYJ2LPJzY
X-Gm-Gg: ASbGnctwk1El1xkbKzqUVfQ0ALoFz0S9L26LnYw/pCNG9pfQl+u2VBkanVppF+Xt+z9
	nHD/O6ZiSK3FNrrskihu6mj+fPDB3X5G9iENyMGGRbnRjWQusMl0JgoxV8HWbONB4HDQCFSJCAN
	v/dr4oUuDV3ojaaH8+TW0H/oxzx9DHdv9jsGkjcpSS5Epew566N2TkbzHlKczoJhdczWKDD6A6F
	0tE38+sQFeXnH9AzwnaYzWdhWS2aYOZu2DEUTF6nKKE9DzwHJXUL9Fm5txURuW8RJ9GffPWpE+X
	dvyBS0/AMwM3uPk2db87yEr5+GT/brf3U1Fx52KnlrFxuVQEuF6YeBkr7NMc6f3EhkPKEVrx/gH
	Vf3kua5zUZmiyN927X2dJz3m46fZzbqlfsOF/pWI57ds0aA1YzXOB93arUYxt3WmX630=
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835285f8f.42.1757142058297;
        Sat, 06 Sep 2025 00:00:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdr4VmZX14HWt6vWJrgVQl61309Yoz3EBz+B4BvfuTuYDfgHO59nfbR4v+s7YipRZZX7VN6g==
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835230f8f.42.1757142057809;
        Sat, 06 Sep 2025 00:00:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm6794555f8f.62.2025.09.06.00.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 00:00:56 -0700 (PDT)
Message-ID: <815cbde4-a56d-446d-b517-c63e12e473de@redhat.com>
Date: Sat, 6 Sep 2025 09:00:54 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
From: David Hildenbrand <david@redhat.com>
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
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>    	pmdp = pmd_offset_lockless(pudp, pud, addr);
> @@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
>    
>    		next = pmd_addr_end(addr, end);
>    		if (!pmd_present(pmd))
> -			return 0;
> +			break;
>    
> -		if (unlikely(pmd_leaf(pmd))) {
> -			/* See gup_fast_pte_range() */
> -			if (pmd_protnone(pmd))
> -				return 0;
> +		if (unlikely(pmd_leaf(pmd)))
> +			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
> +		else
> +			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
>    
> -			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
> -				pages, nr))
> -				return 0;
> +		nr_pages += cur_nr_pages;
> +		pages += cur_nr_pages;
>    
> -		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
> -					       pages, nr))
> -			return 0;
> +		if (nr_pages != (next - addr) >> PAGE_SIZE)
> +			break;

^ cur_nr_pages. Open for suggestions on how to make that thing here even 
better.

-- 
Cheers

David / dhildenb


