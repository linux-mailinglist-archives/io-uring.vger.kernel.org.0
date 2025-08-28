Return-Path: <io-uring+bounces-9370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE08B394E6
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32E7C3B9F92
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A392DE1FE;
	Thu, 28 Aug 2025 07:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Joedf28s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E42DCF4D;
	Thu, 28 Aug 2025 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756365535; cv=none; b=uLfLQZwW0bNd2Zw90eRt+5RGUAQzPfGSZVjn2RkQINEYbsEdtbUudbPFOpQ6tkr9nhvf6s48r8lbaBXOb8JzK/OvmEY2bcttouWteeRd78Ht3OIBo7Aympz1bnFpAUpbanpJL9L+ngOVufHTn38okqPSiTtlGlhIag8eqRWHr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756365535; c=relaxed/simple;
	bh=RLiNIIZsDGQt0B7qhXbwVc0kC0z981GdJgTavaVVo+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPMCurDfcsANH35QmR6eeVJnkKCFzdmBmMnE6i1xTIOtEnQLxIYSu7Ph+m3lWbbkA6lbi94SHiXyJvKrf70Eo7RmCss9VGeuVKhvK0dj3QScxxGb6UP4ew2TZTqhblYDF+TdA8aPdRecYFM+rGXNIEydYhwrcH7q1otgwI9boG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Joedf28s; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afe9f6caf9eso87484066b.3;
        Thu, 28 Aug 2025 00:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756365532; x=1756970332; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACPidqQG6DQZNVxh12NaJPKP3Jkf06hyqyPjQ1p5F2E=;
        b=Joedf28s79TmVflu0u9ETaRtcuAFlF1Q+cRkj0AoHTEbZRc9ov+0LbwWVeBAOSwM5F
         9se5m/hnaH2x9U9mqdgE1yd5LsJv+u+CbNQ1vyDpUOv4Sxm9oBRTEhDgF7ojkoYgmqJI
         Y+SYq6V0dueE4LmZ6hHjIMNaKrWG5O8L9dHNl5Abc9vZo3kIWwP1KgyG3SwielmoovyI
         04xgZFJ3k7phq4cCj4+/Bh/1W9xQExRwrMWhGVQQ4Y3kzygOA3KtT/uESQQs997Dil2z
         b1DUNkXQZ6WUjeRA6av4rhkRQhoIfBHuMVhVo2zPjT/ORNlCvwABaWjy6/Iedzdn4eJh
         AJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756365532; x=1756970332;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACPidqQG6DQZNVxh12NaJPKP3Jkf06hyqyPjQ1p5F2E=;
        b=h7nRzuuMPqBM56Qor/d+U1MMwfU5rv2tNgKuU9BK3rrxOlM5k2dabPmNeeMyegNLXD
         nOQl6Z6SghPGx9aibPNrqLQmcMNbs6B1vFUsVYLpoXhYwTqar3co2m0dZRu2mSY5ZJhn
         datmC1JW7ctj+YfFezmbdMkrpNneqVI8bMbCo90t7qa25lGqFxw2YCbQu109y+ydKxP5
         9oY4/cdVDDp+A34vqW3ddUkMwQKlZKbBfSXw8fBsrQnMSxciEwbnlqNDsORLjeWbrNGc
         dIyNuxvTeCn5PC2zO2wsZMywBgr5qIuVePxVvBhYw+bp6WttNkOu4mAqzOaJEPLjm3PG
         NbDw==
X-Forwarded-Encrypted: i=1; AJvYcCUFLN461B7xX+aGitmy9WuYcSo7gPHYEzT2DSG5gglyYOoornH5S9jAsfDLGEfxq3qw2+r3FIozvAzV@vger.kernel.org, AJvYcCUdbarWq6z1eY1kJQIoM5C1kQSDv/wb0uM58WBskTOg06IFI+8J/aFXU7l3nbGo2i7UMS5E/+9UjqQH9g==@vger.kernel.org, AJvYcCV1abVnSk19u44tjzQ71TeWBmJWURclSiy/bflMR5w7t05I9fdxgKxMhMAC+90qH4owxtay@vger.kernel.org, AJvYcCVx+GXCKhwSoRFUJ4IJmArkRt4jegWeCNwvynGvLXD4/O2WhsW9GYLVGc4CvhqvDvSXIehBBC3G3A==@vger.kernel.org, AJvYcCW3xnuW0hj/5HKEs9PIkTmRIuW/vRZFT7hfhQO9Nv92f0BbFQnAYs4R41IMiTfRmGNk7/tA4NkXQqPfvQ==@vger.kernel.org, AJvYcCW91AEe/r8hDSUDTfmZBb1y3+17At/zKPFo/16Rj5EYcce6zZSkf/qlPtgP8afOuoJH1WzJ+U5SmL8P642z@vger.kernel.org, AJvYcCWRvh/RpFcSW4JMJ0y+aVIPjL22p5Jru5cgB84sewQV7SE9m/LPzjVntn07+gDDpyCFRycqbo5Y@vger.kernel.org, AJvYcCX+DNv7A5c4yvLXTsQsHhsrzwqhFvfHO5R4pEpqnjdcqCp1rKDj6EEyw/dqLmNykfObkJdasZFkM5L3mA==@vger.kernel.org, AJvYcCXiFjJCEUpPrjBN6ZReHRdoDObDbhKMzVMNpbqhu+d6eEfCk4zr8Vc36gyOka4DwhyHsAzCGXFUcJAJNVzJWNmO@vger.kernel.org, AJvYcCXjJPPIj10LXuqzOAvGWKQ86mQMCWuiJ/q2
 IXdTYYuXFtYzlaUPvsWbD5ez4MpKVA/U3VYUAdyhbRlA@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2F96dDb9eVMlmDVaQA5HMcDPai70QF1BoTLh8OJ6kR96Fy2/I
	x26FUYqT5HOOD1MUZkx6z/v9eGljUAVxV0S25pntRAKPxNQVqfelRtZz
X-Gm-Gg: ASbGncuC4y3Zz4kTEt0Yv820rsqQxg96Tjaz12Ob+EaBF0HrYNOZke8/q8ToDkekLlm
	LSGO1vBUGpOv/8YMgwG4OQ18cKdTLWYflSwH3UBCoxfACmIo9iraP+6EL8pxaLF21ybYRzH44XA
	bLifwbx9AEofNbbYu4+KqGmJDUTh+mhRPhZWPxYvjR8iV/YwsZmwED8O9GVwZ/sELvA5YyoX8B3
	kofM37I/JO8oZPRhGLL6+F4h6yCoJXRTXgJkvUNwwarOau1A4KNLoYR+KKU2YA7dsDf+5264WLY
	fMCCyMAXdkatmAHw8tyBge03VNz/kkgCX2EfqynqrRgvOGBWJ8iYB6rLQoh1ksrE0TZNylrhfRl
	g9pYjVvHTnaNZ/Ub9EGnb1T58H5Uav+42lWR1
X-Google-Smtp-Source: AGHT+IEf18QCG44U8jBJ4evHstdtd0oL4Hr6BpN08BPT0cHmsLXVki3gbBRZpXohq9eRx3IUTA8+0Q==
X-Received: by 2002:a17:907:d2a:b0:afe:dbfb:b10e with SMTP id a640c23a62f3a-afedbfbb935mr140730666b.47.1756365531421;
        Thu, 28 Aug 2025 00:18:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe98ade972sm616427066b.50.2025.08.28.00.18.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:18:50 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:18:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 01/36] mm: stop making SPARSEMEM_VMEMMAP
 user-selectable
Message-ID: <20250828071850.kl7clyh6e75horlk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-2-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:05AM +0200, David Hildenbrand wrote:
>In an ideal world, we wouldn't have to deal with SPARSEMEM without
>SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
>considered too costly and consequently not supported.
>
>However, if an architecture does support SPARSEMEM with
>SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
>like we already do for arm64, s390 and x86.
>
>So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
>SPARSEMEM_VMEMMAP.
>
>This implies that the option to not use SPARSEMEM_VMEMMAP will now be
>gone for loongarch, powerpc, riscv and sparc. All architectures only
>enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
>be a big downside to using the VMEMMAP (quite the contrary).
>
>This is a preparation for not supporting
>
>(1) folio sizes that exceed a single memory section
>(2) CMA allocations of non-contiguous page ranges
>
>in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
>want to limit possible impact as much as possible (e.g., gigantic hugetlb
>page allocations suddenly fails).
>
>Acked-by: Zi Yan <ziy@nvidia.com>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Acked-by: SeongJae Park <sj@kernel.org>
>Cc: Huacai Chen <chenhuacai@kernel.org>
>Cc: WANG Xuerui <kernel@xen0n.name>
>Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>Cc: Michael Ellerman <mpe@ellerman.id.au>
>Cc: Nicholas Piggin <npiggin@gmail.com>
>Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>Cc: Paul Walmsley <paul.walmsley@sifive.com>
>Cc: Palmer Dabbelt <palmer@dabbelt.com>
>Cc: Albert Ou <aou@eecs.berkeley.edu>
>Cc: Alexandre Ghiti <alex@ghiti.fr>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Andreas Larsson <andreas@gaisler.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>---
> mm/Kconfig | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/mm/Kconfig b/mm/Kconfig
>index 4108bcd967848..330d0e698ef96 100644
>--- a/mm/Kconfig
>+++ b/mm/Kconfig
>@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
> 	bool
> 
> config SPARSEMEM_VMEMMAP
>-	bool "Sparse Memory virtual memmap"
>+	def_bool y
> 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
>-	default y
> 	help
> 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
> 	  pfn_to_page and page_to_pfn operations.  This is the most
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

