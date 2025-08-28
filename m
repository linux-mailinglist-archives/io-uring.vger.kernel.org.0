Return-Path: <io-uring+bounces-9378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C35FB395B9
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:44:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6820188B78C
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3F22D6418;
	Thu, 28 Aug 2025 07:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GOUjOG6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77929D28B;
	Thu, 28 Aug 2025 07:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756367040; cv=none; b=ERXc+xrQAkd66wmMTdO90ZD7P1owLtQ6FYxSC3t+LzliOMnA2z03oYJLx4JTRW4lmSoMu+tAVI3dLYJTdq8SjcWhIceBM7fnbtK3TVCBwHFYAENOa/P3/U0PI42ZM2b063nst3IyViwUQjmyyIY4GlPOTKetV9U86WHJQNbs1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756367040; c=relaxed/simple;
	bh=XDFRc6QlXzcNT8Ow6MyYcXfogrHGk9sBXxgLao67Ms0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pv68KaKVnG0aD8w2YZTjAkIGpbEc/7kHPsq3eX6DJpm8iywKBsa/NjNodEvQRcs5125gWdCZOALgsFEY+spNZ2CDxoQjIgZlxONG1+JSR7fWK9jZfBqgeG4W88LI17MJqjsMpK9oaoRgoLPR9DeMiXX3hWyv1q2YKCiDE/chQ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GOUjOG6o; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afeee20b7c0so26982266b.3;
        Thu, 28 Aug 2025 00:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756367037; x=1756971837; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCyWFKVmsqDpuka3mORfqvZ6ED5815cQsuT83UfJ0fY=;
        b=GOUjOG6od5zIKCSc6TFz+3QQANGLqQbNGtzlbxVU1BVGLcRUuc52zTa+kc+ocfXH7H
         EhxYzQzjmKsWU0BnDlnYXwF7BNtIQ5mL0VpB7yhaD4mXXGXMAtyvq7sKaB9Pnbxsp0+a
         JTEF6/KWVMJhgV3dk1LLTIzivtmVz1TeUxbPHJwqYg9jT/px0xS8C+f74Jk94hHBv/NI
         c0saUE34Pq7YAv1EyW3J9L17BAnals5J5+kmaqr+WpMfWJeDhI+Od9Ls8Pb9CzPCP+Z2
         /ePzL05XUO6H3yBjUryjOG/4SKB9WXsvb2aYE+ZLvXSLQpKMhipnQyuCjFU/wCeqhYGq
         nnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367037; x=1756971837;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCyWFKVmsqDpuka3mORfqvZ6ED5815cQsuT83UfJ0fY=;
        b=bR0Hw8Y02X7ilNZBrRsTPQ8mWISpHaTH56Zvx9Jztq8cghhePYlUY2MCilKKOxfis+
         SJM1V6qPUF8cWWgDNRpaZoLHwGJp8pKGv56f6i/zQr4dNhwRtYxXaficvemJYImGNTCl
         q6np1GWy4WWQFJCnB53hQinSpwDfwKPg04bIAvKDAavywkuROhPijmvklanKgzFcF01A
         cMDqi1oOuV8XPnTxxKwQE12U+anU3Xhj8A3qoSv+FArCG9dcrccDdw2CD7sPqs9S2ZAt
         6wZ9L1PWJDybo9RWpiJ7PygMaLszB3Nhxtoakl7JQGAHpJbRWPWNfm7RG47cvkUKK/2i
         4Pbg==
X-Forwarded-Encrypted: i=1; AJvYcCU3ytH4nPNU8gDsNp9hv7/k+iEgJHL6e9cNVA/BHv+c9A6glYAg4wJKIAQK5ir+aouL9L7/DtXWgLvp@vger.kernel.org, AJvYcCURJdwWbgfDOAKkPhRyKIvRawMA7IxEnVTsPyV2h6COIPaRG9DkUJN/TB0RUEtQl4jGVr5jkT1C@vger.kernel.org, AJvYcCUgvO/hv6fCmw5IErOhvWGJxwBk11H0OIaLPhjHaV3iAeLJWAx00zJvjwXYcQuuATA5Zwk8Wu85teKrEnB8@vger.kernel.org, AJvYcCUywvRDHJbOOgWEGr96Ps74+5FxC8eOc+lGVltiosjIqBOWR0fyoQrB+v9Wi/O48Rt6EWoAvuT2eQ==@vger.kernel.org, AJvYcCVzrnEO5kYma31gdhyFWSdiZjurtLu4DpIr+FRu7ePvZsKvTjSc35s3NdZ0iFoaii44TcUDLPPh3Xb4Sg==@vger.kernel.org, AJvYcCWGcy/robXvOfb7GccxOX7jJvf2GWNxTRCVtlWbEt9Cc0wb3svWdzEwCc6H6V3LQz/nAq2eBMbg1H8GQQ==@vger.kernel.org, AJvYcCWHE2gdDXczEmeWlWydQg5Gi1IaJHPpOOQgcedDNFlsR5qLLGe9E13o4xTdN7fjPCJLFF3K@vger.kernel.org, AJvYcCXFm4I79CxL/Ik5zQSfrVqY6k73PYHpV6OGQgEy0WYdy/AQXatm/T9duGX8xTdyeOuSbuT5KAogUk2y@vger.kernel.org, AJvYcCXQOXo2yPL76XItWI885UCKwDvlsea734wmWSN+jVNuJl0tbMINm2Dy8IsTz2n0QeaCtpkqVgbzQmzk4HGJ7S/l@vger.kernel.org, AJvYcCXhr//1nsWN/clbvroNjWydXfjcNr/+9spwxr4t
 /yYpIN12adbqG5FvcTuWczxWp/k4E1tet19XfXRk4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaETqZkGzPYI8rY83k/xvAG4sDE5egP+hhWZCCdUMIxPD0Zy9c
	E98oVMTnAugEnYcLoprl5BECba5kRDW3SkH/cSb80ovgzqkzzTO8Y7h/
X-Gm-Gg: ASbGncteuM+tGzCdZk8NQqXNei6vUqn5D++muVG4qeC2b9Hq+s9F/5vVbbc7ATZbNuh
	thKwKCDgFsWu/zAyf/vYpAwVh8DzNcJIbODn8iF3nocGQT7R+eCblMWTNlwkRM+JM3FWJSCgHof
	IXI8w9DEurHrM1Vyy1/DmHdNB5KXZOsTprZ5n5mAT4dfySA5GcZ+lYxkNOgqDfMqquXfYkzt/i/
	urg2CMH2r8SsxR4aU2jgUMYz3xSb75Be58Xy3ASbmFIr67Pj0mPsbHFcLNEKNoBXnP1952h6sPp
	bSblIBJ5/QUtRC5VSaj/kqW9poT6BmaPKqpbonlU3f6pfR1g8gOAI3oURDM3z5aHOh5tf5YJp2L
	W9Bgi0oFJE+ZCdudxqyskPir2JDzW45o+T2sYEKzetQpj1LE=
X-Google-Smtp-Source: AGHT+IFCWGCB9w3JZkSqlrk4a0OYpaWYnOsewLh1z3k9Jb7NB4buZSqln74MwC7LX4UWbpbQGZTMJw==
X-Received: by 2002:a17:906:3717:b0:afe:764d:6b31 with SMTP id a640c23a62f3a-afe764d736dmr1280383766b.4.1756367036783;
        Thu, 28 Aug 2025 00:43:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe48fae316sm1165798866b.28.2025.08.28.00.43.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:43:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:43:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <20250828074356.3xiuqugokg36yuxw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-13-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:16AM +0200, David Hildenbrand wrote:
>Now that a single folio/compound page can no longer span memory sections
>in problematic kernel configurations, we can stop using nth_page().
>
>While at it, turn both macros into static inline functions and add
>kernel doc for folio_page_idx().
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

The code looks good, while one nit below.

>---
> include/linux/mm.h         | 16 ++++++++++++++--
> include/linux/page-flags.h |  5 ++++-
> 2 files changed, 18 insertions(+), 3 deletions(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 2dee79fa2efcf..f6880e3225c5c 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> 
> #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>-#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
> #else
> #define nth_page(page,n) ((page) + (n))
>-#define folio_page_idx(folio, p)	((p) - &(folio)->page)
> #endif
> 
> /* to align the pointer to the (next) page boundary */
>@@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
> #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
> 
>+/**
>+ * folio_page_idx - Return the number of a page in a folio.
>+ * @folio: The folio.
>+ * @page: The folio page.
>+ *
>+ * This function expects that the page is actually part of the folio.
>+ * The returned number is relative to the start of the folio.
>+ */
>+static inline unsigned long folio_page_idx(const struct folio *folio,
>+		const struct page *page)
>+{
>+	return page - &folio->page;
>+}
>+
> static inline struct folio *lru_to_folio(struct list_head *head)
> {
> 	return list_entry((head)->prev, struct folio, lru);
>diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>index 5ee6ffbdbf831..faf17ca211b4f 100644
>--- a/include/linux/page-flags.h
>+++ b/include/linux/page-flags.h
>@@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>  * check that the page number lies within @folio; the caller is presumed
>  * to have a reference to the page.
>  */
>-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
>+static inline struct page *folio_page(struct folio *folio, unsigned long n)
>+{
>+	return &folio->page + n;
>+}
> 

Curious about why it is in page-flags.h. It seems not related to page-flags.

> static __always_inline int PageTail(const struct page *page)
> {
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

